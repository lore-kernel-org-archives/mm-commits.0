Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA38C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB91F61D05
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhF2CgY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231680AbhF2CgX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 350B961D04;
        Tue, 29 Jun 2021 02:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934036;
        bh=gQsGNGqUU2nKF96q3RWxDmuiTpF6hxx/IogkVGkphJQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZZiRurRrxJGakLX8kMSUHGTfKLeLDqNB4rOxWd2KZaC2LBQG6Iaqc0C7huDpjlLnc
         nQ3gCVC7AtnpzeYg+zZLYbosqYm5cBZmycHVKXWLdAXftwHRi63AV+AyFYKz+sxmm3
         ACNCnWdxCHvZLGhQN62Hlhgt0orZU+oqHfYbHR9A=
Date:   Mon, 28 Jun 2021 19:33:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        torvalds@linux-foundation.org, vincent.whitchurch@axis.com
Subject:  [patch 012/192] squashfs: add option to panic on errors
Message-ID: <20210629023355.xnPXg7Qdf%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: squashfs: add option to panic on errors

Add an errors=panic mount option to make squashfs trigger a panic when
errors are encountered, similar to several other filesystems.  This allows
a kernel dump to be saved using which the corruption can be analysed and
debugged.

Inspired by a pre-fs_context patch by Anton Eliasson.

Link: https://lkml.kernel.org/r/20210527125019.14511-1-vincent.whitchurch@axis.com
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c          |    5 +
 fs/squashfs/squashfs_fs_sb.h |    1 
 fs/squashfs/super.c          |   86 +++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-add-option-to-panic-on-errors
+++ a/fs/squashfs/block.c
@@ -226,8 +226,11 @@ out_free_bio:
 	bio_free_pages(bio);
 	bio_put(bio);
 out:
-	if (res < 0)
+	if (res < 0) {
 		ERROR("Failed to read block 0x%llx: %d\n", index, res);
+		if (msblk->panic_on_errors)
+			panic("squashfs read failed");
+	}
 
 	return res;
 }
--- a/fs/squashfs/squashfs_fs_sb.h~squashfs-add-option-to-panic-on-errors
+++ a/fs/squashfs/squashfs_fs_sb.h
@@ -65,5 +65,6 @@ struct squashfs_sb_info {
 	unsigned int				fragments;
 	int					xattr_ids;
 	unsigned int				ids;
+	bool					panic_on_errors;
 };
 #endif
--- a/fs/squashfs/super.c~squashfs-add-option-to-panic-on-errors
+++ a/fs/squashfs/super.c
@@ -18,9 +18,11 @@
 
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/fs_parser.h>
 #include <linux/vfs.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
+#include <linux/seq_file.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -37,6 +39,51 @@
 static struct file_system_type squashfs_fs_type;
 static const struct super_operations squashfs_super_ops;
 
+enum Opt_errors {
+	Opt_errors_continue,
+	Opt_errors_panic,
+};
+
+enum squashfs_param {
+	Opt_errors,
+};
+
+struct squashfs_mount_opts {
+	enum Opt_errors errors;
+};
+
+static const struct constant_table squashfs_param_errors[] = {
+	{"continue",   Opt_errors_continue },
+	{"panic",      Opt_errors_panic },
+	{}
+};
+
+static const struct fs_parameter_spec squashfs_fs_parameters[] = {
+	fsparam_enum("errors", Opt_errors, squashfs_param_errors),
+	{}
+};
+
+static int squashfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct squashfs_mount_opts *opts = fc->fs_private;
+	struct fs_parse_result result;
+	int opt;
+
+	opt = fs_parse(fc, squashfs_fs_parameters, param, &result);
+	if (opt < 0)
+		return opt;
+
+	switch (opt) {
+	case Opt_errors:
+		opts->errors = result.uint_32;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static const struct squashfs_decompressor *supported_squashfs_filesystem(
 	struct fs_context *fc,
 	short major, short minor, short id)
@@ -67,6 +114,7 @@ static const struct squashfs_decompresso
 
 static int squashfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
+	struct squashfs_mount_opts *opts = fc->fs_private;
 	struct squashfs_sb_info *msblk;
 	struct squashfs_super_block *sblk = NULL;
 	struct inode *root;
@@ -85,6 +133,8 @@ static int squashfs_fill_super(struct su
 	}
 	msblk = sb->s_fs_info;
 
+	msblk->panic_on_errors = (opts->errors == Opt_errors_panic);
+
 	msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
 	msblk->devblksize_log2 = ffz(~msblk->devblksize);
 
@@ -350,18 +400,52 @@ static int squashfs_get_tree(struct fs_c
 
 static int squashfs_reconfigure(struct fs_context *fc)
 {
+	struct super_block *sb = fc->root->d_sb;
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct squashfs_mount_opts *opts = fc->fs_private;
+
 	sync_filesystem(fc->root->d_sb);
 	fc->sb_flags |= SB_RDONLY;
+
+	msblk->panic_on_errors = (opts->errors == Opt_errors_panic);
+
 	return 0;
 }
 
+static void squashfs_free_fs_context(struct fs_context *fc)
+{
+	kfree(fc->fs_private);
+}
+
 static const struct fs_context_operations squashfs_context_ops = {
 	.get_tree	= squashfs_get_tree,
+	.free		= squashfs_free_fs_context,
+	.parse_param	= squashfs_parse_param,
 	.reconfigure	= squashfs_reconfigure,
 };
 
+static int squashfs_show_options(struct seq_file *s, struct dentry *root)
+{
+	struct super_block *sb = root->d_sb;
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+
+	if (msblk->panic_on_errors)
+		seq_puts(s, ",errors=panic");
+	else
+		seq_puts(s, ",errors=continue");
+
+	return 0;
+}
+
 static int squashfs_init_fs_context(struct fs_context *fc)
 {
+	struct squashfs_mount_opts *opts;
+
+	opts = kzalloc(sizeof(*opts), GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
+
+	fc->fs_private = opts;
 	fc->ops = &squashfs_context_ops;
 	return 0;
 }
@@ -481,6 +565,7 @@ static struct file_system_type squashfs_
 	.owner = THIS_MODULE,
 	.name = "squashfs",
 	.init_fs_context = squashfs_init_fs_context,
+	.parameters = squashfs_fs_parameters,
 	.kill_sb = kill_block_super,
 	.fs_flags = FS_REQUIRES_DEV
 };
@@ -491,6 +576,7 @@ static const struct super_operations squ
 	.free_inode = squashfs_free_inode,
 	.statfs = squashfs_statfs,
 	.put_super = squashfs_put_super,
+	.show_options = squashfs_show_options,
 };
 
 module_init(init_squashfs_fs);
_

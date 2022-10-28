Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9599EECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 22:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiJ1WGf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 18:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJ1WGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 18:06:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BB824D891
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 15:06:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0878FB82CDC
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 22:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6A6C433D6;
        Fri, 28 Oct 2022 22:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666994775;
        bh=1gaqqv7CId9NnWCoeifBlg7jmYdIeze9MtU8BNPTirA=;
        h=Date:To:From:Subject:From;
        b=IY+hIW1zi1XKoX0YmdequFqYtmJp130nReNWV/FS9SAYOI/xPkmfhnpbE7IViI4eJ
         ZSM+u2eEtups0VLn33zYpqi1ST92dAwx5mzW1fx9jiGuCNc4l0OuaTACDAaZ6xqkMx
         koG1vNDmI72HEaGX++gn81f3MQ/B9C3DDTpX92cg=
Date:   Fri, 28 Oct 2022 15:06:14 -0700
To:     mm-commits@vger.kernel.org, zhongjubin@huawei.com,
        yi.zhang@huawei.com, phillip@squashfs.org.uk,
        chenjianguo3@huawei.com, nixiaoming@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-allows-users-to-configure-the-number-of-decompression-threads.patch added to mm-nonmm-unstable branch
Message-Id: <20221028220615.9C6A6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: allows users to configure the number of decompression threads
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-allows-users-to-configure-the-number-of-decompression-threads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-allows-users-to-configure-the-number-of-decompression-threads.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: squashfs: allows users to configure the number of decompression threads
Date: Wed, 19 Oct 2022 11:09:30 +0800

The maximum number of threads in the decompressor_multi.c file is fixed
and cannot be adjusted according to user needs.  Therefore, the mount
parameter needs to be added to allow users to configure the number of
threads as required.  The upper limit is num_online_cpus() * 2.

Link: https://lkml.kernel.org/r/20221019030930.130456-3-nixiaoming@huawei.com
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Jianguo Chen <chenjianguo3@huawei.com>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/squashfs/decompressor_multi.c~squashfs-allows-users-to-configure-the-number-of-decompression-threads
+++ a/fs/squashfs/decompressor_multi.c
@@ -144,7 +144,7 @@ static struct decomp_stream *get_decomp_
 		 * If there is no available decomp and already full,
 		 * let's wait for releasing decomp from other users.
 		 */
-		if (stream->avail_decomp >= MAX_DECOMPRESSOR)
+		if (stream->avail_decomp >= msblk->max_thread_num)
 			goto wait;
 
 		/* Let's allocate new decomp */
@@ -160,7 +160,7 @@ static struct decomp_stream *get_decomp_
 		}
 
 		stream->avail_decomp++;
-		WARN_ON(stream->avail_decomp > MAX_DECOMPRESSOR);
+		WARN_ON(stream->avail_decomp > msblk->max_thread_num);
 
 		mutex_unlock(&stream->mutex);
 		break;
--- a/fs/squashfs/Kconfig~squashfs-allows-users-to-configure-the-number-of-decompression-threads
+++ a/fs/squashfs/Kconfig
@@ -73,11 +73,10 @@ config SQUASHFS_CHOICE_DECOMP_BY_MOUNT
 	select SQUASHFS_DECOMP_SINGLE
 	select SQUASHFS_DECOMP_MULTI
 	select SQUASHFS_DECOMP_MULTI_PERCPU
+	select SQUASHFS_MOUNT_DECOMP_THREADS
 	help
 	  Compile all parallel decompression modes and specify the
 	  decompression mode by setting "threads=" during mount.
-	    threads=<single|multi|percpu>
-
 	  default Decompressor parallelisation is SQUASHFS_DECOMP_SINGLE
 
 choice
@@ -127,6 +126,19 @@ config SQUASHFS_COMPILE_DECOMP_MULTI_PER
 	  decompression is load-balanced across the cores.
 endchoice
 
+config SQUASHFS_MOUNT_DECOMP_THREADS
+	bool "Add the mount parameter 'threads=' for squashfs"
+	depends on SQUASHFS
+	depends on SQUASHFS_DECOMP_MULTI
+	default n
+	help
+	  Use threads= to set the decompression parallel mode and the number of threads.
+	  If SQUASHFS_CHOICE_DECOMP_BY_MOUNT=y
+	      threads=<single|multi|percpu|1|2|3|...>
+	  else
+	      threads=<2|3|...>
+	  The upper limit is num_online_cpus() * 2.
+
 config SQUASHFS_XATTR
 	bool "Squashfs XATTR support"
 	depends on SQUASHFS
--- a/fs/squashfs/squashfs_fs_sb.h~squashfs-allows-users-to-configure-the-number-of-decompression-threads
+++ a/fs/squashfs/squashfs_fs_sb.h
@@ -67,5 +67,6 @@ struct squashfs_sb_info {
 	unsigned int				ids;
 	bool					panic_on_errors;
 	const struct squashfs_decompressor_thread_ops *thread_ops;
+	int					max_thread_num;
 };
 #endif
--- a/fs/squashfs/super.c~squashfs-allows-users-to-configure-the-number-of-decompression-threads
+++ a/fs/squashfs/super.c
@@ -53,6 +53,7 @@ enum squashfs_param {
 struct squashfs_mount_opts {
 	enum Opt_errors errors;
 	const struct squashfs_decompressor_thread_ops *thread_ops;
+	int thread_num;
 };
 
 static const struct constant_table squashfs_param_errors[] = {
@@ -67,7 +68,8 @@ static const struct fs_parameter_spec sq
 	{}
 };
 
-static int squashfs_parse_param_threads(const char *str, struct squashfs_mount_opts *opts)
+
+static int squashfs_parse_param_threads_str(const char *str, struct squashfs_mount_opts *opts)
 {
 #ifdef CONFIG_SQUASHFS_CHOICE_DECOMP_BY_MOUNT
 	if (strcmp(str, "single") == 0) {
@@ -86,6 +88,42 @@ static int squashfs_parse_param_threads(
 	return -EINVAL;
 }
 
+static int squashfs_parse_param_threads_num(const char *str, struct squashfs_mount_opts *opts)
+{
+#ifdef CONFIG_SQUASHFS_MOUNT_DECOMP_THREADS
+	int ret;
+	unsigned long num;
+
+	ret = kstrtoul(str, 0, &num);
+	if (ret != 0)
+		return -EINVAL;
+	if (num > 1) {
+		opts->thread_ops = &squashfs_decompressor_multi;
+		if (num > opts->thread_ops->max_decompressors())
+			return -EINVAL;
+		opts->thread_num = (int)num;
+		return 0;
+	}
+#ifdef CONFIG_SQUASHFS_DECOMP_SINGLE
+	if (num == 1) {
+		opts->thread_ops = &squashfs_decompressor_single;
+		opts->thread_num = 1;
+		return 0;
+	}
+#endif
+#endif /* !CONFIG_SQUASHFS_MOUNT_DECOMP_THREADS */
+	return -EINVAL;
+}
+
+static int squashfs_parse_param_threads(const char *str, struct squashfs_mount_opts *opts)
+{
+	int ret = squashfs_parse_param_threads_str(str, opts);
+
+	if (ret == 0)
+		return ret;
+	return squashfs_parse_param_threads_num(str, opts);
+}
+
 static int squashfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 {
 	struct squashfs_mount_opts *opts = fc->fs_private;
@@ -194,6 +232,11 @@ static int squashfs_fill_super(struct su
 		goto failed_mount;
 	}
 	msblk->thread_ops = opts->thread_ops;
+	if (opts->thread_num == 0) {
+		msblk->max_thread_num = msblk->thread_ops->max_decompressors();
+	} else {
+		msblk->max_thread_num = opts->thread_num;
+	}
 
 	/* Check the MAJOR & MINOR versions and lookup compression type */
 	msblk->decompressor = supported_squashfs_filesystem(
@@ -279,7 +322,7 @@ static int squashfs_fill_super(struct su
 
 	/* Allocate read_page block */
 	msblk->read_page = squashfs_cache_init("data",
-		msblk->thread_ops->max_decompressors(), msblk->block_size);
+		msblk->max_thread_num, msblk->block_size);
 	if (msblk->read_page == NULL) {
 		errorf(fc, "Failed to allocate read_page block");
 		goto failed_mount;
@@ -467,15 +510,14 @@ static int squashfs_show_options(struct
 		seq_puts(s, ",threads=single");
 		return 0;
 	}
-	if (msblk->thread_ops == &squashfs_decompressor_multi) {
-		seq_puts(s, ",threads=multi");
-		return 0;
-	}
 	if (msblk->thread_ops == &squashfs_decompressor_percpu) {
 		seq_puts(s, ",threads=percpu");
 		return 0;
 	}
 #endif
+#ifdef CONFIG_SQUASHFS_MOUNT_DECOMP_THREADS
+	seq_printf(s, ",threads=%d", msblk->max_thread_num);
+#endif
 	return 0;
 }
 
@@ -496,6 +538,7 @@ static int squashfs_init_fs_context(stru
 #else
 #error "fail: unknown squashfs decompression thread mode?"
 #endif
+	opts->thread_num = 0;
 	fc->fs_private = opts;
 	fc->ops = &squashfs_context_ops;
 	return 0;
_

Patches currently in -mm which might be from nixiaoming@huawei.com are

squashfs-add-the-mount-parameter-theads=singlemultipercpu.patch
squashfs-allows-users-to-configure-the-number-of-decompression-threads.patch


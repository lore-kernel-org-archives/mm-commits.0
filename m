Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EA6C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  9 Feb 2022 18:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbiBISGD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238652AbiBISGB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2022 13:06:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAD4C05CB88
        for <mm-commits@vger.kernel.org>; Wed,  9 Feb 2022 10:06:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 204E761B69
        for <mm-commits@vger.kernel.org>; Wed,  9 Feb 2022 18:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C9DC340E7;
        Wed,  9 Feb 2022 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644429962;
        bh=6wf6QIN0IrhQBebpjduVfAxqrxkOO8k+tn/oEqA17Hc=;
        h=Date:From:To:Subject:From;
        b=Qu3CphZtPffu8WdFJlmNRdsvBqXBzXGr2HJYHYuScmgl3p29lza4XW7n71desSz+0
         A49Uk8vESVKCBTRLLf3LzVW3SIrzjUFsbz0tVl9OCi/VxPSlEODmUsNcKFozeVn1vr
         kVtWPiQSh8sWxFhN2duMiMYd5qy/PrHe+4bRriOw=
Date:   Wed, 09 Feb 2022 10:06:01 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, domenico.andreoli@linux.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 fix-regression-due-to-fs-move-binfmt_misc-sysctl-to-its-own-file.patch
 removed from -mm tree
Message-ID: <20220209180601.sefQRYbdF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix regression due to "fs: move binfmt_misc sysctl to its own file"
has been removed from the -mm tree.  Its filename was
     fix-regression-due-to-fs-move-binfmt_misc-sysctl-to-its-own-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Domenico Andreoli <domenico.andreoli@linux.com>
Subject: fix regression due to "fs: move binfmt_misc sysctl to its own file"

Commit 3ba442d5331f did not go unnoticed, binfmt-support stopped to work
on my Debian system since v5.17-rc2 (did not check with -rc1).

The existence of /proc/sys/fs/binfmt_misc is a precondition for attempting
to mount the binfmt_misc fs, which in turn triggers the autoload of the
binfmt_misc module.  Without it, no module is loaded and no binfmt is
available at boot.

Building as built-in or manually loading the module and mounting the fs
works fine, it's therefore only a matter of interaction with user-space.

I could try to improve the Debian systemd configuration but I can't
say anything about the other distributions.

In the meanwhile this patch restores a working system right after boot.

Link: https://lkml.kernel.org/r/YgEeQNdgBuHRyEWl@dumbo
Fixes: 3ba442d5331f ("fs: move binfmt_misc sysctl to its own file")
Signed-off-by: Domenico Andreoli <domenico.andreoli@linux.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    6 +-----
 kernel/sysctl.c  |   13 +++++++++++++
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/fs/binfmt_misc.c~fix-regression-due-to-fs-move-binfmt_misc-sysctl-to-its-own-file
+++ a/fs/binfmt_misc.c
@@ -817,20 +817,16 @@ static struct file_system_type bm_fs_typ
 };
 MODULE_ALIAS_FS("binfmt_misc");
 
-static struct ctl_table_header *binfmt_misc_header;
-
 static int __init init_misc_binfmt(void)
 {
 	int err = register_filesystem(&bm_fs_type);
 	if (!err)
 		insert_binfmt(&misc_format);
-	binfmt_misc_header = register_sysctl_mount_point("fs/binfmt_misc");
-	return 0;
+	return err;
 }
 
 static void __exit exit_misc_binfmt(void)
 {
-	unregister_sysctl_table(binfmt_misc_header);
 	unregister_binfmt(&misc_format);
 	unregister_filesystem(&bm_fs_type);
 }
--- a/kernel/sysctl.c~fix-regression-due-to-fs-move-binfmt_misc-sysctl-to-its-own-file
+++ a/kernel/sysctl.c
@@ -2806,6 +2806,17 @@ static struct ctl_table vm_table[] = {
 	{ }
 };
 
+static struct ctl_table fs_table[] = {
+#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
+	{
+		.procname	= "binfmt_misc",
+		.mode		= 0555,
+		.child		= sysctl_mount_point,
+	},
+#endif
+	{ }
+};
+
 static struct ctl_table debug_table[] = {
 #ifdef CONFIG_SYSCTL_EXCEPTION_TRACE
 	{
@@ -2825,6 +2836,7 @@ static struct ctl_table dev_table[] = {
 
 DECLARE_SYSCTL_BASE(kernel, kern_table);
 DECLARE_SYSCTL_BASE(vm, vm_table);
+DECLARE_SYSCTL_BASE(fs, fs_table);
 DECLARE_SYSCTL_BASE(debug, debug_table);
 DECLARE_SYSCTL_BASE(dev, dev_table);
 
@@ -2832,6 +2844,7 @@ int __init sysctl_init_bases(void)
 {
 	register_sysctl_base(kernel);
 	register_sysctl_base(vm);
+	register_sysctl_base(fs);
 	register_sysctl_base(debug);
 	register_sysctl_base(dev);
 
_

Patches currently in -mm which might be from domenico.andreoli@linux.com are



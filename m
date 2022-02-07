Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5879C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiBGVAx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiBGVAe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FBAC0401E1
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8FD86156D
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26226C004E1;
        Mon,  7 Feb 2022 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267627;
        bh=upaJNjvW3tkA/mivpFwnXBQk8JhQJU+CPJU4bzozKkI=;
        h=Date:To:From:Subject:From;
        b=KJ6rn5nzCXIQNxMQL8i8xW0BYXBBND+UMCSmJrMThXCzMf4LRJvH7+t7FNXjE/0SD
         9v3EypMS/OgyuV+WHtDUWGY9aUZ0K9EFiRj7u6JnUizcKUkVj2ZNXv0cMBO3hIqs4Z
         l5ZTBPFmR7A6nJjphChd8S4aDGOCGNlvYFT2yy1E=
Date:   Mon, 07 Feb 2022 13:00:26 -0800
To:     mm-commits@vger.kernel.org, mcgrof@kernel.org,
        domenico.andreoli@linux.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-regression-due-to-fs-move-binfmt_misc-sysctl-to-its-own-file.patch added to -mm tree
Message-Id: <20220207210027.26226C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix regression due to "fs: move binfmt_misc sysctl to its own file"
has been added to the -mm tree.  Its filename is
     fix-regression-due-to-fs-move-binfmt_misc-sysctl-to-its-own-file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fix-regression-due-to-fs-move-binfmt_misc-sysctl-to-its-own-file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fix-regression-due-to-fs-move-binfmt_misc-sysctl-to-its-own-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fix-regression-due-to-fs-move-binfmt_misc-sysctl-to-its-own-file.patch


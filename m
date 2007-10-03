From: akpm@linux-foundation.org
Subject: + kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch added to -mm tree
Date: Wed, 03 Oct 2007 14:19:20 -0700
Message-ID: <200710032119.l93LJKx7009231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49055 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302AbXJCVT0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 17:19:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl


The patch titled
     kernel/fork.c: remove unneeded variable initialization in copy_process()
has been added to the -mm tree.  Its filename is
     kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/fork.c: remove unneeded variable initialization in copy_process()
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This initialization of is not needed so just remove it.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/fork.c~kernel-forkc-remove-unneeded-variable-initialization-in-copy_process kernel/fork.c
--- a/kernel/fork.c~kernel-forkc-remove-unneeded-variable-initialization-in-copy_process
+++ a/kernel/fork.c
@@ -981,7 +981,7 @@ static struct task_struct *copy_process(
 					struct pid *pid)
 {
 	int retval;
-	struct task_struct *p = NULL;
+	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-alsa.patch
sound-snd_register_device_for_dev-fix.patch
git-arm.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
git-hid.patch
git-mmc.patch
git-mtd.patch
git-net.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch

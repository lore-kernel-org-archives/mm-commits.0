From: akpm@linux-foundation.org
Subject: + md-fix-integer-as-null-pointer-warnings-in-mdc.patch added to -mm tree
Date: Wed, 27 Feb 2008 18:45:31 -0800
Message-ID: <200802280245.m1S2jVqp011923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbYB1CqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 21:46:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, neilb@suse.de


The patch titled
     md: fix integer as NULL pointer warnings in md.c
has been added to the -mm tree.  Its filename is
     md-fix-integer-as-null-pointer-warnings-in-mdc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix integer as NULL pointer warnings in md.c
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/md/md.c:734:16: warning: Using plain integer as NULL pointer
drivers/md/md.c:1115:16: warning: Using plain integer as NULL pointer

Add some braces to match the else-block as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/md/md.c~md-fix-integer-as-null-pointer-warnings-in-mdc drivers/md/md.c
--- a/drivers/md/md.c~md-fix-integer-as-null-pointer-warnings-in-mdc
+++ a/drivers/md/md.c
@@ -731,9 +731,9 @@ static int super_90_load(mdk_rdev_t *rde
 	else
 		rdev->desc_nr = sb->this_disk.number;
 
-	if (refdev == 0)
+	if (!refdev) {
 		ret = 1;
-	else {
+	} else {
 		__u64 ev1, ev2;
 		mdp_super_t *refsb = (mdp_super_t*)page_address(refdev->sb_page);
 		if (!uuid_equal(refsb, sb)) {
@@ -1112,9 +1112,9 @@ static int super_1_load(mdk_rdev_t *rdev
 	else
 		rdev->desc_nr = le32_to_cpu(sb->dev_number);
 
-	if (refdev == 0)
+	if (!refdev) {
 		ret = 1;
-	else {
+	} else {
 		__u64 ev1, ev2;
 		struct mdp_superblock_1 *refsb = 
 			(struct mdp_superblock_1*)page_address(refdev->sb_page);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
specialixc-fix-possible-double-unlock.patch
git-x86.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
git-dvb.patch
git-dlm.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-net.patch
git-nfsd.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch

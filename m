From: akpm@linux-foundation.org
Subject: + agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch added to -mm tree
Date: Wed, 27 Feb 2008 18:31:59 -0800
Message-ID: <200802280231.m1S2VxOf011412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbYB1CcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 21:32:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, airlied@linux.ie


The patch titled
     agp: fix shadowed variable warning in amd-k7-agp.c
has been added to the -mm tree.  Its filename is
     agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch

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
Subject: agp: fix shadowed variable warning in amd-k7-agp.c
From: Harvey Harrison <harvey.harrison@gmail.com>

Introduced between 2.6.25-rc2 and -rc3
drivers/char/agp/amd-k7-agp.c:439:6: warning: symbol 'cap_ptr' shadows an earlier one
drivers/char/agp/amd-k7-agp.c:414:5: originally declared here

cap_ptr is never used again in this function, don't bother redeclaring.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/amd-k7-agp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/agp/amd-k7-agp.c~agp-fix-shadowed-variable-warning-in-amd-k7-agpc drivers/char/agp/amd-k7-agp.c
--- a/drivers/char/agp/amd-k7-agp.c~agp-fix-shadowed-variable-warning-in-amd-k7-agpc
+++ a/drivers/char/agp/amd-k7-agp.c
@@ -436,8 +436,9 @@ static int __devinit agp_amdk7_probe(str
 	   system controller may experience noise due to strong drive strengths
 	 */
 	if (agp_bridge->dev->device == PCI_DEVICE_ID_AMD_FE_GATE_7006) {
-		u8 cap_ptr=0;
 		struct pci_dev *gfxcard=NULL;
+
+		cap_ptr = 0;
 		while (!cap_ptr) {
 			gfxcard = pci_get_class(PCI_CLASS_DISPLAY_VGA<<8, gfxcard);
 			if (!gfxcard) {
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
specialixc-fix-possible-double-unlock.patch
git-x86.patch
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
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
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
fbcon-replace-mono_col-macro-with-static-inline.patch
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
xen-make-blkif_getgeo-static.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch

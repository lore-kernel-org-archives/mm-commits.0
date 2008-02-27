From: akpm@linux-foundation.org
Subject: + cycladesc-fix-sparse-shadowed-variable-warnings.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:30:29 -0800
Message-ID: <200802272330.m1RNUTF4004138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755576AbYB0Xa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:30:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     cyclades.c: fix sparse shadowed variable warnings
has been added to the -mm tree.  Its filename is
     cycladesc-fix-sparse-shadowed-variable-warnings.patch

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
Subject: cyclades.c: fix sparse shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

Nested min() macros.
drivers/char/cyclades.c:2750:7: warning: symbol '_x' shadows an earlier one
drivers/char/cyclades.c:2750:7: originally declared here
drivers/char/cyclades.c:2750:7: warning: symbol '_x' shadows an earlier one
drivers/char/cyclades.c:2750:7: originally declared here
drivers/char/cyclades.c:2750:7: warning: symbol '_y' shadows an earlier one
drivers/char/cyclades.c:2750:7: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/cyclades.c~cycladesc-fix-sparse-shadowed-variable-warnings drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~cycladesc-fix-sparse-shadowed-variable-warnings
+++ a/drivers/char/cyclades.c
@@ -2747,8 +2747,8 @@ static int cy_write(struct tty_struct *t
 
 	spin_lock_irqsave(&info->card->card_lock, flags);
 	while (1) {
-		c = min(count, min((int)(SERIAL_XMIT_SIZE - info->xmit_cnt - 1),
-				   (int)(SERIAL_XMIT_SIZE - info->xmit_head)));
+		c = min(count, (int)(SERIAL_XMIT_SIZE - info->xmit_cnt - 1));
+		c = min(c, (int)(SERIAL_XMIT_SIZE - info->xmit_head));
 
 		if (c <= 0)
 			break;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
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

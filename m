From: akpm@linux-foundation.org
Subject: + char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:29:54 -0800
Message-ID: <200802272329.m1RNTsFQ004101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421AbYB0XaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:30:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     char: rocket.c: fix sparse variable shadowing and int as NULL pointer
has been added to the -mm tree.  Its filename is
     char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch

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
Subject: char: rocket.c: fix sparse variable shadowing and int as NULL pointer
From: Harvey Harrison <harvey.harrison@gmail.com>

Nested min() macros shadow _x, separate into two lines.
drivers/char/rocket.c:451:7: warning: symbol '_x' shadows an earlier one
drivers/char/rocket.c:451:7: originally declared here
drivers/char/rocket.c:451:7: warning: symbol '_x' shadows an earlier one
drivers/char/rocket.c:451:7: originally declared here
drivers/char/rocket.c:451:7: warning: symbol '_y' shadows an earlier one
drivers/char/rocket.c:451:7: originally declared here
drivers/char/rocket.c:1754:7: warning: symbol '_x' shadows an earlier one
drivers/char/rocket.c:1754:7: originally declared here
drivers/char/rocket.c:1754:7: warning: symbol '_x' shadows an earlier one
drivers/char/rocket.c:1754:7: originally declared here
drivers/char/rocket.c:1754:7: warning: symbol '_y' shadows an earlier one
drivers/char/rocket.c:1754:7: originally declared here
drivers/char/rocket.c:1751:20: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/char/rocket.c~char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer drivers/char/rocket.c
--- a/drivers/char/rocket.c~char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer
+++ a/drivers/char/rocket.c
@@ -448,7 +448,8 @@ static void rp_do_transmit(struct r_port
 	while (1) {
 		if (tty->stopped || tty->hw_stopped)
 			break;
-		c = min(info->xmit_fifo_room, min(info->xmit_cnt, XMIT_BUF_SIZE - info->xmit_tail));
+		c = min(info->xmit_fifo_room, info->xmit_cnt);
+		c = min(c, XMIT_BUF_SIZE - info->xmit_tail);
 		if (c <= 0 || info->xmit_fifo_room <= 0)
 			break;
 		sOutStrW(sGetTxRxDataIO(cp), (unsigned short *) (info->xmit_buf + info->xmit_tail), c / 2);
@@ -1757,10 +1758,10 @@ static int rp_write(struct tty_struct *t
 
 	/*  Write remaining data into the port's xmit_buf */
 	while (1) {
-		if (info->tty == 0)	/*   Seemingly obligatory check... */
+		if (info->tty == NULL)	/*   Seemingly obligatory check... */
 			goto end;
-
-		c = min(count, min(XMIT_BUF_SIZE - info->xmit_cnt - 1, XMIT_BUF_SIZE - info->xmit_head));
+		c = min(count, XMIT_BUF_SIZE - info->xmit_cnt - 1);
+		c = min(c, XMIT_BUF_SIZE - info->xmit_head);
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

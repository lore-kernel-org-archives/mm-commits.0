From: akpm@linux-foundation.org
Subject: +
 ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch added to -mm tree
Date: Wed, 10 Aug 2016 15:54:09 -0700
Message-ID: <57abb091.tRowUdLNrCd97dOX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbcHJWyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 18:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes

WARNING: braces {} are not necessary for single statement blocks
#134: FILE: ipc/msg.c:679:
+		if (msg_fits_inqueue(msq, msgsz)) {
 			break;
 		}

total: 0 errors, 1 warnings, 118 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/ipc-msg-avoid-waking-sender-upon-full-queue.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN ipc/msg.c~ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes ipc/msg.c
--- a/ipc/msg.c~ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes
+++ a/ipc/msg.c
@@ -676,9 +676,8 @@ long do_msgsnd(int msqid, long mtype, vo
 		if (err)
 			goto out_unlock0;
 
-		if (msg_fits_inqueue(msq, msgsz)) {
+		if (msg_fits_inqueue(msq, msgsz))
 			break;
-		}
 
 		/* queue full, wait: */
 		if (msgflg & IPC_NOWAIT) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-arm-keystone-dts-add-psci-command-definition.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


From: akpm@linux-foundation.org
Subject: + kfifo-add-kfifo_initialized.patch added to -mm tree
Date: Mon, 04 Jan 2010 14:05:03 -0800
Message-ID: <201001042205.o04M53UT020995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731Ab0ADWGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 17:06:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, awalls@radix.net, dhillonv10@gmail.com, dmitry.torokhov@gmail.com, rdreier@cisco.com, stefani@seibold.net


The patch titled
     kfifo: add kfifo_initialized
has been added to the -mm tree.  Its filename is
     kfifo-add-kfifo_initialized.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: add kfifo_initialized
From: Andi Kleen <andi@firstfloor.org>

Simple inline that checks if kfifo_init() has been executed on a fifo.

This is useful for walking all per CPU fifos, when some of them might not
have been brought up yet.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andy Walls <awalls@radix.net>
Cc: Vikram Dhillon <dhillonv10@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/kfifo.h~kfifo-add-kfifo_initialized include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-add-kfifo_initialized
+++ a/include/linux/kfifo.h
@@ -116,6 +116,16 @@ extern __must_check unsigned int kfifo_o
 extern __must_check unsigned int kfifo_out_peek(struct kfifo *fifo,
 				void *to, unsigned int len, unsigned offset);
 
+/**
+ * kfifo_initialized - Check if kfifo is initialized.
+ * @fifo: fifo to check
+ * Return %true if FIFO is initialized, otherwise %false.
+ * Assumes the fifo was 0 before.
+ */
+static inline bool kfifo_initialized(struct kfifo *fifo)
+{
+	return fifo->buffer != 0;
+}
 
 /**
  * kfifo_reset - removes the entire FIFO contents
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1.patch
kfifo-use-void-pointers-for-user-buffers.patch
kfifo-make-kfifo_in-atomic.patch
kfifo-sanitize-_user-error-handling.patch
kfifo-add-kfifo_out_peek.patch
kfifo-add-kfifo_initialized.patch
kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch
hardware-latency-detector-remove-default-m.patch
kbuild-move-fno-dwarf2-cfi-asm-to-powerpc-only.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch


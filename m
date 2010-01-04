From: akpm@linux-foundation.org
Subject: + kfifo-make-kfifo_in-atomic.patch added to -mm tree
Date: Mon, 04 Jan 2010 14:04:56 -0800
Message-ID: <201001042204.o04M4uEU020982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731Ab0ADWGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 17:06:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, awalls@radix.net, dhillonv10@gmail.com, dmitry.torokhov@gmail.com, rdreier@cisco.com, stefani@seibold.net


The patch titled
     kfifo: make kfifo_in atomic
has been added to the -mm tree.  Its filename is
     kfifo-make-kfifo_in-atomic.patch

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
Subject: kfifo: make kfifo_in atomic
From: Andi Kleen <andi@firstfloor.org>

Right now kfifo_in allows copying in less than the input amount.  This is
unfortunately not a good idea on any record oriented users: if the size of
the kfifo is not a multiple of the record (and that can easily happen due
to the power-of-two requirement) then when the FIFO fills up partial
records could be put in.  Such a condition would be fatal for any record
consumer who would get permanently desynchronized.  In fact I doubt unless
the input is a totally boundary less data stream I doubt anything could
handle this.

Change kfifo_in() to always put in everything or nothing.

The return value is now always 0 or the full length.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andy Walls <awalls@radix.net>
Cc: Vikram Dhillon <dhillonv10@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kfifo.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/kfifo.c~kfifo-make-kfifo_in-atomic kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-make-kfifo_in-atomic
+++ a/kernel/kfifo.c
@@ -228,9 +228,8 @@ EXPORT_SYMBOL(__kfifo_in_n);
  * @from: the data to be added.
  * @len: the length of the data to be added.
  *
- * This function copies at most @len bytes from the @from buffer into
- * the FIFO depending on the free space, and returns the number of
- * bytes copied.
+ * This function copies @len bytes from the @from buffer into
+ * the FIFO and returns 0 if there is not enough space.
  *
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
@@ -238,8 +237,8 @@ EXPORT_SYMBOL(__kfifo_in_n);
 unsigned int kfifo_in(struct kfifo *fifo, const void *from,
 				unsigned int len)
 {
-	len = min(kfifo_avail(fifo), len);
-
+	if (kfifo_avail(fifo) < len)
+		return 0;
 	__kfifo_in_data(fifo, from, len, 0);
 	__kfifo_add_in(fifo, len);
 	return len;
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


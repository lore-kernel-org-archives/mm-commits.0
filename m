From: akpm@linux-foundation.org
Subject: + kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch added to -mm tree
Date: Mon, 04 Jan 2010 14:05:05 -0800
Message-ID: <201001042205.o04M55Qh020998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380Ab0ADWGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 17:06:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, awalls@radix.net, dhillonv10@gmail.com, dmitry.torokhov@gmail.com, rdreier@cisco.com, stefani@seibold.net


The patch titled
     kfifo: document everywhere that size has to be power of two
has been added to the -mm tree.  Its filename is
     kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch

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
Subject: kfifo: document everywhere that size has to be power of two
From: Andi Kleen <andi@firstfloor.org>

On my first try using them I missed that the fifos need to be power of
two, resulting in a runtime bug.  Document that requirement everywhere
(and fix one grammar bug)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andy Walls <awalls@radix.net>
Cc: Vikram Dhillon <dhillonv10@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    4 ++--
 kernel/kfifo.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/kfifo.h~kfifo-document-everywhere-that-size-has-to-be-power-of-two include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-document-everywhere-that-size-has-to-be-power-of-two
+++ a/include/linux/kfifo.h
@@ -67,7 +67,7 @@ struct kfifo {
 /**
  * DECLARE_KFIFO - macro to declare a kfifo and the associated buffer
  * @name: name of the declared kfifo datatype
- * @size: size of the fifo buffer
+ * @size: size of the fifo buffer. Must be a power of two.
  *
  * Note1: the macro can be used inside struct or union declaration
  * Note2: the macro creates two objects:
@@ -91,7 +91,7 @@ union { \
 /**
  * DEFINE_KFIFO - macro to define and initialize a kfifo
  * @name: name of the declared kfifo datatype
- * @size: size of the fifo buffer
+ * @size: size of the fifo buffer. Must be a power of two.
  *
  * Note1: the macro can be used for global and local kfifo data type variables
  * Note2: the macro creates two objects:
diff -puN kernel/kfifo.c~kfifo-document-everywhere-that-size-has-to-be-power-of-two kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-document-everywhere-that-size-has-to-be-power-of-two
+++ a/kernel/kfifo.c
@@ -41,7 +41,7 @@ static void _kfifo_init(struct kfifo *fi
  * kfifo_init - initialize a FIFO using a preallocated buffer
  * @fifo: the fifo to assign the buffer
  * @buffer: the preallocated buffer to be used.
- * @size: the size of the internal buffer, this have to be a power of 2.
+ * @size: the size of the internal buffer, this has to be a power of 2.
  *
  */
 void kfifo_init(struct kfifo *fifo, void *buffer, unsigned int size)
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


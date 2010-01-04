From: akpm@linux-foundation.org
Subject: + kfifo-sanitize-_user-error-handling.patch added to -mm tree
Date: Mon, 04 Jan 2010 14:04:58 -0800
Message-ID: <201001042204.o04M4x6J020986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682Ab0ADWGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 17:06:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, awalls@radix.net, dhillonv10@gmail.com, dmitry.torokhov@gmail.com, rdreier@cisco.com, stefani@seibold.net


The patch titled
     kfifo: sanitize *_user error handling
has been added to the -mm tree.  Its filename is
     kfifo-sanitize-_user-error-handling.patch

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
Subject: kfifo: sanitize *_user error handling
From: Andi Kleen <andi@firstfloor.org>

Right now for kfifo_*_user it's not easily possible to distingush between
a user copy failing and the FIFO not containing enough data.  The problem
is that both conditions are multiplexed into the same return code.

Avoid this by moving the "copy length" into a separate output parameter
and only return 0/-EFAULT in the main return value.

I didn't fully adapt the weird "record" variants, those seem
to be unused anyways and were rather messy (should they be just removed?)

I would appreciate some double checking if I did all the conversions
correctly.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andy Walls <awalls@radix.net>
Cc: Vikram Dhillon <dhillonv10@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    8 ++--
 kernel/kfifo.c        |   76 +++++++++++++++++++++++++---------------
 2 files changed, 53 insertions(+), 31 deletions(-)

diff -puN include/linux/kfifo.h~kfifo-sanitize-_user-error-handling include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-sanitize-_user-error-handling
+++ a/include/linux/kfifo.h
@@ -242,11 +242,11 @@ static inline __must_check unsigned int 
 
 extern void kfifo_skip(struct kfifo *fifo, unsigned int len);
 
-extern __must_check unsigned int kfifo_from_user(struct kfifo *fifo,
-	const void __user *from, unsigned int n);
+extern __must_check int kfifo_from_user(struct kfifo *fifo,
+	const void __user *from, unsigned int n, unsigned *lenout);
 
-extern __must_check unsigned int kfifo_to_user(struct kfifo *fifo,
-	void __user *to, unsigned int n);
+extern __must_check int kfifo_to_user(struct kfifo *fifo,
+	void __user *to, unsigned int n, unsigned *lenout);
 
 /*
  * __kfifo_add_out internal helper function for updating the out offset
diff -puN kernel/kfifo.c~kfifo-sanitize-_user-error-handling kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-sanitize-_user-error-handling
+++ a/kernel/kfifo.c
@@ -159,8 +159,9 @@ static inline void __kfifo_out_data(stru
 	memcpy(to + l, fifo->buffer, len - l);
 }
 
-static inline unsigned int __kfifo_from_user_data(struct kfifo *fifo,
-	 const void __user *from, unsigned int len, unsigned int off)
+static inline int __kfifo_from_user_data(struct kfifo *fifo,
+	 const void __user *from, unsigned int len, unsigned int off,
+	 unsigned *lenout)
 {
 	unsigned int l;
 	int ret;
@@ -177,16 +178,20 @@ static inline unsigned int __kfifo_from_
 	/* first put the data starting from fifo->in to buffer end */
 	l = min(len, fifo->size - off);
 	ret = copy_from_user(fifo->buffer + off, from, l);
-
-	if (unlikely(ret))
-		return ret + len - l;
+	if (unlikely(ret)) {
+		*lenout = ret;
+		return -EFAULT;
+	}
+	*lenout = l;
 
 	/* then put the rest (if any) at the beginning of the buffer */
-	return copy_from_user(fifo->buffer, from + l, len - l);
+	ret = copy_from_user(fifo->buffer, from + l, len - l);
+	*lenout += ret ? ret : len - l;
+	return ret ? -EFAULT : 0;
 }
 
-static inline unsigned int __kfifo_to_user_data(struct kfifo *fifo,
-		void __user *to, unsigned int len, unsigned int off)
+static inline int __kfifo_to_user_data(struct kfifo *fifo,
+		void __user *to, unsigned int len, unsigned int off, unsigned *lenout)
 {
 	unsigned int l;
 	int ret;
@@ -203,12 +208,21 @@ static inline unsigned int __kfifo_to_us
 	/* first get the data from fifo->out until the end of the buffer */
 	l = min(len, fifo->size - off);
 	ret = copy_to_user(to, fifo->buffer + off, l);
-
-	if (unlikely(ret))
-		return ret + len - l;
+	*lenout = l;
+	if (unlikely(ret)) {
+		*lenout -= ret;
+		return -EFAULT;
+	}
 
 	/* then get the rest (if any) from the beginning of the buffer */
-	return copy_to_user(to + l, fifo->buffer, len - l);
+	len -= l;
+	ret = copy_to_user(to + l, fifo->buffer, len);
+	if (unlikely(ret)) {
+		*lenout += len - ret;
+		return -EFAULT;
+	}
+	*lenout += len;
+	return 0;
 }
 
 unsigned int __kfifo_in_n(struct kfifo *fifo,
@@ -298,10 +312,13 @@ EXPORT_SYMBOL(__kfifo_out_generic);
 unsigned int __kfifo_from_user_n(struct kfifo *fifo,
 	const void __user *from, unsigned int len, unsigned int recsize)
 {
+	unsigned total;
+
 	if (kfifo_avail(fifo) < len + recsize)
 		return len + 1;
 
-	return __kfifo_from_user_data(fifo, from, len, recsize);
+	__kfifo_from_user_data(fifo, from, len, recsize, &total);
+	return total;
 }
 EXPORT_SYMBOL(__kfifo_from_user_n);
 
@@ -312,18 +329,21 @@ EXPORT_SYMBOL(__kfifo_from_user_n);
  * @len: the length of the data to be added.
  *
  * This function copies at most @len bytes from the @from into the
- * FIFO depending and returns the number of copied bytes.
+ * FIFO depending and returns -EFAULT/0.
  *
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int kfifo_from_user(struct kfifo *fifo,
-	const void __user *from, unsigned int len)
+int kfifo_from_user(struct kfifo *fifo,
+        const void __user *from, unsigned int len, unsigned *total)
 {
+	int ret;
 	len = min(kfifo_avail(fifo), len);
-	len -= __kfifo_from_user_data(fifo, from, len, 0);
+	ret = __kfifo_from_user_data(fifo, from, len, 0, total);
+	if (ret)
+		return ret;
 	__kfifo_add_in(fifo, len);
-	return len;
+	return 0;
 }
 EXPORT_SYMBOL(kfifo_from_user);
 
@@ -338,17 +358,17 @@ unsigned int __kfifo_to_user_n(struct kf
 	void __user *to, unsigned int len, unsigned int reclen,
 	unsigned int recsize)
 {
-	unsigned int ret;
+	unsigned int ret, total;
 
 	if (kfifo_len(fifo) < reclen + recsize)
 		return len;
 
-	ret = __kfifo_to_user_data(fifo, to, reclen, recsize);
+	ret = __kfifo_to_user_data(fifo, to, reclen, recsize, &total);
 
 	if (likely(ret == 0))
 		__kfifo_add_out(fifo, reclen + recsize);
 
-	return ret;
+	return total;
 }
 EXPORT_SYMBOL(__kfifo_to_user_n);
 
@@ -357,20 +377,22 @@ EXPORT_SYMBOL(__kfifo_to_user_n);
  * @fifo: the fifo to be used.
  * @to: where the data must be copied.
  * @len: the size of the destination buffer.
+ @ @lenout: pointer to output variable with copied data
  *
  * This function copies at most @len bytes from the FIFO into the
- * @to buffer and returns the number of copied bytes.
+ * @to buffer and 0 or -EFAULT.
  *
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int kfifo_to_user(struct kfifo *fifo,
-	void __user *to, unsigned int len)
+int kfifo_to_user(struct kfifo *fifo,
+	void __user *to, unsigned int len, unsigned *lenout)
 {
+	int ret;
 	len = min(kfifo_len(fifo), len);
-	len -= __kfifo_to_user_data(fifo, to, len, 0);
-	__kfifo_add_out(fifo, len);
-	return len;
+	ret = __kfifo_to_user_data(fifo, to, len, 0, lenout);
+	__kfifo_add_out(fifo, *lenout);
+	return ret;
 }
 EXPORT_SYMBOL(kfifo_to_user);
 
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


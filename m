Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F22CEC7
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 00:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708734390; cv=none; b=n4QMhROLTlJCRjd5Pv/ql0SfO1EKmZjsNv/OnRRb+bqef8Q5b8fJbdu1RG0/UW/SAZ5IAJNM4g0Hv9lrVpL9nB8TmElfJE6udeHpOl1V98v90aAZ2zqWQf2wkOabsILU33HbvtUnQ+lcN/Srp46yOKlkZ158eUsOTK8xjWypZKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708734390; c=relaxed/simple;
	bh=jgLw+NJBBhMx3Yg894AFaMX9R1iKOE6/Mxq8NfGahvw=;
	h=Date:To:From:Subject:Message-Id; b=iYxRrun2tQ0gk10WlbRf2LzcmIv4THqYdMlhUc2d0zj1hTyX2LxktvVBDWlxm1ibb4LtDw3xrHHF6Q8Ac1VzM08mjeWUlx+0VMA5kYfmO9saTPwkv2oCQ9Dc/TIhTuq2klXnKn+eI3+EOMw4NtEFvkf5ITHoGEc41l/aNTlpWAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fas7wOJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fas7wOJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C93C433F1;
	Sat, 24 Feb 2024 00:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708734390;
	bh=jgLw+NJBBhMx3Yg894AFaMX9R1iKOE6/Mxq8NfGahvw=;
	h=Date:To:From:Subject:From;
	b=fas7wOJppNI4blj2dwRUUlDa1RNp75TGF+VFX065HtVqnP2FCjnk3sdrrNiSP1LAI
	 27Ibfl48vozRqOyc8PROc1xfxzsI9qHm4cORELdNq+Vk91jpYKXLus1/IBhwptTuWq
	 wmvbtgEqW4NCjpxInVLSj1t9AyxqGwZZt8OMSdm0=
Date: Fri, 23 Feb 2024 16:26:29 -0800
To: mm-commits@vger.kernel.org,stefani@seibold.net,jirislaby@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfifo-add-kfifo_out_linear_ptr.patch added to mm-nonmm-unstable branch
Message-Id: <20240224002630.12C93C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfifo: add kfifo_out_linear{,_ptr}()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kfifo-add-kfifo_out_linear_ptr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfifo-add-kfifo_out_linear_ptr.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Subject: kfifo: add kfifo_out_linear{,_ptr}()
Date: Fri, 23 Feb 2024 12:51:54 +0100

These are helpers which are going to be used in the serial layer.  We need
a wrapper around kfifo which provides us with a tail (sometimes "tail"
offset, sometimes a pointer) to the kfifo data.  And which returns count
of available data -- but not larger than to the end of the buffer (hence
_linear in the names).  I.e.  something like CIRC_CNT_TO_END() in the
legacy circ_buf.

This patch adds such two helpers.

Link: https://lkml.kernel.org/r/20240223115155.8806-4-jirislaby@kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |   64 ++++++++++++++++++++++++++++++++++++++++
 lib/kfifo.c           |   28 +++++++++++++++++
 2 files changed, 92 insertions(+)

--- a/include/linux/kfifo.h~kfifo-add-kfifo_out_linear_ptr
+++ a/include/linux/kfifo.h
@@ -827,6 +827,64 @@ __kfifo_uint_must_check_helper( \
 }) \
 )
 
+/**
+ * kfifo_out_linear - gets a tail of/offset to available data
+ * @fifo: address of the fifo to be used
+ * @tail: pointer to an unsigned int to store the value of tail
+ * @n: max. number of elements to point at
+ *
+ * This macro obtains the offset (tail) to the available data in the fifo
+ * buffer and returns the
+ * numbers of elements available. It returns the available count till the end
+ * of data or till the end of the buffer. So that it can be used for linear
+ * data processing (like memcpy() of (@fifo->data + @tail) with count
+ * returned).
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define kfifo_out_linear(fifo, tail, n) \
+__kfifo_uint_must_check_helper( \
+({ \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	unsigned int *__tail = (tail); \
+	unsigned long __n = (n); \
+	const size_t __recsize = sizeof(*__tmp->rectype); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	(__recsize) ? \
+	__kfifo_out_linear_r(__kfifo, __tail, __n, __recsize) : \
+	__kfifo_out_linear(__kfifo, __tail, __n); \
+}) \
+)
+
+/**
+ * kfifo_out_linear_ptr - gets a pointer to the available data
+ * @fifo: address of the fifo to be used
+ * @ptr: pointer to data to store the pointer to tail
+ * @n: max. number of elements to point at
+ *
+ * Similarly to kfifo_out_linear(), this macro obtains the pointer to the
+ * available data in the fifo buffer and returns the numbers of elements
+ * available. It returns the available count till the end of available data or
+ * till the end of the buffer. So that it can be used for linear data
+ * processing (like memcpy() of @ptr with count returned).
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macro.
+ */
+#define kfifo_out_linear_ptr(fifo, ptr, n) \
+__kfifo_uint_must_check_helper( \
+({ \
+	typeof((fifo) + 1) ___tmp = (fifo); \
+	unsigned int ___tail; \
+	unsigned int ___n = kfifo_out_linear(___tmp, &___tail, (n)); \
+	struct __kfifo *___kfifo = &___tmp->kfifo; \
+	*(ptr) = ___kfifo->data + ___tail * kfifo_esize(___tmp); \
+	___n; \
+}) \
+)
+
+
 extern int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
 	size_t esize, gfp_t gfp_mask);
 
@@ -856,6 +914,9 @@ extern unsigned int __kfifo_dma_out_prep
 extern unsigned int __kfifo_out_peek(struct __kfifo *fifo,
 	void *buf, unsigned int len);
 
+extern unsigned int __kfifo_out_linear(struct __kfifo *fifo,
+	unsigned int *tail, unsigned int n);
+
 extern unsigned int __kfifo_in_r(struct __kfifo *fifo,
 	const void *buf, unsigned int len, size_t recsize);
 
@@ -885,6 +946,9 @@ extern void __kfifo_skip_r(struct __kfif
 extern unsigned int __kfifo_out_peek_r(struct __kfifo *fifo,
 	void *buf, unsigned int len, size_t recsize);
 
+extern unsigned int __kfifo_out_linear_r(struct __kfifo *fifo,
+	unsigned int *tail, unsigned int n, size_t recsize);
+
 extern unsigned int __kfifo_max_r(unsigned int len, size_t recsize);
 
 #endif
--- a/lib/kfifo.c~kfifo-add-kfifo_out_linear_ptr
+++ a/lib/kfifo.c
@@ -163,6 +163,21 @@ unsigned int __kfifo_out_peek(struct __k
 }
 EXPORT_SYMBOL(__kfifo_out_peek);
 
+unsigned int __kfifo_out_linear(struct __kfifo *fifo,
+		unsigned int *tail, unsigned int n)
+{
+	unsigned int size = fifo->mask + 1;
+	unsigned int off = fifo->out & fifo->mask;
+
+	n = min3(n, fifo->in - fifo->out, size - off);
+
+	if (tail)
+		*tail = off;
+
+	return n;
+}
+EXPORT_SYMBOL(__kfifo_out_linear);
+
 unsigned int __kfifo_out(struct __kfifo *fifo,
 		void *buf, unsigned int len)
 {
@@ -473,6 +488,19 @@ unsigned int __kfifo_out_peek_r(struct _
 }
 EXPORT_SYMBOL(__kfifo_out_peek_r);
 
+unsigned int __kfifo_out_linear_r(struct __kfifo *fifo,
+		unsigned int *tail, unsigned int n, size_t recsize)
+{
+	if (fifo->in == fifo->out)
+		return 0;
+
+	if (tail)
+		*tail = fifo->out + recsize;
+
+	return min(n, __kfifo_peek_n(fifo, recsize);
+}
+EXPORT_SYMBOL(__kfifo_out_linear_r);
+
 unsigned int __kfifo_out_r(struct __kfifo *fifo, void *buf,
 		unsigned int len, size_t recsize)
 {
_

Patches currently in -mm which might be from jirislaby@kernel.org are

kfifo-drop-__kfifo_dma_out_finish_r.patch
kfifo-introduce-and-use-kfifo_skip_count.patch
kfifo-add-kfifo_out_linear_ptr.patch
kfifo-fix-typos-in-kernel-doc.patch


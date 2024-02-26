Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA5A136986
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 17:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967181; cv=none; b=Bc8KPVlIi3V1RcRPvm569hGlIVGH24ttOAqUGu0R2zLKIyj06xZ5XfARPIqDx0Q8o9YLfQgXYV5Rf+6JOUZ4JCxUqWQrQRHII8QBcI5Yb3RDqpXvUby8AXucacZgJ7kuyfRxocU7eYYQDKgIU3mAFSYzN0rqCYfAKBP71a4aPfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967181; c=relaxed/simple;
	bh=Ltq9MWJ0nlYqLiZCvKBBou0lZN6+Z3KxH7HQgHgApAs=;
	h=Date:To:From:Subject:Message-Id; b=bfZd/zEAduwsZ3aPkv/z+kneZ5p4bDSkfbQMfs3DSRTDIKmSUDXE0EdSWGJaiQxEIG5+qWijXwrc1lYMFmpfqaDVkaHrhg6dRxi6/8G+HivAuqeAgjJ7HbHoKSf0IcldIf/OporAKLMUNFF3z2JY5PbdF9oiVIvK8HPq4tds4+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NOLS33IT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NOLS33IT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881A5C43390;
	Mon, 26 Feb 2024 17:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708967180;
	bh=Ltq9MWJ0nlYqLiZCvKBBou0lZN6+Z3KxH7HQgHgApAs=;
	h=Date:To:From:Subject:From;
	b=NOLS33ITisHjsL7flUJLppmKnMlx+3/uQo7+OaXBN8awtfasKFhV5htlxGJ/4QGDM
	 jvq3U6gQ95lhRgnhDa1CBDk5pondr1/zHdSeh5TbTxzOKB9v3R0O3fFW1noY/DiKvr
	 xBBBGQ3LiRDmA9yHcGxVXL02pPhA11+E6qfu5Dk8=
Date: Mon, 26 Feb 2024 09:06:19 -0800
To: mm-commits@vger.kernel.org,stefani@seibold.net,jirislaby@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kfifo-add-kfifo_out_linear_ptr.patch removed from -mm tree
Message-Id: <20240226170620.881A5C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kfifo: add kfifo_out_linear{,_ptr}()
has been removed from the -mm tree.  Its filename was
     kfifo-add-kfifo_out_linear_ptr.patch

This patch was dropped because an updated version will be merged

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

kfifo-fix-typos-in-kernel-doc.patch


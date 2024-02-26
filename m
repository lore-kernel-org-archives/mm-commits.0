Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28E312F369
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 17:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967179; cv=none; b=PPCexCxAmfklKmXtVqeXq79HVqvwP8kfcBAJ6aeLXGluXOa5nYysR9LMQk+8uHnTpTMRvQiv8wC2R4kWw09IAeV3XwBu7KD4nOO1GScDD9RIcVl8MPkrHpv2hAetux1LRn7OmG2+XsVPgcIPFowFSzZi02Bkb8rsnaUpHegbcoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967179; c=relaxed/simple;
	bh=QTMLbClYOPVpKZPg+oWVNJagaGA9AMSOm1Nt4bsfLjA=;
	h=Date:To:From:Subject:Message-Id; b=P/KQV0Y0BSK4v0BfMG+DNBa+9kbj7KN7LA2uUuEQaOQuhuGIeQNSaoroebBvo0cxQJ3oesxGev+wqOXXU21k1tgkwNcbY9ruCOd+VRp6Eflzu+HwM3+4aI0/pyO3iUIFTjc6NzZuFq13XU9Fk+BPvUkvBelHssQ4Z10s9+yzx1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ovaJVIef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ovaJVIef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71499C433F1;
	Mon, 26 Feb 2024 17:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708967179;
	bh=QTMLbClYOPVpKZPg+oWVNJagaGA9AMSOm1Nt4bsfLjA=;
	h=Date:To:From:Subject:From;
	b=ovaJVIefjpJTOYycgx/uwwiQGxisN0oFzlfs8AtSP2HrtHaID1huXXCDKYQtU0Uyv
	 HEzo07mKxDmw8BA/TrUtWHwJCljXomxilht/xiuomowdW2NK9xi9JF4SnHxXtbtPbc
	 8Wmetf7oOesHyq+a8+nvsH3K3ZXLvZBq1V68qf9U=
Date: Mon, 26 Feb 2024 09:06:18 -0800
To: mm-commits@vger.kernel.org,stefani@seibold.net,jirislaby@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kfifo-introduce-and-use-kfifo_skip_count.patch removed from -mm tree
Message-Id: <20240226170619.71499C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kfifo: introduce and use kfifo_skip_count()
has been removed from the -mm tree.  Its filename was
     kfifo-introduce-and-use-kfifo_skip_count.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Subject: kfifo: introduce and use kfifo_skip_count()
Date: Fri, 23 Feb 2024 12:51:53 +0100

kfifo_skip_count() is an extended version of kfifo_skip(), accepting also
count.  This will be useful in the serial code later.

Now, it can be used to implement both kfifo_skip() and
kfifo_dma_out_finish().  In the latter, 'len' only needs to be divided by
'type' size (as it was until now).

And stop using statement expressions when the return value is cast to
'void'.  Use classic 'do {} while (0)' instead.

Note: perhaps we should skip 'count' records for the 'recsize' case, but
the original (kfifo_dma_out_finish()) used to skip only one record.  So
this is kept unchanged and 'count' is still ignored in the recsize case.

Link: https://lkml.kernel.org/r/20240223115155.8806-3-jirislaby@kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/include/linux/kfifo.h~kfifo-introduce-and-use-kfifo_skip_count
+++ a/include/linux/kfifo.h
@@ -304,19 +304,25 @@ __kfifo_uint_must_check_helper( \
 )
 
 /**
- * kfifo_skip - skip output data
+ * kfifo_skip_count - skip output data
  * @fifo: address of the fifo to be used
+ * @count: count of data to skip
  */
-#define	kfifo_skip(fifo) \
-(void)({ \
+#define	kfifo_skip_count(fifo, count) do { \
 	typeof((fifo) + 1) __tmp = (fifo); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	if (__recsize) \
 		__kfifo_skip_r(__kfifo, __recsize); \
 	else \
-		__kfifo->out++; \
-})
+		__kfifo->out += (count); \
+} while(0)
+
+/**
+ * kfifo_skip - skip output data
+ * @fifo: address of the fifo to be used
+ */
+#define	kfifo_skip(fifo)	kfifo_skip_count(fifo, 1)
 
 /**
  * kfifo_peek_len - gets the size of the next fifo record
@@ -790,17 +796,10 @@ __kfifo_int_must_check_helper( \
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these macros.
  */
-#define kfifo_dma_out_finish(fifo, len) \
-(void)({ \
+#define kfifo_dma_out_finish(fifo, len) do { \
 	typeof((fifo) + 1) __tmp = (fifo); \
-	unsigned int __len = (len); \
-	const size_t __recsize = sizeof(*__tmp->rectype); \
-	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (__recsize) \
-		__kfifo_skip_r(__kfifo, __recsize); \
-	else \
-		__kfifo->out += __len / sizeof(*__tmp->type); \
-})
+	kfifo_skip_count(__tmp, (len) / sizeof(*__tmp->type)); \
+} while (0)
 
 /**
  * kfifo_out_peek - gets some data from the fifo
_

Patches currently in -mm which might be from jirislaby@kernel.org are

kfifo-add-kfifo_out_linear_ptr.patch
kfifo-fix-typos-in-kernel-doc.patch


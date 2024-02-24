Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1C1818
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 00:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708734388; cv=none; b=oMKJP7VZlhe5HKr248KQWAkIukn8tZ5h/tKyeoWR6Bt1zhhkbIKfcAEp4Y1O1mG7HEjm6/HLYxJffoSV0dOb8cuTWFlbvOOlL9FkgcbTjuIWP/NafR+J5RKwshbzC8yHwbKq55TNZ+T2oMKjCNZAX1u7lfQ7iValjb9IeVLHVec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708734388; c=relaxed/simple;
	bh=m0iYgVGldGAUBRWQtBXHAmyh0kJJqBshriMkq3m0U5w=;
	h=Date:To:From:Subject:Message-Id; b=NMvrx6FeQEOxEbvhcuRuvSlaBKWncEQnYMQohLeKy96hREekweePkW3Pc37LATs6F9cmFO2ZavQ2c/NWAcslwxXV4ZXxoXBG1YKDuf+69zNpE7eX19UReVJwq4tYk/dvNNnjfOEk8DS+zN/TyurQk41NcGB9vO2htplSUPbIAXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KOGQH1Fu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KOGQH1Fu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6E1C433F1;
	Sat, 24 Feb 2024 00:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708734388;
	bh=m0iYgVGldGAUBRWQtBXHAmyh0kJJqBshriMkq3m0U5w=;
	h=Date:To:From:Subject:From;
	b=KOGQH1FuqnnU+7M4EK/sbnvYqoDS1WGNz3GPtNbsnAKzCuJ4+jfa6+cwNhBzmGyAF
	 IRku4tevt9qhB5p4yGFqzwfsUueSlo6xYQqtR7HAkdS5HSKZt4kTPK7j+oguxaKmr+
	 eMuqNWXw9QIXHH4HkyWEA9WctBRFhR513D3a9npg=
Date: Fri, 23 Feb 2024 16:26:27 -0800
To: mm-commits@vger.kernel.org,stefani@seibold.net,jirislaby@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfifo-introduce-and-use-kfifo_skip_count.patch added to mm-nonmm-unstable branch
Message-Id: <20240224002628.4C6E1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfifo: introduce and use kfifo_skip_count()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kfifo-introduce-and-use-kfifo_skip_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfifo-introduce-and-use-kfifo_skip_count.patch

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

kfifo-drop-__kfifo_dma_out_finish_r.patch
kfifo-introduce-and-use-kfifo_skip_count.patch
kfifo-add-kfifo_out_linear_ptr.patch
kfifo-fix-typos-in-kernel-doc.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E631B12F369
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967179; cv=none; b=Ueli9iqbdCrIG90QqyTteRCjzRs4hKTco66NdKkLAn8dAvepO3MJwMVZLsmGAWU3nKRgBj0VgvGBIaABsIVhgMWbnOi5fEaptcjJ841Jg4GL/VIF6Uw5KL9r4fwYSXYGMj/EUULZXYVIQHHcrbOGpaO23SukugPvqTkBa+h/oBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967179; c=relaxed/simple;
	bh=R88P15ONHQOurPyqVFjpOpfE1teZg37OKtNfMgjjUss=;
	h=Date:To:From:Subject:Message-Id; b=Q3faHh7w1yik9AEcX5MmYJXQjPQwpci2y77/3E7sE1olTCo5vFg43LEvWef3MCCA/AhjRv3C1tUS+WzjV3SRulJ9lQA32gSg5N8M6ODWJqAVInNmC8HI8ReyWG7wKGT4cSIUhu2C36ILjVt120sse8jvwBakMceV2Jlqlh2gp1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZOvBP2tE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZOvBP2tE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEC5C43394;
	Mon, 26 Feb 2024 17:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708967178;
	bh=R88P15ONHQOurPyqVFjpOpfE1teZg37OKtNfMgjjUss=;
	h=Date:To:From:Subject:From;
	b=ZOvBP2tEN/RYX5+FCuuSGkHOQN0B1XwciufG4z7N8hzD8tkPFDN24o65irg3On7mG
	 /sfFv+QHrZDEAOuWsvlSUexlg048e1aL2lw8Rj/aECXT4FCBsbk1zVNyQnYrmvI/f9
	 ToKeRJIu/fxQLofv7i2yKRVFv1fa06uIvRNhI9qc=
Date: Mon, 26 Feb 2024 09:06:17 -0800
To: mm-commits@vger.kernel.org,stefani@seibold.net,jirislaby@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kfifo-drop-__kfifo_dma_out_finish_r.patch removed from -mm tree
Message-Id: <20240226170618.5AEC5C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kfifo: drop __kfifo_dma_out_finish_r()
has been removed from the -mm tree.  Its filename was
     kfifo-drop-__kfifo_dma_out_finish_r.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Subject: kfifo: drop __kfifo_dma_out_finish_r()
Date: Fri, 23 Feb 2024 12:51:52 +0100

It is the same as __kfifo_skip_r(), so:
* drop __kfifo_dma_out_finish_r() completely, and
* replace its (only) use by __kfifo_skip_r().

Link: https://lkml.kernel.org/r/20240223115155.8806-2-jirislaby@kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    4 +---
 lib/kfifo.c           |    8 --------
 2 files changed, 1 insertion(+), 11 deletions(-)

--- a/include/linux/kfifo.h~kfifo-drop-__kfifo_dma_out_finish_r
+++ a/include/linux/kfifo.h
@@ -797,7 +797,7 @@ __kfifo_int_must_check_helper( \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	if (__recsize) \
-		__kfifo_dma_out_finish_r(__kfifo, __recsize); \
+		__kfifo_skip_r(__kfifo, __recsize); \
 	else \
 		__kfifo->out += __len / sizeof(*__tmp->type); \
 })
@@ -879,8 +879,6 @@ extern void __kfifo_dma_in_finish_r(stru
 extern unsigned int __kfifo_dma_out_prepare_r(struct __kfifo *fifo,
 	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize);
 
-extern void __kfifo_dma_out_finish_r(struct __kfifo *fifo, size_t recsize);
-
 extern unsigned int __kfifo_len_r(struct __kfifo *fifo, size_t recsize);
 
 extern void __kfifo_skip_r(struct __kfifo *fifo, size_t recsize);
--- a/lib/kfifo.c~kfifo-drop-__kfifo_dma_out_finish_r
+++ a/lib/kfifo.c
@@ -582,11 +582,3 @@ unsigned int __kfifo_dma_out_prepare_r(s
 }
 EXPORT_SYMBOL(__kfifo_dma_out_prepare_r);
 
-void __kfifo_dma_out_finish_r(struct __kfifo *fifo, size_t recsize)
-{
-	unsigned int len;
-
-	len = __kfifo_peek_n(fifo, recsize);
-	fifo->out += len + recsize;
-}
-EXPORT_SYMBOL(__kfifo_dma_out_finish_r);
_

Patches currently in -mm which might be from jirislaby@kernel.org are

kfifo-introduce-and-use-kfifo_skip_count.patch
kfifo-add-kfifo_out_linear_ptr.patch
kfifo-fix-typos-in-kernel-doc.patch


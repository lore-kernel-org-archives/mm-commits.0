Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B954538D
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 00:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708734386; cv=none; b=aY+4/jbBm3mUHRp7jfFQDPu7hSsoHhpXqFLAcNMkhhSqWydmDY5/ZsVtWA1aU6Oimk2rMG4drOoiZ3JwefGbfx7XkgnhMF0dzY1UqMYLS1wNIg4g5+g+j4jWKiycEBm12aE3rExGVss2+5FV2B6WlPh+f1PkT4cpr2/k68oY/Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708734386; c=relaxed/simple;
	bh=5iT1ybAbtnpmohoHzS9xd+nVJAdlxSAp6PT32woQFrs=;
	h=Date:To:From:Subject:Message-Id; b=FQEdhW4nPSbiR2FKyHvttpdotZMO7+2Fh6MXJyfz28xarcOuyWKCineL50tiLpbwCskSx2qPEU007zgcwdOFkfU/+czwVusYMe5XrqLFCZ/CPMy1KSwWGHZr7G8XI9UWNtvPiFbVWfQhMA687uhkI2EmmiEIOYerAPXljcAPQxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=piHouGGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="piHouGGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125D5C433C7;
	Sat, 24 Feb 2024 00:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708734386;
	bh=5iT1ybAbtnpmohoHzS9xd+nVJAdlxSAp6PT32woQFrs=;
	h=Date:To:From:Subject:From;
	b=piHouGGQ+hHYFPA1TDq7bY6gPqjWMEtQI1Uw5g80p/04QefQIX68zFz2lwM2ceV3q
	 pfNqYPqdHMbH5YHT/tTparQg6rmzthbtpeRIrxrW3dbg4iEpjATc1gPytTWYeR7YqB
	 f9SSgOda9azc/j8xfB73pSYMfgxAxwe8c3ILheNU=
Date: Fri, 23 Feb 2024 16:26:25 -0800
To: mm-commits@vger.kernel.org,stefani@seibold.net,jirislaby@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfifo-drop-__kfifo_dma_out_finish_r.patch added to mm-nonmm-unstable branch
Message-Id: <20240224002626.125D5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfifo: drop __kfifo_dma_out_finish_r()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kfifo-drop-__kfifo_dma_out_finish_r.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfifo-drop-__kfifo_dma_out_finish_r.patch

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

kfifo-drop-__kfifo_dma_out_finish_r.patch
kfifo-introduce-and-use-kfifo_skip_count.patch
kfifo-add-kfifo_out_linear_ptr.patch
kfifo-fix-typos-in-kernel-doc.patch


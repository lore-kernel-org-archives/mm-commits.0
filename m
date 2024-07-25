Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851C5139D19
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 20:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721940639; cv=none; b=hXjld+xusm5r2SCcx/2N7kTncqcou04VdrvevcHvCQpSMBa1HjJDnpAQSftQOJrCG9iknXw5Fwdkemh16ylN/qa6Pt/3W5rZj+TpTdGExOL6lY2Vtc9O9X4aVYAszUsU7AFBRaYElxnN3IG0euMzzGFUa/PzsarwgXtL7fiL128=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721940639; c=relaxed/simple;
	bh=RgmPPz+WhJD2/SDQarnXeY9e7dmJp/dUaKxPBnDr8zU=;
	h=Date:To:From:Subject:Message-Id; b=lI8s96HeLLgOghF1GZGZQRpk/vF/rXJk1Pj9isOQzjFGzojuC1ImP76CAHgrM3nytu+Xc3fd74H1u/ThOMlJ46c5YimuUfiurYdW4FvzyLTwWnBYilbm4YMBTVvlbLn8keDUI1NpjkaxJIidVkT7CDCEAtsUV+bEQoU9d8iC42Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c6JKeZEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c6JKeZEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E0BC116B1;
	Thu, 25 Jul 2024 20:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721940639;
	bh=RgmPPz+WhJD2/SDQarnXeY9e7dmJp/dUaKxPBnDr8zU=;
	h=Date:To:From:Subject:From;
	b=c6JKeZEN7/G/a+tn9svEp6duQJtmD5FgEqiSzVrzdk8t5lLs2g0pd1gaYyY5sr6Zl
	 m0slp/4HPFFm84ib2t1cgls55y4yMzE4Cf8R6aHVMM82v39YglAdX4ENeNKrc2ElqF
	 c0SK2Q8eNcmKk77y9SNAURGIJabSY19faNNayDJs=
Date: Thu, 25 Jul 2024 13:50:38 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch added to mm-unstable branch
Message-Id: <20240725205038.E9E0BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: (k)vrealloc: document concurrency restrictions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Danilo Krummrich <dakr@kernel.org>
Subject: mm: (k)vrealloc: document concurrency restrictions
Date: Thu, 25 Jul 2024 14:54:37 +0200

Document that concurrent calls to vrealloc() with itself or vfree() for
the same memory allocation are not permitted, since it leads to undefined
behavior.

Consequently, the same applies for kvrealloc(), hence also document it
for kvrealloc().

Link: https://lkml.kernel.org/r/20240725125442.4957-1-dakr@kernel.org
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/util.c~mm-kvmalloc-align-kvrealloc-with-krealloc-fix
+++ a/mm/util.c
@@ -732,6 +732,9 @@ EXPORT_SYMBOL(kvfree_sensitive);
  * If @p is %NULL, kvrealloc() behaves exactly like kvmalloc(). If @size is 0
  * and @p is not a %NULL pointer, the object pointed to is freed.
  *
+ * This function must not be called concurrently with itself or kvfree() for the
+ * same memory allocation.
+ *
  * Return: pointer to the allocated memory or %NULL in case of error
  */
 void *kvrealloc_noprof(const void *p, size_t size, gfp_t flags)
_

Patches currently in -mm which might be from dakr@kernel.org are

mm-vmalloc-implement-vrealloc.patch
mm-vmalloc-implement-vrealloc-fix.patch
mm-vmalloc-implement-vrealloc-fix-2.patch
mm-kvmalloc-align-kvrealloc-with-krealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch


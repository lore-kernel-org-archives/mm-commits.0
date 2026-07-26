Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9B319E839
	for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 03:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785036647; cv=none; b=Nvc8xceTrVvRMiGjyWw/noOYg/69ftfZKI+ouiM16zWTW3T/M9hOrIqFHcaj+tYOMOvLGvojZchGw5nfEabXg/DZfCxctdwTWRp/1c4I1u7y+g3hyU3TBD6ZQqlvfCLfbmnblgnHFNwogau7wOcmDf8+NnMKtyZueqIZqg33NH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785036647; c=relaxed/simple;
	bh=ZeO9pCwjoNzJReHFmpEh68fWlE/juwODKtc2jsDUArk=;
	h=Date:To:From:Subject:Message-Id; b=uk8Ha5juJQ6g2PsBpkGEyrlYc3trOsRxPnXDZeF25hihm0mtGtuwmzSecZ6XWTq9DmDXTD8NI2emGJ3eCbk01ZgEbdYfIFuDDSmMjEfjN97ndo6V+QODTdLy6Oj4IIOUQ+HdoSxOJBy0op6uZG0+N2UtM/rwB+w2HOh9QNhxkvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qAtlF4O+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qAtlF4O+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923F91F000E9;
	Sun, 26 Jul 2026 03:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785036645;
	bh=4BVNDh3mC3eX7By2Njb47bBfKTo+3MwMF8Akkd9Xqno=;
	h=Date:To:From:Subject;
	b=qAtlF4O+TMwPrT9qeXfb0WupEn+jyluw3jns0lqb3r3p6SGQ7G5Hb8/7zE4V28jdX
	 /l8JwxozAoxCRzhgAaXGe2TDh6BAhmeCacNXVCnJB4OgtZTwD7Th6mI6+XFryqSP3Q
	 HCHptuMxTNPIGxTOlDpi2Xm7yHvqMxbnWRfhNpS4=
Date: Sat, 25 Jul 2026 20:30:45 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,sshegde@linux.ibm.com,npiggin@gmail.com,nilay@linux.ibm.com,namcao@linutronix.de,mripard@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,leon@kernel.org,jiazhenyuan@uniontech.com,jgg@ziepe.ca,guanwentao@uniontech.com,clg@kaod.org,bharat@chelsio.com,airlied@gmail.com,gouhao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch added to mm-nonmm-unstable branch
Message-Id: <20260726033045.923F91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Gou Hao <gouhao@uniontech.com>
Subject: lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
Date: Fri, 24 Jul 2026 10:28:50 +0800

kvcalloc with the __GFP_NOFAIL flag will never return NULL, so the
subsequent NULL checks are unreachable dead code.  Remove them.

Link: https://lore.kernel.org/20260724022851.466017-6-gouhao@uniontech.com
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Cc: Bharat Potnuri <bharat@chelsio.com>
Cc: Cédric Le Goater <clg@kaod.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: jiazhenyuan <jiazhenyuan@uniontech.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nilay Shroff <nilay@linux.ibm.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations
+++ a/lib/test_hmm.c
@@ -1312,16 +1312,10 @@ static int dmirror_migrate_to_device(str
 	if (!mmget_not_zero(mm))
 		return -EINVAL;
 
-	ret = -ENOMEM;
 	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns),
 			  GFP_KERNEL | __GFP_NOFAIL);
-	if (!src_pfns)
-		goto free_mem;
-
 	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns),
 			  GFP_KERNEL | __GFP_NOFAIL);
-	if (!dst_pfns)
-		goto free_mem;
 
 	ret = 0;
 	mmap_read_lock(mm);
_

Patches currently in -mm which might be from gouhao@uniontech.com are

powerpc-xive-remove-dead-null-check-after-gfp_nofail-allocation.patch
powerpc-xive-add-error-return-value-to-xive_smp_probe.patch
powerpc-xive-fix-use-after-free-of-xive_ipis.patch
drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch
lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch
rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch


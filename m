Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F5015EFAF
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 20:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718743619; cv=none; b=iRRCIedPcTfq7eW8HqvPFAuYXXmAcRUIX6ASzyNxy2E+gPpbxxTTJWCF2kVp6UQarZpe4Dmdj0DLyZCbeOBMFU/hsM7YgETM1a+yHUIwhf9x2dxvxLZtRQIrOnU9LziWjVH/B1jAAFI1f9Zl9G2W2gpSOG306mxHfSkBLy2PQPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718743619; c=relaxed/simple;
	bh=qsqRKCaQYJ86/LPdAAt8ZAMA2fMr0kOJOPPrMQEJnHU=;
	h=Date:To:From:Subject:Message-Id; b=AmJi2V6jc1dXqItCbLSnRdU4FeK56dyBMypb/3C0rTPfHYicYRlaYzH4S1Q8BKfS7nUL6CAJmvjsnJRzhBBKYSe4om/D/T5Lq1pgrLNdXA3Yxagndi+z/vT9BsPKyPTtmUvGjQmikNHYmqRK4ZrTuH0dfLuYLePEpiKNt/fwJrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uvQ0Tjcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uvQ0Tjcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDB9C3277B;
	Tue, 18 Jun 2024 20:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718743618;
	bh=qsqRKCaQYJ86/LPdAAt8ZAMA2fMr0kOJOPPrMQEJnHU=;
	h=Date:To:From:Subject:From;
	b=uvQ0TjcgWdFv2awSnhsgjqDYhdbgrKowUJJm6uoTlOAHX81qTbJUT21Q5dUghwRRV
	 iybwX0xgrlilEtqtqLHbUW0qfaP12AKdCtsdf8ksBCcfThJbDRimgv8mxleg8QZ4eI
	 NX3rL+KZ7Th7jcBF0Y3xpbvJc48jovtbYNvGH9Nc=
Date: Tue, 18 Jun 2024 13:46:57 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-simplify-the-allocation-of-slab-caches.patch added to mm-unstable branch
Message-Id: <20240618204658.5FDB9C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: simplify the allocation of slab caches
has been added to the -mm mm-unstable branch.  Its filename is
     khugepaged-simplify-the-allocation-of-slab-caches.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-simplify-the-allocation-of-slab-caches.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: khugepaged: simplify the allocation of slab caches
Date: Tue, 18 Jun 2024 09:45:17 +0800

Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
to simplify the creation of SLAB caches.

Link: https://lkml.kernel.org/r/20240618014517.25954-1-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/khugepaged.c~khugepaged-simplify-the-allocation-of-slab-caches
+++ a/mm/khugepaged.c
@@ -385,10 +385,7 @@ int hugepage_madvise(struct vm_area_stru
 
 int __init khugepaged_init(void)
 {
-	mm_slot_cache = kmem_cache_create("khugepaged_mm_slot",
-					  sizeof(struct khugepaged_mm_slot),
-					  __alignof__(struct khugepaged_mm_slot),
-					  0, NULL);
+	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

khugepaged-simplify-the-allocation-of-slab-caches.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDC228D830
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 06:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754978488; cv=none; b=VKtFRUL5DCXIx6eG791PVoHH/meFvdZ9Nk9Eq9g40sL3BegBO1gZDbaj9ZTZUD+jrb0h6S0/VWZ/UH0HnSeQ65Zpajnkln+K/UI+rx0Klh84JMCg/i8v1AZ+5gxHTJ/J5U1F2rxgYkYZSbJmE5sCNumlxOKyZUq1Afx6uPww6yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754978488; c=relaxed/simple;
	bh=DVclwshGMVDb03IBq/t0gr0o9BZoew363QuNmHnrab8=;
	h=Date:To:From:Subject:Message-Id; b=jqMB4PhXYsgY/OAHB3gvFYAN7NZ9qQkmYvipGM5rTwzvfNb47UzXiob8taV9kR2EvT/iXw0MNbR+BWIu2wjP6CClnT5vK3KInk2ryX3QPAeDVGW2pTRTFYyTXtB6thI05LYsApDLLwVszNWTfdF/RPqJOTI5AFpwNSSuQzW6sZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mqv+Tdib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mqv+Tdib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21735C4CEF0;
	Tue, 12 Aug 2025 06:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754978488;
	bh=DVclwshGMVDb03IBq/t0gr0o9BZoew363QuNmHnrab8=;
	h=Date:To:From:Subject:From;
	b=Mqv+Tdib1Xe2cp/YeAJyXKhREbfSEmY+pR3Cu0eV0qky26s8lRDdAI2qJYamR/S5L
	 qCm4fzu08BVPaQ4omD3Yky69QGFsXY2zoJhp1egWyarSD123jKLU1OXLD4ruj/APkd
	 2Mq9GU5CmJqWREMPLnXl6H9cluULLz46QE1h7a/A=
Date: Mon, 11 Aug 2025 23:01:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,pfalcato@suse.de,oliver.sang@intel.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-avoid-expensive-folio-lookup-on-mremap-folio-pte-batch.patch removed from -mm tree
Message-Id: <20250812060128.21735C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: avoid expensive folio lookup on mremap folio pte batch
has been removed from the -mm tree.  Its filename was
     mm-mremap-avoid-expensive-folio-lookup-on-mremap-folio-pte-batch.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: avoid expensive folio lookup on mremap folio pte batch
Date: Thu, 7 Aug 2025 19:58:19 +0100

It was discovered in the attached report that commit f822a9a81a31 ("mm:
optimize mremap() by PTE batching") introduced a significant performance
regression on a number of metrics on x86-64, most notably
stress-ng.bigheap.realloc_calls_per_sec - indicating a 37.3% regression in
number of mremap() calls per second.

I was able to reproduce this locally on an intel x86-64 raptor lake
system, noting an average of 143,857 realloc calls/sec (with a stddev of
4,531 or 3.1%) prior to this patch being applied, and 81,503 afterwards
(stddev of 2,131 or 2.6%) - a 43.3% regression.

During testing I was able to determine that there was no meaningful
difference in efforts to optimise the folio_pte_batch() operation, nor
checking folio_test_large().

This is within expectation, as a regression this large is likely to
indicate we are accessing memory that is not yet in a cache line (and
perhaps may even cause a main memory fetch).

The expectation by those discussing this from the start was that
vm_normal_folio() (invoked by mremap_folio_pte_batch()) would likely be
the culprit due to having to retrieve memory from the vmemmap (which
mremap() page table moves does not otherwise do, meaning this is
inevitably cold memory).

I was able to definitively determine that this theory is indeed correct
and the cause of the issue.

The solution is to restore part of an approach previously discarded on
review, that is to invoke pte_batch_hint() which explicitly determines,
through reference to the PTE alone (thus no vmemmap lookup), what the PTE
batch size may be.

On platforms other than arm64 this is currently hardcoded to return 1, so
this naturally resolves the issue for x86-64, and for arm64 introduces
little to no overhead as the pte cache line will be hot.

With this patch applied, we move from 81,503 realloc calls/sec to 138,701
(stddev of 496.1 or 0.4%), which is a -3.6% regression, however accounting
for the variance in the original result, this is broadly restoring
performance to its prior state.

Link: https://lkml.kernel.org/r/20250807185819.199865-1-lorenzo.stoakes@oracle.com
Fixes: f822a9a81a31 ("mm: optimize mremap() by PTE batching")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202508071609.4e743d7c-lkp@intel.com
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mremap.c~mm-mremap-avoid-expensive-folio-lookup-on-mremap-folio-pte-batch
+++ a/mm/mremap.c
@@ -179,6 +179,10 @@ static int mremap_folio_pte_batch(struct
 	if (max_nr == 1)
 		return 1;
 
+	/* Avoid expensive folio lookup if we stand no chance of benefit. */
+	if (pte_batch_hint(ptep, pte) == 1)
+		return 1;
+
 	folio = vm_normal_folio(vma, addr, pte);
 	if (!folio || !folio_test_large(folio))
 		return 1;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch
mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area.patch
mm-mremap-catch-invalid-multi-vma-moves-earlier.patch
selftests-mm-add-test-for-invalid-multi-vma-operations.patch


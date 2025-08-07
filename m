Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A2680BEC
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 21:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754603448; cv=none; b=PMbNx6tzuD3qH9Y8XwG/Ucn+QuTO7PyZMn4mL5SXUN/ZxIBVlUKeUYcx1yfqIc0bdeVEH6oBP6bw17c+OcHe/ESes43LEkhAts2LKnV2qvVwlbaem4D0FuPz6GocU0zpg+ydz0Fj1TX/B2gMdYWHLqpCq9HVh4O05Yf1ylUsVQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754603448; c=relaxed/simple;
	bh=AqoScGy88gGME1xUG96HN9WrEyZa4WNGsgjF5QYsbv0=;
	h=Date:To:From:Subject:Message-Id; b=JJwF7aMKtLY3Nk6Q9JDShLfvUGiu1NeU3cy17fKpTyibIK1S5BQhd/5nU/z9qhBi+mdc5P+cLaOyID55WW6nt92A5PNltCEo6rriLJObqNKcHUeKUICb1IFM2xdujVZQGblh6vaezCGDAf/1qeQL+LHqeP8+hVA7LzoGikBCNGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zPofu2V5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zPofu2V5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60DBC4CEEB;
	Thu,  7 Aug 2025 21:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754603448;
	bh=AqoScGy88gGME1xUG96HN9WrEyZa4WNGsgjF5QYsbv0=;
	h=Date:To:From:Subject:From;
	b=zPofu2V5uQejg2XPPkLflxnscn4gV/TYfvi3lrcgQ55KYYDlOCOkgDmYD3RwQvLrI
	 kXiD1zjZKkylecqrWij4hpPl79pKtdp84ot4mV+Q8atE366UB/kpYEgzjly36Uu0If
	 XIyxeTP5VW6HktrR+1zlEkOlhL2dusipl7nfsIdc=
Date: Thu, 07 Aug 2025 14:50:47 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,pfalcato@suse.de,oliver.sang@intel.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-avoid-expensive-folio-lookup-on-mremap-folio-pte-batch.patch added to mm-hotfixes-unstable branch
Message-Id: <20250807215047.E60DBC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: avoid expensive folio lookup on mremap folio pte batch
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-avoid-expensive-folio-lookup-on-mremap-folio-pte-batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-avoid-expensive-folio-lookup-on-mremap-folio-pte-batch.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-mremap-avoid-expensive-folio-lookup-on-mremap-folio-pte-batch.patch


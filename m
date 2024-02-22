Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F88225A4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644476; cv=none; b=XTOwDmz6vbAoPF2hBNkfNZBih3lO7OQ2RGc8ja2oc7OqW47UWZT/0lcQjKdoAnP7suAsRYJrZzipWI4Bwcu7AUkSi9aO+IHDCjNAs805S+3Ph0ujnXQrHbwtumMEYuVZllEjFwARU3KahzPM7g26IpVM8c9v0NXUC+cO0QgPjHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644476; c=relaxed/simple;
	bh=xiCzkqOijMKkusu5lcwQSmsnxnn5Tsd4nDXywZgBZIk=;
	h=Date:To:From:Subject:Message-Id; b=eqa3W3QwSWMAiCpXfMxh7JIhdS0ZxvwNRyNh468ilAAK/R+0w51aaTt6eWZyG1gLwpU+Th4nLrMHQk0uWKQTgs5OeFUH2KwJ0CjPwFlRr+7iJU6qhTsXzlYm2eFlAu76jxz0Rq2ZFRVAsWJNp3/AT0/B9mlMC70ushLrUPPV5wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yL8A0mC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yL8A0mC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD4AC433C7;
	Thu, 22 Feb 2024 23:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644476;
	bh=xiCzkqOijMKkusu5lcwQSmsnxnn5Tsd4nDXywZgBZIk=;
	h=Date:To:From:Subject:From;
	b=yL8A0mC/fqHvtROS3+/5XE4hU8IIz/+E+kxdjbYfPKq7+dFKkdkSJbUMKF1jKFlES
	 yGzfOAfhk5Tu9l8juRxb12AafZZasuMJBXp/drc4r6HHJ8Oo33dBZ2XY6ej6NIMWII
	 HZKPPRtxaTg97L/r9135vui653rQQVHgMHBnqSps=
Date: Thu, 22 Feb 2024 15:27:55 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,fengwei.yin@intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,arnd@arndb.de,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-further-separate-anon-and-pagecache-folio-handling-in-zap_present_pte.patch removed from -mm tree
Message-Id: <20240222232755.EDD4AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: further separate anon and pagecache folio handling in zap_present_pte()
has been removed from the -mm tree.  Its filename was
     mm-memory-further-separate-anon-and-pagecache-folio-handling-in-zap_present_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: further separate anon and pagecache folio handling in zap_present_pte()
Date: Wed, 14 Feb 2024 21:44:28 +0100

We don't need up-to-date accessed-dirty information for anon folios and
can simply work with the ptent we already have.  Also, we know the RSS
counter we want to update.

We can safely move arch_check_zapped_pte() + tlb_remove_tlb_entry() +
zap_install_uffd_wp_if_needed() after updating the folio and RSS.

While at it, only call zap_install_uffd_wp_if_needed() if there is even
any chance that pte_install_uffd_wp_if_needed() would do *something*. 
That is, just don't bother if uffd-wp does not apply.

Link: https://lkml.kernel.org/r/20240214204435.167852-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-memory-further-separate-anon-and-pagecache-folio-handling-in-zap_present_pte
+++ a/mm/memory.c
@@ -1554,12 +1554,9 @@ static inline void zap_present_pte(struc
 	folio = page_folio(page);
 	if (unlikely(!should_zap_folio(details, folio)))
 		return;
-	ptent = ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
-	arch_check_zapped_pte(vma, ptent);
-	tlb_remove_tlb_entry(tlb, pte, addr);
-	zap_install_uffd_wp_if_needed(vma, addr, pte, details, ptent);
 
 	if (!folio_test_anon(folio)) {
+		ptent = ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
 		if (pte_dirty(ptent)) {
 			folio_mark_dirty(folio);
 			if (tlb_delay_rmap(tlb)) {
@@ -1569,8 +1566,17 @@ static inline void zap_present_pte(struc
 		}
 		if (pte_young(ptent) && likely(vma_has_recency(vma)))
 			folio_mark_accessed(folio);
+		rss[mm_counter(folio)]--;
+	} else {
+		/* We don't need up-to-date accessed/dirty bits. */
+		ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
+		rss[MM_ANONPAGES]--;
 	}
-	rss[mm_counter(folio)]--;
+	arch_check_zapped_pte(vma, ptent);
+	tlb_remove_tlb_entry(tlb, pte, addr);
+	if (unlikely(userfaultfd_pte_wp(vma, ptent)))
+		zap_install_uffd_wp_if_needed(vma, addr, pte, details, ptent);
+
 	if (!delay_rmap) {
 		folio_remove_rmap_pte(folio, page, vma);
 		if (unlikely(page_mapcount(page) < 0))
_

Patches currently in -mm which might be from david@redhat.com are



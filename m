Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85B1364943
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622929; cv=none; b=R9drLrCNHsfgetGrdhb+YDD5gUjWTVulU2ixzb1QNUTWDsZBZtbd/NKwAZOEHA3M0cDFKD2ps+7QR2kqdyVBtEt+4a/cJwZ0ePDpDTsLhudXGJ+KMHzoEdLVdnpiNhsnVrVEwpicpFXfD54+NO9FSGotsW5DtEOPFZZsBi3/zuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622929; c=relaxed/simple;
	bh=Ge9qZ2SuvwHHTIXPSxeTZ66V5fyZmK/PfS5yNxnU9Wo=;
	h=Date:To:From:Subject:Message-Id; b=QPwL7pB94J/7ti2zzq8tLZHR9N3Fu8m86PLwxvxDY/Q//ipTQRl4oIBGtLZN5vlR2Oiw9gzswPWLGOkNouvjI8yU9rqsGoRD4ibgOR0RxMD1h5NdiQzf6xgiiq3B/qVJdOLXIyZ6ArZsUNBn+PJgva5a5+8wTc1LfpRy4z17vPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r2DQJFFK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r2DQJFFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BEA1F00A3A;
	Tue, 25 Aug 2026 01:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622925;
	bh=EER10Bq4SA2khxS/tLocJo+sRpxuJxwVf5UqdrFNKEU=;
	h=Date:To:From:Subject;
	b=r2DQJFFKmQm0UdJ8FTt8m7m/7B2PNC3NXCEbVUbrTvoUdhALWwoLDgmwETx4JSeiY
	 x7xsROrtsQhWxcn4dJO62I64FyEVdZDWoDj+JF6TBo23qfKSJOODqSI2CKUUfuoKjh
	 fadVyxPuuQKreUWy1yFpUTNNoqkA3sDtEvzdZaAM=
Date: Mon, 24 Aug 2026 18:55:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch removed from -mm tree
Message-Id: <20260825015525.71BEA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: refactor per-scan state clearing into collapse_control_init_scan()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: mm/khugepaged: refactor per-scan state clearing into collapse_control_init_scan()
Date: Tue, 11 Aug 2026 06:48:33 -0600

Patch series "mm/khugepaged: several cleanups", v4.

The following changes stem from a number of reviews during my khugepaged
mTHP support series [1].  Some of these are minor code cleanups, issues or
reviews that we decided to deferred to a followup series, or in the case
of the more major patch of the series, changes [2] Lance Yang attempted
while my series was in-flight and we decided to wait till later to try.

The first 3 patches introduce helper functions to increase code reuse and
readability.  This includes a per-scan state clearing function, extracting
the young page check into a helper, and a count_collapse_event() function
to reduce a repetative pattern used across mTHP collapse.

The 4th patch was the byproduct of me throwing Claude at all the comments
in khugepaged verifying and looking for any outdated info.

The 5th patch is based on Lance Yang's commit series [2] trying to extract
the PTE state checking into a helper function.  This required a bit of
rewriting due to differences after mTHP collapse was introduced.  I also
took into account the changes requested during his patches review cycle.

The remaining 2 patches were review points during my mTHP series that we
agreed can be deferred to a later series.

Thank you to those whos reviews and work I leveraged to achieve these
cleanups.


This patch (of 6):

Extract the repeated clearing of node_load, alloc_nmask, and
mthp_present_ptes into a helper to reduce duplication in
collapse_scan_pmd() and collapse_scan_file().  Althought file scans do not
current use the bitmap, they will in the future, and clearing it now is
harmless.

Link: https://lore.kernel.org/20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev
Link: https://lore.kernel.org/20260811-khugepaged_pte_refactor-v4-1-ddac39d61c4a@linux.dev
Link: https://lore.kernel.org/all/20260605161422.213817-1-npache@redhat.com/ [1]
Link: https://lore.kernel.org/all/20251008043748.45554-1-lance.yang@linux.dev/ [2]
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan
+++ a/mm/khugepaged.c
@@ -629,6 +629,13 @@ void __khugepaged_exit(struct mm_struct
 	}
 }
 
+static void collapse_control_init_scan(struct collapse_control *cc)
+{
+	memset(cc->node_load, 0, sizeof(cc->node_load));
+	nodes_clear(cc->alloc_nmask);
+	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
+}
+
 static void release_pte_folio(struct folio *folio)
 {
 	node_stat_mod_folio(folio,
@@ -1617,9 +1624,7 @@ static enum scan_result collapse_scan_pm
 		goto out;
 	}
 
-	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
-	memset(cc->node_load, 0, sizeof(cc->node_load));
-	nodes_clear(cc->alloc_nmask);
+	collapse_control_init_scan(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2691,8 +2696,7 @@ static enum scan_result collapse_scan_fi
 
 	present = 0;
 	swap = 0;
-	memset(cc->node_load, 0, sizeof(cc->node_load));
-	nodes_clear(cc->alloc_nmask);
+	collapse_control_init_scan(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
_

Patches currently in -mm which might be from nico.pache@linux.dev are



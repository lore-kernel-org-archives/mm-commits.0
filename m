Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1A635E1B1
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 20:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783283793; cv=none; b=pViTET6eBCnv17MfEJ0XDzg2DdLst+HxPJLg3KCHSQQ4J1kJXYcYr9N0uIUi3Hz5R5z4gXiWrOeNUN6f/uFz1RZPRdhuKdhrBuSoEup+eGDJcGnQs5YF5Ls9vWpuTtzPM7I86fgJ2xuw+OayrbozoY7a7RXwDVC/jaqGriNkTHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783283793; c=relaxed/simple;
	bh=dsLPYpIFTvqk0Tx+aBQ1D5l4+ok0zTOxppJRxPy+GNM=;
	h=Date:To:From:Subject:Message-Id; b=h7SpSEM+1jql+6H87wT7aBH6j+NAli6W7A/vQI82vJvebj1LveVWiyfePywcnDrv81j9ryRqqFqbAST3RbuE0AbixLAI7FUi1FhHsTN6Y441ssckjt4b5zggdJK3jfYuCCH/gktXHLO4FFComoLq5tWLvL54O2iRMbc/Y0EMWjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r5F6uoRd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r5F6uoRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AE61F00A3A;
	Sun,  5 Jul 2026 20:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783283791;
	bh=MiAl56mNsH7TGFZQdIKRCEkno06H9hj1Jkg0zUsEsk4=;
	h=Date:To:From:Subject;
	b=r5F6uoRdB42ks6I7vmoOsZKgc8rJY2W8KctbA0JkPO5pPlDRuYgb7TnycrnBTj2jv
	 J8qBHd5I/GY0wD13ICi/5uDQaFbAYi9V10qZSnymr8SKNIAzOwZNMyfEnqLC7kqCZ9
	 +soWdDL+ocD74fACkkw+L5Lqh4Hyc//fgRH5MX0U=
Date: Sun, 05 Jul 2026 13:36:31 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch removed from -mm tree
Message-Id: <20260705203631.D0AE61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix
Date: Tue Jun 30 11:35:55 AM PDT 2026

avoid warnings on architectures whose flush_cache_vmap() don't reference
their args

Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Wen Jiang <jiangwen6@xiaomi.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix
+++ a/mm/vmalloc.c
@@ -3629,6 +3629,7 @@ static int vmap_batched(unsigned long ad
 				prot, pages + idx, prev_shift);
 
 out:
+	(void)start;	/* several archs use a macro for flush_cache_vmap() */
 	flush_cache_vmap(start, end);
 	return err;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_vma_mapped-fix-device-private-pmd-handling-fix.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


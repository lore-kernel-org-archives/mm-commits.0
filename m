Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38FC442FD0
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 19:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142959; cv=none; b=BTd84R7HVdo0emzfWook41YvgrzvcFlxzz+uMhjULBD2Cld4cGz2NgDBt/qSCiojC+G7xFP0zuV9vxnqi3kcc+9ArypJd/kmF7Qfi0iQ8uAaM2Sb5c7TCgFEE/9cmFuh6e7w8pORWZtDWL5wZyUCz1gdnTblig8eynqBqZle120=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142959; c=relaxed/simple;
	bh=NZzJOtxVhsH2aX0Qu0WnIKgMkOJ25I5qTVlUQvopFdk=;
	h=Date:To:From:Subject:Message-Id; b=oc5FLYWWHTDWloVqgGKVdFx4aDxgA27TYju6UnTEcVmGhq0L2OKFXu9nQM0Skcj+p1YUAAZswjRxH/iFPWMcOThKgb4o110re4/KwPVQVAAcnF7+8fDjij/JAo3MXzQ0hCDMOizBbfSEt1vuv5ycZAy4njNUH1yAc7NCtumyAvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XlSrlt6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XlSrlt6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39B91F000E9;
	Wed, 15 Jul 2026 19:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784142952;
	bh=LQgM0qHij1UGdkTtw8YzutQ0s9ovsEYaHAlpguqv5QA=;
	h=Date:To:From:Subject;
	b=XlSrlt6IPSRXhplG2sFHE/FHnMAmhI+BaO5/aSFuXry2JnbHfyOsLKRwikmkSYf8i
	 BO1uzw2dPxQatxLV9qKYFO9NVoqU69JXVNE3nWzQR7rXRT18TB4szEVsqiDU7VKpFM
	 MyUgJesrrXnI7yemdF0ncX8OdNI0cO+wdrcZzblc=
Date: Wed, 15 Jul 2026 12:15:52 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,urezki@gmail.com,toshi.kani@hpe.com,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,ljs@kernel.org,liam@infradead.org,kas@kernel.org,hpa@zytor.com,dev.jain@arm.com,david@kernel.org,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260715191552.C39B91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf-fix
Date: Wed Jul 15 12:12:32 PM PDT 2026

update comment, per Kiryl

Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf-fix
+++ a/mm/vmalloc.c
@@ -163,12 +163,11 @@ static int vmap_try_huge_pmd(pmd_t *pmd,
 		return pmd_set_huge(pmd, phys_addr, prot);
 
 	/*
-	 * Kernel page table walkers either walk ranges they own exclusively or
-	 * hold the mmap write lock on init_mm (ptdump being the motivating
-	 * case).
+	 * Acquire the mmap read lock to exclude ptdump, which walks kernel
+	 * page tables it does not own under the mmap write lock.
 	 *
-	 * Therefore, acquire the mmap read lock to prevent use-after-free when
-	 * freeing page tables.
+	 * Concurrent read lock holders are safe: each exclusively owns the
+	 * range it operates on and cannot reach this page table.
 	 */
 #ifndef CONFIG_ARM64
 	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf-fix.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


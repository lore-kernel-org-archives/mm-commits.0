Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7BB3921E7
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298478; cv=none; b=rm4AsuZn/qRI63HOuuwYP5x65ZHLc9G1pFuVLgt8nWOkQOxJFNc1xorP6vbinibUjU3jIDOzT3wUbTuFLNPixDCVDttrllpUj3UG8dqBCKREvDr7F0Prpi/CV2+/pWlBEUdYmp0HIEdWIRKHdMOFjRWzRxB+pwLe9tc44XNh/HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298478; c=relaxed/simple;
	bh=YdsFVju5jsNrN7NsU3/WwA6KmB47wQlYZDT9HlTl1kQ=;
	h=Date:To:From:Subject:Message-Id; b=Kw2I1eoK4Kg37QDA18fY4yUA/J2fl/IdO+MqKtELBhvbyJScG55Kl/JdOGdpIrRuNB6sSYMKkGM1y36oVfz1QpBRdP2kTaB2eX1sesdw0PR5lG/7U0B66JovniLNZnFCmfu0gc3nDCaWoUnIs4WUdZI8ZTZ21V5rHboebMRS2Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sD0UWqlV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sD0UWqlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C220A1F00A3A;
	Wed, 29 Jul 2026 04:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298476;
	bh=movPLlhAplZ1Og1aYOEWwahpaKwHnBJ9lzIxc3pCIsY=;
	h=Date:To:From:Subject;
	b=sD0UWqlVUpsUmEAKmpJYes6LyYGog3pDX/Z1egP+m7/Gd9kmbt7bTSwvCVa3d0fkQ
	 qkJP42MtpdTGDayyfuaQtb6OPHRdrvBSoS0eIbjtYywAM0VdcwkNukdwe8UIY1TxqT
	 aNsFw4yHRm0o2AbNCVS4L2DUgXIrpYVzs6hfQ5Vg=
Date: Tue, 28 Jul 2026 21:14:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch removed from -mm tree
Message-Id: <20260729041436.C220A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: remove sparse_vmemmap_init_nid_late()
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: remove sparse_vmemmap_init_nid_late()
Date: Fri, 12 Jun 2026 11:59:01 +0800

hugetlb_vmemmap_init_late() no longer has any users, so the remaining
late-init path in sparse_vmemmap_init_nid_late() is dead code.

Remove sparse_vmemmap_init_nid_late() and its declarations.

Link: https://lore.kernel.org/20260612035903.2468601-18-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 -------
 mm/hugetlb_vmemmap.c   |    4 ----
 mm/hugetlb_vmemmap.h   |    5 -----
 mm/sparse-vmemmap.c    |   11 -----------
 mm/sparse.c            |    1 -
 5 files changed, 28 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late
+++ a/include/linux/mmzone.h
@@ -2156,8 +2156,6 @@ static inline int preinited_vmemmap_sect
 }
 
 void sparse_vmemmap_init_nid_early(int nid);
-void sparse_vmemmap_init_nid_late(int nid);
-
 #else
 static inline int preinited_vmemmap_section(const struct mem_section *section)
 {
@@ -2166,10 +2164,6 @@ static inline int preinited_vmemmap_sect
 static inline void sparse_vmemmap_init_nid_early(int nid)
 {
 }
-
-static inline void sparse_vmemmap_init_nid_late(int nid)
-{
-}
 #endif
 
 static inline int online_section_nr(unsigned long nr)
@@ -2374,7 +2368,6 @@ static inline unsigned long next_present
 
 #else
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
-#define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
--- a/mm/hugetlb_vmemmap.c~mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late
+++ a/mm/hugetlb_vmemmap.c
@@ -808,10 +808,6 @@ void __init hugetlb_vmemmap_init_early(i
 		m->flags |= HUGE_BOOTMEM_HVO;
 	}
 }
-
-void __init hugetlb_vmemmap_init_late(int nid)
-{
-}
 #endif
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
--- a/mm/hugetlb_vmemmap.h~mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late
+++ a/mm/hugetlb_vmemmap.h
@@ -29,7 +29,6 @@ void hugetlb_vmemmap_optimize_folios(str
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
 void hugetlb_vmemmap_init_early(int nid);
-void hugetlb_vmemmap_init_late(int nid);
 #endif
 
 
@@ -81,10 +80,6 @@ static inline void hugetlb_vmemmap_init_
 {
 }
 
-static inline void hugetlb_vmemmap_init_late(int nid)
-{
-}
-
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
--- a/mm/sparse.c~mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late
+++ a/mm/sparse.c
@@ -320,7 +320,6 @@ static void __init sparse_init_nid(int n
 		}
 	}
 	sparse_usage_fini();
-	sparse_vmemmap_init_nid_late(nid);
 }
 
 /*
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late
+++ a/mm/sparse-vmemmap.c
@@ -581,17 +581,6 @@ void __init sparse_vmemmap_init_nid_earl
 {
 	hugetlb_vmemmap_init_early(nid);
 }
-
-/*
- * This is called just before the initialization of page structures
- * through memmap_init. Zones are now initialized, so any work that
- * needs to be done that needs zone information can be done from
- * here.
- */
-void __init sparse_vmemmap_init_nid_late(int nid)
-{
-	hugetlb_vmemmap_init_late(nid);
-}
 #endif
 
 static void subsection_mask_set(unsigned long *map, unsigned long pfn,
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch


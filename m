Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832346;
	b=mJJFmr/UYM7g04bVS2RrjqMJxuSJdpAwjm9HVlDQ3d0F93HQtn8AQ5i19XQKH9E6LHvZ
	 BEfvxQOvGzFsODt3IF5hWpzj5k3lDSHXLIUZCNCKwSVeqJ0xA0B1VyKxqIyhfKq7CnAVt
	 0UKPa3HBdxXf3INXYnWqqFO6AfKdIjH9SMrX/Sv5nhHijPD02HNe4wGuRor0bJKFO4lg6
	 S8sHoPneqv2fTbb+p83qk7y3oSR0TWyaievJPYJiCIVZmyFosiUPVGimPn2dO+hwSpxGp
	 2uqrDahfu8YbLb8XUViDzDb42tkdveRHUxWJq13PBzPqJ+QEg5kKv4t5FmtJljbFh1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832346;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=lPRYSSacnRaNp2hzoNWT3YeisFPf1J2dZbTzf8t/blk=;
	b=vRCMBJlCMCpRJ5CvfEjRCQ6rSjIilrfem60rOr/Zk/ijKUXsmzjBDK0cdugLhwcZe6Oz
	 MEuUc3Agnzs2YsWzZKxg/rTyWv4PloauKfL5NPryDKPJEF61yWrs9t3sw0CFi2AouRNf8
	 KU75p9OyAAQGXfZ5Rpct4MxL71Bcbxo1PMZGWedSWKFItmNVo0IoSUVfnO9/QoinVzCdM
	 TvjIT8ZgK0skPze+FIdMxCaUHJlA/jS8OLmjYxs3dZbgNfTILi3/SVxXUO1RNqVYJgZEV
	 mbFzBAgzUaiT6/7pG8CLFhPo1qRnWGYKPtAq492+h6dO6n2Hl2qmtj/MSsL+mY2Djww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=m+353F8U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D082A606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=m+353F8U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9566F1F01825;
	Sat, 24 Oct 2026 08:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832345;
	bh=lPRYSSacnRaNp2hzoNWT3YeisFPf1J2dZbTzf8t/blk=;
	h=Date:To:From:Subject;
	b=m+353F8Ud9WrJEGFEVx71KlwWuQniFezIJyf2fQLMMJLsz6GOSLm4lmtcZDH8Obdp
	 QL4WVS+J01ZLr9j16xiHumLaBr45JQHW7n/2Y9Hy8HesFvqUOsheU5UJxZn3Qc6zbY
	 nzCtKN/xhJ02InMlqklmg/Ic5AFkjTvZoTJAzKLg=
Date: Sat, 24 Oct 2026 01:59:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch removed from -mm tree
Message-Id: <20261024085905.9566F1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse: remove flags parameter from sparse_init_one_section()
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: remove flags parameter from sparse_init_one_section()
Date: Mon, 21 Sep 2026 21:59:03 +0200

The last user of the flags parameter that used to pass SECTION_IS_EARLY
was removed, so let's remove the parameter.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-11-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 mm/sparse-vmemmap.c |    2 +-
 mm/sparse.c         |    2 +-
 mm/sparse.h         |    5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

--- a/mm/sparse.c~mm-sparse-remove-flags-parameter-from-sparse_init_one_section
+++ a/mm/sparse.c
@@ -243,7 +243,7 @@ static void __init sparse_metadata_init_
 			      section_nr);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
-					mem_map, usage, 0);
+					mem_map, usage);
 		usage = (void *)usage + mem_section_usage_size();
 	}
 }
--- a/mm/sparse.h~mm-sparse-remove-flags-parameter-from-sparse_init_one_section
+++ a/mm/sparse.h
@@ -21,7 +21,7 @@ int sparse_index_init(unsigned long sect
 
 static inline void sparse_init_one_section(struct mem_section *ms,
 		unsigned long section_nr, struct page *mem_map,
-		struct mem_section_usage *usage, unsigned long flags)
+		struct mem_section_usage *usage)
 {
 	unsigned long coded_mem_map;
 
@@ -37,8 +37,7 @@ static inline void sparse_init_one_secti
 	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
-	ms->section_mem_map |= coded_mem_map;
-	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
+	ms->section_mem_map |= coded_mem_map | SECTION_HAS_MEM_MAP;
 	ms->usage = usage;
 }
 
--- a/mm/sparse-vmemmap.c~mm-sparse-remove-flags-parameter-from-sparse_init_one_section
+++ a/mm/sparse-vmemmap.c
@@ -908,7 +908,7 @@ int __meminit sparse_add_section(int nid
 	/* Align memmap to section boundary in the subsection case */
 	if (section_nr_to_pfn(section_nr) != start_pfn)
 		memmap = pfn_to_page(section_nr_to_pfn(section_nr));
-	sparse_init_one_section(ms, section_nr, memmap, ms->usage, 0);
+	sparse_init_one_section(ms, section_nr, memmap, ms->usage);
 
 	return 0;
 }
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch


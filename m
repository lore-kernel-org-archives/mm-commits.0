Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0C83D75C9
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 20:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791665001; cv=none; b=iO4AoTaBjMcp2rKcBjKWGMrmfBXYtmFjYqCltS0XjM8iqFRGrnI/UKPewB/Uwic6oSRNp8johX4KV9bndbraE9K40Sb5SN/yIGqw9yojwXwDnzINtlI75ObQ73hfTeUejKjls2ZGkPjIa/Q5UaQgcOjjmDysJiit1cRNC2fz8VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791665001; c=relaxed/simple;
	bh=espWp1KJQxR7flZv5tWTufzex8BJQmqCba/KP4veMJE=;
	h=Date:To:From:Subject:Message-Id; b=HWPji+7u1Y32/k09uS+di5d3zMk3btjsDxGxNwzsgRAG7wyPFobPBZ1N0p0wy6HwyIoATG1G7jotooD7UTcXQGN0tBfIrgFL4bCm27x2QdKmyO295Wj+CdPWuANvuEmqndLllOgy5COvy6FPoWeT/P8wv58pQolcY7V56v3hvXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sSkAUMXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sSkAUMXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A811F000FF;
	Sat, 10 Oct 2026 20:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791665000;
	bh=mZhpS4S91DL7Rd635VaQkxt7zGLDZiKS6fIaEeS/usk=;
	h=Date:To:From:Subject;
	b=sSkAUMXIgmh8kFNbAkNhsaM8ROhBg630mhaX+CSKS/UfeCD+O0fKfFRpANUyjgxam
	 aPgVW3aa1BSGK/nje7yf0WuriFkn/sQRQqC0X13YnbwQUvbYAbfaovV/JWstZgwJxx
	 4Zq30Q474nbWJQpLOrND9pQnZqu0BaoNPWozAoV8=
Date: Sat, 10 Oct 2026 13:43:19 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-add-zone-mismatch-warning-during-page-init.patch added to mm-unstable branch
Message-Id: <20261010204319.F2A811F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: add zone mismatch warning during page init
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

This patch will later appear in the mm-unstable branch at
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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/mm_init: add zone mismatch warning during page init
Date: Sat, 10 Oct 2026 15:57:55 +0800

For vmemmap-optimized sections, tail struct pages may be backed by shared
vmemmap pages.  Those shared pages must carry the same page zone ID as the
struct pages initialized for the section.

Warn in __init_single_page() if the shared tail page has a different
page_zone_id(), which would indicate inconsistent initialization.

Link: https://lore.kernel.org/20261010075755.83339-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 mm/mm_init.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/mm_init.c~mm-mm_init-add-zone-mismatch-warning-during-page-init
+++ a/mm/mm_init.c
@@ -593,6 +593,15 @@ out:
 	node_states[N_MEMORY] = saved_node_state;
 }
 
+static inline void vmemmap_optimization_verify_zone(struct page *page)
+{
+	const unsigned int order = pfn_to_section_compound_order(page_to_pfn(page));
+
+	VM_WARN_ON_ONCE(vmemmap_optimizable_order(order) &&
+			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
+			page_zone_id(page));
+}
+
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid)
 {
@@ -609,6 +618,7 @@ void __meminit __init_single_page(struct
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+	vmemmap_optimization_verify_zone(page);
 }
 
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init-fix.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch


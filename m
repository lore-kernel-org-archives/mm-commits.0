Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E174E4C5E
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 21:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717571; cv=none; b=YEZmUXLJ96NQ5I+lUznKO4srjRXcM9fcnGl108fCfKWnPS5rD+D4o3pNQh2DXZdBIJXAtZzCnV7MmiTmN4XFmcsSCTFkwzuMHQixCs7VygheLPgvtEo5lunPM+cCPqo3njcE03Q/5snSRAYEIFyBAr0WXNV5JVnCrYmB5jxnM9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717571; c=relaxed/simple;
	bh=asAcDdQf2hdqjRoVOyuuhwmOIKGH21MQtw6zdyyyZ/0=;
	h=Date:To:From:Subject:Message-Id; b=ZP+SwaSlDiQLRgal8TAKj9XXEEOkPdH8R/uMIWSjmXRGDP4CPe8rThSzeZ+OX0uJGgBAjFvxcL6J0bVI3q9YQ+3aeHjV93h4BOBW8uUQc9ma7NF4DoPHxR/aB6v/pAaEewm774KgzYhPsYjxE6CDz/H47f6wMYR3uERXgo95idc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mk7Wjmyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mk7Wjmyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490AF1F00898;
	Tue, 29 Sep 2026 21:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790717566;
	bh=d/K9+g+sV8MsCqU+6d/j7e5ZH5VGayLx6jlt/fIdi+E=;
	h=Date:To:From:Subject;
	b=Mk7WjmypVbeqBW0UtA4Vmg5bh/UttrUY/YjvwE21HvLpuSBO/sqaf3gIAfWCQsYXW
	 5ZUrt8KU7C7AYWL3SikUHpw7ybQnR7kKE9cuq8c2zT4QxiFdDwyI0SRuzckGxQoq+9
	 33w43jCqiGCeacOjxNlmYHAiRdILvB6M/28+X1aY=
Date: Tue, 29 Sep 2026 14:32:45 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-add-zone-mismatch-warning-during-page-init.patch added to mm-new branch
Message-Id: <20260929213246.490AF1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: add zone mismatch warning during page init
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Tue, 29 Sep 2026 13:32:31 +0800

For vmemmap-optimized sections, tail struct pages may be backed by shared
vmemmap pages.  Those shared pages must carry the same page zone ID as the
struct pages initialized for the section.

Warn in __init_single_page() if the shared tail page has a different
page_zone_id(), which would indicate inconsistent initialization.

Link: https://lore.kernel.org/20260929053231.66085-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

 mm/mm_init.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mm_init.c~mm-mm_init-add-zone-mismatch-warning-during-page-init
+++ a/mm/mm_init.c
@@ -609,6 +609,9 @@ void __meminit __init_single_page(struct
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+	VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)) &&
+			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
+			page_zone_id(page));
 }
 
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-allocate-shared-tail-page-array-dynamically.patch
mm-sparse-vmemmap-introduce-config_vmemmap_optimization.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-compound-page-orders.patch
mm-sparse-vmemmap-set-compound-page-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch
mm-sparse-vmemmap-move-vmemmap-optimization-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch
mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch


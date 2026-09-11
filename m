Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1871E2F7F07
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 00:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789088219; cv=none; b=iRq6+HRAG5ryU0SXwZ2ZtzXn/TRJ2BF9gX6XivgqxRLqlr1RDKFJ4WKWab4eG+1q/57XQUEtLc5Ozngw8GtsIy5ZDYjeY2gFw7pEqHaVccm795XlJqDz5HJe6VI6eOPhny2usVm78bamOal17/MJrZykBnICarroivAhMQsP6TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789088219; c=relaxed/simple;
	bh=GFSk8KW8+dFeAckG69+XIarrUfdtq1WoSQytgsntGrM=;
	h=Date:To:From:Subject:Message-Id; b=NiTSxRTl3QwTEN70hqohcnkDi1xZoCFRwYTlQCAy8/bTvhNLUaKpW23TkNgYuM8VYn7wNyE+n7RpqA7AGf1l3bddMASbvmrkRgv9QmcXPiUCpOWcEl4bbN8xccgUBjTD9BePS10hAaiHlriqXDGNXYTi4tmvsnhgxPhfzZlNdPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wEuRQ19T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wEuRQ19T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A27F1F000FF;
	Fri, 11 Sep 2026 00:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789088217;
	bh=tih+EB43ltly1ExuRu7Tc7iL2pIQcLi5mwHD0J6bx+A=;
	h=Date:To:From:Subject;
	b=wEuRQ19TpXPrvzpbFkKnQgsvpPHuzvQ57IjcLBYWu8TM2AGYwZ+0hyI+sXShv64cQ
	 VTUtiBq+/clkU0qtvAkdOIehoR6aVG7+LJtOeXVZSR26iM4OUhHB5LoRZ3fuGTXpsQ
	 TnfgdBvP4h5hXMHP7SDadkgxyXUKJCwgxxDG1uDY=
Date: Thu, 10 Sep 2026 17:56:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-core-api-memory-allocation-clarify-when-to-use-kzalloc_obj-and-kzalloc.patch added to mm-new branch
Message-Id: <20260911005657.6A27F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/core-api: memory-allocation: clarify when to use kzalloc_obj and kzalloc
has been added to the -mm mm-new branch.  Its filename is
     docs-core-api-memory-allocation-clarify-when-to-use-kzalloc_obj-and-kzalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-core-api-memory-allocation-clarify-when-to-use-kzalloc_obj-and-kzalloc.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: docs/core-api: memory-allocation: clarify when to use kzalloc_obj and kzalloc
Date: Mon, 7 Sep 2026 09:36:54 +0300

Make it abundantly clear that in the most cases objects should be
allocated with kzalloc_obj() and buffers should be allocated with
kzalloc().

Link: https://lore.kernel.org/20260907063654.2248617-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/memory-allocation.rst |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/core-api/memory-allocation.rst~docs-core-api-memory-allocation-clarify-when-to-use-kzalloc_obj-and-kzalloc
+++ a/Documentation/core-api/memory-allocation.rst
@@ -23,12 +23,14 @@ answer, although very likely you should
 
   kzalloc_obj(<VAR_OR_TYPE>);
 
-or
+if you need memory for an object and
 
 ::
 
   kzalloc(<size>, GFP_KERNEL);
 
+if you need memory for a buffer.
+
 Of course there are cases when other allocation APIs and different GFP
 flags must be used.
 
_

Patches currently in -mm which might be from rppt@kernel.org are

set_memory-add-number-of-pages-parameter-to-set_direct_map-apis.patch
mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch
mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch
mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch
mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch
revert-arch-introduce-set_direct_map_valid_noflush.patch
docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch
maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch
mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch
mm-execmem-handle-potential-allocation-errors-in-the-maple-tree.patch
mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch
mm-vmalloc-add-define_free-for-vfree.patch
mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch
docs-core-api-memory-allocation-clarify-when-to-use-kzalloc_obj-and-kzalloc.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573F12D2495
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 02:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775011820; cv=none; b=jxBS+QXAssq4X5InmN8iPj5u3GBvRBOo1PlsNRGSUDYHcdji4+68T41I42g2DZbfBO7hr1k0gw6bgaZg3K+OAcMxsdswG7uIAgIdgSv/mj+Kc4uleJRjhDDgW7OH15IIHj9L67iJSVUHFUIyrt+8ET26nHB7Dl8yNO9EfdVnHx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775011820; c=relaxed/simple;
	bh=TtZNxwghYUnCOhdGXYDnfWGJ951HbxAbVtZMcHu0mk8=;
	h=Date:To:From:Subject:Message-Id; b=PCvmW3N2R/FtnDfiUd3IU8CYPwh30wp50VmO5kVE2mOAPAqD0ZaKbSUJmxH/UmQI87bADbEzZPnhMYJP1VEkXuHGMOguLqs/CuoiLspm9/c0ygVw+Q+PVBYQgwnbHFzGdVLaL7DQ8YOjrFUaFQ/y26HVewtcQ9ZnODki+4aETPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QJFAztfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QJFAztfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB202C19423;
	Wed,  1 Apr 2026 02:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775011819;
	bh=TtZNxwghYUnCOhdGXYDnfWGJ951HbxAbVtZMcHu0mk8=;
	h=Date:To:From:Subject:From;
	b=QJFAztfpyQgiWlGRTgOJx+dzHeO151B4BIGkuzoahGgZzN07Eg8SZpcwCBQRy4MxU
	 BU4msqKeuG3vnHnV+dHR/DO+ImYxveh9OVvT8yw8FL8/M4mcc8t3EI8kGHjMCMyFpE
	 7KR8yrybedENgHs9YbrMzO4b2D6M1z274ojbfI4s=
Date: Tue, 31 Mar 2026 19:50:19 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,fvdl@google.com,donettom@linux.ibm.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-fix-preinited-section_mem_map-clobbering-on-failure-path.patch added to mm-new branch
Message-Id: <20260401025019.AB202C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: fix preinited section_mem_map clobbering on failure path
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-fix-preinited-section_mem_map-clobbering-on-failure-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-fix-preinited-section_mem_map-clobbering-on-failure-path.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: fix preinited section_mem_map clobbering on failure path
Date: Tue, 31 Mar 2026 19:37:24 +0800

sparse_init_nid() is careful to leave alone every section whose vmemmap
has already been set up by sparse_vmemmap_init_nid_early(); it only clears
section_mem_map for the rest:

        if (!preinited_vmemmap_section(ms))
                ms->section_mem_map = 0;

A leftover line after that conditional block

        ms->section_mem_map = 0;

was supposed to be deleted but was missed in the failure path, causing the
field to be overwritten for all sections when memory allocation fails,
effectively destroying the pre-initialization check.

Drop the stray assignment so that preinited sections retain their
already valid state.

Link: https://lkml.kernel.org/r/20260331113724.2080833-1-songmuchun@bytedance.com
Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-fix-preinited-section_mem_map-clobbering-on-failure-path
+++ a/mm/sparse.c
@@ -403,7 +403,6 @@ failed:
 		ms = __nr_to_section(pnum);
 		if (!preinited_vmemmap_section(ms))
 			ms->section_mem_map = 0;
-		ms->section_mem_map = 0;
 	}
 }
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-remove-dead-code-of-checking-parent-memory-cgroup.patch
mm-workingset-use-folio_lruvec-in-workingset_refault.patch
mm-rename-unlock_page_lruvec_irq-and-its-variants.patch
mm-vmscan-refactor-move_folios_to_lru.patch
mm-memcontrol-allocate-object-cgroup-for-non-kmem-case.patch
mm-memcontrol-return-root-object-cgroup-for-root-memory-cgroup.patch
mm-memcontrol-prevent-memory-cgroup-release-in-get_mem_cgroup_from_folio.patch
buffer-prevent-memory-cgroup-release-in-folio_alloc_buffers.patch
writeback-prevent-memory-cgroup-release-in-writeback-module.patch
mm-memcontrol-prevent-memory-cgroup-release-in-count_memcg_folio_events.patch
mm-page_io-prevent-memory-cgroup-release-in-page_io-module.patch
mm-migrate-prevent-memory-cgroup-release-in-folio_migrate_mapping.patch
mm-mglru-prevent-memory-cgroup-release-in-mglru.patch
mm-memcontrol-prevent-memory-cgroup-release-in-mem_cgroup_swap_full.patch
mm-workingset-prevent-memory-cgroup-release-in-lru_gen_eviction.patch
mm-workingset-prevent-lruvec-release-in-workingset_refault.patch
mm-zswap-prevent-lruvec-release-in-zswap_folio_swapin.patch
mm-swap-prevent-lruvec-release-in-lru_gen_clear_refs.patch
mm-workingset-prevent-lruvec-release-in-workingset_activation.patch
mm-memcontrol-prepare-for-reparenting-lru-pages-for-lruvec-lock.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-helpers.patch
mm-sparse-fix-build_bug_on-check-for-section-map-alignment.patch
mm-sparse-fix-preinited-section_mem_map-clobbering-on-failure-path.patch


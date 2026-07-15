Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD4B400966
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 19:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142534; cv=none; b=A5OhkpWwiNr4rjsF+PP5ONQSdNnXai2Va7WBXNT+riOw3fEqrzOr3oGNx/rx4JpGQxJ6rOVPaCzSWNqUuGRUz0qW+YeJnvX4cEjnr3BBfPFCQ3TUDIRfhgmORBBHKSXgy6yR0FQrjXW+8RKth1KbYXfmWP0Y8ZJb2M+LYwYTVME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142534; c=relaxed/simple;
	bh=dtJRArI4CHmdjDEEQWQbgyz89DvHI5Cse9CrxbeprYg=;
	h=Date:To:From:Subject:Message-Id; b=rLHJvZmtwDecBmYERxhgoQ/4iqbAPYDBqh8FkdFWTsCQyD4VJOpUh1JUHUM5ysCU1D57IHCvM5VFb3vUHRrhy/7eqgNILFvDxhI/K/dSNXZKEI+lR+BWpVaQihBHSMBLzwlYyT977dH/uibhjOwL98Uhi+9f1cqZxYZjT2w6S4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K6My0+GH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K6My0+GH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE6A1F00A3D;
	Wed, 15 Jul 2026 19:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784142519;
	bh=ekUxfbPDTVgJyMG5KMaHRaJT1lBvjzEoGc6iVuSmZDs=;
	h=Date:To:From:Subject;
	b=K6My0+GHQqX9gRwcoUZc8xzCuoafoBebf9KPNrwbTGUh4UrNspW/4c1zrtZflDmcP
	 Kg0hypTU60fs6z1HJB4w2HAzBHdnIhKA8IVUcey8bmgsM/3rfLL5k9TN0qd13KecB7
	 YHzuS751WuaKZXydng6jTZdcp+FbiTAav6NcaYLw=
Date: Wed, 15 Jul 2026 12:08:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tj@kernel.org,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mkoutny@suse.com,mhocko@suse.com,longman@redhat.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,bigeasy@linutronix.de,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch added to mm-new branch
Message-Id: <20260715190839.0DE6A1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove a couple of VM_BUG_ON()st
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: remove a couple of VM_BUG_ON()st
Date: Wed, 15 Jul 2026 11:03:21 +0000

VM_BUG_ON() is out of favour and on the way to removal, since I recently
touched alloc_pages_node_noprof() I am removing that invocation, and also
removing the __folio_alloc_node_noprof() one for consistency.  If this
precondition is violated, the system will soon crash anyway.

Link: https://lore.kernel.org/20260715-spin-trylock-followup-v3-4-fc4d246f705d@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Link: https://lore.kernel.org/all/7F866265-3F2E-4765-B9D4-9AB898A9C4AC@nvidia.com/
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    1 -
 mm/page_alloc.c     |    1 -
 2 files changed, 2 deletions(-)

--- a/include/linux/gfp.h~mm-page_alloc-remove-a-couple-of-vm_bug_onst
+++ a/include/linux/gfp.h
@@ -255,7 +255,6 @@ static inline void warn_if_node_offline(
 static inline
 struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 {
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp);
 
 	return __folio_alloc_noprof(gfp, order, nid, NULL);
--- a/mm/page_alloc.c~mm-page_alloc-remove-a-couple-of-vm_bug_onst
+++ a/mm/page_alloc.c
@@ -5427,7 +5427,6 @@ struct page *alloc_pages_node_noprof(int
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp_mask);
 
 	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-drop-flag-conversion-optimisation.patch
mm-secretmem-disable-under-highmem.patch
mm-page_alloc-rename-alloc_trylock-alloc_nolock.patch
mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes.patch
mm-name-some-args-in-a-function-declaration.patch
mm-split-out-internal-page_alloch.patch
mm-page_alloc-unify-__alloc_frozen_pages_noprof.patch
mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch
mm-move-some-stuff-to-mm-page_alloch.patch
perf-x86-intel-use-higher-level-allocator-api.patch
kvm-vmx-use-higher-level-allocator-api.patch
x86-virt-use-higher-level-allocator-api.patch
sgi-xp-use-higher-level-allocator-api.patch
net-funeth-switch-to-higher-level-allocator-api.patch
mm-remove-__alloc_pages_node.patch
mm-move-__alloc_pages-to-mm-page_alloch.patch
mm-replace-__gfp_no_codetag-with-alloc_no_codetag.patch
mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch
mm-factor-out-can_spin_trylock.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch


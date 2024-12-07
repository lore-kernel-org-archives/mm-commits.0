Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DC84D8D1
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 04:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733545773; cv=none; b=L4i+E7BlGg0yBH3wrHLllQbSFMTH0a15HIzb6wDNv5zNkVlbB4nUjud0ClCSWH5EIJRx5GHG1I31saeEiiiwVmMjKSRksdTEsWDQagdPUO9AyEsgQMTRDIjbwApvKjcCimPYe5C5rmum99EhFFKR0i9chsCIkbPoVSbB/8HHRVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733545773; c=relaxed/simple;
	bh=0wDoUw6LbUneL0nxcXD1meOE876oW8D2ufKnETDTkHU=;
	h=Date:To:From:Subject:Message-Id; b=FYC/dFFcRc2+Wrxf+ImrxtJPzL5gvWKOMakkzJWBAmtZTDl9F7JlPj5Td+ryfNlwKz9iT6qiK+KvVi/gjkq0PtZdHamnw5sv/KRfOj2BEHxuSBHOMRX5XoJhyP4xrDYLf7wtg0tQk63UktUI8uLk1nuxMpoHYoi2iUMb4FeCVZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HxiNVNIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HxiNVNIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40AFC4CECD;
	Sat,  7 Dec 2024 04:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733545772;
	bh=0wDoUw6LbUneL0nxcXD1meOE876oW8D2ufKnETDTkHU=;
	h=Date:To:From:Subject:From;
	b=HxiNVNIsoRt3LjtOU0DZTqr2kpU1Lf4WlB8Lh/+c9ZF1eDhXq7S6iGxaIHXbdFLdo
	 rlTosrQX6q8iPpvhnhIjNJHyNsy5BB83T4kV6Ln31OQHmDh1KNa9Q5PVo+Ng9ONvUm
	 7ZWk9R8p7/WGfVvjzJ7RVkCIlh+GqmhqC808L4s8=
Date: Fri, 06 Dec 2024 20:29:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slab-allow-freeptr_offset-to-be-used-with-ctor.patch added to mm-unstable branch
Message-Id: <20241207042932.C40AFC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/slab: allow freeptr_offset to be used with ctor
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slab-allow-freeptr_offset-to-be-used-with-ctor.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slab-allow-freeptr_offset-to-be-used-with-ctor.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/slab: allow freeptr_offset to be used with ctor
Date: Fri, 6 Dec 2024 14:52:02 -0800

There is no real reason to prevent freeptr_offset usage when a slab cache
has a ctor.  The only real limitation is that any field unioned with the
free pointer and initialized by ctor will be overwritten since free
pointer is set after @ctor invocation.  Document this limitation and
enable usage of freeptr_offset with ctor.

Link: https://lkml.kernel.org/r/20241206225204.4008261-6-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    5 +++--
 mm/slub.c            |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/slab.h~mm-slab-allow-freeptr_offset-to-be-used-with-ctor
+++ a/include/linux/slab.h
@@ -305,8 +305,9 @@ struct kmem_cache_args {
 	 * Using %0 as a value for @freeptr_offset is valid. If @freeptr_offset
 	 * is specified, %use_freeptr_offset must be set %true.
 	 *
-	 * Note that @ctor currently isn't supported with custom free pointers
-	 * as a @ctor requires an external free pointer.
+	 * Note that fields unioned with free pointer cannot be initialized by
+	 * @ctor since free pointer is set after @ctor invocation, so those
+	 * values will be overwritten.
 	 */
 	unsigned int freeptr_offset;
 	/**
--- a/mm/slub.c~mm-slab-allow-freeptr_offset-to-be-used-with-ctor
+++ a/mm/slub.c
@@ -5462,7 +5462,7 @@ static int calculate_sizes(struct kmem_c
 	s->inuse = size;
 
 	if (((flags & SLAB_TYPESAFE_BY_RCU) && !args->use_freeptr_offset) ||
-	    (flags & SLAB_POISON) || s->ctor ||
+	    (flags & SLAB_POISON) || (s->ctor && !args->use_freeptr_offset) ||
 	    ((flags & SLAB_RED_ZONE) &&
 	     (s->object_size < sizeof(void *) || slub_debug_orig_size(s)))) {
 		/*
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch
alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
mm-slab-allow-freeptr_offset-to-be-used-with-ctor.patch
docs-mm-document-latest-changes-to-vm_lock.patch


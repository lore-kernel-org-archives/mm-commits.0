Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38D6DDC1
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742186111; cv=none; b=EoHgDFu97Kb/VyqJ+voc3G3N11sMR5Z8+Ln3YHWEWE1cMMJ84E3ClCio7yPK+lwa/WBPKI0nrgND+06hZ4JnMzeGG4JRLKk//q9EXdLjwkJ4rErLQiCrmXbt/02j8GAQIlgH40MBghS1FsImDZQkWnNM+0vfsc9hAyaDLznvVvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742186111; c=relaxed/simple;
	bh=tFIpOQvuN0plfI0h5/R1bH2Tofpvzri7804QGl1ZSW8=;
	h=Date:To:From:Subject:Message-Id; b=tHDBRFm71duvztAEamTdbTN2inDHZaLjUOGyDLCCUTCiaDG9ghdsvTyTSHBuTiTxfTu8FX+ssgxMDs6bGVCQjQWUoKZWMASDWpZ2rvplDQIMJ429ih8DDsdpoNNbWT8q1llA274i/uapmQ0GZ2PQFJIFw+W49x5baBbYG11JYOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0mdgmbiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0mdgmbiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6E9C4CEEC;
	Mon, 17 Mar 2025 04:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742186110;
	bh=tFIpOQvuN0plfI0h5/R1bH2Tofpvzri7804QGl1ZSW8=;
	h=Date:To:From:Subject:From;
	b=0mdgmbiXq3MPz1QbA27mBTiUL//UmrACJ5gPkmXDV/AeD1MvX91t3jP54ZXuxkXDY
	 ze6akFB4wCigxDq0Ta4NIbnpD0bCqI3J1ib49xKa2m4rqSQJYKUqAhMujjvS4JgkhA
	 opWYWYM8CyulOqHmU1Ne+v1ilsiEluISGBzZgYXY=
Date: Sun, 16 Mar 2025 21:35:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] refcount-provide-ops-for-cases-when-objects-memory-can-be-reused-fix.patch removed from -mm tree
Message-Id: <20250317043510.1A6E9C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: fix title underlines in refcount-vs-atomic.rst
has been removed from the -mm tree.  Its filename was
     refcount-provide-ops-for-cases-when-objects-memory-can-be-reused-fix.patch

This patch was dropped because it was folded into refcount-provide-ops-for-cases-when-objects-memory-can-be-reused.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: docs: fix title underlines in refcount-vs-atomic.rst
Date: Mon, 17 Feb 2025 08:16:45 -0800

Fix title underlines for newly updated refcount-vs-atomic.rst

Link: https://lkml.kernel.org/r/20250217161645.3137927-1-surenb@google.com
Fixes: 03b412c8b184 ("refcount: provide ops for cases when object's memory can be reused")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/refcount-vs-atomic.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/core-api/refcount-vs-atomic.rst~refcount-provide-ops-for-cases-when-objects-memory-can-be-reused-fix
+++ a/Documentation/core-api/refcount-vs-atomic.rst
@@ -87,7 +87,7 @@ Memory ordering guarantee changes:
 
 
 case 2) - non-"Read/Modify/Write" (RMW) ops with release ordering
--------------------------------------------
+-----------------------------------------------------------------
 
 Function changes:
 
@@ -139,7 +139,7 @@ Memory ordering guarantees changes:
 
 
 case 6) - increment-based RMW ops with acquire ordering that return a value
------------------------------------------------------
+---------------------------------------------------------------------------
 
 Function changes:
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-avoid-extra-mem_alloc_profiling_enabled-checks.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-page-allocator.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch
mm-mark-vmas-detached-upon-exit.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-provide-ops-for-cases-when-objects-memory-can-be-reused.patch
refcount-introduce-__refcount_addinc_not_zero_limited_acquire.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count-fix.patch
mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch
docs-mm-document-latest-changes-to-vm_lock.patch


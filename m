Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DB1DDC1
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742186146; cv=none; b=lKc/teyd4XvTVAbyomt6FZVNwsYiIi6xq5ImMO4h5/x/aJO+MQnmgeTU4mSlC1pFtIDzeAVKbfMyIuT6ZvMCoDCaKbuaOWWLF9V6NvHbe4FTnq52DbBwjyaUZcd38C3IRW784mG+V48KxEX/P43dQKGdakkQrlh4e2WHAIWJKQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742186146; c=relaxed/simple;
	bh=ghMXrTc3MSg315+GYhf+A+O1ZxV4M8Y9I2bMQRAdkMw=;
	h=Date:To:From:Subject:Message-Id; b=HbB35am9oaBD+V3h9Wa/tW9E6ArLEzOuzJ+H8NAktomYa+BSYVeb5XaPvmBPj7VjhzQ4EyBrGNsWoS5UXk5GIpN8DySCbiPoCEMjoRDSGVU0alh2g1slsdEmIKOk4JAaXzQn7XbR7C2QWLHHaahggyKSC7jgM1hBoBUYWoslmOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iSk0GRWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iSk0GRWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00083C4CEEC;
	Mon, 17 Mar 2025 04:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742186146;
	bh=ghMXrTc3MSg315+GYhf+A+O1ZxV4M8Y9I2bMQRAdkMw=;
	h=Date:To:From:Subject:From;
	b=iSk0GRWHMPKRreuy3Xt0/NFteYteTAtfBqkfezoT9A6555mrYfMG/n4VNzMW/WYnk
	 VHsO8AKkSxh/DnXqu3xQK6x4phCtDYMpFcD9SOvqVSwZBaUm6e3VI3Ka32KD1Bq+vy
	 8nuCYnWX5gjvHSBDjjr/UTdkebreJE/mefAJtBzI=
Date: Sun, 16 Mar 2025 21:35:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-replace-vm_lock-and-detached-flag-with-a-reference-count-fix.patch removed from -mm tree
Message-Id: <20250317043546.00083C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix a crash due to vma_end_read() that should have been removed
has been removed from the -mm tree.  Its filename was
     mm-replace-vm_lock-and-detached-flag-with-a-reference-count-fix.patch

This patch was dropped because it was folded into mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix a crash due to vma_end_read() that should have been removed
Date: Thu, 20 Feb 2025 12:02:08 -0800

Handling a vma lock failure due to vma being detached from under us got
changed but vma_end_read() in that path was left untouched while it should
have been removed.  Remove it.

Link: https://lkml.kernel.org/r/20250220200208.323769-1-surenb@google.com
Fixes: 758f7664c3d1 ("mm: replace vm_lock and detached flag with a reference count")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Closes: https://lore.kernel.org/all/20250220185304.8313A7d-hca@linux.ibm.com/
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c~mm-replace-vm_lock-and-detached-flag-with-a-reference-count-fix
+++ a/mm/memory.c
@@ -6458,7 +6458,6 @@ retry:
 	if (IS_ERR_OR_NULL(vma)) {
 		/* Check if the VMA got isolated after we found it */
 		if (PTR_ERR(vma) == -EAGAIN) {
-			vma_end_read(vma);
 			count_vm_vma_lock_event(VMA_LOCK_MISS);
 			/* The area was replaced with another one */
 			goto retry;
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
mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch
docs-mm-document-latest-changes-to-vm_lock.patch


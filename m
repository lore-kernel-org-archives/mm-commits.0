Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4E824B29
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580145; cv=none; b=ieHwPD3V1neyXLn9SabkcoL3PWihYvb6LV2L7bkwhyeEmbd7TgoF35CcLHCvF7JWj85qS96aWtGp83lI98PAq8LwbFZsXjiM2OUgwmoblr7kpPW1inugCCw4takmqbQSKzkU0PftXEydOm7GY1Ps3DPG2CXKZWOZRCPGjHjVm4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580145; c=relaxed/simple;
	bh=DZ6vAz9Q3nKxy0t9K322HMVmdF7DZ+BgzxSaU6noRqo=;
	h=Date:To:From:Subject:Message-Id; b=a/nY7B5CkULAjUYf4JP7622RRvtQXMMs6o+5F4yanxmwbz36WGxuuD6PtBRv4iiqhs/RYUw4TVVQNt+GT+0/NBFR5HxWF4Pekm12ohtfWTsepE5LHvwjpN2x3lysTIpRm2iEJkcqISXHvWWE1EySjxwAIv5VdbQYitjXmEEcxBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NaZu9qCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NaZu9qCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF34C4CED1;
	Sat, 15 Feb 2025 00:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739580145;
	bh=DZ6vAz9Q3nKxy0t9K322HMVmdF7DZ+BgzxSaU6noRqo=;
	h=Date:To:From:Subject:From;
	b=NaZu9qCs/YtuVoma0g3ydvnG+bb0rYzcbdQ7Qtmhtm0fnLtKW4xaLQNxwEGrh0Jr2
	 lAd8PYob/u5p4DMC3JxohevqDuSM99q4f9p2xCeN20FZp3IxOVY7aA/LVL3+NMe5wW
	 /P6J77qsbHLZZTjiWwW4fyZ2En+2O+YcMJrxcNA4=
Date: Fri, 14 Feb 2025 16:42:24 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + refcount-introduce-__refcount_addinc_not_zero_limited_acquire.patch added to mm-unstable branch
Message-Id: <20250215004225.5DF34C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: refcount: introduce __refcount_{add|inc}_not_zero_limited_acquire
has been added to the -mm mm-unstable branch.  Its filename is
     refcount-introduce-__refcount_addinc_not_zero_limited_acquire.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/refcount-introduce-__refcount_addinc_not_zero_limited_acquire.patch

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
Subject: refcount: introduce __refcount_{add|inc}_not_zero_limited_acquire
Date: Thu, 13 Feb 2025 14:46:48 -0800

Introduce functions to increase refcount but with a top limit above which
they will fail to increase (the limit is inclusive).  Setting the limit to
INT_MAX indicates no limit.

Link: https://lkml.kernel.org/r/20250213224655.1680278-12-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickens <hughd@google.com>
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
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/refcount.h |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/include/linux/refcount.h~refcount-introduce-__refcount_addinc_not_zero_limited_acquire
+++ a/include/linux/refcount.h
@@ -213,13 +213,20 @@ static inline __must_check bool refcount
 }
 
 static inline __must_check __signed_wrap
-bool __refcount_add_not_zero_acquire(int i, refcount_t *r, int *oldp)
+bool __refcount_add_not_zero_limited_acquire(int i, refcount_t *r, int *oldp,
+					     int limit)
 {
 	int old = refcount_read(r);
 
 	do {
 		if (!old)
 			break;
+
+		if (i > limit - old) {
+			if (oldp)
+				*oldp = old;
+			return false;
+		}
 	} while (!atomic_try_cmpxchg_acquire(&r->refs, &old, old + i));
 
 	if (oldp)
@@ -231,6 +238,18 @@ bool __refcount_add_not_zero_acquire(int
 	return old;
 }
 
+static inline __must_check bool
+__refcount_inc_not_zero_limited_acquire(refcount_t *r, int *oldp, int limit)
+{
+	return __refcount_add_not_zero_limited_acquire(1, r, oldp, limit);
+}
+
+static inline __must_check __signed_wrap
+bool __refcount_add_not_zero_acquire(int i, refcount_t *r, int *oldp)
+{
+	return __refcount_add_not_zero_limited_acquire(i, r, oldp, INT_MAX);
+}
+
 /**
  * refcount_add_not_zero_acquire - add a value to a refcount with acquire ordering unless it is 0
  *
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-work-around-clang-14-issue-with-__builtin_object_size.patch
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
docs-mm-document-latest-changes-to-vm_lock.patch


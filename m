Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5935F219FF
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736660802; cv=none; b=aeXRxXsrMwWiQrFrsusi9IxhVyhRnc2ll0MQ9Ihw7iR5RwbqWA/5VQPv5VnEMHN7Jimi+kLlPz+NystW3fWSh6xir6J/lDKN71pVzWEHPot7bGrekphyFqzti/c/FgL1qke3c0pH+3tixSbaZeod+Zgpc9KO0T/C9artIegIKkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736660802; c=relaxed/simple;
	bh=j9W7mMKLapQfKtSFKK/PcMdIIXBaJRYzFmsZCZ5xgXQ=;
	h=Date:To:From:Subject:Message-Id; b=I4venkFx0hEp3GFd+cDIJqDrfT7jK03imtmbz3E8KZuobj6J0LqjJ/ye3RQWgPuzxQRXdN58tewDOv0Q7do0bfIT8DjlYGlRF/IHRK13AhtjG37G6UMkbPF84H4sf9I7j5yagEyAjB/C5KyJYhmb6o+W6fZ90oZ2mEV/z5peFkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EzOIQnQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EzOIQnQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E14C4CEE0;
	Sun, 12 Jan 2025 05:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736660801;
	bh=j9W7mMKLapQfKtSFKK/PcMdIIXBaJRYzFmsZCZ5xgXQ=;
	h=Date:To:From:Subject:From;
	b=EzOIQnQjgSNfMyaID0scva9EpM3LIxvLKTV08IND+FFhysbuPWD7GnXj04tVs6QA2
	 lhdqn3EqhIiAGdU3GQB7jdaAQpfJlJyAwIT1B4uUkaP8eX5Cf48PlngVFh0+BW868D
	 H5/9nh8YcNoJ5NCnxX7/hp8pC6evh1SB1AFlRjIY=
Date: Sat, 11 Jan 2025 21:46:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + refcount-introduce-__refcount_addinc_not_zero_limited.patch added to mm-unstable branch
Message-Id: <20250112054641.C9E14C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: refcount: introduce __refcount_{add|inc}_not_zero_limited
has been added to the -mm mm-unstable branch.  Its filename is
     refcount-introduce-__refcount_addinc_not_zero_limited.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/refcount-introduce-__refcount_addinc_not_zero_limited.patch

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
Subject: refcount: introduce __refcount_{add|inc}_not_zero_limited
Date: Fri, 10 Jan 2025 20:25:57 -0800

Introduce functions to increase refcount but with a top limit above which
they will fail to increase (the limit is inclusive).  Setting the limit to
INT_MAX indicates no limit.

Link: https://lkml.kernel.org/r/20250111042604.3230628-11-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mattew Wilcox <willy@infradead.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/refcount.h |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/include/linux/refcount.h~refcount-introduce-__refcount_addinc_not_zero_limited
+++ a/include/linux/refcount.h
@@ -137,13 +137,23 @@ static inline unsigned int refcount_read
 }
 
 static inline __must_check __signed_wrap
-bool __refcount_add_not_zero(int i, refcount_t *r, int *oldp)
+bool __refcount_add_not_zero_limited(int i, refcount_t *r, int *oldp,
+				     int limit)
 {
 	int old = refcount_read(r);
 
 	do {
 		if (!old)
 			break;
+
+		if (statically_true(limit == INT_MAX))
+			continue;
+
+		if (i > limit - old) {
+			if (oldp)
+				*oldp = old;
+			return false;
+		}
 	} while (!atomic_try_cmpxchg_relaxed(&r->refs, &old, old + i));
 
 	if (oldp)
@@ -155,6 +165,12 @@ bool __refcount_add_not_zero(int i, refc
 	return old;
 }
 
+static inline __must_check __signed_wrap
+bool __refcount_add_not_zero(int i, refcount_t *r, int *oldp)
+{
+	return __refcount_add_not_zero_limited(i, r, oldp, INT_MAX);
+}
+
 /**
  * refcount_add_not_zero - add a value to a refcount unless it is 0
  * @i: the value to add to the refcount
@@ -213,6 +229,12 @@ static inline void refcount_add(int i, r
 	__refcount_add(i, r, NULL);
 }
 
+static inline __must_check bool __refcount_inc_not_zero_limited(refcount_t *r,
+								int *oldp, int limit)
+{
+	return __refcount_add_not_zero_limited(1, r, oldp, limit);
+}
+
 static inline __must_check bool __refcount_inc_not_zero(refcount_t *r, int *oldp)
 {
 	return __refcount_add_not_zero(1, r, oldp);
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch
tools-fix-atomic_set-definition-to-set-the-value-correctly.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch
mm-mark-vmas-detached-upon-exit.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch
alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch


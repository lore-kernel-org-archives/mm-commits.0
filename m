Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7796DDC1
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742186185; cv=none; b=IbdCOqVxArmk7tuWJMcgRBFitgJ/q/irHqsLDlVSOJ/2Ipkm+K0IMqOuN57VOm7VCXiZveDZwwNJGcX2o10mE8K45BFqNgT0KU1lK9x9JbdWQoei+/tu8Pq8n2QbSrVsWf/UHDbSKJPpfikiUYQ+gTPurPeIp4pMy83s5+H8cag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742186185; c=relaxed/simple;
	bh=U/EiAfczVC/l9CXrS7f6QeTv4KCCX2bq4OH1PLivceY=;
	h=Date:To:From:Subject:Message-Id; b=gJNpquq09nR8b0CKgiBz/wcPS5JQOKPIA9lVHF9vr+J+OvorzjOgHkeOza3OYNOdXk2HnNePJHN7AEXlLUnBlV2Cd+9E0rXLnrS98MerXSO8WYyzZTIzU79pBsW2uKRWBZK/GgMOIW+uw9niAbQfgQisSXH83jT/XnTUmJNoJ20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hwh/KcQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hwh/KcQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3722DC4CEEC;
	Mon, 17 Mar 2025 04:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742186185;
	bh=U/EiAfczVC/l9CXrS7f6QeTv4KCCX2bq4OH1PLivceY=;
	h=Date:To:From:Subject:From;
	b=Hwh/KcQD/aFhiclb+ID3/1irIDVdfYzOnzd9HKPZcti0mdwsiaQnrl+A14d+yyZjD
	 8jmJkOOvvUE3BMkNM/OISGKKRQWJx/wp+YoO+A4PXnWb+hy+nK3flq8VYFAEI9kkLA
	 ZDyqxFoR1t2Sx/Q5lcSjJm7ljJwAdbl6IB0h6uqA=
Date: Sun, 16 Mar 2025 21:36:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,lkp@intel.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch removed from -mm tree
Message-Id: <20250317043625.3722DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: remove atomic_set_release() usage in tools/
has been removed from the -mm tree.  Its filename was
     mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch

This patch was dropped because it was folded into mm-make-vma-cache-slab_typesafe_by_rcu.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: tools: remove atomic_set_release() usage in tools/
Date: Sun, 16 Feb 2025 21:43:51 -0800

Userspace versions of both atomic_set_release() and atomic_set() get
translated into uatomic_set().  To avoid extra definitions of
atomic_set_release(), replace its usage inside refcount_set_release() with
atomic_set().  This results in no functional changes.

Link: https://lkml.kernel.org/r/20250217054351.2973666-1-surenb@google.com
Fixes: 1465347e498f ("mm: make vma cache SLAB_TYPESAFE_BY_RCU")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502170049.sHfzQwpv-lkp@intel.com/
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/refcount.h   |    2 +-
 tools/testing/vma/linux/atomic.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/tools/include/linux/refcount.h~mm-make-vma-cache-slab_typesafe_by_rcu-fix
+++ a/tools/include/linux/refcount.h
@@ -62,7 +62,7 @@ static inline void refcount_set(refcount
 
 static inline void refcount_set_release(refcount_t *r, unsigned int n)
 {
-	atomic_set_release(&r->refs, n);
+	atomic_set(&r->refs, n);
 }
 
 static inline unsigned int refcount_read(const refcount_t *r)
--- a/tools/testing/vma/linux/atomic.h~mm-make-vma-cache-slab_typesafe_by_rcu-fix
+++ a/tools/testing/vma/linux/atomic.h
@@ -7,7 +7,6 @@
 #define atomic_inc(x) uatomic_inc(x)
 #define atomic_read(x) uatomic_read(x)
 #define atomic_set(x, y) uatomic_set(x, y)
-#define atomic_set_release(x, y) uatomic_set(x, y)
 #define U8_MAX UCHAR_MAX
 
 #ifndef atomic_cmpxchg_relaxed
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
docs-mm-document-latest-changes-to-vm_lock.patch


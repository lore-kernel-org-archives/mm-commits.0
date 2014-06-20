From: akpm@linux-foundation.org
Subject: +
 mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch added to
 -mm tree
Date: Fri, 20 Jun 2014 15:11:01 -0700
Message-ID: <53a4b175.92k3NrYedUyOtQK8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966137AbaFTWLC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:11:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org


The patch titled
     Subject: mm: page-flags: clean up the page flag test, set, clear macros
has been added to the -mm tree.  Its filename is
     mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page-flags: clean up the page flag test, set, clear macros

- PAGEFLAG_FALSE only defines TEST, make it define SET and CLEAR as
  well, analogous to PAGEFLAG.

- Define TESTSETFLAG_FALSE, analogous to TESTSETFLAG.

- Define TESTSCFLAG_FALSE, analogous to TESTSCFLAG

- Make PG_mlocked accessors the same on both MMU and !MMU setups

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff -puN include/linux/page-flags.h~mm-page-flags-clean-up-the-page-flag-test-set-clear-macros include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-page-flags-clean-up-the-page-flag-test-set-clear-macros
+++ a/include/linux/page-flags.h
@@ -171,13 +171,12 @@ static inline int __TestClearPage##uname
 #define __PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
 	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
 
-#define PAGEFLAG_FALSE(uname) 						\
-static inline int Page##uname(const struct page *page)			\
-			{ return 0; }
-
 #define TESTSCFLAG(uname, lname)					\
 	TESTSETFLAG(uname, lname) TESTCLEARFLAG(uname, lname)
 
+#define TESTPAGEFLAG_FALSE(uname)					\
+static inline int Page##uname(const struct page *page) { return 0; }
+
 #define SETPAGEFLAG_NOOP(uname)						\
 static inline void SetPage##uname(struct page *page) {  }
 
@@ -187,12 +186,21 @@ static inline void ClearPage##uname(stru
 #define __CLEARPAGEFLAG_NOOP(uname)					\
 static inline void __ClearPage##uname(struct page *page) {  }
 
+#define TESTSETFLAG_FALSE(uname)					\
+static inline int TestSetPage##uname(struct page *page) { return 0; }
+
 #define TESTCLEARFLAG_FALSE(uname)					\
 static inline int TestClearPage##uname(struct page *page) { return 0; }
 
 #define __TESTCLEARFLAG_FALSE(uname)					\
 static inline int __TestClearPage##uname(struct page *page) { return 0; }
 
+#define PAGEFLAG_FALSE(uname) TESTPAGEFLAG_FALSE(uname)			\
+	SETPAGEFLAG_NOOP(uname) CLEARPAGEFLAG_NOOP(uname)
+
+#define TESTSCFLAG_FALSE(uname)						\
+	TESTSETFLAG_FALSE(uname) TESTCLEARFLAG_FALSE(uname)
+
 struct page;	/* forward declaration */
 
 TESTPAGEFLAG(Locked, locked)
@@ -248,7 +256,6 @@ PAGEFLAG_FALSE(HighMem)
 PAGEFLAG(SwapCache, swapcache)
 #else
 PAGEFLAG_FALSE(SwapCache)
-	SETPAGEFLAG_NOOP(SwapCache) CLEARPAGEFLAG_NOOP(SwapCache)
 #endif
 
 PAGEFLAG(Unevictable, unevictable) __CLEARPAGEFLAG(Unevictable, unevictable)
@@ -258,8 +265,8 @@ PAGEFLAG(Unevictable, unevictable) __CLE
 PAGEFLAG(Mlocked, mlocked) __CLEARPAGEFLAG(Mlocked, mlocked)
 	TESTSCFLAG(Mlocked, mlocked) __TESTCLEARFLAG(Mlocked, mlocked)
 #else
-PAGEFLAG_FALSE(Mlocked) SETPAGEFLAG_NOOP(Mlocked)
-	TESTCLEARFLAG_FALSE(Mlocked) __TESTCLEARFLAG_FALSE(Mlocked)
+PAGEFLAG_FALSE(Mlocked) __CLEARPAGEFLAG_NOOP(Mlocked)
+	TESTSCFLAG_FALSE(Mlocked) __TESTCLEARFLAG_FALSE(Mlocked)
 #endif
 
 #ifdef CONFIG_ARCH_USES_PG_UNCACHED
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-charge-api-fix-3.patch
mm-memcontrol-rewrite-charge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch


From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:04:17 -0700
Message-ID: <53e3dbc1.Chyr23DG8WJz6bR4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43443 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaHGUES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:18 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so843979obc.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page-flags: clean up the page flag test, set, clear macros
has been removed from the -mm tree.  Its filename was
     mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch


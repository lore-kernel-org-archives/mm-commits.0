From: akpm@linux-foundation.org
Subject: + memcg-add-hugetlb-extension-fix.patch added to -mm tree
Date: Fri, 27 Apr 2012 13:35:27 -0700
Message-ID: <20120427203527.D5A7BA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:37828 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2D0Ufa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 16:35:30 -0400
Received: by wibhj13 with SMTP id hj13so59038wib.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 13:35:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg-add-hugetlb-extension-fix
has been added to the -mm tree.  Its filename is
     memcg-add-hugetlb-extension-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: memcg-add-hugetlb-extension-fix

Fix UML build:

mm/memcontrol.c:256:30: error: 'HUGE_MAX_HSTATE' undeclared here (not in a function)

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/page.h   |    2 +-
 arch/tile/include/asm/page.h      |    3 +--
 arch/x86/include/asm/page_types.h |    2 ++
 include/linux/hugetlb.h           |    1 +
 4 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/include/asm/page.h~memcg-add-hugetlb-extension-fix arch/powerpc/include/asm/page.h
--- a/arch/powerpc/include/asm/page.h~memcg-add-hugetlb-extension-fix
+++ a/arch/powerpc/include/asm/page.h
@@ -39,13 +39,13 @@
 #ifndef __ASSEMBLY__
 #ifdef CONFIG_HUGETLB_PAGE
 extern unsigned int HPAGE_SHIFT;
+#define HUGE_MAX_HSTATE		(MMU_PAGE_COUNT-1)
 #else
 #define HPAGE_SHIFT PAGE_SHIFT
 #endif
 #define HPAGE_SIZE		((1UL) << HPAGE_SHIFT)
 #define HPAGE_MASK		(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
-#define HUGE_MAX_HSTATE		(MMU_PAGE_COUNT-1)
 #endif
 
 /* We do define AT_SYSINFO_EHDR but don't use the gate mechanism */
diff -puN arch/tile/include/asm/page.h~memcg-add-hugetlb-extension-fix arch/tile/include/asm/page.h
--- a/arch/tile/include/asm/page.h~memcg-add-hugetlb-extension-fix
+++ a/arch/tile/include/asm/page.h
@@ -136,9 +136,8 @@ static inline __attribute_const__ int ge
 
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
 
-#define HUGE_MAX_HSTATE		6
-
 #ifdef CONFIG_HUGETLB_PAGE
+#define HUGE_MAX_HSTATE		6
 #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 #endif
 
diff -puN arch/x86/include/asm/page_types.h~memcg-add-hugetlb-extension-fix arch/x86/include/asm/page_types.h
--- a/arch/x86/include/asm/page_types.h~memcg-add-hugetlb-extension-fix
+++ a/arch/x86/include/asm/page_types.h
@@ -25,7 +25,9 @@
 #define HPAGE_MASK		(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
 
+#ifdef CONFIG_HUGETLB_PAGE
 #define HUGE_MAX_HSTATE 2
+#endif
 
 #define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
 
diff -puN include/linux/hugetlb.h~memcg-add-hugetlb-extension-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~memcg-add-hugetlb-extension-fix
+++ a/include/linux/hugetlb.h
@@ -318,6 +318,7 @@ static inline int hstate_index(struct hs
 
 #else
 struct hstate {};
+#define HUGE_MAX_HSTATE 0
 #define alloc_huge_page_node(h, nid) NULL
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
_
Subject: Subject: memcg-add-hugetlb-extension-fix

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-memory_failure-let-the-compiler-add-the-function-name.patch
mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy.patch
mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch
mm-thp-remove-unnecessary-ret-variable.patch
mm-thp-allow-fallback-when-pte_alloc_one-fails-for-huge-pmd.patch
memcg-add-hugetlb-extension-fix.patch
mm-vmstatc-remov-debug-fs-entries-on-failure-of-file-creation-and-made-extfrag_debug_root-dentry-local.patch
thp-memcg-split-hugepage-for-memcg-oom-on-cow.patch
mm-thp-drop-page_table_lock-to-uncharge-memcg-pages.patch


From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-add-hugetlb-extension-fix.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:09:48 -0700
Message-ID: <20120611210948.62BE3A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:54380 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2FKVJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:09:49 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so382695qab.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:09:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-add-hugetlb-extension-fix
has been removed from the -mm tree.  Its filename was
     memcg-add-hugetlb-extension-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -322,6 +322,7 @@ static inline int hstate_index(struct hs
 
 #else
 struct hstate {};
+#define HUGE_MAX_HSTATE 0
 #define alloc_huge_page_node(h, nid) NULL
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
slab-move-full-state-transition-to-an-initcall.patch
memcg-add-hugetlb-extension-fix-fix.patch


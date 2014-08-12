From: akpm@linux-foundation.org
Subject: [merged] page-cgroup-trivial-cleanup.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:38:02 -0700
Message-ID: <53ea6d1a.7g5MfmoTME0S9N6z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:60798 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaHLTiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:04 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so1068129igi.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-cgroup: trivial cleanup
has been removed from the -mm tree.  Its filename was
     page-cgroup-trivial-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: page-cgroup: trivial cleanup

Add forward declarations for struct pglist_data, mem_cgroup.

Remove __init, __meminit from function prototypes and inline functions.

Remove redundant inclusion of bit_spinlock.h.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/page_cgroup.h~page-cgroup-trivial-cleanup include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~page-cgroup-trivial-cleanup
+++ a/include/linux/page_cgroup.h
@@ -12,8 +12,10 @@ enum {
 #ifndef __GENERATING_BOUNDS_H
 #include <generated/bounds.h>
 
+struct pglist_data;
+
 #ifdef CONFIG_MEMCG
-#include <linux/bit_spinlock.h>
+struct mem_cgroup;
 
 /*
  * Page Cgroup can be considered as an extended mem_map.
@@ -27,16 +29,16 @@ struct page_cgroup {
 	struct mem_cgroup *mem_cgroup;
 };
 
-void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
+extern void pgdat_page_cgroup_init(struct pglist_data *pgdat);
 
 #ifdef CONFIG_SPARSEMEM
-static inline void __init page_cgroup_init_flatmem(void)
+static inline void page_cgroup_init_flatmem(void)
 {
 }
-extern void __init page_cgroup_init(void);
+extern void page_cgroup_init(void);
 #else
-void __init page_cgroup_init_flatmem(void);
-static inline void __init page_cgroup_init(void)
+extern void page_cgroup_init_flatmem(void);
+static inline void page_cgroup_init(void)
 {
 }
 #endif
@@ -48,11 +50,10 @@ static inline int PageCgroupUsed(struct
 {
 	return !!(pc->flags & PCG_USED);
 }
-
-#else /* CONFIG_MEMCG */
+#else /* !CONFIG_MEMCG */
 struct page_cgroup;
 
-static inline void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
+static inline void pgdat_page_cgroup_init(struct pglist_data *pgdat)
 {
 }
 
@@ -65,10 +66,9 @@ static inline void page_cgroup_init(void
 {
 }
 
-static inline void __init page_cgroup_init_flatmem(void)
+static inline void page_cgroup_init_flatmem(void)
 {
 }

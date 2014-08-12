From: akpm@linux-foundation.org
Subject: [merged] page-cgroup-get-rid-of-nr_pcg_flags.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:38:04 -0700
Message-ID: <53ea6d1c.8XNHuzIvwjwinps8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:63969 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaHLTiG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:06 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so2670172pdj.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-cgroup: get rid of NR_PCG_FLAGS
has been removed from the -mm tree.  Its filename was
     page-cgroup-get-rid-of-nr_pcg_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: page-cgroup: get rid of NR_PCG_FLAGS

It's not used anywhere today, so let's remove it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    6 ------
 kernel/bounds.c             |    2 --
 2 files changed, 8 deletions(-)

diff -puN include/linux/page_cgroup.h~page-cgroup-get-rid-of-nr_pcg_flags include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~page-cgroup-get-rid-of-nr_pcg_flags
+++ a/include/linux/page_cgroup.h
@@ -6,12 +6,8 @@ enum {
 	PCG_USED = 0x01,	/* This page is charged to a memcg */
 	PCG_MEM = 0x02,		/* This page holds a memory charge */
 	PCG_MEMSW = 0x04,	/* This page holds a memory+swap charge */
-	__NR_PCG_FLAGS,
 };
 
-#ifndef __GENERATING_BOUNDS_H
-#include <generated/bounds.h>
-
 struct pglist_data;
 
 #ifdef CONFIG_MEMCG
@@ -107,6 +103,4 @@ static inline void swap_cgroup_swapoff(i
 
 #endif /* CONFIG_MEMCG_SWAP */
 
-#endif /* !__GENERATING_BOUNDS_H */
-
 #endif /* __LINUX_PAGE_CGROUP_H */
diff -puN kernel/bounds.c~page-cgroup-get-rid-of-nr_pcg_flags kernel/bounds.c
--- a/kernel/bounds.c~page-cgroup-get-rid-of-nr_pcg_flags
+++ a/kernel/bounds.c
@@ -9,7 +9,6 @@
 #include <linux/page-flags.h>
 #include <linux/mmzone.h>
 #include <linux/kbuild.h>
-#include <linux/page_cgroup.h>
 #include <linux/log2.h>
 #include <linux/spinlock_types.h>
 
@@ -18,7 +17,6 @@ void foo(void)
 	/* The enum constants to put into include/generated/bounds.h */
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
 	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
-	DEFINE(NR_PCG_FLAGS, __NR_PCG_FLAGS);
 #ifdef CONFIG_SMP
 	DEFINE(NR_CPUS_BITS, ilog2(CONFIG_NR_CPUS));
 #endif
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch


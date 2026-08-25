Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFC1340A57
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622848; cv=none; b=Y2cSMjPwbZ9ZyAEEFk4QEZbiDKysXpY/VdKUVoTLkHsyA+A/p1oEdHfDlg4vyWaiF6Uni1Qq+gHW4FuanD0q7kPpAIG9ABm1wQdIN/oDAhaBBqG8wuehRc35dFEkALmTCFszCEAGcXWpeog2nnm744SpuONzu1gPU0ItSmYrl9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622848; c=relaxed/simple;
	bh=YN+SSb0nERvboYhlS8t3NdXJNInGzL6g0H6+7BNKmrc=;
	h=Date:To:From:Subject:Message-Id; b=dQ80YgMGuht7v9ob1WqpMvXH5evUwO/+f/unTAcZSd/zckuDHsJKuzDVFuLH8tJmlZLsokeCWhDmULYG15l+DpSkspoM4CB+yYAPJXTm9jAAmP2XOz9M2hHWXTj0G+wGY2845s38kMwuevlMVDdOAAkWOgLc/1vaFvi2mUKbYyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UdKFWX3S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UdKFWX3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574721F000E9;
	Tue, 25 Aug 2026 01:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622847;
	bh=TaW3WQUb9K9UqKv50+0A2z/cYsIQEWPLLB6jYEldMis=;
	h=Date:To:From:Subject;
	b=UdKFWX3S24bZmADjXCF/wHW97L3HXi7nzirGeVtDL2jhTGGYbswJcOryhTa68yqjH
	 H4Lcbp4aurOwsnYdM4tOb2A+FFiPtSIRy5beKFXTv1e0eBMaI4GZ/c9Qyo2ZQcE3uU
	 y81H17CJMUPSHkd4/PyaAfE3SuvXYFxJ8rbswnCI=
Date: Mon, 24 Aug 2026 18:54:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-show_mem-fix-format-string-inconsistencies-and-type-mismatches.patch removed from -mm tree
Message-Id: <20260825015407.574721F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/show_mem: fix format string inconsistencies and type mismatches
has been removed from the -mm tree.  Its filename was
     mm-show_mem-fix-format-string-inconsistencies-and-type-mismatches.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/show_mem: fix format string inconsistencies and type mismatches
Date: Wed, 5 Aug 2026 10:15:55 +0800

Fix five format string issues in show_free_areas() and __show_mem():

1-2. reserved_highatomic and free_highatomic: %luKB -> %lukB
   The uppercase "KB" is inconsistent with all other fields in the
   same output block and with /proc/meminfo convention.

3. local_pcp: %ukB -> %lukB with explicit (unsigned long) cast
   per_cpu_pages.count is int, so K(count) yields int. Using %u
   was a signed/unsigned mismatch. Cast to unsigned long and use
   %lu for consistency with all other K() usages in the file.

4. total pagecache pages: %ld -> %lu
   global_node_page_state() returns unsigned long. Using %ld is a
   signedness mismatch caught by gcc -Wformat-signedness.

5. hwpoisoned pages: %lu -> %ld
   atomic_long_read() returns long (signed). Using %lu is a
   signedness mismatch caught by gcc -Wformat-signedness.

Verified with: make KCFLAGS="-Wformat -Wformat-signedness" mm/show_mem.o

Link: https://lore.kernel.org/20260805021556.1908807-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/show_mem.c~mm-show_mem-fix-format-string-inconsistencies-and-type-mismatches
+++ a/mm/show_mem.c
@@ -309,8 +309,8 @@ static void show_free_areas(unsigned int
 			" min:%lukB"
 			" low:%lukB"
 			" high:%lukB"
-			" reserved_highatomic:%luKB"
-			" free_highatomic:%luKB"
+			" reserved_highatomic:%lukB"
+			" free_highatomic:%lukB"
 			" active_anon:%lukB"
 			" inactive_anon:%lukB"
 			" active_file:%lukB"
@@ -323,7 +323,7 @@ static void show_free_areas(unsigned int
 			" mlocked:%lukB"
 			" bounce:%lukB"
 			" free_pcp:%lukB"
-			" local_pcp:%ukB"
+			" local_pcp:%lukB"
 			" free_cma:%lukB"
 			"\n",
 			zone->name,
@@ -350,7 +350,7 @@ static void show_free_areas(unsigned int
 			K(zone_page_state(zone, NR_MLOCK)),
 			0UL,
 			K(free_pcp),
-			K(this_cpu_read(zone->per_cpu_pageset->count)),
+			K((unsigned long)this_cpu_read(zone->per_cpu_pageset->count)),
 			K(zone_page_state(zone, NR_FREE_CMA_PAGES)));
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
@@ -400,7 +400,7 @@ static void show_free_areas(unsigned int
 		hugetlb_show_meminfo_node(nid);
 	}
 
-	printk("%ld total pagecache pages\n", global_node_page_state(NR_FILE_PAGES));
+	printk("%lu total pagecache pages\n", global_node_page_state(NR_FILE_PAGES));
 
 	show_swap_cache_info();
 }
@@ -430,7 +430,7 @@ void __show_mem(unsigned int filter, con
 	printk("%lu pages cma reserved\n", totalcma_pages);
 #endif
 #ifdef CONFIG_MEMORY_FAILURE
-	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
+	printk("%ld pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
_

Patches currently in -mm which might be from liuye@kylinos.cn are



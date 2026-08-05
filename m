Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C80437F303
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 18:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785955405; cv=none; b=I7amdy5siGtZ5dAM80TwQUkTOsahlJbI6ECl1m78rDiI/9ib93kM41cWFi/UFrxervtPib6VY28DEC6CSiVzStyD5xb4aQuOh5EMNjmPuj2imVRaBzRuYu9UdLLS26vtQ3OHO6B2lPjhBw014CvVBm6ioIE5s5PMH0mexc+MhC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785955405; c=relaxed/simple;
	bh=U5hB0A/RqM01o0CX6lROnyzkMSqTMWgFjM0bm+NqB4U=;
	h=Date:To:From:Subject:Message-Id; b=P/5LyJU7DEwu0Aa53vEEEXUIwv+JwIWHnImujAEuUsr1lFeoao4XEpju6hVbyGJK3Ik4J4L4gv7pljRQm9HjEYtuGEzjesxMRpIDMhPSHCDRh7cub8uxGh2z5SbJE2F8F9W4EW38lhpbaPp9wis4a+lU72aQwY4ceVKznlELOmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1mDgz0v/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1mDgz0v/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B877C1F000E9;
	Wed,  5 Aug 2026 18:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785955403;
	bh=Fh11uoe+vsTYoWvzy4TwGPgha2ULUNoX/yth6SbE8Dc=;
	h=Date:To:From:Subject;
	b=1mDgz0v/ilfKEiZAuJiOqMWCZM5nE5Ej+8/WE1zsuEju2LrX9XbpnngsczkA2vGFN
	 feZi+5YraiGEbIeNBgF4Lc8M6kXi0tIBrLs1ENDrB83fhi96ri+x8lNW3msig2ajvv
	 yv+YAOVliYrxm4p28UctH+4ezcdg/fExS8vLkUVQ=
Date: Wed, 05 Aug 2026 11:43:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-show_mem-fix-format-string-inconsistencies-and-type-mismatches.patch added to mm-new branch
Message-Id: <20260805184323.B877C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/show_mem: fix format string inconsistencies and type mismatches
has been added to the -mm mm-new branch.  Its filename is
     mm-show_mem-fix-format-string-inconsistencies-and-type-mismatches.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-show_mem-fix-format-string-inconsistencies-and-type-mismatches.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

mm-debug_page_alloc-fix-type-mismatch-for-debug_guardpage_minorder.patch
mm-show_mem-fix-format-string-inconsistencies-and-type-mismatches.patch


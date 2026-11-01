Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565171;
	b=yRpw1gxc14Fnr5N2+hxfV0/6HeLOKbB648Omd3qfEvAs0muivM8K9tjokiLmXqi9iabp
	 fbPDf7i1X3NSD1MF5jfSTDEqOey9ErW/x95hXLCfRWGVTABIkr74dRGUrEGzuR9pIUcVB
	 Ld9AWIJjTNCJk36dmZitls7evBFYDgc0J+1D8kbRhf8j6g0+FYB/XV9xLamMBeUkGtXQp
	 4KfnapMuWqc0YRWzdZITRTDiV/uhVMgejptHixFfJuJ56VDRiqft8QYID70C/5Z8isoqq
	 VEKf/CCk0+S1Gefdrvp6n1BaohYf/YyOUo3fmP5+LW6wYxj+skWdfTSJtyinXoJitig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565171;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qfXahCopr8yiSjlQytILGn0+3UTkEpAV4Dm2C4UGGO4=;
	b=q5sZURcZh5rwhVGmffOO78ILP5J8V2u4NOU6X5GYvomfvEpp5nMNra001W7mW6egRyNB
	 /1LWQ9q4fUMLtQm2IkLdURx4H1h0sNH150wbPMQS2DRqHCsBFvxCEonoxJ8RFMVVpRZt3
	 okHdutKh4MgdlN3dLy70S/i5hbo66jjBud7UUr/Q4OqqrCWhhpSSFtYylMsU7qTBfkjq3
	 p/DtJnyWEtW+1b/XHgYnHG6AEs9jiXnb+19vvdZ55lZOSv62XFX9fshw+ImUaN63XdIWS
	 72YauYAP0sYhEyhY5PO8hkRqdA7+Zj7RZ9NoxHeqpqkoUA2b5vvIqgl4cFsJXmrktfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PmBzXIV+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12518606A324
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 20:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PmBzXIV+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803E51F000C1;
	Sun,  1 Nov 2026 20:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793565170;
	bh=qfXahCopr8yiSjlQytILGn0+3UTkEpAV4Dm2C4UGGO4=;
	h=Date:To:From:Subject;
	b=PmBzXIV+Bqm+w2oERQQAryDIkBi2BR4LXpuc7JD8TgLvPy/p74nPdNax88xDVj9i3
	 KXz2xvjKoRLzJMT9cqkhSyfo0/m7SpI3pNLmJ1iG8srEzASv6oCRif47DKZlvt0FKK
	 /tVtrwmlq1PZXEwbmJq/ErKaPvn7d7c7HgI1fv4A=
Date: Sun, 01 Nov 2026 12:32:50 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,
	ying.huang@linux.alibaba.com,xu.xin@linux.dev,will@kernel.org,
	vbabka@kernel.org,usama.arif@linux.dev,urezki@gmail.com,tj@kernel.org,
	surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,
	shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,
	roman.gushchin@linux.dev,rientjes@google.com,riel@surriel.com,
	rakie.kim@sk.com,qi.zheng@linux.dev,pfalcato@suse.de,peterz@infradead.org,
	peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,nphamcs@gmail.com,
	nico.pache@linux.dev,nao.horiguchi@gmail.com,muchun.song@linux.dev,
	mhocko@kernel.org,matthew.brost@intel.com,ljs@kernel.org,
	linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,
	kasong@tencent.com,kas@kernel.org,joshua.hahnjy@gmail.com,
	jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,hughd@google.com,
	harry@kernel.org,hao.li@linux.dev,hannes@cmpxchg.org,gourry@gourry.net,
	dev.jain@arm.com,dennis@kernel.org,david@fromorbit.com,cl@gentwo.org,
	chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,
	brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,apopple@nvidia.com,aneesh.kumar@kernel.org,
	david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-sort-entries-in-mm-sections.patch added to mm-hotfixes-unstable branch
Message-Id: <20261101203250.803E51F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: sort entries in MM sections
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-sort-entries-in-mm-sections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-sort-entries-in-mm-sections.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: sort entries in MM sections
Date: Fri, 30 Oct 2026 22:34:28 +0100

We try to keep these entries sorted; let's sort the MM related ones.

Link: https://lore.kernel.org/20261030-maintainers-v1-4-97278f8a5f54@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: SJ Park <sj@kernel.org>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Hao Li <hao.li@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Will Deacon <will@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
---

 MAINTAINERS |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/MAINTAINERS~maintainers-sort-entries-in-mm-sections
+++ a/MAINTAINERS
@@ -6827,9 +6827,9 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/memcontrol.h
 F:	include/linux/page_counter.h
-F:	mm/memcontrol.c
 F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
+F:	mm/memcontrol.c
 F:	mm/page_counter.c
 F:	samples/cgroup/*
 F:	tools/testing/selftests/cgroup/memcg_protection.m
@@ -17412,8 +17412,8 @@ F:	Documentation/core-api/memory-hotplug
 F:	drivers/base/memory.c
 F:	include/linux/memory_hotplug.h
 F:	include/linux/memremap.h
-F:	mm/memremap.c
 F:	mm/memory_hotplug.c
+F:	mm/memremap.c
 F:	tools/testing/selftests/memory-hotplug/
 
 MEMORY MANAGEMENT
@@ -17463,6 +17463,7 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	Documentation/admin-guide/sysctl/vm.rst
+F:	fs/proc/meminfo.c
 F:	include/linux/folio_batch.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
@@ -17471,16 +17472,15 @@ F:	include/linux/leafops.h
 F:	include/linux/memory.h
 F:	include/linux/mm.h
 F:	include/linux/mm_*.h
-F:	include/linux/mmzone.h
 F:	include/linux/mmdebug.h
 F:	include/linux/mmu_notifier.h
+F:	include/linux/mmzone.h
 F:	include/linux/pagewalk.h
 F:	include/linux/pgalloc.h
 F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
-F:	fs/proc/meminfo.c
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
@@ -17619,14 +17619,12 @@ F:	Documentation/admin-guide/mm/
 F:	Documentation/core-api/memory-allocation.rst
 F:	Documentation/core-api/mm-api.rst
 F:	Documentation/mm/
-X:	Documentation/admin-guide/mm/damon/
-X:	Documentation/mm/damon/
-F:	mm/char-mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
 F:	include/linux/ioremap.h
 F:	include/linux/page_idle.h
 F:	mm/backing-dev.c
+F:	mm/char-mem.c
 F:	mm/cma.c
 F:	mm/cma_debug.c
 F:	mm/cma_sysfs.c
@@ -17641,6 +17639,8 @@ F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
 F:	tools/lib/mm/
 F:	tools/testing/selftests/mm/
+X:	Documentation/admin-guide/mm/damon/
+X:	Documentation/mm/damon/
 
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -17793,8 +17793,8 @@ F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
 F:	mm/page_io.c
 F:	mm/swap.h
-F:	mm/swap_table.h
 F:	mm/swap_state.c
+F:	mm/swap_table.h
 F:	mm/swapfile.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
@@ -17866,10 +17866,10 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	mm/char-mem.c
-F:	include/trace/events/mmap.h
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
+F:	include/trace/events/mmap.h
+F:	mm/char-mem.c
 F:	mm/mincore.c
 F:	mm/mlock.c
 F:	mm/mmap.c
@@ -29804,9 +29804,9 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/vmalloc.h
+F:	lib/test_vmalloc.c
 F:	mm/vmalloc.c
 F:	mm/vmalloc.h
-F:	lib/test_vmalloc.c
 
 VME SUBSYSTEM
 L:	linux-kernel@vger.kernel.org
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch
mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch
maintainers-mention-for-next-branch-in-memory-management-memory-map.patch
maintainers-tmpfs-shmem-filesystem-updates.patch
maintainers-add-zi-yan-as-co-maintainer-for-memory-management-thp.patch
maintainers-sort-entries-in-mm-sections.patch
maintainers-add-missing-files-to-mm-component-sections.patch
maintainers-rename-and-move-memory-hotunplug.patch
maintainers-route-more-mm-changes-through-mm-coregit.patch


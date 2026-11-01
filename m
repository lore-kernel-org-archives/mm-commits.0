Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565173;
	b=sWFJPcx6TMtAy932l2vXpWlZuR60zfBHY8b3fjdSj3KQbPi7HUElNPQYcaOKCUUzse69
	 IMUImLtyn7IdzcMFKs88mc/0oQYoStWhboaGYY099pBnwyUeDK3p/Psx+VnDlvMb4KOAy
	 GWtzDZbmXV6k1XRTA4WwyhU5JvCjtRxJHsvFIWemL+wt2cEbDxxNnV+U9W0S+ZXo9Z0zm
	 OW0Olk4sBqtA00iwPvaEAR3CMbs9pgGn2hBRtfM5xKjiylS5+6tURYez1KPzg/TrGvIJ0
	 rk6OO90QVbHapIprEhyw3DtdCFOKzWE4W2puudqwckQKiwMe/0tMcF7AI/VlD749kGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565173;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=OPk6ygr0bG1QWuAR1BrOiv5ssrdhTCNSya7o75KiUOs=;
	b=vjovbzX8llMxFrwBxUAxIKo9aYo0OFnxICa8oXgy/v0V83txYiLzq9YyUFEqK/LTyLFW
	 ZZPoBw/yNOTM4eFw4Mc4OLDOeEIcTun4+Iz8bkyk7ZYoGVuDr13MkVfCmN33nL3GH6odH
	 8XaSQ7Irq1NgTeiLc2DhpwU2nji4BYc/QOaUsouXF1zPHGRe6s3VIs1jD5up3TP3My9tw
	 s08D3+7TjzQmPa+XcGLLqOKOinL1iYBhKhn0loIO8jqISr+dPf7xklrIfxuiX095oMnRF
	 hWx/w/usJiYQVpFlcSL2pZMIKPO7x5HqAw3jnFMXSQHg2z5ojHJyfxpQME0DdcuFO2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UrhoObQk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F94606A324
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 20:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UrhoObQk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6B81F000C1;
	Sun,  1 Nov 2026 20:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793565172;
	bh=OPk6ygr0bG1QWuAR1BrOiv5ssrdhTCNSya7o75KiUOs=;
	h=Date:To:From:Subject;
	b=UrhoObQkqwDfWnx1ZLiE1sKY0geXy44xfcWb6OYag6QlWYeRPOM3lneZg+lfX/Jo3
	 DaWD52EnI9Ubv1cukO/Rbe+7SLpVrq2hc4rJml23VGFoLZEkeDc6vzCCezhRWpk90Z
	 0akQJV+0BviRMg7JPQvGYa8KOxNoOGB7GC1GdmFo=
Date: Sun, 01 Nov 2026 12:32:52 -0800
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
Subject: + maintainers-add-missing-files-to-mm-component-sections.patch added to mm-hotfixes-unstable branch
Message-Id: <20261101203252.5F6B81F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: add missing files to MM component sections
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-missing-files-to-mm-component-sections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-missing-files-to-mm-component-sections.patch

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
Subject: MAINTAINERS: add missing files to MM component sections
Date: Fri, 30 Oct 2026 22:34:29 +0100

We want to make sure that MM components cover all relevant MM files. The
generic "MEMORY MANAGEMENT" sections will probably go away at some
point.

We have a bunch of files that are not explicitly tracked under MM
components. Let's add these missing files.

Split up tools/mm to the appropriate components, but still add it also
under MISC, similar to what we did with selftests.

Don't split up selftests for now. They are covered by MISC and some
sections name them separately.

Some files like

 - include/linux/numa.h
 - include/trace/events/kmem.h
 - Documentation/admin-guide/numastat.rst

are a bit fuzzy. Add them to the best fit for now.

Link: https://lore.kernel.org/20261030-maintainers-v1-5-97278f8a5f54@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
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
Cc: Harry Yoo <harry@kernel.org>
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

 MAINTAINERS |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

--- a/MAINTAINERS~maintainers-add-missing-files-to-mm-component-sections
+++ a/MAINTAINERS
@@ -6825,8 +6825,10 @@ R:	Muchun Song <muchun.song@linux.dev>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/admin-guide/cgroup-v1/memory.rst
 F:	include/linux/memcontrol.h
 F:	include/linux/page_counter.h
+F:	include/trace/events/memcg.h
 F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
 F:	mm/memcontrol.c
@@ -12333,6 +12335,7 @@ R:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
+F:	Documentation/admin-guide/cgroup-v1/hugetlb.rst
 F:	Documentation/admin-guide/mm/hugetlbpage.rst
 F:	Documentation/mm/hugetlbfs_reserv.rst
 F:	Documentation/mm/vmemmap_dedup.rst
@@ -12344,6 +12347,7 @@ F:	mm/hugetlb.c
 F:	mm/hugetlb_cgroup.c
 F:	mm/hugetlb_cma.c
 F:	mm/hugetlb_cma.h
+F:	mm/hugetlb_internal.h
 F:	mm/hugetlb_sysctl.c
 F:	mm/hugetlb_sysfs.c
 F:	mm/hugetlb_vmemmap.c
@@ -12363,6 +12367,7 @@ M:	Miaohe Lin <linmiaohe@huawei.com>
 R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-memory-page-offline
 F:	include/linux/memory-failure.h
 F:	include/trace/events/memory-failure.h
 F:	mm/hwpoison-inject.c
@@ -17407,6 +17412,7 @@ M:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
 L:	linux-cxl@vger.kernel.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-devices-memory
 F:	Documentation/admin-guide/mm/memory-hotplug.rst
 F:	Documentation/core-api/memory-hotplug.rst
 F:	drivers/base/memory.c
@@ -17463,10 +17469,13 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	Documentation/admin-guide/sysctl/vm.rst
+F:	Documentation/core-api/gfp_mask-from-fs-io.rst
 F:	fs/proc/meminfo.c
+F:	include/linux/cacheflush.h
 F:	include/linux/folio_batch.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
+F:	include/linux/highmem-internal.h
 F:	include/linux/highmem.h
 F:	include/linux/leafops.h
 F:	include/linux/memory.h
@@ -17476,11 +17485,16 @@ F:	include/linux/mmdebug.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/mmzone.h
 F:	include/linux/pagewalk.h
+F:	include/linux/pfn.h
 F:	include/linux/pgalloc.h
 F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
+F:	include/linux/sched/mm.h
+F:	include/linux/vm_event_item.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
+F:	include/trace/events/mmflags.h
+F:	include/trace/events/pagemap.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
@@ -17499,6 +17513,7 @@ F:	mm/ptdump.c
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
+F:	scripts/gdb/linux/mm.py
 N:	include\/linux\/page[-_][a-zA-Z]*
 
 MEMORY MANAGEMENT - EXECMEM
@@ -17519,6 +17534,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/core-api/pin_user_pages.rst
 F:	mm/gup.c
 F:	mm/gup_test.c
 F:	mm/gup_test.h
@@ -17596,6 +17612,7 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/migrate.h
 F:	include/linux/migrate_mode.h
+F:	include/trace/events/migrate.h
 F:	mm/migrate.c
 F:	mm/migrate_device.c
 
@@ -17619,13 +17636,20 @@ F:	Documentation/admin-guide/mm/
 F:	Documentation/core-api/memory-allocation.rst
 F:	Documentation/core-api/mm-api.rst
 F:	Documentation/mm/
+F:	fs/proc/page.c
+F:	include/linux/backing-dev-defs.h
+F:	include/linux/backing-dev.h
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
 F:	include/linux/ioremap.h
+F:	include/linux/kernel-page-flags.h
 F:	include/linux/page_idle.h
+F:	include/trace/events/cma.h
+F:	include/uapi/linux/kernel-page-flags.h
 F:	mm/backing-dev.c
 F:	mm/char-mem.c
 F:	mm/cma.c
+F:	mm/cma.h
 F:	mm/cma_debug.c
 F:	mm/cma_sysfs.c
 F:	mm/dmapool.c
@@ -17638,7 +17662,9 @@ F:	mm/page_idle.c
 F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
 F:	tools/lib/mm/
+F:	tools/mm/
 F:	tools/testing/selftests/mm/
+X:	Documentation/ABI/testing/sysfs-kernel-mm-damon
 X:	Documentation/admin-guide/mm/damon/
 X:	Documentation/mm/damon/
 
@@ -17648,6 +17674,7 @@ M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
+F:	include/linux/numa.h
 F:	include/linux/numa_memblks.h
 F:	mm/numa.c
 F:	mm/numa_emulation.c
@@ -17668,6 +17695,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
+F:	Documentation/admin-guide/numastat.rst
 F:	include/linux/memory-tiers.h
 F:	include/linux/mempolicy.h
 F:	include/uapi/linux/mempolicy.h
@@ -17699,6 +17727,9 @@ F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
 F:	include/linux/pageblock-flags.h
+F:	include/trace/events/compaction.h
+F:	include/trace/events/page_isolation.h
+F:	include/trace/events/page_ref.h
 F:	mm/compaction.c
 F:	mm/debug_page_alloc.c
 F:	mm/debug_page_ref.c
@@ -17715,6 +17746,9 @@ F:	mm/page_reporting.h
 F:	mm/show_mem.c
 F:	mm/shuffle.c
 F:	mm/shuffle.h
+F:	scripts/gdb/linux/page_owner.py
+F:	tools/mm/page_owner_filter.c
+F:	tools/mm/page_owner_sort.c
 
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -17726,6 +17760,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/trace/events/vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17819,10 +17854,12 @@ F:	Documentation/admin-guide/mm/transhug
 F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h
 F:	include/trace/events/huge_memory.h
+F:	include/trace/events/thp.h
 F:	mm/collapse.h
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
+F:	tools/mm/thpmaps
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
@@ -17866,9 +17903,15 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/core-api/protection-keys.rst
+F:	Documentation/filesystems/mmap_prepare.rst
+F:	Documentation/userspace-api/mseal.rst
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
+F:	include/linux/mman.h
+F:	include/linux/pkeys.h
 F:	include/trace/events/mmap.h
+F:	include/uapi/linux/mman.h
 F:	mm/char-mem.c
 F:	mm/mincore.c
 F:	mm/mlock.c
@@ -18707,6 +18750,7 @@ M:	Peter Zijlstra <peterz@infradead.org>
 L:	linux-arch@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/core-api/cachetlb.rst
 F:	arch/*/include/asm/tlb.h
 F:	include/asm-generic/tlb.h
 F:	include/trace/events/tlb.h
@@ -21807,6 +21851,7 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dennis/percpu.git
 F:	arch/*/include/asm/percpu.h
 F:	include/linux/percpu*.h
+F:	include/trace/events/percpu.h
 F:	lib/percpu*.c
 F:	mm/percpu*.c
 F:	mm/percpu-internal.h
@@ -25521,6 +25566,7 @@ F:	include/linux/shrinker.h
 F:	mm/list_lru.c
 F:	mm/shrinker.c
 F:	mm/shrinker_debug.c
+F:	tools/cgroup/memcg_shrinker.py
 
 SH_VOU V4L2 OUTPUT DRIVER
 L:	linux-media@vger.kernel.org
@@ -25753,10 +25799,12 @@ R:	Roman Gushchin <roman.gushchin@linux.
 L:	linux-mm@kvack.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git
+F:	Documentation/ABI/testing/sysfs-kernel-slab
 F:	Documentation/admin-guide/mm/slab.rst
 F:	Documentation/mm/slab.rst
 F:	include/linux/mempool.h
 F:	include/linux/slab.h
+F:	include/trace/events/kmem.h
 F:	lib/tests/slub_kunit.c
 F:	mm/failslab.c
 F:	mm/mempool.c
@@ -29804,9 +29852,11 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/vmalloc.h
+F:	include/trace/events/vmalloc.h
 F:	lib/test_vmalloc.c
 F:	mm/vmalloc.c
 F:	mm/vmalloc.h
+F:	scripts/gdb/linux/vmalloc.py
 
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


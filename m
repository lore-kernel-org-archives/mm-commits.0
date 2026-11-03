Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672167;
	b=w+lqLM9cn+akGhorJaT5g/H5PuRB++AD7pbJSIQbJK9G2A9ktQw4FDo/049P/s/Rm//A
	 R+1Oedj5kExLbtI1nDuXjFUacEgPC3295EUJFjrCqyQvD4I7tKPa/NAF7yh12HuLfffPw
	 HrJ/1yWx7x0lI5F0SryCXKW3VN0qO9mBZBFFEltaCqLFkidGWDiiHfcNuN29Lclyo2CIN
	 KHMUG4XHL5P7xw1OTs2Q63jL/d+YLV0ASH6/8LOiG/56fK+6wparigm3yLvqNsPIlLs0F
	 29n7eN00HkMiQ85v+Cl9PVzlZDlZzx2W5bdlwEVIk0gb/7XFSikF7uLmV+ICTPJuCCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672167;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YY4kcNvQqByLMKq/5Ki5Rt8jgZ8DBb1yLP0rWcPs0M8=;
	b=cq+5pLX8XfnlVUSwVujze0zujr9aYPi7b8n9ovuevGFz0goS215XDohIIccuKmeA9+FG
	 YGqqBDpry1LzCUWITWjWckt80HvoahkydJ+1H0maI47jVySN+XLiS0rEkKkJwhayObd4C
	 I2XvpbewaVVIqLrWKVLczao80dk58s/6UEhhGA/I0KR4ICsXuRgkZL9Rb5BvkEnmsHQXg
	 UAvWpUhE280I9DHQw76NWL+bdp9MH85mAHZh6HXQVYiTLRebDpnurvR0gdGGSlrVad7Jl
	 mschCeiSB5Goqh5UFoAhfKYy7BfB+FXwJPqIUSHFZNT2xANC8IWQ70vbCEc/QZpv1SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UdgM0N+M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40878606A338
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 02:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UdgM0N+M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6141F000C1;
	Tue,  3 Nov 2026 02:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672167;
	bh=YY4kcNvQqByLMKq/5Ki5Rt8jgZ8DBb1yLP0rWcPs0M8=;
	h=Date:To:From:Subject;
	b=UdgM0N+MaZLl73Qr6uZ+eN5RzUg3DVXGqSOZMxDFeGEa98QUADuwQFBaLzQJjlMuN
	 RukKFGs+rabWi7Okws38IW/p9TirhuazBe+e8eHopyaGBeFGK/vv31w1R97sX+oT/u
	 pKU590yYQVO6oAv9WrghHurLOpUiBPOw4vW84ib0=
Date: Mon, 02 Nov 2026 18:16:06 -0800
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
Subject: [merged mm-hotfixes-stable] maintainers-add-missing-files-to-mm-component-sections.patch removed from -mm tree
Message-Id: <20261103021606.DF6141F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: add missing files to MM component sections
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-files-to-mm-component-sections.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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
@@ -6868,8 +6868,10 @@ R:	Muchun Song <muchun.song@linux.dev>
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
@@ -12376,6 +12378,7 @@ R:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
+F:	Documentation/admin-guide/cgroup-v1/hugetlb.rst
 F:	Documentation/admin-guide/mm/hugetlbpage.rst
 F:	Documentation/mm/hugetlbfs_reserv.rst
 F:	Documentation/mm/vmemmap_dedup.rst
@@ -12387,6 +12390,7 @@ F:	mm/hugetlb.c
 F:	mm/hugetlb_cgroup.c
 F:	mm/hugetlb_cma.c
 F:	mm/hugetlb_cma.h
+F:	mm/hugetlb_internal.h
 F:	mm/hugetlb_sysctl.c
 F:	mm/hugetlb_sysfs.c
 F:	mm/hugetlb_vmemmap.c
@@ -12406,6 +12410,7 @@ M:	Miaohe Lin <linmiaohe@huawei.com>
 R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-memory-page-offline
 F:	include/linux/memory-failure.h
 F:	include/trace/events/memory-failure.h
 F:	mm/hwpoison-inject.c
@@ -17462,6 +17467,7 @@ M:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
 L:	linux-cxl@vger.kernel.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-devices-memory
 F:	Documentation/admin-guide/mm/memory-hotplug.rst
 F:	Documentation/core-api/memory-hotplug.rst
 F:	drivers/base/memory.c
@@ -17518,10 +17524,13 @@ S:	Maintained
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
@@ -17531,11 +17540,16 @@ F:	include/linux/mmdebug.h
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
@@ -17554,6 +17568,7 @@ F:	mm/ptdump.c
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
+F:	scripts/gdb/linux/mm.py
 N:	include\/linux\/page[-_][a-zA-Z]*
 
 MEMORY MANAGEMENT - EXECMEM
@@ -17574,6 +17589,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/core-api/pin_user_pages.rst
 F:	mm/gup.c
 F:	mm/gup_test.c
 F:	mm/gup_test.h
@@ -17651,6 +17667,7 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/migrate.h
 F:	include/linux/migrate_mode.h
+F:	include/trace/events/migrate.h
 F:	mm/migrate.c
 F:	mm/migrate_device.c
 
@@ -17674,13 +17691,20 @@ F:	Documentation/admin-guide/mm/
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
@@ -17693,7 +17717,9 @@ F:	mm/page_idle.c
 F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
 F:	tools/lib/mm/
+F:	tools/mm/
 F:	tools/testing/selftests/mm/
+X:	Documentation/ABI/testing/sysfs-kernel-mm-damon
 X:	Documentation/admin-guide/mm/damon/
 X:	Documentation/mm/damon/
 
@@ -17703,6 +17729,7 @@ M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
+F:	include/linux/numa.h
 F:	include/linux/numa_memblks.h
 F:	mm/numa.c
 F:	mm/numa_emulation.c
@@ -17723,6 +17750,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
+F:	Documentation/admin-guide/numastat.rst
 F:	include/linux/memory-tiers.h
 F:	include/linux/mempolicy.h
 F:	include/uapi/linux/mempolicy.h
@@ -17754,6 +17782,9 @@ F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
 F:	include/linux/pageblock-flags.h
+F:	include/trace/events/compaction.h
+F:	include/trace/events/page_isolation.h
+F:	include/trace/events/page_ref.h
 F:	mm/compaction.c
 F:	mm/debug_page_alloc.c
 F:	mm/debug_page_ref.c
@@ -17770,6 +17801,9 @@ F:	mm/page_reporting.h
 F:	mm/show_mem.c
 F:	mm/shuffle.c
 F:	mm/shuffle.h
+F:	scripts/gdb/linux/page_owner.py
+F:	tools/mm/page_owner_filter.c
+F:	tools/mm/page_owner_sort.c
 
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -17781,6 +17815,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/trace/events/vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17874,10 +17909,12 @@ F:	Documentation/admin-guide/mm/transhug
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
@@ -17921,9 +17958,15 @@ L:	linux-mm@kvack.org
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
@@ -18762,6 +18805,7 @@ M:	Peter Zijlstra <peterz@infradead.org>
 L:	linux-arch@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/core-api/cachetlb.rst
 F:	arch/*/include/asm/tlb.h
 F:	include/asm-generic/tlb.h
 F:	include/trace/events/tlb.h
@@ -21872,6 +21916,7 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dennis/percpu.git
 F:	arch/*/include/asm/percpu.h
 F:	include/linux/percpu*.h
+F:	include/trace/events/percpu.h
 F:	lib/percpu*.c
 F:	mm/percpu*.c
 F:	mm/percpu-internal.h
@@ -25598,6 +25643,7 @@ F:	include/linux/shrinker.h
 F:	mm/list_lru.c
 F:	mm/shrinker.c
 F:	mm/shrinker_debug.c
+F:	tools/cgroup/memcg_shrinker.py
 
 SH_VOU V4L2 OUTPUT DRIVER
 L:	linux-media@vger.kernel.org
@@ -25830,10 +25876,12 @@ R:	Roman Gushchin <roman.gushchin@linux.
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
@@ -29887,9 +29935,11 @@ S:	Maintained
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

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch


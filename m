Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672166;
	b=2TTV5F3KzT99Nds6DTRT7Y12b9lEpktE0SU4H7HC+0gMsvgmghggxqXTmPUF0QMyelJa
	 mmOxEmdAnoW3yalGE6rbmEAQlTGs0uKYzaim2JN/4b5H0jRzaKaWC3Kbadsi4rGqAg3uP
	 qIU9d0+z4vN4c+6dWRhTiXmGKmQSx+RRNovF8ZYTX9WE6uHCrnqZ8QuUqyOPVdtzK7AXy
	 YzZEyeIh05fy2m7zcuI/cpvexVnmVk8+RracKvSilYTPV+CrpbAJ8zMLkXAU4elX2BM3Z
	 MeFpCFIXrO0ptDay4nJNMYlTLB7qN6kKbyRyvKek7hFPmqCqqaDUwiwuN1plleYzkSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672166;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0b55xdLFSaTE5pr16pYnuPhhBqNQ5gr6PasSb66PhE0=;
	b=SbhgT2fDD3xaJvBBxGf2S2Xkh7FLMAPyItXJj/SxrhX1utUL6LbYfBFKvVdjjSgE8B67
	 1e7fdjvfGXWVEW4HuxnxUBOR4zP80afPWUwDQPAsIgDmJ1DP/IfAjA6mEKVdBXL4Ffa2Q
	 13cxcSKrpJs40IqfY4jYvilFtm/8ZgzEDY6lj92h3qCyidsnXmn/rRMTm/RououPmFzW2
	 3V8o3juvRJ8HZ1T+zoonLC5sjCEBvw+1CXsjKCU73wKHx/+4sQ429yEglA43H93NB58eg
	 MLZd/Ln7gEBHEreaRZdt8pNZtS0HAdpdWkGbWvL3vGmMhsUy/2e5q4hvj9V9g2NoL4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GVf9wvx8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1D3606A32E
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 02:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GVf9wvx8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1571F00A1B;
	Tue,  3 Nov 2026 02:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672165;
	bh=0b55xdLFSaTE5pr16pYnuPhhBqNQ5gr6PasSb66PhE0=;
	h=Date:To:From:Subject;
	b=GVf9wvx8cWMHBM0tj3VR2+vT4NzYYhaJoOwd3L8hwZXF+HT1Qq8pmJ7qysF5RQuHN
	 Lo+vkUFqNz4k0PbuAbTopBDEYY53qea03pphedv9ABvxuZMkXWidpcGPlMiydLWJwm
	 TkY9NHKSst6S7eVUiIYk5g6tSrhLEUH/K3HOtYUg=
Date: Mon, 02 Nov 2026 18:16:05 -0800
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
Subject: [merged mm-hotfixes-stable] maintainers-sort-entries-in-mm-sections.patch removed from -mm tree
Message-Id: <20261103021605.BC1571F00A1B@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: sort entries in MM sections
has been removed from the -mm tree.  Its filename was
     maintainers-sort-entries-in-mm-sections.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -6870,9 +6870,9 @@ L:	linux-mm@kvack.org
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
@@ -17467,8 +17467,8 @@ F:	Documentation/core-api/memory-hotplug
 F:	drivers/base/memory.c
 F:	include/linux/memory_hotplug.h
 F:	include/linux/memremap.h
-F:	mm/memremap.c
 F:	mm/memory_hotplug.c
+F:	mm/memremap.c
 F:	tools/testing/selftests/memory-hotplug/
 
 MEMORY MANAGEMENT
@@ -17518,6 +17518,7 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	Documentation/admin-guide/sysctl/vm.rst
+F:	fs/proc/meminfo.c
 F:	include/linux/folio_batch.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
@@ -17526,16 +17527,15 @@ F:	include/linux/leafops.h
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
@@ -17674,14 +17674,12 @@ F:	Documentation/admin-guide/mm/
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
@@ -17696,6 +17694,8 @@ F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
 F:	tools/lib/mm/
 F:	tools/testing/selftests/mm/
+X:	Documentation/admin-guide/mm/damon/
+X:	Documentation/mm/damon/
 
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -17848,8 +17848,8 @@ F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
 F:	mm/page_io.c
 F:	mm/swap.h
-F:	mm/swap_table.h
 F:	mm/swap_state.c
+F:	mm/swap_table.h
 F:	mm/swapfile.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
@@ -17921,10 +17921,10 @@ L:	linux-mm@kvack.org
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
@@ -29887,9 +29887,9 @@ S:	Maintained
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

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672169;
	b=dcDTJf+wBRmFEpS/T6dFtmMi3hVtfKx4AnEU8d3EgLgTxNs+OO0iFfJiIid3+INTTIOM
	 7MQhMq9Ur5m/zKjxRchNeSKOcjQfeWWSOHx8o2OMnsicJB85aLXmnxbQ/xm0yMByqOppO
	 dSGbBGiYfzrOhQSdhkVyMNGLR4mkP4q9lTb0CPJ/JhQameVDTL67firQPuQdI6kddb6Ug
	 mSEz8FQdzYLVcT6tBZjY4NyKulLBp/cRn3z+EHA1m/9Du3ZGYos1UBPJqYa9NoTPI3gn8
	 dVAHvQ/zSIYNTUSg7a7BE3V9HGJw2NYE3ZWp5yeUdVpycEsO5YK5RR7xYU+ekihIg5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672169;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=t6klAO1uGmTPDKW0L9LHH1UiEZcjtnsBRhXXdEZoazE=;
	b=dneot951fZr/K5TtTI07fF12zvQLAwH/XU6jqNz2E2hI4xtamdbMVfBGxvakSdUhxYgj
	 DROBeiAEERINz0OwIa5C8YKH2nvQ41qMDKccUFTFsg6nnJXEmv9PCID7DowaWfndVI6bJ
	 nwrGhRu4vyfxNzg33Dqmq2g3m/1kJfL/g/lIkGT42F2gqMGqgoFWZ/xGTrezlSW/v2gS/
	 sgVFZ3gFcEAaVRmlFez7uTIIBblhKny150xJ0pq1K7+lXA6r3nnWXEZsS0D4T8CHx7t7L
	 x0/A0dNgSWN528jm69Priu9/5zBtuIZXF6WTZ8LrH70Z2JyIfTOezvZ212DL8M0LNUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eks66Z0m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698CE606A32C
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 02:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eks66Z0m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237AE1F000C1;
	Tue,  3 Nov 2026 02:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672169;
	bh=t6klAO1uGmTPDKW0L9LHH1UiEZcjtnsBRhXXdEZoazE=;
	h=Date:To:From:Subject;
	b=eks66Z0mVYDuxt299/XHHMgz7s35DevdPHLcP9FQvAvGAzl5pLqRXEWyVwPG/XXi5
	 4UhcU74Tu1JFohtEtCxMAjJ+vsu7ks2fWoGtMwKMOj/U2G+9HIyc50yepkNBAMWgne
	 4f74d4uKNmA7twnjQFse6aHOjPfj+o9qN3LJobcE=
Date: Mon, 02 Nov 2026 18:16:08 -0800
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
Subject: [merged mm-hotfixes-stable] maintainers-route-more-mm-changes-through-mm-coregit.patch removed from -mm tree
Message-Id: <20261103021609.237AE1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: route more MM changes through mm/core.git
has been removed from the -mm tree.  Its filename was
     maintainers-route-more-mm-changes-through-mm-coregit.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: route more MM changes through mm/core.git
Date: Fri, 30 Oct 2026 22:34:31 +0100

Let's start routing more components I (co)maintain through mm/core.git.
Update the git trees by pointing them at the for-next branch:

 - MEMORY MANAGEMENT - BALLOON
 - MEMORY MANAGEMENT - CORE
 - MEMORY MANAGEMENT - GUP (GET USER PAGES)
 - MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
 - MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
 - MEMORY MANAGEMENT - MIGRATION
 - MEMORY MANAGEMENT - NUMA PLACEMENT
 - MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
 - MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)

Leave out MISC for now.

This change doesn't imply that all changes to these components will
immediately be routed through that tree; in particular changes that cover
other components, or severe conflicts will require coordination with
Andrew's tree.

So this marks merely the start of "mm/core.git will start picking
relevant material for these components".

Remove Andrew from these components to set the expectation that he won't be
the primary person picking stuff for these components; he is listed as
maintainer under the generic "MEMORY MANAGEMENT" and will get CCed on most
changes, and can keep an eye on stuff that falls through the cracks
(thanks!).

While at it, drop the link to http://www.linux-mm.org: it's not
particularly useful in 2026.

Link: https://lore.kernel.org/20261030-maintainers-v1-7-97278f8a5f54@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: SJ Park <sj@kernel.org>
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

 MAINTAINERS |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

--- a/MAINTAINERS~maintainers-route-more-mm-changes-through-mm-coregit
+++ a/MAINTAINERS
@@ -17484,18 +17484,15 @@ F:	mm/alloc_tag.c
 F:	tools/testing/selftests/alloc_tag/
 
 MEMORY MANAGEMENT - BALLOON
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
 L:	virtualization@lists.linux.dev
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	include/linux/balloon.h
 F:	mm/balloon.c
 
 MEMORY MANAGEMENT - CORE
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
@@ -17505,8 +17502,7 @@ R:	Suren Baghdasaryan <surenb@google.com
 R:	Michal Hocko <mhocko@suse.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/admin-guide/sysctl/vm.rst
 F:	Documentation/core-api/gfp_mask-from-fs-io.rst
 F:	fs/proc/meminfo.c
@@ -17564,15 +17560,13 @@ F:	include/linux/execmem.h
 F:	mm/execmem.c
 
 MEMORY MANAGEMENT - GUP (GET USER PAGES)
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	John Hubbard <jhubbard@nvidia.com>
 R:	Peter Xu <peterx@redhat.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/core-api/pin_user_pages.rst
 F:	mm/gup.c
 F:	mm/gup_test.c
@@ -17582,14 +17576,12 @@ F:	tools/testing/selftests/mm/gup.c
 F:	tools/testing/selftests/mm/gup_longterm.c
 
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Xu Xin <xu.xin@linux.dev>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/ABI/testing/sysfs-kernel-mm-ksm
 F:	Documentation/admin-guide/mm/ksm.rst
 F:	Documentation/mm/ksm.rst
@@ -17604,6 +17596,7 @@ M:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
 L:	linux-cxl@vger.kernel.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/ABI/testing/sysfs-devices-memory
 F:	Documentation/admin-guide/mm/memory-hotplug.rst
 F:	Documentation/core-api/memory-hotplug.rst
@@ -17652,7 +17645,6 @@ F:	mm/vmscan.c
 F:	mm/workingset.c
 
 MEMORY MANAGEMENT - MIGRATION
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Matthew Brost <matthew.brost@intel.com>
@@ -17663,8 +17655,7 @@ R:	Ying Huang <ying.huang@linux.alibaba.
 R:	Alistair Popple <apopple@nvidia.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	include/linux/migrate.h
 F:	include/linux/migrate_mode.h
 F:	include/trace/events/migrate.h
@@ -17736,7 +17727,6 @@ F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
 MEMORY MANAGEMENT - NUMA PLACEMENT
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 M:	Gregory Price <gourry@gourry.net>
 R:	Zi Yan <ziy@nvidia.com>
@@ -17745,8 +17735,7 @@ R:	Rakie Kim <rakie.kim@sk.com>
 R:	Ying Huang <ying.huang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
@@ -17820,7 +17809,6 @@ F:	mm/vmscan.c
 F:	mm/workingset.c
 
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Rik van Riel <riel@surriel.com>
@@ -17831,6 +17819,7 @@ R:	Jann Horn <jannh@google.com>
 R:	Lance Yang <lance.yang@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	include/linux/rmap.h
 F:	mm/interval_tree.c
 F:	mm/page_vma_mapped.c
@@ -17888,7 +17877,6 @@ F:	mm/swap_table.h
 F:	mm/swapfile.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 M:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
@@ -17902,8 +17890,7 @@ R:	Usama Arif <usama.arif@linux.dev>
 R:	Kiryl Shutsemau <kas@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
 F:	Documentation/admin-guide/mm/transhuge.rst
 F:	include/linux/huge_mm.h
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch


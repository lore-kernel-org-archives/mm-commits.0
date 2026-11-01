Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565180;
	b=BM8U8KkVoKpjJi3SBy46UO1y1iiWlFHyJZqpGGWt5IYUgwCT26wqrU9sO0v25f/amgUO
	 1a+dCwjvEm8QnO6eGbgrTjN3MVJz5AZd4Ym5/tifMJnt34C/DhO4IeKoA4tap/UseMrFk
	 bKHZRsAlD03P+S6vy4Ywb/OVIyHHmES6Wfd4z1kHRiQZfXC14ZNFZb/uMd3fi3URl3GVi
	 1UqK3MUdp27F2UswZvHQ4u0fD47niKq3TH//JWTpIonxv9GU4imrrw5IxQAFHZe9ZxGkL
	 wk532QrgMQ6ejP4nzOTtyShtwFvNxClcLlh8Xdk7tR20X9Tzv3j87p8TYw3F2Cg/i/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565180;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qYCxN3alJvzZXoeZ9EQG0Xkw4r2rpJBWe6wce0KVoBA=;
	b=crdtPwR0M8CLL432qLzI/KfWWlRGeAi/5w6M0Dx+NnjPrTVk3M3wP+1ot3mMp0IJBiak
	 CusckozMM2yj5JJxTB7VMSc+/BQOklNHQdR8KYANZSnAeYfZxjLvZ/mtQpoK08dzjBtLF
	 rzoN9XZAg2TpgSo1ACPZpTLCq/G0D3hnUov0g63JgZOMXVNbiEOi0UbGf8SFsqGcQanpL
	 BuTX/W0x7Omri56zAf1EmeoiEPV2WHVyACR1LNBZFhTDZc6nsK31KBis6k8V7h9lgPyo9
	 2nT6poW5L4LS9u8Jftx/Wzr0nqgGMTM9Cay8Y7ZtWf4F8zS1ICpzBriJ7Vjp+KpCDvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aiWePqHy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B85606A327
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 20:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aiWePqHy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149DF1F000C1;
	Sun,  1 Nov 2026 20:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793565178;
	bh=qYCxN3alJvzZXoeZ9EQG0Xkw4r2rpJBWe6wce0KVoBA=;
	h=Date:To:From:Subject;
	b=aiWePqHy4uKIKZhVfa5sj5tmKCuknJdlBminSGVpQN2iTbRTQbyv4gxsLog3IMLz/
	 OWT2iV8AehZm06J76iB7EoMbedGg9BI8+pk7EPWi6DJ+aCeJnRuc1Qhb31M+tLjyDn
	 BPmXovICdyHcILrrvZ13WRROdNB7/5pDcn23fot0=
Date: Sun, 01 Nov 2026 12:32:57 -0800
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
	dev.jain@arm.com,dennis@kernel.org,david@kernel.org,david@fromorbit.com,
	cl@gentwo.org,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,
	brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,apopple@nvidia.com,aneesh.kumar@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-use-a-common-prefix-for-mm-components.patch added to mm-hotfixes-unstable branch
Message-Id: <20261101203258.149DF1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: use a common prefix for MM components
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-use-a-common-prefix-for-mm-components.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-use-a-common-prefix-for-mm-components.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: use a common prefix for MM components
Date: Sun, 01 Nov 2026 12:13:07 -0800

Several MM component entries still use standalone headings, so searching
for headings beginning with "MEMORY MANAGEMENT" misses them.

Give these 18 entries the common "MEMORY MANAGEMENT - " prefix.  Leave
them in place for now so that the renames can be reviewed separately
from the subsequent alphabetical sorting.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SJ Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 MAINTAINERS |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/MAINTAINERS~maintainers-use-a-common-prefix-for-mm-components
+++ a/MAINTAINERS
@@ -6816,7 +6816,7 @@ T:	git https://gitlab.freedesktop.org/dr
 F:	include/linux/cgroup_dmem.h
 F:	kernel/cgroup/dmem.c
 
-CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
+MEMORY MANAGEMENT - MEMORY RESOURCE CONTROLLER (MEMCG)
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Michal Hocko <mhocko@kernel.org>
 M:	Roman Gushchin <roman.gushchin@linux.dev>
@@ -7322,7 +7322,7 @@ S:	Maintained
 W:	https://docs.dasharo.com/
 F:	drivers/platform/x86/dasharo-acpi.c
 
-DAMON
+MEMORY MANAGEMENT - DAMON
 M:	SJ Park <sj@kernel.org>
 L:	damon@lists.linux.dev
 L:	linux-mm@kvack.org
@@ -12164,7 +12164,7 @@ S:	Maintained
 F:	Documentation/ABI/testing/debugfs-hisi-zip
 F:	drivers/crypto/hisilicon/zip/
 
-HMM - Heterogeneous Memory Management
+MEMORY MANAGEMENT - HMM (Heterogeneous Memory Management)
 M:	Jason Gunthorpe <jgg@nvidia.com>
 M:	Leon Romanovsky <leonro@nvidia.com>
 L:	linux-mm@kvack.org
@@ -12328,7 +12328,7 @@ F:	drivers/power/supply/huawei-gaokun-ba
 F:	drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
 F:	include/linux/platform_data/huawei-gaokun-ec.h
 
-HUGETLB SUBSYSTEM
+MEMORY MANAGEMENT - HUGETLB
 M:	Muchun Song <muchun.song@linux.dev>
 M:	Oscar Salvador <osalvador@suse.de>
 R:	David Hildenbrand <david@kernel.org>
@@ -12362,7 +12362,7 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media.git
 F:	drivers/media/platform/st/sti/hva
 
-HWPOISON MEMORY FAILURE HANDLING
+MEMORY MANAGEMENT - HWPOISON MEMORY FAILURE HANDLING
 M:	Miaohe Lin <linmiaohe@huawei.com>
 R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
 L:	linux-mm@kvack.org
@@ -17370,7 +17370,7 @@ F:	arch/*/include/asm/sync_core.h
 F:	include/uapi/linux/membarrier.h
 F:	kernel/sched/membarrier.c
 
-MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
+MEMORY MANAGEMENT - MEMBLOCK AND INITIALIZATION
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -17879,7 +17879,7 @@ F:	rust/kernel/mm.rs
 F:	rust/kernel/mm/
 F:	rust/kernel/page.rs
 
-MEMORY MAPPING
+MEMORY MANAGEMENT - MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
@@ -17916,7 +17916,7 @@ F:	mm/vma_internal.h
 F:	tools/testing/selftests/mm/merge.c
 F:	tools/testing/vma/
 
-MEMORY MAPPING - LOCKING
+MEMORY MANAGEMENT - MEMORY MAPPING - LOCKING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Liam R. Howlett <liam@infradead.org>
@@ -17932,7 +17932,7 @@ F:	include/linux/mmap_lock.h
 F:	include/trace/events/mmap_lock.h
 F:	mm/mmap_lock.c
 
-MEMORY MAPPING - MADVISE (MEMORY ADVICE)
+MEMORY MANAGEMENT - MEMORY MAPPING - MADVISE (MEMORY ADVICE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
@@ -18728,7 +18728,7 @@ S:	Maintained
 F:	drivers/phy/marvell/phy-mmp3-usb.c
 F:	drivers/phy/marvell/phy-pxa-usb.c
 
-MMU GATHER AND TLB INVALIDATION
+MEMORY MANAGEMENT - MMU GATHER AND TLB INVALIDATION
 M:	Will Deacon <will@kernel.org>
 M:	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -21113,7 +21113,7 @@ F:	Documentation/core-api/padata.rst
 F:	include/linux/padata.h
 F:	kernel/padata.c
 
-PAGE CACHE
+MEMORY MANAGEMENT - PAGE CACHE
 M:	Matthew Wilcox (Oracle) <willy@infradead.org>
 M:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
@@ -21142,7 +21142,7 @@ F:	include/net/page_pool/
 F:	include/trace/events/page_pool.h
 F:	net/core/page_pool.c
 
-PAGE TABLE CHECK
+MEMORY MANAGEMENT - PAGE TABLE CHECK
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
 L:	linux-mm@kvack.org
@@ -21829,7 +21829,7 @@ S:	Maintained
 F:	Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
 F:	drivers/net/ethernet/pensando/
 
-PER-CPU MEMORY ALLOCATOR
+MEMORY MANAGEMENT - PER-CPU MEMORY ALLOCATOR
 M:	Dennis Zhou <dennis@kernel.org>
 M:	Tejun Heo <tj@kernel.org>
 M:	Christoph Lameter <cl@gentwo.org>
@@ -25539,7 +25539,7 @@ T:	git git://linuxtv.org/media.git
 F:	drivers/media/i2c/rj54n1cb0c.c
 F:	include/media/i2c/rj54n1cb0c.h
 
-SHRINKER
+MEMORY MANAGEMENT - SHRINKER
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Dave Chinner <david@fromorbit.com>
 R:	Qi Zheng <qi.zheng@linux.dev>
@@ -25775,7 +25775,7 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
 F:	drivers/nvmem/layouts/sl28vpd.c
 
-SLAB ALLOCATOR
+MEMORY MANAGEMENT - SLAB ALLOCATOR
 M:	Vlastimil Babka <vbabka@kernel.org>
 M:	Harry Yoo <harry@kernel.org>
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -29831,7 +29831,7 @@ F:	net/vmw_vsock/
 F:	tools/testing/selftests/vsock/
 F:	tools/testing/vsock/
 
-VMALLOC
+MEMORY MANAGEMENT - VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Uladzislau Rezki <urezki@gmail.com>
 L:	linux-mm@kvack.org
@@ -30864,7 +30864,7 @@ M:	"Maciej W. Rozycki" <macro@orcam.me.u
 S:	Maintained
 F:	drivers/tty/serial/zs.*
 
-ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
+MEMORY MANAGEMENT - ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
 M:	Minchan Kim <minchan@kernel.org>
 M:	Sergey Senozhatsky <senozhatsky@chromium.org>
 L:	linux-mm@kvack.org
@@ -30887,7 +30887,7 @@ F:	lib/zstd/
 N:	zstd
 K:	zstd
 
-ZSWAP COMPRESSED SWAP CACHING
+MEMORY MANAGEMENT - ZSWAP COMPRESSED SWAP CACHING
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Yosry Ahmed <yosry@kernel.org>
 M:	Nhat Pham <nphamcs@gmail.com>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

openrisc-export-mulsi3.patch
mm-mempolicy-use-one-node-set-for-interleave-weights.patch
maintainers-use-a-common-prefix-for-mm-components.patch
maintainers-sort-component-entries-alphabetically.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
maintainers-add-ipc-maintainers.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


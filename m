Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565165;
	b=h8PzmXCIiIcijEykC6SzsonUaoeSXD+mtyIcD+E1ZDZYeDMlNjeuEQwX2B18CaziVJIc
	 KUCgEy3X5IhTENapjkNgQCGwOYe2LNJv1XERRVtEqnL5HnCr4jqFxOZdDKmF3JDHrOue/
	 1ms06v3AjAAqeGuOOqw/i13HNUKFR+ImA2mQUwjgI77CAGnnx3/1qC8/9AeOSTrMXwVSy
	 HWB8qx4NdAyDazYwGMYxKvtcXIw+aJmY/ARhY4lQddwNGgz3R5stFB2zql6l0z6owJ1w4
	 mNYiJvh6Q0unvcYCzA03XS3f6bEjTanRSdvYxc9s/KaF7AXKHfyK922Wkzt1TwzTxAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565165;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=TpVE325nuSZoMYDBy0UMn/Vun2NfhnUrYZDj4bql8fc=;
	b=aCG7hZc7WSYHixdqLq4AIL2VbgD3ggo+GbOkdMMF8oS0bEHWxnXkwtO/yuUojqO8gT9C
	 MfUgdDOf6t0uIfgAVpIXX28ibf7xZNTTV/d0abiz+dT6c96w4OAqKSLWxWtNGwFbmtjZP
	 7BFx6DS5kAzNtl9DUmOPSoXCfXuGNrogij+WdR3NZOAuxGIYV5jopkhc2E1YEUlSDahf4
	 93VdeodZIaxT5o4e0rZfzbxDFutr+fXNyGt5vn2UzgK/zrJbXq8G9G1qkK0WYogLTlUrf
	 tIstowgI16OaoOJurQRiSzbTHZjt3j3peYzCNgQFawO+JLeHPsvcQRPi3QxkSBTKt2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=h2naOhpG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A81606A324
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 20:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=h2naOhpG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43851F000C1;
	Sun,  1 Nov 2026 20:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793565165;
	bh=TpVE325nuSZoMYDBy0UMn/Vun2NfhnUrYZDj4bql8fc=;
	h=Date:To:From:Subject;
	b=h2naOhpGfaaAMZJPEUfJToU2KFo7joFjPdr1NfxKY++bQM+giOthJMRkUOMt9AvRe
	 sx3syw/p6PEitLvIC6K0BR9rs+iFGmxC4AVo5XPLWdppF/C5V0BwepqHar3Zqi5M8w
	 gwFPcIOcghC+MEl6e/yzV8g6LSN229azARgASXfg=
Date: Sun, 01 Nov 2026 12:32:44 -0800
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
Subject: + maintainers-mention-for-next-branch-in-memory-management-memory-map.patch added to mm-hotfixes-unstable branch
Message-Id: <20261101203244.E43851F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: mention for-next branch in MEMORY MANAGEMENT - MEMORY MAP
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mention-for-next-branch-in-memory-management-memory-map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mention-for-next-branch-in-memory-management-memory-map.patch

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
Subject: MAINTAINERS: mention for-next branch in MEMORY MANAGEMENT - MEMORY MAP
Date: Fri, 30 Oct 2026 22:34:25 +0100

Patch series "MAINTAINERS: MM updates".

Several MM updates:

Make Zi Yan a THP maintainer (thanks for all your hard work over
the years and thanks for taking on this responsibility), and perform some
MM MAINTAINERS cleanups.

Then, start the next step of the transition from Andrew's MM tree to
separate component trees that all get integrated into the mm-next
integration tree.

Start routing shmem through mm/core.git, adding me as a maintainer
primarily to pick patches.

Then, target the following components for the mm/core.git tree that I
(co)maintain:

     - MEMORY MANAGEMENT - BALLOON
     - MEMORY MANAGEMENT - CORE
     - MEMORY MANAGEMENT - GUP (GET USER PAGES)
     - MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
     - MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
     - MEMORY MANAGEMENT - MIGRATION
     - MEMORY MANAGEMENT - NUMA PLACEMENT
     - MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
     - MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)

More details in the last patch.

In the upcoming cycles we'll then route more of the other MM components
through different trees.

Let's see how this goes, in particular with the continuous stream of
fixes. But getting these in in a controlled way has highest priority
right now wither way.


This patch (of 7):

"memmap" will be used as a prefix for branches, but not as a branch
itself. "for-next" is the integration for all these things against which
people should ideally send patches.

Not mentioning a branch makes them assume "master", which is wrong.

So just mention the right thing, which is "for-next"

Link: https://lore.kernel.org/20261030-maintainers-v1-0-97278f8a5f54@kernel.org
Link: https://lore.kernel.org/20261030-maintainers-v1-1-97278f8a5f54@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Harry Yoo (Meta) <harry@kernel.org>
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

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-mention-for-next-branch-in-memory-management-memory-map
+++ a/MAINTAINERS
@@ -17549,7 +17549,7 @@ M:	Mike Rapoport <rppt@kernel.org>
 M:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git memmap
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/mm/memory-model.rst
 F:	arch/*/include/asm/sparsemem.h
 F:	include/asm-generic/memory_model.h
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


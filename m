Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFBD336EC0
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622289; cv=none; b=Rf3hKJWtzMDhDOilJl2sg4aP/mUoOljwSL7myZjkaluas+6Ic664zkwJeEMmMTaEvMhrzHdbYMYSfXkyH9iouU9XBpaRNEygi7T2lLpoQpeBUKy5yIjqXrHvoqGY0gcGsk5B75hQTuRZDeio77rXW2Xkljvis+85SxKvtQyYd54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622289; c=relaxed/simple;
	bh=6QrP4MwMiQ8/ZPRaUe9R22KPrgY78LOQmvUcOkOvlIU=;
	h=Date:To:From:Subject:Message-Id; b=FkjZRS47j/vYqqWkO/F7bQIGgbvvA3hq6vu21Odl3XlZ07JNb2fT4c13g1R35X2SNYx24tVrozXq+RN9hzX3A6NdZ6pywZ7wlDHV/UpPcTNGoUp0t3YTZVubQdqS7ILZ6h+lyJ8Y0bfzIQzw6V8NUyRe7FEyP18wUc8qKtfetoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dmJ1dl1b reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dmJ1dl1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41491F000E9;
	Tue, 25 Aug 2026 01:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622287;
	bh=J8kBPvi647n/HfYIwO+PH4gaPqAKftkRqJslCBdSkIg=;
	h=Date:To:From:Subject;
	b=dmJ1dl1bH2GYPPSsXiLo99Ux8qvn1S3aE3SlJt5PYhHTWzAch5LRbjmDW33pHlfwA
	 MhWNFWk4C9Kn2/fPIi9KvIu3ajge95M+mwqj9hp3j9VwAgybSoMoAtVBzqQAmCqQ7w
	 fcyDHUQjBJ1aVpKSOxavfm1vymr0FoPqMYw9IIqg=
Date: Mon, 24 Aug 2026 18:44:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,vbabka@kernel.org,tzimmermann@suse.de,thomas.hellstrom@linux.intel.com,svens@linux.ibm.com,surenb@google.com,steven.price@arm.com,shikemeng@huaweicloud.com,ryan.roberts@arm.com,rppt@kernel.org,rodrigo.vivi@intel.com,riel@surriel.com,Ray.Huang@amd.com,rakie.kim@sk.com,pfalcato@suse.de,peterz@infradead.org,peterx@redhat.com,osalvador@suse.de,oleg@redhat.com,nphamcs@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,namhyung@kernel.org,muchun.song@linux.dev,mripard@kernel.org,mingo@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,matthew.auld@intel.com,mark.rutland@arm.com,maarten.lankhorst@linux.intel.com,liviu.dudau@arm.com,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kees@kernel.org,kasong@tencent.com,joshua.hahnjy@gmail.com,jolsa@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,james.clark@linaro.org,jack@suse.cz,iroger
 s@google.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,harry@kernel.org,gregkh@linuxfoundation.org,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,dev.jain@arm.com,david@kernel.org,christian.koenig@amd.com,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,borntraeger@linux.ibm.com,boris.brezillon@collabora.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,apopple@nvidia.com,alexander.shishkin@linux.intel.com,alexander.deucher@amd.com,airlied@gmail.com,agordeev@linux.ibm.com,adrian.hunter@intel.com,acme@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch removed from -mm tree
Message-Id: <20260825014446.F41491F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: track whether the page VMA mapped pgoff is anonymous
has been removed from the -mm tree.  Its filename was
     mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/rmap: track whether the page VMA mapped pgoff is anonymous
Date: Thu, 13 Aug 2026 18:32:27 +0100

Update the page_vma_mapped_walk structure to track whether the pgoff being
tracked is an anonymous pgoff or not and update the comments to reflect
this.

This is necessary in order to determine the correct VMA page offset in
vma_address_end() when pvmw->nr_pages > 1.

Also document that pvmw->pgoff is meaningless for pvmw->nr_pages == 1 and
for KSM.

Do not set this field where pgoff is not specified.

This is laying the groundwork for eventually using anonymous page offsets
as the index for all anonymous folios.

No functional change intended.

Link: https://lore.kernel.org/20260813-b4-scalable-cow-virt-pgoff-v5-10-c21581c0c3c8@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Deucher <alexander.deucher@amd.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christan König <christian.koenig@amd.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price (Meta) <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ray <Ray.Huang@amd.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 +++-
 mm/rmap.c            |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/rmap.h~mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous
+++ a/include/linux/rmap.h
@@ -864,13 +864,14 @@ struct page *make_device_exclusive(struc
 struct page_vma_mapped_walk {
 	unsigned long pfn;
 	unsigned long nr_pages;
-	pgoff_t pgoff;
+	pgoff_t pgoff;	/* Only meaningful if nr_pages > 1 and not a KSM walk */
 	struct vm_area_struct *vma;
 	unsigned long address;
 	pmd_t *pmd;
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned int flags;
+	bool pgoff_is_anon : 1;
 };
 
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
@@ -881,6 +882,7 @@ struct page_vma_mapped_walk {
 		.vma = _vma,						\
 		.address = _address,					\
 		.flags = _flags,					\
+		.pgoff_is_anon = folio_test_anon(_folio),		\
 	}
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
--- a/mm/rmap.c~mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous
+++ a/mm/rmap.c
@@ -1240,6 +1240,7 @@ static bool mapping_wrprotect_range_one(
 		.vma		= vma,
 		.address	= address,
 		.flags		= PVMW_SYNC,
+		.pgoff_is_anon	= false,
 	};
 
 	state->cleaned += page_vma_mkclean_one(&pvmw);
@@ -1317,6 +1318,7 @@ int pfn_mkclean_range(unsigned long pfn,
 		.pgoff		= pgoff,
 		.vma		= vma,
 		.flags		= PVMW_SYNC,
+		.pgoff_is_anon	= false,
 	};
 
 	if (invalid_mkclean_vma(vma, NULL))
_

Patches currently in -mm which might be from ljs@kernel.org are



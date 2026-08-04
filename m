Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF74934214A
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 17:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785866036; cv=none; b=hiyHTOKwywSu9MbrwdUUCroX3DF/MNhe1P2TlpE3n1SkRUpjVB5Kxr11oQ7U86pCcuu2zwotacIkerStX74nRg5wfDYkPatN+g5VE2MUn5wBNLEh5/tJOSVdpkkacsOPzwLDKO1fY0GLT2JQ3z3N6FDlKr+eUbGpJi0qlyWgxt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785866036; c=relaxed/simple;
	bh=pAC86kpWCbjjDvV0J76eyJT1NqA4a3iCyagHX4geSG8=;
	h=Date:To:From:Subject:Message-Id; b=dXEW6W18I4mjxhPoRuafo+7fEYLMRxhlnP66uimlZ+Iq/LECs553/Be3zyD7DfO6yI2Pb6PncXDWm7NCjdyVk5j/HxeZACJ3jN1JSWgEbbwuE83SBqMg1Kd19DvBIaJCcm083sKNBbTW0CCeIN/8/x4zjQajgsEYummKMQ+whQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nxfq6NMV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nxfq6NMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908351F000E9;
	Tue,  4 Aug 2026 17:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785866034;
	bh=pw6iNUKSuKVhVwU27QMn1ei7Ybv4fB4qJcH65YdbevQ=;
	h=Date:To:From:Subject;
	b=Nxfq6NMVCWZ0jbhfHQHTGy5RFmlinplXHFCW4IbY6Vl+kEHq+06WMiYjbjd7KIem7
	 XPSHwK88mJSOcHW+enfxFRrTgJwMz8Amt5WziEwcoiVm5ADiSNWsVrndQk+a02FEA+
	 Wp42gr8n1IzXOKv/Le/oSbVS4sm/4MOfMezQPPRI=
Date: Tue, 04 Aug 2026 10:53:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-remove-pgdat_page_ext_init.patch added to mm-new branch
Message-Id: <20260804175354.908351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_ext: remove pgdat_page_ext_init()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_ext-remove-pgdat_page_ext_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-remove-pgdat_page_ext_init.patch

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/page_ext: remove pgdat_page_ext_init()
Date: Wed, 5 Aug 2026 00:11:42 +0900

pgdat_page_ext_init() sets pgdat->node_page_ext to NULL only on FLATMEM. 
FLATMEM depends on !NUMA, so the pgdat is always the zero-initialized
contig_page_data and the store has no effect.

So remove the call site, the unused function and its declaration.

No functional change.

Link: https://lore.kernel.org/20260804151145.3419768-3-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    5 -----
 mm/mm_init.c             |    1 -
 mm/page_ext.c            |    9 ---------
 3 files changed, 15 deletions(-)

--- a/include/linux/page_ext.h~mm-page_ext-remove-pgdat_page_ext_init
+++ a/include/linux/page_ext.h
@@ -55,7 +55,6 @@ struct page_ext {
 
 extern bool early_page_ext;
 extern unsigned long page_ext_size;
-extern void pgdat_page_ext_init(struct pglist_data *pgdat);
 
 static inline bool early_page_ext_enabled(void)
 {
@@ -202,10 +201,6 @@ static inline bool early_page_ext_enable
 	return false;
 }
 
-static inline void pgdat_page_ext_init(struct pglist_data *pgdat)
-{
-}
-
 static inline void page_ext_init(void)
 {
 }
--- a/mm/mm_init.c~mm-page_ext-remove-pgdat_page_ext_init
+++ a/mm/mm_init.c
@@ -1394,7 +1394,6 @@ static void __meminit pgdat_init_interna
 	for (i = 0; i < NR_VMSCAN_THROTTLE; i++)
 		init_waitqueue_head(&pgdat->reclaim_wait[i]);
 
-	pgdat_page_ext_init(pgdat);
 	lruvec_init(&pgdat->__lruvec);
 }
 
--- a/mm/page_ext.c~mm-page_ext-remove-pgdat_page_ext_init
+++ a/mm/page_ext.c
@@ -164,11 +164,6 @@ void __init page_ext_init_flatmem_late(v
 	invoke_init_callbacks();
 }
 
-void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
-{
-	pgdat->node_page_ext = NULL;
-}
-
 static struct page_ext *lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
@@ -494,10 +489,6 @@ oom:
 	panic("Out of memory");
 }
 
-void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
-{
-}
-
 #endif
 
 /**
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-early_ioremap-clarify-early_ioremap_reset-semantics.patch
riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap.patch
arm64-remove-early_ioremap_reset-call-and-__late_-macros.patch
mm-sparse-correct-init-section-annotations.patch
mm-kconfig-make-flatmem-depend-on-numa.patch
mm-page_ext-remove-pgdat_page_ext_init.patch


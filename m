Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B8BF9DD
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755883; cv=none; b=afPAlFEWDu0xEl+XwiCpa1fo4UqXibkgrtwK+beLFJm6TT90ie1g11wgPWCQspLeVl5QQpwQkYbXv/7vJvdLzJWVsUyTxKSJJxMR8ZAcmdLmF2YuX3NXJ+XuaeTcm+WaqKrExBlfBjsMCMW1wTpfHagXzAmDut2xDNpZLmuxm/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755883; c=relaxed/simple;
	bh=WvJIIGmxaFFy210Xk1xmqO3YjmO4IkfkvuwtdguEAXI=;
	h=Date:To:From:Subject:Message-Id; b=PfvDHuEympbAntFl8uedtqoQ+YxeutIfE97QDvneb/eF5WpTgyjfEa4i5i0q67NjQXt/gzf5f+OGo3dAtGEtqkkvwb1IuvMHNUfXKhmihmAHRxevc1Av1FAMikAQopB1Cbe9jcCIx1XFDWEaFueSgmhcmD8/OEZeLbIBFaUJ9SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LQOPqF/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LQOPqF/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9267C4CECC;
	Thu, 28 Nov 2024 01:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755882;
	bh=WvJIIGmxaFFy210Xk1xmqO3YjmO4IkfkvuwtdguEAXI=;
	h=Date:To:From:Subject:From;
	b=LQOPqF/cdDu+d6zlwTpuXdlhBimCUGqjeB34qEdp+6xTJJkVvGF2Uu8iWVU+l1Imn
	 SuaWeSIjWRh0oQPTTPJqDijO08vnbaFyToiBTEJX0SnVRAhHOMDxl0ed2b/mI6aajN
	 n0Ez04fY+7XF15EQj4RDAmoKl5JfqgoQAXDsUumc=
Date: Wed, 27 Nov 2024 17:04:42 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch added to mm-unstable branch
Message-Id: <20241128010442.B9267C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_direct_compact()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_direct_compact()
Date: Mon, 25 Nov 2024 21:01:41 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in __alloc_pages_direct_compact().

Link: https://lkml.kernel.org/r/20241125210149.2976098-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsinguularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact
+++ a/mm/page_alloc.c
@@ -3704,7 +3704,6 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	if (page) {
 		struct zone *zone = page_zone(page);
 
-		set_page_refcounted(page);
 		zone->compact_blockskip_flush = false;
 		compaction_defer_reset(zone, order, true);
 		count_vm_event(COMPACTSUCCESS);
@@ -4306,8 +4305,10 @@ restart:
 						alloc_flags, ac,
 						INIT_COMPACT_PRIORITY,
 						&compact_result);
-		if (page)
+		if (page) {
+			set_page_refcounted(page);
 			goto got_pg;
+		}
 
 		/*
 		 * Checks for costly allocations with __GFP_NORETRY, which
@@ -4389,8 +4390,10 @@ retry:
 	/* Try direct compaction and then allocating */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
 					compact_priority, &compact_result);
-	if (page)
+	if (page) {
+		set_page_refcounted(page);
 		goto got_pg;
+	}
 
 	/* Do not loop if specifically requested */
 	if (gfp_mask & __GFP_NORETRY)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch


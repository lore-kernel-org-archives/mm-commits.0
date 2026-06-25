Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8D95B5AB;
	Thu, 25 Jun 2026 00:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782348900; cv=none; b=H8ROTJL7RXdOYY3hD+gB6TRhn0dpi4B1bcgGKIV14iOpUDkA6XWIXAgc8Fz6fvahB/jnAuW4bM1D0tldgJ/NS2CERqEfrwmHwi1Omf66woSvlGbJSz0E+yntmHoLpzWHKxsLq3Z6gvo5JQF+2JL6OJzYQctssdYkW46EGuaHxBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782348900; c=relaxed/simple;
	bh=E1QMaLPuXJSmKrpKJ2S/oQ2jD77yOLsebWrvZbksCLQ=;
	h=Date:To:From:Subject:Message-Id; b=iNZONzT7lxYEv0OBwu6emgIKy4CCZV2r7aKPDDy9BOsyopDOF7Fw/ZksJg+RYJSWeH4qEkQGgq0Es2Qx1xj5jdX57hV8GmEOBmF8t88deenjkLaO7g4lyO3POOlWRRDg/m00Fy3FREEz9RmpkW0bQk1nK6wtTiPoCd7NL1Ullf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vTIQaQRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vTIQaQRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F75F1F000E9;
	Thu, 25 Jun 2026 00:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782348898;
	bh=rPJlVCmVLEVN7l0Dkkg76TNEEyp3cE7p52OjSBpRNJs=;
	h=Date:To:From:Subject;
	b=vTIQaQRZrmpZ012qLOlpnG2/oJ+5HT++vLF4ZQkZNPDFLss9HRalgrPnxkYoYo7oL
	 TMT0bon7huwYOPa59Z6MEDR/zreUS+Ct/iuYfUjBLEsoXc0+37FCfBOvJUioD0r+Fh
	 hP0wTqwY76J7Uha/A6vbzaLh2ZQxrEmvvogdHoFY=
Date: Wed, 24 Jun 2026 17:54:58 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,kas@kernel.org,david@kernel.org,mclapinski@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-init-tails-before-init_migratetype.patch added to mm-hotfixes-unstable branch
Message-Id: <20260625005458.9F75F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: init tails before init_migratetype
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-init-tails-before-init_migratetype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-init-tails-before-init_migratetype.patch

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
From: Michal Clapinski <mclapinski@google.com>
Subject: mm/hugetlb: init tails before init_migratetype
Date: Mon, 22 Jun 2026 12:19:01 +0200

Currently, if you enable HVO, DEFERRED_STRUCT_PAGE_INIT and VM_DEBUG the
kernel will crash with the following stack trace

get_pfnblock_bitmap_bitidx
__set_pfnblock_flags_mask
hugetlb_bootmem_init_migratetype
prep_and_add_bootmem_folios
gather_bootmem_prealloc_node
gather_bootmem_prealloc_parallel
padata_do_multithreaded
gather_bootmem_prealloc
hugetlb_init

on this code

VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

This code looks inside the struct page which will be uninitialized
for hugetlb tail pages, which will cause a false positive.

So let's initialize the tail pages before this happens.

Link: https://lore.kernel.org/20260622101901.223961-1-mclapinski@google.com
Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Clapinski <mclapinski@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c         |    1 +
 mm/hugetlb_vmemmap.c |   14 +++++++++-----
 mm/hugetlb_vmemmap.h |    5 +++++
 3 files changed, 15 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-init-tails-before-init_migratetype
+++ a/mm/hugetlb.c
@@ -4127,6 +4127,7 @@ static int __init hugetlb_init(void)
 	}
 
 	hugetlb_init_hstates();
+	hugetlb_vmemmap_init_tails();
 	gather_bootmem_prealloc();
 	report_hugepages();
 
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-init-tails-before-init_migratetype
+++ a/mm/hugetlb_vmemmap.c
@@ -867,14 +867,10 @@ static const struct ctl_table hugetlb_vm
 	},
 };
 
-static int __init hugetlb_vmemmap_init(void)
+void __init hugetlb_vmemmap_init_tails(void)
 {
-	const struct hstate *h;
 	struct zone *zone;
 
-	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
-	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
-
 	for_each_zone(zone) {
 		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
 			struct page *tail, *p;
@@ -890,6 +886,14 @@ static int __init hugetlb_vmemmap_init(v
 				init_compound_tail(p + j, NULL, order, zone);
 		}
 	}
+}
+
+static int __init hugetlb_vmemmap_init(void)
+{
+	const struct hstate *h;
+
+	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
+	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
 
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb-init-tails-before-init_migratetype
+++ a/mm/hugetlb_vmemmap.h
@@ -20,6 +20,7 @@
 #define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+void hugetlb_vmemmap_init_tails(void);
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
 long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *folio_list,
@@ -72,6 +73,10 @@ static inline void hugetlb_vmemmap_optim
 {
 }
 
+static inline void hugetlb_vmemmap_init_tails(void)
+{
+}
+
 static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
 						struct list_head *folio_list)
 {
_

Patches currently in -mm which might be from mclapinski@google.com are

mm-hugetlb-init-tails-before-init_migratetype.patch


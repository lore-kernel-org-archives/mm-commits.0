From: akpm@linux-foundation.org
Subject: [merged] mm-debug-always-print-flags-in-dump_page.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:17:20 -0800
Message-ID: <20200131231720.RRWEQBt4i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXRV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:17:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, cai@lca.pw, dan.j.williams@intel.com, david@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pavel.tatashin@microsoft.com, rcampbell@nvidia.com, rppt@linux.ibm.com, vbabka@suse.cz


The patch titled
     Subject: mm/debug.c: always print flags in dump_page()
has been removed from the -mm tree.  Its filename was
     mm-debug-always-print-flags-in-dump_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/debug.c: always print flags in dump_page()

Commit 76a1850e4572 ("mm/debug.c: __dump_page() prints an extra line")
inadvertently removed printing of page flags for pages that are neither
anon nor ksm nor have a mapping.  Fix that.

Using pr_cont() again would be a solution, but the commit explicitly
removed its use.  Avoiding the danger of mixing up split lines from
multiple CPUs might be beneficial for near-panic dumps like this, so fix
this without reintroducing pr_cont().

Link: http://lkml.kernel.org/r/9f884d5c-ca60-dc7b-219c-c081c755fab6@suse.cz
Fixes: 76a1850e4572 ("mm/debug.c: __dump_page() prints an extra line")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reported-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/debug.c~mm-debug-always-print-flags-in-dump_page
+++ a/mm/debug.c
@@ -47,6 +47,7 @@ void __dump_page(struct page *page, cons
 	struct address_space *mapping;
 	bool page_poisoned = PagePoisoned(page);
 	int mapcount;
+	char *type = "";
 
 	/*
 	 * If struct page is poisoned don't access Page*() functions as that
@@ -78,9 +79,9 @@ void __dump_page(struct page *page, cons
 			page, page_ref_count(page), mapcount,
 			page->mapping, page_to_pgoff(page));
 	if (PageKsm(page))
-		pr_warn("ksm flags: %#lx(%pGp)\n", page->flags, &page->flags);
+		type = "ksm ";
 	else if (PageAnon(page))
-		pr_warn("anon flags: %#lx(%pGp)\n", page->flags, &page->flags);
+		type = "anon ";
 	else if (mapping) {
 		if (mapping->host && mapping->host->i_dentry.first) {
 			struct dentry *dentry;
@@ -88,10 +89,11 @@ void __dump_page(struct page *page, cons
 			pr_warn("%ps name:\"%pd\"\n", mapping->a_ops, dentry);
 		} else
 			pr_warn("%ps\n", mapping->a_ops);
-		pr_warn("flags: %#lx(%pGp)\n", page->flags, &page->flags);
 	}
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS + 1);
 
+	pr_warn("%sflags: %#lx(%pGp)\n", type, page->flags, &page->flags);
+
 hex_only:
 	print_hex_dump(KERN_WARNING, "raw: ", DUMP_PREFIX_NONE, 32,
 			sizeof(unsigned long), page,
_

Patches currently in -mm which might be from vbabka@suse.cz are

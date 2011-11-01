From: akpm@linux-foundation.org
Subject: [merged] mm-output-a-list-of-loaded-modules-when-we-hit-bad_page.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:08:32 -0700
Message-ID: <201111012108.pA1L8WB0025378@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28635 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1KAVIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: output a list of loaded modules when we hit bad_page()
has been removed from the -mm tree.  Its filename was
     mm-output-a-list-of-loaded-modules-when-we-hit-bad_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: mm: output a list of loaded modules when we hit bad_page()

When we get a bad_page bug report, it's useful to see what modules the
user had loaded.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~mm-output-a-list-of-loaded-modules-when-we-hit-bad_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-output-a-list-of-loaded-modules-when-we-hit-bad_page
+++ a/mm/page_alloc.c
@@ -318,6 +318,7 @@ static void bad_page(struct page *page)
 		current->comm, page_to_pfn(page));
 	dump_page(page);
 
+	print_modules();
 	dump_stack();
 out:
 	/* Leave bad fields for debug, except PageBuddy could make trouble */
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch
slab-add-taint-flag-outputting-to-debug-paths.patch
slub-add-taint-flag-outputting-to-debug-paths.patch


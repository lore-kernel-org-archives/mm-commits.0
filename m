From: akpm@linux-foundation.org
Subject: [merged] mm-page_idlec-skip-offline-pages.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 15:31:27 -0700
Message-ID: <20200608223127.G0EXmyuy8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgFHWb2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, sjpark@amazon.de


The patch titled
     Subject: mm/page_idle.c: skip offline pages
has been removed from the -mm tree.  Its filename was
     mm-page_idlec-skip-offline-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: mm/page_idle.c: skip offline pages

'Idle page tracking' users can pass random pfn that might be mapped to an
offline page.  To avoid accessing such pages, this commit modifies the
'page_idle_get_page()' to use 'pfn_to_online_page()' instead of
'pfn_valid()' and 'pfn_to_page()' combination, so that the pfn mapped to
an offline page can be skipped.

Link: http://lkml.kernel.org/r/20200605092502.18018-2-sjpark@amazon.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/page_idle.c~mm-page_idlec-skip-offline-pages
+++ a/mm/page_idle.c
@@ -4,6 +4,7 @@
 #include <linux/fs.h>
 #include <linux/sysfs.h>
 #include <linux/kobject.h>
+#include <linux/memory_hotplug.h>
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/pagemap.h>
@@ -30,13 +31,9 @@
  */
 static struct page *page_idle_get_page(unsigned long pfn)
 {
-	struct page *page;
+	struct page *page = pfn_to_online_page(pfn);
 	pg_data_t *pgdat;
 
-	if (!pfn_valid(pfn))
-		return NULL;

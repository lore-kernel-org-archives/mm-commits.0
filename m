From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 01/54] mm/page_idle.c: skip offline pages
Date: Sun, 07 Jun 2020 21:40:04 -0700
Message-ID: <20200608044004.04xI8ALrc%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEkF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:40:05 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, sjpark@amazon.de, torvalds@linux-foundation.org

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

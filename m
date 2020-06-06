From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_idlec-skip-offline-pages.patch added to -mm
 tree
Date: Fri, 05 Jun 2020 18:06:29 -0700
Message-ID: <20200606010629.NBKqk1gCz%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFFBGb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 21:06:31 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, sjpark@amazon.de


The patch titled
     Subject: mm/page_idle.c: Skip offline pages
has been added to the -mm tree.  Its filename is
     mm-page_idlec-skip-offline-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_idlec-skip-offline-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_idlec-skip-offline-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: mm/page_idle.c: Skip offline pages

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

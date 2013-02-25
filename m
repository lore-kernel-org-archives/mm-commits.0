From: akpm@linux-foundation.org
Subject: [merged] mm-accurately-document-nr_free__pages-functions-with-code-comments.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:40 -0800
Message-ID: <20130225205540.9DFAE31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:45126 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759370Ab3BYUzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:41 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so159449yen.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: accurately document nr_free_*_pages functions with code comments
has been removed from the -mm tree.  Its filename was
     mm-accurately-document-nr_free__pages-functions-with-code-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm: accurately document nr_free_*_pages functions with code comments

nr_free_zone_pages(), nr_free_buffer_pages() and nr_free_pagecache_pages()
are horribly badly named, so accurately document them with code comments
in case of the misuse of them.

[akpm@linux-foundation.org: tweak comments]
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-accurately-document-nr_free__pages-functions-with-code-comments mm/page_alloc.c
--- a/mm/page_alloc.c~mm-accurately-document-nr_free__pages-functions-with-code-comments
+++ a/mm/page_alloc.c
@@ -2813,6 +2813,15 @@ void free_pages_exact(void *virt, size_t
 }
 EXPORT_SYMBOL(free_pages_exact);
 
+/**
+ * nr_free_zone_pages - count number of pages beyond high watermark
+ * @offset: The zone index of the highest zone
+ *
+ * nr_free_zone_pages() counts the number of counts pages which are beyond the
+ * high watermark within all zones at or below a given zone index.  For each
+ * zone, the number of pages is calculated as:
+ *     present_pages - high_pages
+ */
 static unsigned long nr_free_zone_pages(int offset)
 {
 	struct zoneref *z;
@@ -2833,8 +2842,11 @@ static unsigned long nr_free_zone_pages(
 	return sum;
 }
 
-/*
- * Amount of free RAM allocatable within ZONE_DMA and ZONE_NORMAL
+/**
+ * nr_free_buffer_pages - count number of pages beyond high watermark
+ *
+ * nr_free_buffer_pages() counts the number of pages which are beyond the high
+ * watermark within ZONE_DMA and ZONE_NORMAL.
  */
 unsigned long nr_free_buffer_pages(void)
 {
@@ -2842,8 +2854,11 @@ unsigned long nr_free_buffer_pages(void)
 }
 EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
 
-/*
- * Amount of free RAM allocatable within all zones
+/**
+ * nr_free_pagecache_pages - count number of pages beyond high watermark
+ *
+ * nr_free_pagecache_pages() counts the number of pages which are beyond the
+ * high watermark within all zones.
  */
 unsigned long nr_free_pagecache_pages(void)
 {
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch
kexec-prevent-double-free-on-image-allocation-failure.patch
kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch
kexec-avoid-freeing-null-pointer-in-function-kimage_crash_alloc.patch


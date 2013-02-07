From: akpm@linux-foundation.org
Subject: + mm-accurately-document-nr_free__pages-functions-with-code-comments.patch added to -mm tree
Date: Thu, 07 Feb 2013 15:26:49 -0800
Message-ID: <20130207232650.977BC1E419F@corp2gmr1-2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f73.google.com ([209.85.214.73]:59028 "EHLO
	mail-bk0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394Ab3BGX0x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2013 18:26:53 -0500
Received: by mail-bk0-f73.google.com with SMTP id w5so213577bku.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Feb 2013 15:26:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com, rdunlap@infradead.org


The patch titled
     Subject: mm: accurately document nr_free_*_pages functions with code comments
has been added to the -mm tree.  Its filename is
     mm-accurately-document-nr_free__pages-functions-with-code-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm: accurately document nr_free_*_pages functions with code comments

nr_free_zone_pages(), nr_free_buffer_pages() and nr_free_pagecache_pages()
are horribly badly named, so accurately document them with code comments
in case of the misuse of them.

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-accurately-document-nr_free__pages-functions-with-code-comments mm/page_alloc.c
--- a/mm/page_alloc.c~mm-accurately-document-nr_free__pages-functions-with-code-comments
+++ a/mm/page_alloc.c
@@ -2812,6 +2812,15 @@ void free_pages_exact(void *virt, size_t
 }
 EXPORT_SYMBOL(free_pages_exact);
 
+/**
+ * nr_free_zone_pages - get pages that is beyond high watermark
+ * @offset: The zone index of the highest zone
+ *
+ * The function counts pages which are beyond high watermark within
+ * all zones at or below a given zone index. For each zone, the
+ * amount of pages is calculated as:
+ *     present_pages - high_pages
+ */
 static unsigned long nr_free_zone_pages(int offset)
 {
 	struct zoneref *z;
@@ -2832,8 +2841,11 @@ static unsigned long nr_free_zone_pages(
 	return sum;
 }
 
-/*
- * Amount of free RAM allocatable within ZONE_DMA and ZONE_NORMAL
+/**
+ * nr_free_buffer_pages - get pages that is beyond high watermark
+ *
+ * The function counts pages which are beyond high watermark within
+ * ZONE_DMA and ZONE_NORMAL.
  */
 unsigned long nr_free_buffer_pages(void)
 {
@@ -2841,8 +2853,11 @@ unsigned long nr_free_buffer_pages(void)
 }
 EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
 
-/*
- * Amount of free RAM allocatable within all zones
+/**
+ * nr_free_pagecache_pages - get pages that is beyond high watermark
+ *
+ * The function counts pages which are beyond high watermark within
+ * all zones.
  */
 unsigned long nr_free_pagecache_pages(void)
 {
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

mm-fix-return-type-for-functions-nr_free__pages.patch
ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch
fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch
fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch
vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch
net-change-type-of-virtio_chan-p9_max_pages.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
binfmt_elf-remove-unused-argument-in-fill_elf_header.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch


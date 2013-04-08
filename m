From: akpm@linux-foundation.org
Subject: [merged] mm-export-split_page.patch removed from -mm tree
Date: Mon, 08 Apr 2013 12:17:58 -0700
Message-ID: <20130408191758.E7C2D5A4005@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:42847 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934741Ab3DHTSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 15:18:00 -0400
Received: by mail-ie0-f202.google.com with SMTP id qd14so1549831ieb.3
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 12:18:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kys@microsoft.com, greg@kroah.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject:  mm: export split_page()
has been removed from the -mm tree.  Its filename was
     mm-export-split_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject:  mm: export split_page()

This symbol will be used in the Hyper-V balloon driver to support 2M
allocations.

Signed-off-by: K.  Y.  Srinivasan <kys@microsoft.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~mm-export-split_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-export-split_page
+++ a/mm/page_alloc.c
@@ -1397,6 +1397,7 @@ void split_page(struct page *page, unsig
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 }
+EXPORT_SYMBOL_GPL(split_page);
 
 static int __isolate_free_page(struct page *page, unsigned int order)
 {
_

Patches currently in -mm which might be from kys@microsoft.com are

linux-next.patch
drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver.patch
drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix.patch


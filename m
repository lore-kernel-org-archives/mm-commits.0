From: akpm@linux-foundation.org
Subject: [merged]
 drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:37:49 -0800
Message-ID: <5283e31d.Ok9z3zXMo10K4+d3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3KMUhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, qiuxishi@huawei.com

Subject: [merged] drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch removed from -mm tree
To: qiuxishi@huawei.com,plagnioj@jcrosoft.com,tomi.valkeinen@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:49 -0800


The patch titled
     Subject: drivers/video/acornfb.c: use __free_reserved_page() to simplify the code
has been removed from the -mm tree.  Its filename was
     drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: drivers/video/acornfb.c: use __free_reserved_page() to simplify the code

Use __free_reserved_page() to simplify the code in the others.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/acornfb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/acornfb.c~drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code drivers/video/acornfb.c
--- a/drivers/video/acornfb.c~drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code
+++ a/drivers/video/acornfb.c
@@ -949,9 +949,7 @@ free_unused_pages(unsigned int virtual_s
 		 * the page.
 		 */
 		page = virt_to_page(virtual_start);
-		ClearPageReserved(page);
-		init_page_count(page);
-		free_page(virtual_start);
+		__free_reserved_page(page);
 
 		virtual_start += PAGE_SIZE;
 		mb_freed += PAGE_SIZE / 1024;
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

origin.patch
linux-next.patch


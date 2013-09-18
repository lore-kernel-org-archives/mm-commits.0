From: akpm@linux-foundation.org
Subject: +
 drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch
 added to -mm tree
Date: Wed, 18 Sep 2013 14:07:08 -0700
Message-ID: <523a15fc.vN70pB4GzVMSiydU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3IRVHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 17:07:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, qiuxishi@huawei.com

Subject: + drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch added to -mm tree
To: qiuxishi@huawei.com,plagnioj@jcrosoft.com,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 14:07:08 -0700


The patch titled
     Subject: drivers/video/acornfb.c: use __free_reserved_page() to simplify the code
has been added to the -mm tree.  Its filename is
     drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-arch-use-__free_reserved_page-to-simplify-the-code.patch
drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch
documentation-dma-attributestxt-fix-typo.patch


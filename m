From: akpm@linux-foundation.org
Subject: + mm-remove-struct-node_active_region.patch added to -mm tree
Date: Thu, 09 Jul 2015 15:32:09 -0700
Message-ID: <559ef669.rK/YanHwu/fvQ5fy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbbGIWcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:32:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minkyung88.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove struct node_active_region
has been added to the -mm tree.  Its filename is
     mm-remove-struct-node_active_region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-struct-node_active_region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-struct-node_active_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "minkyung88.kim" <minkyung88.kim@lge.com>
Subject: mm: remove struct node_active_region

struct node_active_region is not used anymore.  Remove it.

Signed-off-by: minkyung88.kim <minkyung88.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    8 --------
 1 file changed, 8 deletions(-)

diff -puN include/linux/mmzone.h~mm-remove-struct-node_active_region include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-struct-node_active_region
+++ a/include/linux/mmzone.h
@@ -690,14 +690,6 @@ struct zonelist {
 #endif
 };
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-struct node_active_region {
-	unsigned long start_pfn;
-	unsigned long end_pfn;
-	int nid;
-};
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */

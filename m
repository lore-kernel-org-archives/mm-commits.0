From: akpm@linux-foundation.org
Subject: [patch 021/115] mm/cma.c: warn if the CMA area could not
 be activated
Date: Mon, 10 Jul 2017 15:48:12 -0700
Message-ID: <20170710224812.PKtu4_aue%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42194 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755051AbdGJWsN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com, khandual@linux.vnet.ibm.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/cma.c: warn if the CMA area could not be activated

While activating a CMA area we check to make sure that all the PFNs in the
range are inside the same zone.  This is a requirement for
alloc_contig_range() to work.  Any CMA area failing the check is disabled
for good.  This happens silently right now making all future cma_alloc()
allocations failure inevitable.

Here we add an error message stating that the CMA area could not be
activated which makes it easier to explain any future cma_alloc() failures
on it.  While in there, change the bail out goto label from 'err' to
'not_in_zone' which makes more sense.

Link: http://lkml.kernel.org/r/20170605023729.26303-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/cma.c~mm-cma-warn-if-the-cma-area-could-not-be-activated mm/cma.c
--- a/mm/cma.c~mm-cma-warn-if-the-cma-area-could-not-be-activated
+++ a/mm/cma.c
@@ -127,7 +127,7 @@ static int __init cma_activate_area(stru
 			 * to be in the same zone.
 			 */
 			if (page_zone(pfn_to_page(pfn)) != zone)
-				goto err;
+				goto not_in_zone;
 		}
 		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
 	} while (--i);
@@ -141,7 +141,8 @@ static int __init cma_activate_area(stru
 
 	return 0;
 
-err:
+not_in_zone:
+	pr_err("CMA area %s could not be activated\n", cma->name);
 	kfree(cma->bitmap);
 	cma->count = 0;
 	return -EINVAL;
_

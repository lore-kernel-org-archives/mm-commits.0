From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-cma-use-%pa-to-avoid-truncating-the-physical-address.patch removed from
 -mm tree
Date: Mon, 27 Oct 2014 21:35:29 -0700
Message-ID: <544f1d11./K02oqtliuHGFepF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaJ1EfM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 00:35:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cernekee@gmail.com, aneesh.kumar@linux.vnet.ibm.com, gregory.0xf0@gmail.com, iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: use %pa to avoid truncating the physical address
has been removed from the -mm tree.  Its filename was
     mm-cma-use-%pa-to-avoid-truncating-the-physical-address.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kevin Cernekee <cernekee@gmail.com>
Subject: mm: cma: use %pa to avoid truncating the physical address

[gregory.0xf0@gmail.com: rebased from 3.14 and updated commit message]
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/cma.c~mm-cma-use-%pa-to-avoid-truncating-the-physical-address mm/cma.c
--- a/mm/cma.c~mm-cma-use-%pa-to-avoid-truncating-the-physical-address
+++ a/mm/cma.c
@@ -294,8 +294,8 @@ int __init cma_declare_contiguous(phys_a
 		goto err;
 
 	totalcma_pages += (size / PAGE_SIZE);
-	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
-		(unsigned long)base);
+	pr_info("Reserved %ld MiB at %pa\n", (unsigned long)size / SZ_1M,
+		&base);
 	return 0;
 
 err:
_

Patches currently in -mm which might be from cernekee@gmail.com are



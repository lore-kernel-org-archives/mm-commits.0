From: akpm@linux-foundation.org
Subject: + mm-cma-use-%pa-to-avoid-truncating-the-physical-address.patch
 added to -mm tree
Date: Thu, 23 Oct 2014 13:03:56 -0700
Message-ID: <54495f2c.QdKe2Gfllx0xCfLd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaJWUD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 16:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cernekee@gmail.com, aneesh.kumar@linux.vnet.ibm.com, gregory.0xf0@gmail.com, iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: use %pa to avoid truncating the physical address
has been added to the -mm tree.  Its filename is
     mm-cma-use-%pa-to-avoid-truncating-the-physical-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-use-%pa-to-avoid-truncating-the-physical-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-use-%pa-to-avoid-truncating-the-physical-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -289,8 +289,8 @@ int __init cma_declare_contiguous(phys_a
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

mm-cma-use-%pa-to-avoid-truncating-the-physical-address.patch


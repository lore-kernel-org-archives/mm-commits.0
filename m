From: akpm@linux-foundation.org
Subject: [merged] mm-zbud-fix-condition-check-on-allocation-size.patch
 removed from -mm tree
Date: Mon, 05 Aug 2013 12:05:55 -0700
Message-ID: <51fff793.JtnbHv7P6nUfDwU4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3HETGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:06:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunae.seo@samsung.com, sjenning@linux.vnet.ibm.com, d.j.shin@samsung.com, bob.liu@oracle.com, heesub.shin@samsung.com

Subject: [merged] mm-zbud-fix-condition-check-on-allocation-size.patch removed from -mm tree
To: heesub.shin@samsung.com,bob.liu@oracle.com,d.j.shin@samsung.com,sjenning@linux.vnet.ibm.com,sunae.seo@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:05:55 -0700


The patch titled
     Subject: mm: zbud: fix condition check on allocation size
has been removed from the -mm tree.  Its filename was
     mm-zbud-fix-condition-check-on-allocation-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heesub Shin <heesub.shin@samsung.com>
Subject: mm: zbud: fix condition check on allocation size

zbud_alloc() incorrectly verifies the size of allocation limit.  It should
deny the allocation request greater than (PAGE_SIZE - ZHDR_SIZE_ALIGNED -
CHUNK_SIZE), not (PAGE_SIZE - ZHDR_SIZE_ALIGNED) which has no remaining
spaces for its buddy.  There is no point in spending the entire zbud page
storing only a single page, since we don't have any benefits.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunae Seo <sunae.seo@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zbud.c~mm-zbud-fix-condition-check-on-allocation-size mm/zbud.c
--- a/mm/zbud.c~mm-zbud-fix-condition-check-on-allocation-size
+++ a/mm/zbud.c
@@ -257,7 +257,7 @@ int zbud_alloc(struct zbud_pool *pool, i
 
 	if (size <= 0 || gfp & __GFP_HIGHMEM)
 		return -EINVAL;
-	if (size > PAGE_SIZE - ZHDR_SIZE_ALIGNED)
+	if (size > PAGE_SIZE - ZHDR_SIZE_ALIGNED - CHUNK_SIZE)
 		return -ENOSPC;
 	chunks = size_to_chunks(size);
 	spin_lock(&pool->lock);
_

Patches currently in -mm which might be from heesub.shin@samsung.com are



From: akpm@linux-foundation.org
Subject: + mm-zbud-fix-condition-check-on-allocation-size.patch added to
 -mm tree
Date: Thu, 18 Jul 2013 14:20:38 -0700
Message-ID: <51e85c26.PeZJbnFqvueOzQSn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144Ab3GRVUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jul 2013 17:20:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunae.seo@samsung.com, sjenning@linux.vnet.ibm.com, d.j.shin@samsung.com, bob.liu@oracle.com, heesub.shin@samsung.com

Subject: + mm-zbud-fix-condition-check-on-allocation-size.patch added to -mm tree
To: heesub.shin@samsung.com,bob.liu@oracle.com,d.j.shin@samsung.com,sjenning@linux.vnet.ibm.com,sunae.seo@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 18 Jul 2013 14:20:38 -0700


The patch titled
     Subject: mm: zbud: fix condition check on allocation size
has been added to the -mm tree.  Its filename is
     mm-zbud-fix-condition-check-on-allocation-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zbud-fix-condition-check-on-allocation-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zbud-fix-condition-check-on-allocation-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-zbud-fix-condition-check-on-allocation-size.patch


From: akpm@linux-foundation.org
Subject: [merged] mm-mempool-warn-about-__gfp_zero-usage.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:49:21 -0700
Message-ID: <5390c9c1.O9FCa722Z1tRDK7k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaFETtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sebott@linux.vnet.ibm.com

Subject: [merged] mm-mempool-warn-about-__gfp_zero-usage.patch removed from -mm tree
To: sebott@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:21 -0700


The patch titled
     Subject: mm/mempool: warn about __GFP_ZERO usage
has been removed from the -mm tree.  Its filename was
     mm-mempool-warn-about-__gfp_zero-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: mm/mempool: warn about __GFP_ZERO usage

Memory obtained via mempool_alloc is not always zeroed even when
called with __GFP_ZERO. Add a note and VM_BUG_ON statement to make
that clear.

[akpm@linux-foundation.org: use VM_WARN_ON_ONCE]
Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/mempool.c~mm-mempool-warn-about-__gfp_zero-usage mm/mempool.c
--- a/mm/mempool.c~mm-mempool-warn-about-__gfp_zero-usage
+++ a/mm/mempool.c
@@ -192,6 +192,7 @@ EXPORT_SYMBOL(mempool_resize);
  * returns NULL. Note that due to preallocation, this function
  * *never* fails when called from process contexts. (it might
  * fail if called from an IRQ context.)
+ * Note: using __GFP_ZERO is not supported.
  */
 void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 {
@@ -200,6 +201,7 @@ void * mempool_alloc(mempool_t *pool, gf
 	wait_queue_t wait;
 	gfp_t gfp_temp;
 
+	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */
_

Patches currently in -mm which might be from sebott@linux.vnet.ibm.com are

origin.patch
linux-next.patch


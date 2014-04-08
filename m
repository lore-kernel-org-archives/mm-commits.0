From: akpm@linux-foundation.org
Subject: [merged] mm-zswap-update-zsmalloc-in-comment-to-zbud.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:13:03 -0700
Message-ID: <5344665f.l6jOewCxftzeBGei%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064AbaDHVNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, minchan@kernel.org, sj38.park@gmail.com

Subject: [merged] mm-zswap-update-zsmalloc-in-comment-to-zbud.patch removed from -mm tree
To: sj38.park@gmail.com,minchan@kernel.org,sjenning@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:13:03 -0700


The patch titled
     Subject: mm/zswap.c: update zsmalloc in comment to zbud
has been removed from the -mm tree.  Its filename was
     mm-zswap-update-zsmalloc-in-comment-to-zbud.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj38.park@gmail.com>
Subject: mm/zswap.c: update zsmalloc in comment to zbud

zswap used zsmalloc before and now using zbud.  But, some comments saying
it use zsmalloc yet.  Fix the trivial problems.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/zswap.c~mm-zswap-update-zsmalloc-in-comment-to-zbud mm/zswap.c
--- a/mm/zswap.c~mm-zswap-update-zsmalloc-in-comment-to-zbud
+++ a/mm/zswap.c
@@ -165,7 +165,7 @@ static void zswap_comp_exit(void)
  *            be held while changing the refcount.  Since the lock must
  *            be held, there is no reason to also make refcount atomic.
  * offset - the swap offset for the entry.  Index into the red-black tree.
- * handle - zsmalloc allocation handle that stores the compressed page data
+ * handle - zbud allocation handle that stores the compressed page data
  * length - the length in bytes of the compressed page data.  Needed during
  *          decompression
  */
@@ -282,7 +282,7 @@ static void zswap_rb_erase(struct rb_roo
 }
 
 /*
- * Carries out the common pattern of freeing and entry's zsmalloc allocation,
+ * Carries out the common pattern of freeing and entry's zbud allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
 static void zswap_free_entry(struct zswap_tree *tree,
_

Patches currently in -mm which might be from sj38.park@gmail.com are

origin.patch


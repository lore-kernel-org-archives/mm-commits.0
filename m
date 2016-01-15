From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-use-list_for_each_entry-in-cache_flusharray.patch removed from -mm
 tree
Date: Fri, 15 Jan 2016 14:32:05 -0800
Message-ID: <56997365.C5ZUX/ldZIXXw2bk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbcAOWcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: use list_for_each_entry in cache_flusharray
has been removed from the -mm tree.  Its filename was
     mm-slab-use-list_for_each_entry-in-cache_flusharray.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/slab.c: use list_for_each_entry in cache_flusharray

Simplify the code with list_for_each_entry().

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/slab.c~mm-slab-use-list_for_each_entry-in-cache_flusharray mm/slab.c
--- a/mm/slab.c~mm-slab-use-list_for_each_entry-in-cache_flusharray
+++ a/mm/slab.c
@@ -3338,17 +3338,12 @@ free_done:
 #if STATS
 	{
 		int i = 0;
-		struct list_head *p;
+		struct page *page;
 
-		p = n->slabs_free.next;
-		while (p != &(n->slabs_free)) {
-			struct page *page;

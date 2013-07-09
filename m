From: akpm@linux-foundation.org
Subject: [merged] lib-scatterlist-error-handling-in-__sg_alloc_table.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:22:39 -0700
Message-ID: <51dc9b3f.hi//+U2F/SRmTNw0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3GIXWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, maximlevitsky@gmail.com, imre.deak@intel.com, daniel.vetter@ffwll.ch, akinobu.mita@gmail.com, dan.carpenter@oracle.com

Subject: [merged] lib-scatterlist-error-handling-in-__sg_alloc_table.patch removed from -mm tree
To: dan.carpenter@oracle.com,akinobu.mita@gmail.com,daniel.vetter@ffwll.ch,imre.deak@intel.com,maximlevitsky@gmail.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:39 -0700


The patch titled
     Subject: lib/scatterlist: error handling in __sg_alloc_table()
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-error-handling-in-__sg_alloc_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: lib/scatterlist: error handling in __sg_alloc_table()

I was reviewing code which I suspected might allocate a zero size SG
table.  That will cause memory corruption.  Also we can't return before
doing the memset or we could end up using uninitialized memory in the
cleanup path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN lib/scatterlist.c~lib-scatterlist-error-handling-in-__sg_alloc_table lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-error-handling-in-__sg_alloc_table
+++ a/lib/scatterlist.c
@@ -247,13 +247,15 @@ int __sg_alloc_table(struct sg_table *ta
 	struct scatterlist *sg, *prv;
 	unsigned int left;
 
+	memset(table, 0, sizeof(*table));
+
+	if (nents == 0)
+		return -EINVAL;
 #ifndef ARCH_HAS_SG_CHAIN
 	if (WARN_ON_ONCE(nents > max_ents))
 		return -EINVAL;
 #endif
 
-	memset(table, 0, sizeof(*table));

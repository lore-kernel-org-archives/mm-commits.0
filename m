From: akpm@linux-foundation.org
Subject: [merged] idr-reorder-the-fields.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:35:27 -0700
Message-ID: <53960c7f.vqU1m3nL3oteVowx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaFITf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:35:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: [merged] idr-reorder-the-fields.patch removed from -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:35:27 -0700


The patch titled
     Subject: idr: reorder the fields
has been removed from the -mm tree.  Its filename was
     idr-reorder-the-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: idr: reorder the fields

idr_layer->layer is always accessed in read path, move it in the front.

idr_layer->bitmap is moved on the bottom.  And rcu_head shares with bitmap
due to they do not be accessed at the same time.

idr->id_free/id_free_cnt/lock are free list fields, and moved to the
bottom.  They will be removed in near future.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN include/linux/idr.h~idr-reorder-the-fields include/linux/idr.h
--- a/include/linux/idr.h~idr-reorder-the-fields
+++ a/include/linux/idr.h
@@ -29,21 +29,24 @@
 
 struct idr_layer {
 	int			prefix;	/* the ID prefix of this idr_layer */
-	DECLARE_BITMAP(bitmap, IDR_SIZE); /* A zero bit means "space here" */
+	int			layer;	/* distance from leaf */
 	struct idr_layer __rcu	*ary[1<<IDR_BITS];
 	int			count;	/* When zero, we can release it */
-	int			layer;	/* distance from leaf */
-	struct rcu_head		rcu_head;
+	union {
+		/* A zero bit means "space here" */
+		DECLARE_BITMAP(bitmap, IDR_SIZE);
+		struct rcu_head		rcu_head;
+	};
 };
 
 struct idr {
 	struct idr_layer __rcu	*hint;	/* the last layer allocated from */
 	struct idr_layer __rcu	*top;
-	struct idr_layer	*id_free;
 	int			layers;	/* only valid w/o concurrent changes */
-	int			id_free_cnt;
 	int			cur;	/* current pos for cyclic allocation */
 	spinlock_t		lock;
+	int			id_free_cnt;
+	struct idr_layer	*id_free;
 };
 
 #define IDR_INIT(name)							\
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch


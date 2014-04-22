From: akpm@linux-foundation.org
Subject: + idr-reorder-the-fields.patch added to -mm tree
Date: Tue, 22 Apr 2014 12:44:56 -0700
Message-ID: <5356c6b8.w4/Bbjla2Kzn0E8P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbaDVTo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:44:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: + idr-reorder-the-fields.patch added to -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:44:56 -0700


The patch titled
     Subject: idr: reorder the fields
has been added to the -mm tree.  Its filename is
     idr-reorder-the-fields.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/idr-reorder-the-fields.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/idr-reorder-the-fields.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
idr-fix-overflow-bug-during-maximum-id-calculation-at-maximum-height.patch
idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch
idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch
idr-fix-idr_replaces-returned-error-code.patch
idr-dont-need-to-shink-the-free-list-when-idr_remove.patch
idr-reduce-the-unneeded-check-in-free_layer.patch
idr-proper-invalid-argument-handling.patch
idr-reduce-the-number-of-max_idr_free.patch
ida-in-place-ida-allocation.patch
idr-reorder-the-fields.patch
linux-next.patch


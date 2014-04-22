From: akpm@linux-foundation.org
Subject: + idr-proper-invalid-argument-handling.patch added to -mm tree
Date: Tue, 22 Apr 2014 12:44:53 -0700
Message-ID: <5356c6b5.3NmGJBC/41N1IRtr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaDVToy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:44:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: + idr-proper-invalid-argument-handling.patch added to -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:44:53 -0700


The patch titled
     Subject: idr: proper invalid argument handling
has been added to the -mm tree.  Its filename is
     idr-proper-invalid-argument-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/idr-proper-invalid-argument-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/idr-proper-invalid-argument-handling.patch

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
Subject: idr: proper invalid argument handling

When the arguments passed by the caller are invalid, WARN_ON_ONCE() is
better than BUG_ON() which may crash the kernel.

ida_remove()/idr_remove(): add checks for "id < 0".

BUG_ON() in ida_simple_remove() is simply removed, due to
ida_remove() already checking for "id < 0".

In idr_alloc(), it still returns -ENOSPC when "start == end", but it
returns -EINVAL when "max < start" while old code returns -ENOSPC. 
-EINVAL is proper here, the caller must passed wrong arguments.

ida_simple_get()'s argument-checks are changed as the same as idr_alloc().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN lib/idr.c~idr-proper-invalid-argument-handling lib/idr.c
--- a/lib/idr.c~idr-proper-invalid-argument-handling
+++ a/lib/idr.c
@@ -459,8 +459,10 @@ int idr_alloc(struct idr *idr, void *ptr
 	/* sanity checks */
 	if (WARN_ON_ONCE(start < 0))
 		return -EINVAL;
-	if (unlikely(max < start))
+	if (unlikely(end > 0 && start == end))
 		return -ENOSPC;
+	if (WARN_ON_ONCE(max < start))
+		return -EINVAL;
 
 	/* allocate id */
 	id = idr_get_empty_slot(idr, start, pa, gfp_mask, NULL);
@@ -553,10 +555,7 @@ void idr_remove(struct idr *idp, int id)
 	struct idr_layer *p;
 	struct idr_layer *to_free;
 
-	if (id < 0)
-		return;
-
-	if (id > idr_max(idp->layers)) {
+	if (id < 0 || id > idr_max(idp->layers)) {
 		idr_remove_warning(id);
 		return;
 	}
@@ -1014,7 +1013,7 @@ void ida_remove(struct ida *ida, int id)
 	int n;
 	struct ida_bitmap *bitmap;
 
-	if (idr_id > idr_max(ida->idr.layers))
+	if (id < 0 || idr_id > idr_max(ida->idr.layers))
 		goto err;
 
 	/* clear full bits while looking up the leaf idr_layer */
@@ -1080,14 +1079,17 @@ int ida_simple_get(struct ida *ida, unsi
 	unsigned int max;
 	unsigned long flags;
 
-	BUG_ON((int)start < 0);
-	BUG_ON((int)end < 0);
+	if (WARN_ON_ONCE((int)start < 0))
+		return -EINVAL;
 
-	if (end == 0)
-		max = 0x80000000;
+	if ((int)end <= 0)
+		max = INT_MAX;
 	else {
-		BUG_ON(end < start);
 		max = end - 1;
+		if (unlikely(start == end))
+			return -ENOSPC;
+		if (WARN_ON_ONCE(max < start))
+			return -EINVAL;
 	}
 
 again:
@@ -1122,7 +1124,6 @@ void ida_simple_remove(struct ida *ida,
 {
 	unsigned long flags;
 
-	BUG_ON((int)id < 0);
 	spin_lock_irqsave(&simple_ida_lock, flags);
 	ida_remove(ida, id);
 	spin_unlock_irqrestore(&simple_ida_lock, flags);
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


From: akpm@linux-foundation.org
Subject: [merged]
 idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:35:02 -0700
Message-ID: <53960c66.hHWEIIdoSYi/5MWe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaFITfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: [merged] idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch removed from -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:35:02 -0700


The patch titled
     Subject: idr: fix unexpected ID-removal when idr_remove(unallocated_id)
has been removed from the -mm tree.  Its filename was
     idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: idr: fix unexpected ID-removal when idr_remove(unallocated_id)

If unallocated_id = (ANY * idr_max(idp->layers) + existing_id) is passed
to idr_remove().  The existing_id will be removed unexpectedly.

The following test shows this unexpected id-removal:

static void test4(void)
{
	int id;
	DEFINE_IDR(test_idr);

	printk(KERN_INFO "Start test4\n");
	id = idr_alloc(&test_idr, (void *)1, 42, 43, GFP_KERNEL);
	BUG_ON(id != 42);
	idr_remove(&test_idr, 42 + IDR_SIZE);
	TEST_BUG_ON(idr_find(&test_idr, 42) != (void *)1);
	idr_destroy(&test_idr);
	printk(KERN_INFO "End of test4\n");
}

ida_remove() shares the similar problem.

It happens only when the caller tries to free an unallocated ID which is
the caller's fault.  It is not a bug.  But it is better to add the proper
check and complain rather than removing an existing_id silently.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN lib/idr.c~idr-fix-unexpected-id-removal-when-idr_removeunallocated_id lib/idr.c
--- a/lib/idr.c~idr-fix-unexpected-id-removal-when-idr_removeunallocated_id
+++ a/lib/idr.c
@@ -562,6 +562,11 @@ void idr_remove(struct idr *idp, int id)
 	if (id < 0)
 		return;
 
+	if (id > idr_max(idp->layers)) {
+		idr_remove_warning(id);
+		return;
+	}
+
 	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
 	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
 	    idp->top->ary[0]) {
@@ -1025,6 +1030,9 @@ void ida_remove(struct ida *ida, int id)
 	int n;
 	struct ida_bitmap *bitmap;
 
+	if (idr_id > idr_max(ida->idr.layers))
+		goto err;
+
 	/* clear full bits while looking up the leaf idr_layer */
 	while ((shift > 0) && p) {
 		n = (idr_id >> shift) & IDR_MASK;
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch


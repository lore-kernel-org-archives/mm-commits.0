From: akpm@linux-foundation.org
Subject: +
 idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch added to
 -mm tree
Date: Tue, 22 Apr 2014 12:40:44 -0700
Message-ID: <5356c5bc.oOkdK4FPoIOIIAaF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbaDVTkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:40:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: + idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch added to -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:40:44 -0700


The patch titled
     Subject: idr: fix unexpected ID-removal when idr_remove(unallocated_id)
has been added to the -mm tree.  Its filename is
     idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch

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

mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
idr-fix-overflow-bug-during-maximum-id-calculation-at-maximum-height.patch
idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch
idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch
idr-fix-idr_replaces-returned-error-code.patch
idr-dont-need-to-shink-the-free-list-when-idr_remove.patch
idr-reduce-the-unneeded-check-in-free_layer.patch
linux-next.patch


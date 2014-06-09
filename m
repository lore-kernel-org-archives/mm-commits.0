From: akpm@linux-foundation.org
Subject: [merged]
 idr-fix-overflow-bug-during-maximum-id-calculation-at-maximum-height.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:34:57 -0700
Message-ID: <53960c61.ttNvTb1RN530qnM/%akpm__36115.2083882645$1402342518$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaFITe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:34:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org, laijs@cn.fujitsu.com

Subject: [merged] idr-fix-overflow-bug-during-maximum-id-calculation-at-maximum-height.patch removed from -mm tree
To: laijs@cn.fujitsu.com,stable@vger.kernel.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:34:57 -0700


The patch titled
     Subject: idr: fix overflow bug during maximum ID calculation at maximum height
has been removed from the -mm tree.  Its filename was
     idr-fix-overflow-bug-during-maximum-id-calculation-at-maximum-height.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: idr: fix overflow bug during maximum ID calculation at maximum height

idr_replace() open-codes the logic to calculate the maximum valid ID given
the height of the idr tree; unfortunately, the open-coded logic doesn't
account for the fact that the top layer may have unused slots and
over-shifts the limit to zero when the tree is at its maximum height.

The following test code shows it fails to replace the value for
id=((1<<27)+42):

static void test5(void)
{
	int id;
	DEFINE_IDR(test_idr);
#define TEST5_START ((1<<27)+42) /* use the highest layer */

	printk(KERN_INFO "Start test5\n");
	id = idr_alloc(&test_idr, (void *)1, TEST5_START, 0, GFP_KERNEL);
	BUG_ON(id != TEST5_START);
	TEST_BUG_ON(idr_replace(&test_idr, (void *)2, TEST5_START) != (void *)1);
	idr_destroy(&test_idr);
	printk(KERN_INFO "End of test5\n");
}

Fix the bug by using idr_max() which correctly takes into account the
maximum allowed shift.

sub_alloc() shares the same problem and may incorrectly fail with -EAGAIN;
however, this bug doesn't affect correct operation because
idr_get_empty_slot(), which already uses idr_max(), retries with the
increased @id in such cases.

[tj@kernel.org: Updated patch description.]
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN lib/idr.c~idr-fix-overflow-bug-during-maximum-id-calculation-at-maximum-height lib/idr.c
--- a/lib/idr.c~idr-fix-overflow-bug-during-maximum-id-calculation-at-maximum-height
+++ a/lib/idr.c
@@ -249,7 +249,7 @@ static int sub_alloc(struct idr *idp, in
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
 			/* if already at the top layer, we need to grow */
-			if (id >= 1 << (idp->layers * IDR_BITS)) {
+			if (id > idr_max(idp->layers)) {
 				*starting_id = id;
 				return -EAGAIN;
 			}
@@ -811,12 +811,10 @@ void *idr_replace(struct idr *idp, void
 	if (!p)
 		return ERR_PTR(-EINVAL);
 
-	n = (p->layer+1) * IDR_BITS;

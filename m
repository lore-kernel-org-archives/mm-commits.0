From: akpm@linux-foundation.org
Subject: [merged]
 idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:35:07 -0700
Message-ID: <53960c6b.QUYBb8AkK6I6BoS4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFITfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: [merged] idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch removed from -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:35:07 -0700


The patch titled
     Subject: idr: fix NULL pointer dereference when ida_remove(unallocated_id)
has been removed from the -mm tree.  Its filename was
     idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: idr: fix NULL pointer dereference when ida_remove(unallocated_id)

If the ida has at least one existing id, and when an unallocated ID which
meets a certain condition is passed to the ida_remove(), the system will
crash because it hits NULL pointer dereference.

The condition is that the unallocated ID shares the same lowest idr layer
with the existing ID, but the idr slot would be different if the
unallocated ID were to be allocated.

In this case the matching idr slot for the unallocated_id is NULL, causing
@bitmap to be NULL which the function dereferences without checking
crashing the kernel.

See the test code:

static void test3(void)
{
	int id;
	DEFINE_IDA(test_ida);

	printk(KERN_INFO "Start test3\n");
	if (ida_pre_get(&test_ida, GFP_KERNEL) < 0) return;
	if (ida_get_new(&test_ida,  &id) < 0) return;
	ida_remove(&test_ida, 4000); /* bug: null deference here */
	printk(KERN_INFO "End of test3\n");
}

It happens only when the caller tries to free an unallocated ID which is
the caller's fault.  It is not a bug.  But it is better to add the proper
check and complain rather than crashing the kernel.

[tj@kernel.org: updated patch description]
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/idr.c~idr-fix-null-pointer-dereference-when-ida_removeunallocated_id lib/idr.c
--- a/lib/idr.c~idr-fix-null-pointer-dereference-when-ida_removeunallocated_id
+++ a/lib/idr.c
@@ -1048,7 +1048,7 @@ void ida_remove(struct ida *ida, int id)
 	__clear_bit(n, p->bitmap);
 
 	bitmap = (void *)p->ary[n];
-	if (!test_bit(offset, bitmap->bitmap))
+	if (!bitmap || !test_bit(offset, bitmap->bitmap))
 		goto err;
 
 	/* update bitmap and remove it if empty */
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch


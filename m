From: akpm@linux-foundation.org
Subject: +
 idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch added
 to -mm tree
Date: Tue, 22 Apr 2014 12:40:45 -0700
Message-ID: <5356c5bd.4VTGLd7e6a/KI45T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaDVTkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:40:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: + idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch added to -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:40:45 -0700


The patch titled
     Subject: idr: fix NULL pointer dereference when ida_remove(unallocated_id)
has been added to the -mm tree.  Its filename is
     idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch

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

mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
idr-fix-overflow-bug-during-maximum-id-calculation-at-maximum-height.patch
idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch
idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch
idr-fix-idr_replaces-returned-error-code.patch
idr-dont-need-to-shink-the-free-list-when-idr_remove.patch
idr-reduce-the-unneeded-check-in-free_layer.patch
linux-next.patch


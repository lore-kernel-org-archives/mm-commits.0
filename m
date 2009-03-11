From: akpm@linux-foundation.org
Subject: [merged] idr-make-idr_remove_all-do-removal-before-free_layer.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:35 -0700
Message-ID: <200903111809.n2BI9ZH7019956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbZCKSML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, manfred@colorfullife.com, miltonm@austin.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     idr: make idr_remove_all() do removal -before- free_layer()
has been removed from the -mm tree.  Its filename was
     idr-make-idr_remove_all-do-removal-before-free_layer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: make idr_remove_all() do removal -before- free_layer()
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Fix a problem in the IDR system, where an idr_remove_all() hands a data
element to call_rcu() (via free_layer()) before making that data element
inaccessible to new readers.  This is very bad, and results in readers
still having a reference to this data element at the end of the grace
period.

Tests on large machines that concurrently map and unmap user-space memory
within the same multithreaded process result in crashes within about five
minutes.  Applying this patch increases the kernel's longevity to the
three-to-eight-hour range.

There appear to be other similar problems in idr_get_empty_slot() and
sub_remove(), but I fixed the easy one in idr_remove_all() first.  It is
therefore no surprise that failures still occur.

Located-by: Milton Miller II <miltonm@austin.ibm.com>
Tested-by: Milton Miller II <miltonm@austin.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/idr.c~idr-make-idr_remove_all-do-removal-before-free_layer lib/idr.c
--- a/lib/idr.c~idr-make-idr_remove_all-do-removal-before-free_layer
+++ a/lib/idr.c
@@ -449,6 +449,7 @@ void idr_remove_all(struct idr *idp)
 
 	n = idp->layers * IDR_BITS;
 	p = idp->top;
+	rcu_assign_pointer(idp->top, NULL);
 	max = 1 << n;
 
 	id = 0;
@@ -467,7 +468,6 @@ void idr_remove_all(struct idr *idp)
 			p = *--paa;
 		}
 	}
-	rcu_assign_pointer(idp->top, NULL);
 	idp->layers = 0;
 }
 EXPORT_SYMBOL(idr_remove_all);
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
linux-next.patch


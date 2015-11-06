From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-make-node_hstates-array-static.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:17:05 -0800
Message-ID: <563d0ac1.Ep7g3djQxZq8z88A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161884AbbKFURF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: make node_hstates array static
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-make-node_hstates-array-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/hugetlb: make node_hstates array static

There are no users of the node_hstates array outside of the
mm/hugetlb.c. So let's make it static.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-make-node_hstates-array-static mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-make-node_hstates-array-static
+++ a/mm/hugetlb.c
@@ -2376,7 +2376,7 @@ struct node_hstate {
 	struct kobject		*hugepages_kobj;
 	struct kobject		*hstate_kobjs[HUGE_MAX_HSTATE];
 };
-struct node_hstate node_hstates[MAX_NUMNODES];
+static struct node_hstate node_hstates[MAX_NUMNODES];
 
 /*
  * A subset of global hstate attributes for node devices
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch


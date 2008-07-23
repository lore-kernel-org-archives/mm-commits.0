From: akpm@linux-foundation.org
Subject: - hugetlb-new-sysfs-interface-fix-2.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:03:10 -0700
Message-ID: <200807232315.m6NNFlVM017109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754206AbYGWXQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@linux.vnet.ibm.com, npiggin@suse.de, tony@bakeyournoodle.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb-new-sysfs-interface-fix-2
has been removed from the -mm tree.  Its filename was
     hugetlb-new-sysfs-interface-fix-2.patch

This patch was dropped because it was folded into hugetlb-new-sysfs-interface.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb-new-sysfs-interface-fix-2
From: Dave Hansen <dave@linux.vnet.ibm.com>

This one seems to be causing some compilation errors with SYSFS=n.

>> /scratch/kathys/containers/kernel_trees/upstream/mm/hugetlb.c: In
>> function 'hugetlb_exit':
>> /scratch/kathys/containers/kernel_trees/upstream/mm/hugetlb.c:1234:
>> error: 'hstate_kobjs' undeclared (first use in this function)
>> /scratch/kathys/containers/kernel_trees/upstream/mm/hugetlb.c:1234:
>> error: (Each undeclared identifier is reported only once
>> /scratch/kathys/containers/kernel_trees/upstream/mm/hugetlb.c:1234:
>> error: for each function it appears in.)
>> /scratch/kathys/containers/kernel_trees/upstream/mm/hugetlb.c:1237:
>> error: 'hugepages_kobj' undeclared (first use in this function)
>> make[2]: *** [mm/hugetlb.o] Error 1
>> make[1]: *** [mm] Error 2
>> make: *** [sub-make] Error 2

Should we just move hugetlb_exit() inside the sysfs #ifdef with
everything else?

Cc: Nick Piggin <npiggin@suse.de>
Cc: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-new-sysfs-interface-fix-2 mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-new-sysfs-interface-fix-2
+++ a/mm/hugetlb.c
@@ -1179,6 +1179,19 @@ static void __init hugetlb_sysfs_init(vo
 								h->name);
 	}
 }
+
+static void __exit hugetlb_exit(void)
+{
+	struct hstate *h;
+
+	for_each_hstate(h) {
+		kobject_put(hstate_kobjs[h - hstates]);
+	}
+
+	kobject_put(hugepages_kobj);
+}
+module_exit(hugetlb_exit);
+
 #else
 static void __init hugetlb_sysfs_init(void)
 {
@@ -1205,18 +1218,6 @@ static int __init hugetlb_init(void)
 }
 module_init(hugetlb_init);
 
-static void __exit hugetlb_exit(void)
-{
-	struct hstate *h;
-
-	for_each_hstate(h) {
-		kobject_put(hstate_kobjs[h - hstates]);
-	}
-
-	kobject_put(hugepages_kobj);
-}
-module_exit(hugetlb_exit);

From: akpm@linux-foundation.org
Subject: + hugetlb-new-sysfs-interface-fix-2.patch added to -mm tree
Date: Tue, 24 Jun 2008 00:24:53 -0700
Message-ID: <200806240724.m5O7OrTJ006557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbYFXHZj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 03:25:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, npiggin@suse.de, tony@bakeyournoodle.com


The patch titled
     hugetlb-new-sysfs-interface-fix-2
has been added to the -mm tree.  Its filename is
     hugetlb-new-sysfs-interface-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 mm/hugetlb.c      |   25 +++++++++++++------------
 mm/hugetlb.c.orig |   25 ++++++++++++-------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-new-sysfs-interface-fix-2 mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-new-sysfs-interface-fix-2
+++ a/mm/hugetlb.c
@@ -1104,6 +1104,19 @@ static void __init hugetlb_sysfs_init(vo
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
@@ -1130,18 +1143,6 @@ static int __init hugetlb_init(void)
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
-
 /* Should be called on processing a hugepagesz=... option */
 void __init hugetlb_add_hstate(unsigned order)
 {
diff -puN mm/hugetlb.c.orig~hugetlb-new-sysfs-interface-fix-2 mm/hugetlb.c.orig
--- a/mm/hugetlb.c.orig~hugetlb-new-sysfs-interface-fix-2
+++ a/mm/hugetlb.c.orig
@@ -1104,19 +1104,6 @@ static void __init hugetlb_sysfs_init(vo
 								h->name);
 	}
 }
-
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
-
 #else
 static void __init hugetlb_sysfs_init(void)
 {
@@ -1143,6 +1130,18 @@ static int __init hugetlb_init(void)
 }
 module_init(hugetlb_init);
 
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
 /* Should be called on processing a hugepagesz=... option */
 void __init hugetlb_add_hstate(unsigned order)
 {
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

hugetlb-new-sysfs-interface-fix-2.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch


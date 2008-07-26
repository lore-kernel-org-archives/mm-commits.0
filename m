From: akpm@linux-foundation.org
Subject: - hugetlb-fix-config_sysctl=n-build.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:05 -0700
Message-ID: <200807262113.m6QLD5Hs019570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757521AbYGZVOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:14:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     hugetlb: fix CONFIG_SYSCTL=n build
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-config_sysctl=n-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: fix CONFIG_SYSCTL=n build
From: Nishanth Aravamudan <nacc@us.ibm.com>

Fixes a build failure reported by Alan Cox:

mm/hugetlb.c: In function `hugetlb_acct_memory': mm/hugetlb.c:1507:
error: implicit declaration of function `cpuset_mems_nr'

Also reverts Ingo's

    commit e44d1b2998d62a1f2f4d7eb17b56ba396535509f
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Fri Jul 25 12:57:41 2008 +0200

        mm/hugetlb.c: fix build failure with !CONFIG_SYSCTL
    
which fixed the build error but added some unused-static-function warnings.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-config_sysctl=n-build mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-config_sysctl=n-build
+++ a/mm/hugetlb.c
@@ -1026,18 +1026,6 @@ static void __init report_hugepages(void
 	}
 }
 
-static unsigned int cpuset_mems_nr(unsigned int *array)
-{
-	int node;
-	unsigned int nr = 0;
-
-	for_each_node_mask(node, cpuset_current_mems_allowed)
-		nr += array[node];
-
-	return nr;
-}
-
-#ifdef CONFIG_SYSCTL
 #ifdef CONFIG_HIGHMEM
 static void try_to_free_low(struct hstate *h, unsigned long count)
 {
@@ -1386,6 +1374,18 @@ static int __init hugetlb_default_setup(
 }
 __setup("default_hugepagesz=", hugetlb_default_setup);
 
+static unsigned int cpuset_mems_nr(unsigned int *array)
+{
+	int node;
+	unsigned int nr = 0;
+
+	for_each_node_mask(node, cpuset_current_mems_allowed)
+		nr += array[node];
+
+	return nr;
+}
+
+#ifdef CONFIG_SYSCTL
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
 			   struct file *file, void __user *buffer,
 			   size_t *length, loff_t *ppos)
_

Patches currently in -mm which might be from nacc@us.ibm.com are

origin.patch


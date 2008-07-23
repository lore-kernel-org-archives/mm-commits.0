From: akpm@linux-foundation.org
Subject: - hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:03:18 -0700
Message-ID: <200807232315.m6NNFuqX017119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979AbYGWXQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:16:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     hugetlb: remove CONFIG_SYSFS dependency
has been removed from the -mm tree.  Its filename was
     hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency.patch

This patch was dropped because it was folded into hugetlb-new-sysfs-interface.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: remove CONFIG_SYSFS dependency
From: Nishanth Aravamudan <nacc@us.ibm.com>

I incorrectly made the hugetlb kobject functionality depend on SYSFS, when, in
fact, the kobject functions fully work even with out sysfs.  Without sysfs,
there is no interface to manipulate the attributes of the various hugetlb
kobjects, but they still exist.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency
+++ a/mm/hugetlb.c
@@ -1040,7 +1040,6 @@ out:
 	return ret;
 }
 
-#ifdef CONFIG_SYSFS
 #define HSTATE_ATTR_RO(_name) \
 	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 
@@ -1192,12 +1191,6 @@ static void __exit hugetlb_exit(void)
 }
 module_exit(hugetlb_exit);
 
-#else
-static void __init hugetlb_sysfs_init(void)
-{
-}
-#endif

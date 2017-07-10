From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch removed from -mm tree
Date: Mon, 10 Jul 2017 15:32:06 -0700
Message-ID: <59640066.huKeowwQglO/m6LS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41244 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754106AbdGJWcH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:32:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Liam.Howlett@Oracle.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch

This patch was dropped because it was folded into mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix

reposition memfmt() to avoid forward declaration

Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: zhongjiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix
+++ a/mm/hugetlb.c
@@ -69,7 +69,17 @@ struct mutex *hugetlb_fault_mutex_table
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
-static char * __init memfmt(char *buf, unsigned long n);
+
+static char * __init memfmt(char *buf, unsigned long n)
+{
+	if (n >= (1UL << 30))
+		sprintf(buf, "%lu GB", n >> 30);
+	else if (n >= (1UL << 20))
+		sprintf(buf, "%lu MB", n >> 20);
+	else
+		sprintf(buf, "%lu KB", n >> 10);
+	return buf;
+}
 
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
 {
@@ -2238,17 +2248,6 @@ static void __init hugetlb_init_hstates(
 	VM_BUG_ON(minimum_order == UINT_MAX);
 }
 
-static char * __init memfmt(char *buf, unsigned long n)
-{
-	if (n >= (1UL << 30))
-		sprintf(buf, "%lu GB", n >> 30);
-	else if (n >= (1UL << 20))
-		sprintf(buf, "%lu MB", n >> 20);
-	else
-		sprintf(buf, "%lu KB", n >> 10);
-	return buf;
-}

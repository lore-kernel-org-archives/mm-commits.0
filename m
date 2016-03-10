From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-use-eopnotsupp-in-hugetlb-sysctl-handlers.patch removed from -mm tree
Date: Thu, 10 Mar 2016 10:58:18 -0800
Message-ID: <56e1c3ca.UOowWRmM1L/ZqJkh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbcCJS6T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 13:58:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jstancek@redhat.com, dave.hansen@linux.intel.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use EOPNOTSUPP in hugetlb sysctl handlers
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-eopnotsupp-in-hugetlb-sysctl-handlers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Stancek <jstancek@redhat.com>
Subject: mm/hugetlb: use EOPNOTSUPP in hugetlb sysctl handlers

Replace ENOTSUPP with EOPNOTSUPP.  If hugepages are not supported, this
value is propagated to userspace.  EOPNOTSUPP is part of uapi and is
widely supported by libc libraries.

It gives nicer message to user, rather than:
# cat /proc/sys/vm/nr_hugepages
cat: /proc/sys/vm/nr_hugepages: Unknown error 524

And also LTP's proc01 test was failing because this ret code (524)
was unexpected:
proc01      1  TFAIL  :  proc01.c:396: read failed: /proc/sys/vm/nr_hugepages: errno=???(524): Unknown error 524
proc01      2  TFAIL  :  proc01.c:396: read failed: /proc/sys/vm/nr_hugepages_mempolicy: errno=???(524): Unknown error 524
proc01      3  TFAIL  :  proc01.c:396: read failed: /proc/sys/vm/nr_overcommit_hugepages: errno=???(524): Unknown error 524

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-eopnotsupp-in-hugetlb-sysctl-handlers mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-eopnotsupp-in-hugetlb-sysctl-handlers
+++ a/mm/hugetlb.c
@@ -2751,7 +2751,7 @@ static int hugetlb_sysctl_handler_common
 	int ret;
 
 	if (!hugepages_supported())
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
@@ -2792,7 +2792,7 @@ int hugetlb_overcommit_handler(struct ct
 	int ret;
 
 	if (!hugepages_supported())
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	tmp = h->nr_overcommit_huge_pages;
 
_

Patches currently in -mm which might be from jstancek@redhat.com are



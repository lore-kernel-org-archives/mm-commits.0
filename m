From: akpm@linux-foundation.org
Subject: + mm-hugetlb-use-eopnotsupp-in-hugetlb-sysctl-handlers.patch
 added to -mm tree
Date: Fri, 04 Mar 2016 13:38:41 -0800
Message-ID: <56da0061.VipX/OnLYuDYcOls%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759678AbcCDVim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 16:38:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jstancek@redhat.com, dave.hansen@linux.intel.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use EOPNOTSUPP in hugetlb sysctl handlers
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-eopnotsupp-in-hugetlb-sysctl-handlers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-eopnotsupp-in-hugetlb-sysctl-handlers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-eopnotsupp-in-hugetlb-sysctl-handlers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Stancek <jstancek@redhat.com>
Subject: mm/hugetlb: use EOPNOTSUPP in hugetlb sysctl handlers

Replace ENOTSUPP with EOPNOTSUPP.  If hugepages are not supported, this
value is propagated to userspace.  EOPNOTSUPP is part of uapi and is
widely supported by libc libraries.

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
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

mm-hugetlb-use-eopnotsupp-in-hugetlb-sysctl-handlers.patch


From: akpm@linux-foundation.org
Subject: + s390-hugetlb-add-hugepages_supported-define.patch added to -mm
 tree
Date: Mon, 06 Jul 2015 15:35:32 -0700
Message-ID: <559b02b4.PdMkwYJDZZr6dqOc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbbGFWfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 18:35:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, borntraeger@de.ibm.com, gerald.schaefer@de.ibm.com, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/hugetlb: add hugepages_supported define
has been added to the -mm tree.  Its filename is
     s390-hugetlb-add-hugepages_supported-define.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-hugetlb-add-hugepages_supported-define.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-hugetlb-add-hugepages_supported-define.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: s390/hugetlb: add hugepages_supported define

On s390 we only can enable hugepages if the underlying hardware/hypervisor
also does support this. Common code now would assume this to be signaled
by setting HPAGE_SHIFT to 0. But on s390, where we only support one
hugepage size, there is a link between HPAGE_SHIFT and pageblock_order.

So instead of setting HPAGE_SHIFT to 0, we will implement the check for the
hardware capability.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/hugetlb.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/s390/include/asm/hugetlb.h~s390-hugetlb-add-hugepages_supported-define arch/s390/include/asm/hugetlb.h
--- a/arch/s390/include/asm/hugetlb.h~s390-hugetlb-add-hugepages_supported-define
+++ a/arch/s390/include/asm/hugetlb.h
@@ -14,6 +14,7 @@
 
 #define is_hugepage_only_range(mm, addr, len)	0
 #define hugetlb_free_pgd_range			free_pgd_range
+#define hugepages_supported()			(MACHINE_HAS_HPAGE)
 
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t pte);
_

Patches currently in -mm which might be from dingel@linux.vnet.ibm.com are

revert-s390-mm-change-hpage_shift-type-to-int.patch
revert-s390-mm-make-hugepages_supported-a-boot-time-decision.patch
mm-hugetlb-allow-hugepages_supported-to-be-architecture-specific.patch
s390-hugetlb-add-hugepages_supported-define.patch


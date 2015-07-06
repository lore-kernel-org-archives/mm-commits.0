From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-allow-hugepages_supported-to-be-architecture-specific.patch
 added to -mm tree
Date: Mon, 06 Jul 2015 15:35:30 -0700
Message-ID: <559b02b2.uyxJ87MYYl5fXoPK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbbGFWfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 18:35:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, borntraeger@de.ibm.com, gerald.schaefer@de.ibm.com, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: allow hugepages_supported to be architecture specific
has been added to the -mm tree.  Its filename is
     mm-hugetlb-allow-hugepages_supported-to-be-architecture-specific.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-allow-hugepages_supported-to-be-architecture-specific.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-allow-hugepages_supported-to-be-architecture-specific.patch

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
Subject: mm: hugetlb: allow hugepages_supported to be architecture specific

s390 has a constant hugepage size, by setting HPAGE_SHIFT we also
change e.g. the pageblock_order, which should be independent in
respect to hugepage support.

With this patch every architecture is free to define how to check
for hugepage support.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-allow-hugepages_supported-to-be-architecture-specific include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-allow-hugepages_supported-to-be-architecture-specific
+++ a/include/linux/hugetlb.h
@@ -460,15 +460,14 @@ static inline spinlock_t *huge_pte_lockp
 	return &mm->page_table_lock;
 }
 
-static inline bool hugepages_supported(void)
-{
-	/*
-	 * Some platform decide whether they support huge pages at boot
-	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
-	 * there is no such support
-	 */
-	return HPAGE_SHIFT != 0;
-}
+#ifndef hugepages_supported
+/*
+ * Some platform decide whether they support huge pages at boot
+ * time. Some of them, such as powerpc, set HPAGE_SHIFT to 0
+ * when there is no such support
+ */
+#define hugepages_supported() (HPAGE_SHIFT != 0)
+#endif
 
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
_

Patches currently in -mm which might be from dingel@linux.vnet.ibm.com are

revert-s390-mm-change-hpage_shift-type-to-int.patch
revert-s390-mm-make-hugepages_supported-a-boot-time-decision.patch
mm-hugetlb-allow-hugepages_supported-to-be-architecture-specific.patch
s390-hugetlb-add-hugepages_supported-define.patch


From: akpm@linux-foundation.org
Subject: + iova-lockdep-false-alarm-fix.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:31:57 -0800
Message-ID: <200802230732.m1N7Wk9i018097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbYBWHwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:52:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgross@linux.intel.com


The patch titled
     iova: lockdep false alarm fix
has been added to the -mm tree.  Its filename is
     iova-lockdep-false-alarm-fix.patch

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
Subject: iova: lockdep false alarm fix
From: mark gross <mgross@linux.intel.com>

lockdep goes off on the iova copy_reserved_iova() because it and a function
it calls grabs locks in the from, and the to of the copy operation.

This patch gives the reserved_ioval_list locks special lockdep classes.

Signed-off-by: <mgross@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/pci/intel-iommu.c~iova-lockdep-false-alarm-fix drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~iova-lockdep-false-alarm-fix
+++ a/drivers/pci/intel-iommu.c
@@ -1097,6 +1097,8 @@ static void iommu_free_domain(struct dma
 }
 
 static struct iova_domain reserved_iova_list;
+static struct lock_class_key reserved_alloc_key;
+static struct lock_class_key reserved_rbtree_key;
 
 static void dmar_init_reserved_ranges(void)
 {
@@ -1107,6 +1109,11 @@ static void dmar_init_reserved_ranges(vo
 
 	init_iova_domain(&reserved_iova_list, DMA_32BIT_PFN);
 
+	lockdep_set_class(&reserved_iova_list.iova_alloc_lock,
+		&reserved_alloc_key);
+	lockdep_set_class(&reserved_iova_list.iova_rbtree_lock,
+		&reserved_rbtree_key);
+
 	/* IOAPIC ranges shouldn't be accessed by DMA */
 	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
 		IOVA_PFN(IOAPIC_RANGE_END));
_

Patches currently in -mm which might be from mgross@linux.intel.com are

copyright-owner-and-author-clean-up-for-intel-iommu-and-related-files.patch
pci-iova-rb-tree-setup-tweak.patch
iova-lockdep-false-alarm-fix.patch

From: akpm@linux-foundation.org
Subject: + iova-lockdep-false-alarm-fix.patch added to -mm tree
Date: Mon, 25 Feb 2008 10:32:40 -0800
Message-ID: <200802251833.m1PIXVSu013371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755686AbYBYSe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 13:34:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgross@linux.intel.com, greg@kroah.com


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

The function grab locks of the same lock classes triggering the warning.  The
first lock grabbed is for the constant reserved areas that is never accessed
after early boot.  Technically you could do without grabbing the locks for the
"from" structure its copying reserved areas from.

But dropping the from locks to me looks wrong, even though it would be ok.

The affected code only runs in early boot as its setting up the DMAR
engines.

This patch gives the reserved_ioval_list locks special lockdep classes.

Signed-off-by: <mgross@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
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

pci-iova-rb-tree-setup-tweak.patch
iova-lockdep-false-alarm-fix.patch

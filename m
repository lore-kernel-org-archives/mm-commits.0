From: akpm@linux-foundation.org
Subject: [merged] edac-add-edac_pci_alloc_index.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:49 -0700
Message-ID: <200904061936.n36Janml012663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804AbZDFUG0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:06:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qingtao.cao@windriver.com, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     edac: Add edac_pci_alloc_index()
has been removed from the -mm tree.  Its filename was
     edac-add-edac_pci_alloc_index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: Add edac_pci_alloc_index()
From: Harry Ciao <qingtao.cao@windriver.com>

Add edac_pci_alloc_index(), because for MAPLE platform there may exist
several EDAC driver modules that could make use of edac_pci_ctl_info
structure at the same time.  The index allocation for these structures
should be taken care of by EDAC core.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h |    1 +
 drivers/edac/edac_pci.c  |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff -puN drivers/edac/edac_core.h~edac-add-edac_pci_alloc_index drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~edac-add-edac_pci_alloc_index
+++ a/drivers/edac/edac_core.h
@@ -844,6 +844,7 @@ extern void edac_pci_free_ctl_info(struc
 extern void edac_pci_reset_delay_period(struct edac_pci_ctl_info *pci,
 				unsigned long value);
 
+extern int edac_pci_alloc_index(void);
 extern int edac_pci_add_device(struct edac_pci_ctl_info *pci, int edac_idx);
 extern struct edac_pci_ctl_info *edac_pci_del_device(struct device *dev);
 
diff -puN drivers/edac/edac_pci.c~edac-add-edac_pci_alloc_index drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~edac-add-edac_pci_alloc_index
+++ a/drivers/edac/edac_pci.c
@@ -30,6 +30,7 @@
 
 static DEFINE_MUTEX(edac_pci_ctls_mutex);
 static LIST_HEAD(edac_pci_list);
+static atomic_t pci_indexes = ATOMIC_INIT(0);
 
 /*
  * edac_pci_alloc_ctl_info
@@ -318,6 +319,19 @@ void edac_pci_reset_delay_period(struct 
 EXPORT_SYMBOL_GPL(edac_pci_reset_delay_period);
 
 /*
+ * edac_pci_alloc_index: Allocate a unique PCI index number
+ *
+ * Return:
+ *      allocated index number
+ *
+ */
+int edac_pci_alloc_index(void)
+{
+	return atomic_inc_return(&pci_indexes) - 1;
+}
+EXPORT_SYMBOL_GPL(edac_pci_alloc_index);
+
+/*
  * edac_pci_add_device: Insert the 'edac_dev' structure into the
  * edac_pci global list and create sysfs entries associated with
  * edac_pci structure.
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

origin.patch


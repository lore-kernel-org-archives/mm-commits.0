From: akpm@linux-foundation.org
Subject: [merged] edac-add-edac_device_alloc_index.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:51 -0700
Message-ID: <200906182247.n5IMlpOq006985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759184AbZFRWsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qingtao.cao@windriver.com, benh@kernel.crashing.org, galak@gate.crashing.org, michael@ellerman.id.au, norsk5@yahoo.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     edac: add edac_device_alloc_index()
has been removed from the -mm tree.  Its filename was
     edac-add-edac_device_alloc_index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: add edac_device_alloc_index()
From: Harry Ciao <qingtao.cao@windriver.com>

Add edac_device_alloc_index(), because for MAPLE platform there may
exist several EDAC driver modules that could make use of
edac_device_ctl_info structure at the same time. The index allocation
for these structures should be taken care of by EDAC core.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd8111_edac.c |    3 +--
 drivers/edac/edac_core.h    |    1 +
 drivers/edac/edac_device.c  |   14 ++++++++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff -puN drivers/edac/amd8111_edac.c~edac-add-edac_device_alloc_index drivers/edac/amd8111_edac.c
--- a/drivers/edac/amd8111_edac.c~edac-add-edac_device_alloc_index
+++ a/drivers/edac/amd8111_edac.c
@@ -37,7 +37,6 @@
 #define AMD8111_EDAC_MOD_STR	"amd8111_edac"
 
 #define PCI_DEVICE_ID_AMD_8111_PCI	0x7460
-static int edac_dev_idx;
 
 enum amd8111_edac_devs {
 	LPC_BRIDGE = 0,
@@ -377,7 +376,7 @@ static int amd8111_dev_probe(struct pci_
 	 * edac_device_ctl_info, but make use of existing
 	 * one instead.
 	*/
-	dev_info->edac_idx = edac_dev_idx++;
+	dev_info->edac_idx = edac_device_alloc_index();
 	dev_info->edac_dev =
 		edac_device_alloc_ctl_info(0, dev_info->ctl_name, 1,
 					   NULL, 0, 0,
diff -puN drivers/edac/edac_core.h~edac-add-edac_device_alloc_index drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~edac-add-edac_device_alloc_index
+++ a/drivers/edac/edac_core.h
@@ -841,6 +841,7 @@ extern void edac_device_handle_ue(struct
 				int inst_nr, int block_nr, const char *msg);
 extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
 				int inst_nr, int block_nr, const char *msg);
+extern int edac_device_alloc_index(void);
 
 /*
  * edac_pci APIs
diff -puN drivers/edac/edac_device.c~edac-add-edac_device_alloc_index drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~edac-add-edac_device_alloc_index
+++ a/drivers/edac/edac_device.c
@@ -490,6 +490,20 @@ void edac_device_reset_delay_period(stru
 	mutex_unlock(&device_ctls_mutex);
 }
 
+/*
+ * edac_device_alloc_index: Allocate a unique device index number
+ *
+ * Return:
+ *	allocated index number
+ */
+int edac_device_alloc_index(void)
+{
+	static atomic_t device_indexes = ATOMIC_INIT(0);
+
+	return atomic_inc_return(&device_indexes) - 1;
+}
+EXPORT_SYMBOL_GPL(edac_device_alloc_index);
+
 /**
  * edac_device_add_device: Insert the 'edac_dev' structure into the
  * edac_device global list and create sysfs entries associated with
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

origin.patch


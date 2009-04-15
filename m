From: akpm@linux-foundation.org
Subject: + edac-add-edac_device_alloc_index.patch added to -mm tree
Date: Wed, 15 Apr 2009 15:27:44 -0700
Message-ID: <200904152227.n3FMRi1i007177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756355AbZDOWck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 18:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qingtao.cao@windriver.com, benh@kernel.crashing.org, galak@gate.crashing.org, michael@ellerman.id.au, norsk5@yahoo.com, paulus@samba.org


The patch titled
     edac: add edac_device_alloc_index()
has been added to the -mm tree.  Its filename is
     edac-add-edac_device_alloc_index.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: add edac_device_alloc_index()
From: Harry Ciao <qingtao.cao@windriver.com>

Add edac_device_alloc_index(), because for MAPLE platform there may
exist several EDAC driver modules that could make use of
edac_device_ctl_info structure at the same time. The index allocation
for these structures should be taken care of by EDAC core.

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
 drivers/edac/edac_device.c  |   13 +++++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

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
@@ -840,6 +840,7 @@ extern void edac_device_handle_ue(struct
 				int inst_nr, int block_nr, const char *msg);
 extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
 				int inst_nr, int block_nr, const char *msg);
+extern int edac_device_alloc_index(void);
 
 /*
  * edac_pci APIs
diff -puN drivers/edac/edac_device.c~edac-add-edac_device_alloc_index drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~edac-add-edac_device_alloc_index
+++ a/drivers/edac/edac_device.c
@@ -37,6 +37,7 @@
  */
 static DEFINE_MUTEX(device_ctls_mutex);
 static LIST_HEAD(edac_device_list);
+static atomic_t device_indexes = ATOMIC_INIT(0);
 
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
@@ -490,6 +491,18 @@ void edac_device_reset_delay_period(stru
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
+	return atomic_inc_return(&device_indexes) - 1;
+}
+EXPORT_SYMBOL_GPL(edac_device_alloc_index);
+
 /**
  * edac_device_add_device: Insert the 'edac_dev' structure into the
  * edac_device global list and create sysfs entries associated with
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

edac-add-cpc925-memory-controller-driver.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-cpc925-mc-platform-device-setup.patch


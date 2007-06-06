From: akpm@linux-foundation.org
Subject: + drivers-edac-add-edac_mc_find-api.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:50:25 -0700
Message-ID: <200706060150.l561oPgX007400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933298AbXFFBuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     drivers-edac: add edac_mc_find API
has been added to the -mm tree.  Its filename is
     drivers-edac-add-edac_mc_find-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: add edac_mc_find API
From: Douglas Thompson <dougthompson@xmission.com>

This simple patch adds an important CORE API for EDAC that EDAC drivers can
use to find their edac_mc control structure by passing a mem_ctl_info
'instance' value

Needed for subsequent patches

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc.c |   28 ++++++++++++++++++++++++++++
 drivers/edac/edac_mc.h |    1 +
 2 files changed, 29 insertions(+)

diff -puN drivers/edac/edac_mc.c~drivers-edac-add-edac_mc_find-api drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-add-edac_mc_find-api
+++ a/drivers/edac/edac_mc.c
@@ -1457,6 +1457,34 @@ static void del_mc_from_global_list(stru
 }
 
 /**
+ * edac_mc_find: Search for a mem_ctl_info structure whose index is 'idx'.
+ *
+ * If found, return a pointer to the structure.
+ * Else return NULL.
+ *
+ * Caller must hold mem_ctls_mutex.
+ */
+struct mem_ctl_info * edac_mc_find(int idx)
+{
+	struct list_head *item;
+	struct mem_ctl_info *mci;
+
+	list_for_each(item, &mc_devices) {
+		mci = list_entry(item, struct mem_ctl_info, link);
+
+		if (mci->mc_idx >= idx) {
+			if (mci->mc_idx == idx)
+				return mci;
+
+			break;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(edac_mc_find);
+
+/**
  * edac_mc_add_mc: Insert the 'mci' structure into the mci global list and
  *                 create sysfs entries associated with mci structure
  * @mci: pointer to the mci structure to be added to the list
diff -puN drivers/edac/edac_mc.h~drivers-edac-add-edac_mc_find-api drivers/edac/edac_mc.h
--- a/drivers/edac/edac_mc.h~drivers-edac-add-edac_mc_find-api
+++ a/drivers/edac/edac_mc.h
@@ -430,6 +430,7 @@ void edac_mc_dump_mci(struct mem_ctl_inf
 void edac_mc_dump_csrow(struct csrow_info *csrow);
 #endif  /* CONFIG_EDAC_DEBUG */
 
+extern struct mem_ctl_info * edac_mc_find(int idx);
 extern int edac_mc_add_mc(struct mem_ctl_info *mci,int mc_idx);
 extern struct mem_ctl_info * edac_mc_del_mc(struct device *dev);
 extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
_

Patches currently in -mm which might be from dougthompson@xmission.com are

drivers-edac-remove-depends-on-x86.patch
drivers-edac-add-edac_mc_find-api.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-mod-use-edac_coreh.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-new-inte-30x0-mc-driver.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-edac_device-sysfs-cleanup.patch
drivers-edac-cleanup-workq-ifdefs.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
drivers-edac-add-device-sysfs-attributes.patch
drivers-edac-device-output-clenaup.patch
drivers-edac-add-info-kconfig.patch
drivers-edac-update-maintainers-files-for-edac.patch
drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch

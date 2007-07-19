From: akpm@linux-foundation.org
Subject: - drivers-edac-add-edac_mc_find-api.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:05:11 -0700
Message-ID: <200707192005.l6JK5BD9020022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757450AbXGSUPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: add edac_mc_find API
has been removed from the -mm tree.  Its filename was
     drivers-edac-add-edac_mc_find-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: add edac_mc_find API
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

origin.patch

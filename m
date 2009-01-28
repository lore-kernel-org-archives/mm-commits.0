From: akpm@linux-foundation.org
Subject: [merged] fix-longstanding-error-storage-size-of-__mod_dmi_device_table-isnt-known.patch removed from -mm tree
Date: Wed, 28 Jan 2009 15:29:01 -0800
Message-ID: <200901282329.n0SNT1Dg007022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757490AbZA1X3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 18:29:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Fix longstanding "error: storage size of '__mod_dmi_device_table' isn't known"
has been removed from the -mm tree.  Its filename was
     fix-longstanding-error-storage-size-of-__mod_dmi_device_table-isnt-known.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix longstanding "error: storage size of '__mod_dmi_device_table' isn't known"
From: Alexey Dobriyan <adobriyan@gmail.com>

Needs human-understandable changelog.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mod_devicetable.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/mod_devicetable.h~fix-longstanding-error-storage-size-of-__mod_dmi_device_table-isnt-known include/linux/mod_devicetable.h
--- a/include/linux/mod_devicetable.h~fix-longstanding-error-storage-size-of-__mod_dmi_device_table-isnt-known
+++ a/include/linux/mod_devicetable.h
@@ -443,6 +443,13 @@ struct dmi_system_id {
 	struct dmi_strmatch matches[4];
 	void *driver_data;
 };
+/*
+ * struct dmi_device_id appears during expansion of
+ * "MODULE_DEVICE_TABLE(dmi, x)". Compiler doesn't look inside it
+ * but this is enough for gcc 3.4.6 to error out:
+ *	error: storage size of '__mod_dmi_device_table' isn't known
+ */
+#define dmi_device_id dmi_system_id
 #endif
 
 #define DMI_MATCH(a, b)	{ a, b }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
sm501-fix-section-mismatches.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
seq_file-move-traverse-so-it-can-be-used-from-seq_read.patch
seq_file-properly-cope-with-pread.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch


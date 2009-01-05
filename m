From: akpm@linux-foundation.org
Subject: - dmi-add-dmi_match.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:33 -0800
Message-ID: <200901050641.n056fXYU005556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbZAEGmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:42:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, a_romanescu@yahoo.co.uk, alan@lxorguk.ukuu.org.uk, jgarzik@redhat.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     dmi: add dmi_match
has been removed from the -mm tree.  Its filename was
     dmi-add-dmi_match.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmi: add dmi_match
From: Jiri Slaby <jirislaby@gmail.com>

Add a wrapper for testing system_info which will handle also NULL system
infos.

This will be used by the ata PIIX driver.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Alexandru Romanescu <a_romanescu@yahoo.co.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   16 ++++++++++++++++
 include/linux/dmi.h         |    3 +++
 2 files changed, 19 insertions(+)

diff -puN drivers/firmware/dmi_scan.c~dmi-add-dmi_match drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi-add-dmi_match
+++ a/drivers/firmware/dmi_scan.c
@@ -582,3 +582,19 @@ int dmi_walk(void (*decode)(const struct
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dmi_walk);
+
+/**
+ * dmi_match - compare a string to the dmi field (if exists)
+ *
+ * Returns true if the requested field equals to the str (including NULL).
+ */
+bool dmi_match(enum dmi_field f, const char *str)
+{
+	const char *info = dmi_get_system_info(f);
+
+	if (info == NULL || str == NULL)
+		return info == str;
+
+	return !strcmp(info, str);
+}
+EXPORT_SYMBOL_GPL(dmi_match);
diff -puN include/linux/dmi.h~dmi-add-dmi_match include/linux/dmi.h
--- a/include/linux/dmi.h~dmi-add-dmi_match
+++ a/include/linux/dmi.h
@@ -47,6 +47,7 @@ extern int dmi_name_in_vendors(const cha
 extern int dmi_name_in_serial(const char *str);
 extern int dmi_available;
 extern int dmi_walk(void (*decode)(const struct dmi_header *));
+extern bool dmi_match(enum dmi_field f, const char *str);
 
 #else
 
@@ -61,6 +62,8 @@ static inline int dmi_name_in_serial(con
 #define dmi_available 0
 static inline int dmi_walk(void (*decode)(const struct dmi_header *))
 	{ return -1; }
+static inline bool dmi_match(enum dmi_field f, const char *str)
+	{ return false; }
 
 #endif
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
8250_pci-add-support-for-netmos-9835.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch


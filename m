From: akpm@linux-foundation.org
Subject: - dmi-add-dmi_match.patch removed from -mm tree
Date: Thu, 11 Dec 2008 12:53:51 -0800
Message-ID: <200812112053.mBBKrpqS009207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260AbYLKUyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 15:54:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, a_romanescu@yahoo.co.uk, alan@lxorguk.ukuu.org.uk, jgarzik@redhat.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     DMI: add dmi_match
has been removed from the -mm tree.  Its filename was
     dmi-add-dmi_match.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: DMI: add dmi_match
From: Jiri Slaby <jirislaby@gmail.com>

Add a wrapper for testing system_info which will handle also NULL system
infos.

This will be used by the ata PIIX driver.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Alexandru Romanescu <a_romanescu@yahoo.co.uk>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dmi.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN include/linux/dmi.h~dmi-add-dmi_match include/linux/dmi.h
--- a/include/linux/dmi.h~dmi-add-dmi_match
+++ a/include/linux/dmi.h
@@ -48,6 +48,21 @@ extern int dmi_name_in_serial(const char
 extern int dmi_available;
 extern int dmi_walk(void (*decode)(const struct dmi_header *));
 
+/**
+ * dmi_match - compare string to the dmi field (if exists)
+ *
+ * Returns true if requested field equals to str (including NULL).
+ */
+static inline bool dmi_match(enum dmi_field f, const char *str)
+{
+	const char *info = dmi_get_system_info(f);
+
+	if (info == NULL || str == NULL)
+		return info == str;
+
+	return !strcmp(info, str);
+}
+
 #else
 
 static inline int dmi_check_system(const struct dmi_system_id *list) { return 0; }
@@ -61,6 +76,8 @@ static inline int dmi_name_in_serial(con
 #define dmi_available 0
 static inline int dmi_walk(void (*decode)(const struct dmi_header *))
 	{ return -1; }
+static inline bool dmi_match(enum dmi_field f, const char *str)
+	{ return false; }
 
 #endif
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
8250_pci-add-support-for-netmos-9835.patch
dmi-add-dmi_match.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch


From: akpm@linux-foundation.org
Subject: + dmi-add-dmi_match.patch added to -mm tree
Date: Thu, 11 Dec 2008 12:29:19 -0800
Message-ID: <200812112029.mBBKTJWl025224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755003AbYLKUae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 15:30:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, a_romanescu@yahoo.co.uk, alan@lxorguk.ukuu.org.uk, jgarzik@redhat.com, tj@kernel.org


The patch titled
     DMI: add dmi_match
has been added to the -mm tree.  Its filename is
     dmi-add-dmi_match.patch

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


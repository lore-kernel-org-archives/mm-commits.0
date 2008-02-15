From: akpm@linux-foundation.org
Subject: + convert-wpa_sem-in-a-mutex.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:24:32 -0800
Message-ID: <200802152124.m1FLOWVs024708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760556AbYBOV0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:26:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias@kaehlcke.net, flamingice@sourmilk.net, linville@tuxdriver.com


The patch titled
     prism54: convert wpa_sem in a mutex
has been added to the -mm tree.  Its filename is
     convert-wpa_sem-in-a-mutex.patch

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
Subject: prism54: convert wpa_sem in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore wpa_sem is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/prism54/isl_ioctl.c  |   10 +++++-----
 drivers/net/wireless/prism54/islpci_dev.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/net/wireless/prism54/isl_ioctl.c~convert-wpa_sem-in-a-mutex drivers/net/wireless/prism54/isl_ioctl.c
--- a/drivers/net/wireless/prism54/isl_ioctl.c~convert-wpa_sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/isl_ioctl.c
@@ -2114,7 +2114,7 @@ prism54_wpa_bss_ie_add(islpci_private *p
 	if (wpa_ie_len > MAX_WPA_IE_LEN)
 		wpa_ie_len = MAX_WPA_IE_LEN;
 
-	down(&priv->wpa_sem);
+	mutex_lock(&priv->wpa_lock);
 
 	/* try to use existing entry */
 	list_for_each(ptr, &priv->bss_wpa_list) {
@@ -2165,7 +2165,7 @@ prism54_wpa_bss_ie_add(islpci_private *p
 		kfree(bss);
 	}
 
-	up(&priv->wpa_sem);
+	mutex_unlock(&priv->wpa_lock);
 }
 
 static size_t
@@ -2175,7 +2175,7 @@ prism54_wpa_bss_ie_get(islpci_private *p
 	struct islpci_bss_wpa_ie *bss = NULL;
 	size_t len = 0;
 
-	down(&priv->wpa_sem);
+	mutex_lock(&priv->wpa_lock);
 
 	list_for_each(ptr, &priv->bss_wpa_list) {
 		bss = list_entry(ptr, struct islpci_bss_wpa_ie, list);
@@ -2187,7 +2187,7 @@ prism54_wpa_bss_ie_get(islpci_private *p
 		len = bss->wpa_ie_len;
 		memcpy(wpa_ie, bss->wpa_ie, len);
 	}
-	up(&priv->wpa_sem);
+	mutex_unlock(&priv->wpa_lock);
 
 	return len;
 }
@@ -2196,7 +2196,7 @@ void
 prism54_wpa_bss_ie_init(islpci_private *priv)
 {
 	INIT_LIST_HEAD(&priv->bss_wpa_list);
-	sema_init(&priv->wpa_sem, 1);
+	mutex_init(&priv->wpa_lock);
 }
 
 void
diff -puN drivers/net/wireless/prism54/islpci_dev.h~convert-wpa_sem-in-a-mutex drivers/net/wireless/prism54/islpci_dev.h
--- a/drivers/net/wireless/prism54/islpci_dev.h~convert-wpa_sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/islpci_dev.h
@@ -178,7 +178,7 @@ typedef struct {
 	int wpa; /* WPA mode enabled */
 	struct list_head bss_wpa_list;
 	int num_bss_wpa;
-	struct semaphore wpa_sem;
+	struct mutex wpa_lock;
 	u8 wpa_ie[MAX_WPA_IE_LEN];
 	size_t wpa_ie_len;
 
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

convert-acl-sem-in-a-mutex.patch
convert-stats_sem-in-a-mutex.patch
convert-wpa_sem-in-a-mutex.patch

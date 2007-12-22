From: akpm@linux-foundation.org
Subject: + prism54-remove-questionable-down_interruptible-usage.patch added to -mm tree
Date: Fri, 21 Dec 2007 20:16:15 -0800
Message-ID: <200712220416.lBM4GFCL016659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50240 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbXLVERg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 23:17:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, flamingice@sourmilk.net, linville@tuxdriver.com


The patch titled
     prism54: remove questionable down_interruptible usage
has been added to the -mm tree.  Its filename is
     prism54-remove-questionable-down_interruptible-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: prism54: remove questionable down_interruptible usage
From: Daniel Walker <dwalker@mvista.com>

Reviewing the semaphore usage I noticed these down_interruptible calls.  Most
of these aren't returning anything, so a caller can't tell if the operation
completed or not.  prism54_wpa_bss_ie_get() returns zero, but it's treated as
the function failing which doesn't seem correct.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/prism54/isl_ioctl.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/net/wireless/prism54/isl_ioctl.c~prism54-remove-questionable-down_interruptible-usage drivers/net/wireless/prism54/isl_ioctl.c
--- a/drivers/net/wireless/prism54/isl_ioctl.c~prism54-remove-questionable-down_interruptible-usage
+++ a/drivers/net/wireless/prism54/isl_ioctl.c
@@ -165,8 +165,7 @@ prism54_update_stats(struct work_struct 
 	struct obj_bss bss, *bss2;
 	union oid_res_t r;
 
-	if (down_interruptible(&priv->stats_sem))
-		return;
+	down(&priv->stats_sem);
 
 /* Noise floor.
  * I'm not sure if the unit is dBm.
@@ -1793,8 +1792,7 @@ prism54_clear_mac(struct islpci_acl *acl
 	struct list_head *ptr, *next;
 	struct mac_entry *entry;
 
-	if (down_interruptible(&acl->sem))
-		return;
+	down(&acl->sem);
 
 	if (acl->size == 0) {
 		up(&acl->sem);
@@ -2116,8 +2114,7 @@ prism54_wpa_bss_ie_add(islpci_private *p
 	if (wpa_ie_len > MAX_WPA_IE_LEN)
 		wpa_ie_len = MAX_WPA_IE_LEN;
 
-	if (down_interruptible(&priv->wpa_sem))
-		return;
+	down(&priv->wpa_sem);
 
 	/* try to use existing entry */
 	list_for_each(ptr, &priv->bss_wpa_list) {
@@ -2178,8 +2175,7 @@ prism54_wpa_bss_ie_get(islpci_private *p
 	struct islpci_bss_wpa_ie *bss = NULL;
 	size_t len = 0;
 
-	if (down_interruptible(&priv->wpa_sem))
-		return 0;
+	down(&priv->wpa_sem);
 
 	list_for_each(ptr, &priv->bss_wpa_list) {
 		bss = list_entry(ptr, struct islpci_bss_wpa_ie, list);
_

Patches currently in -mm which might be from dwalker@mvista.com are

ps3-vuart-fix-error-path-locking.patch
driver-base-memory-semaphore-to-mutex.patch
git-dvb.patch
usb-microtek-remove-unused-semaphore.patch
prism54-remove-questionable-down_interruptible-usage.patch
git-x86.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
docs-kernel-locking-convert-semaphore-references.patch
stopmachine-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex-fix.patch
amiga-serial-driver-port_write_mutex-fixup.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
docs-convert-kref-semaphore-to-mutex.patch

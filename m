From: akpm@osdl.org
Subject: - prism54-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:18:59 -0800
Message-ID: <200612072318.kB7NIxIH031074@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54106 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163954AbWLGXTX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:19:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: burman.yan@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     prism54: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     prism54-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: prism54: replace kmalloc+memset with kzalloc
From: Yan Burman <burman.yan@gmail.com>

Replace kmalloc+memset with kzalloc

Signed-off-by: Yan Burman <burman.yan@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/wireless/prism54/isl_ioctl.c |    9 +++------
 drivers/net/wireless/prism54/oid_mgt.c   |    4 +---
 2 files changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/net/wireless/prism54/isl_ioctl.c~prism54-replace-kmallocmemset-with-kzalloc drivers/net/wireless/prism54/isl_ioctl.c
--- a/drivers/net/wireless/prism54/isl_ioctl.c~prism54-replace-kmallocmemset-with-kzalloc
+++ a/drivers/net/wireless/prism54/isl_ioctl.c
@@ -2140,11 +2140,9 @@ prism54_wpa_bss_ie_add(islpci_private *p
 					 struct islpci_bss_wpa_ie, list);
 			list_del(&bss->list);
 		} else {
-			bss = kmalloc(sizeof (*bss), GFP_ATOMIC);
-			if (bss != NULL) {
+			bss = kzalloc(sizeof (*bss), GFP_ATOMIC);
+			if (bss != NULL)
 				priv->num_bss_wpa++;
-				memset(bss, 0, sizeof (*bss));
-			}
 		}
 		if (bss != NULL) {
 			memcpy(bss->bssid, bssid, ETH_ALEN);
@@ -2684,11 +2682,10 @@ prism2_ioctl_set_generic_element(struct 
                return -EINVAL;
 
        alen = sizeof(*attach) + len;
-       attach = kmalloc(alen, GFP_KERNEL);
+       attach = kzalloc(alen, GFP_KERNEL);
        if (attach == NULL)
                return -ENOMEM;
 
-       memset(attach, 0, alen);
 #define WLAN_FC_TYPE_MGMT 0
 #define WLAN_FC_STYPE_ASSOC_REQ 0
 #define WLAN_FC_STYPE_REASSOC_REQ 2
diff -puN drivers/net/wireless/prism54/oid_mgt.c~prism54-replace-kmallocmemset-with-kzalloc drivers/net/wireless/prism54/oid_mgt.c
--- a/drivers/net/wireless/prism54/oid_mgt.c~prism54-replace-kmallocmemset-with-kzalloc
+++ a/drivers/net/wireless/prism54/oid_mgt.c
@@ -235,12 +235,10 @@ mgt_init(islpci_private *priv)
 {
 	int i;
 
-	priv->mib = kmalloc(OID_NUM_LAST * sizeof (void *), GFP_KERNEL);
+	priv->mib = kcalloc(OID_NUM_LAST, sizeof (void *), GFP_KERNEL);
 	if (!priv->mib)
 		return -ENOMEM;
 
-	memset(priv->mib, 0, OID_NUM_LAST * sizeof (void *));
-
 	/* Alloc the cache */
 	for (i = 0; i < OID_NUM_LAST; i++) {
 		if (isl_oid[i].flags & OID_FLAG_CACHED) {
_

Patches currently in -mm which might be from burman.yan@gmail.com are

origin.patch
ia64-replace-kmallocmemset-with-kzalloc.patch
jffs2-replace-kmallocmemset-with-kzalloc.patch
nfsd-replace-kmallocmemset-with-kcalloc.patch


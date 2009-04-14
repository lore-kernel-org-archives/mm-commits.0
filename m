From: akpm@linux-foundation.org
Subject: + agnx-replace-print_mac-with-%pm.patch added to -mm tree
Date: Tue, 14 Apr 2009 16:53:41 -0700
Message-ID: <200904142353.n3ENrfqB004623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbZDNXza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 19:55:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, greg@kroah.com


The patch titled
     agnx: replace print_mac with %pM
has been added to the -mm tree.  Its filename is
     agnx-replace-print_mac-with-%pm.patch

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
Subject: agnx: replace print_mac with %pM
From: Alexander Beregalov <a.beregalov@gmail.com>

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/agnx/debug.h |    9 ++++-----
 drivers/staging/agnx/pci.c   |    8 +++-----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff -puN drivers/staging/agnx/debug.h~agnx-replace-print_mac-with-%pm drivers/staging/agnx/debug.h
--- a/drivers/staging/agnx/debug.h~agnx-replace-print_mac-with-%pm
+++ a/drivers/staging/agnx/debug.h
@@ -312,7 +312,6 @@ static inline void dump_ieee80211_hdr(st
 {
 	u16 fctl;
 	int hdrlen;
-	DECLARE_MAC_BUF(mac);
 
 	fctl = le16_to_cpu(hdr->frame_control);
 	switch (fctl & IEEE80211_FCTL_FTYPE) {
@@ -375,13 +374,13 @@ static inline void dump_ieee80211_hdr(st
 		printk("FC=0x%04x DUR=0x%04x",
 		       fctl, le16_to_cpu(hdr->duration_id));
 	if (hdrlen >= 10)
-		printk(" A1=%s", print_mac(mac, hdr->addr1));
+		printk(" A1=%pM", hdr->addr1);
 	if (hdrlen >= 16)
-		printk(" A2=%s", print_mac(mac, hdr->addr2));
+		printk(" A2=%pM", hdr->addr2);
 	if (hdrlen >= 24)
-		printk(" A3=%s", print_mac(mac, hdr->addr3));
+		printk(" A3=%pM", hdr->addr3);
 	if (hdrlen >= 30)
-		printk(" A4=%s", print_mac(mac, hdr->addr4));
+		printk(" A4=%pM", hdr->addr4);
 	printk("\n");
 }
 
diff -puN drivers/staging/agnx/pci.c~agnx-replace-print_mac-with-%pm drivers/staging/agnx/pci.c
--- a/drivers/staging/agnx/pci.c~agnx-replace-print_mac-with-%pm
+++ a/drivers/staging/agnx/pci.c
@@ -150,8 +150,7 @@ static int agnx_get_mac_address(struct a
 	*((u32 *)(priv->mac_addr + 2)) = cpu_to_le32(reg);
 
 	if (!is_valid_ether_addr(priv->mac_addr)) {
-		DECLARE_MAC_BUF(mbuf);
-		printk(KERN_WARNING PFX "read mac %s\n", print_mac(mbuf, priv->mac_addr));
+		printk(KERN_WARNING PFX "read mac %pM\n", priv->mac_addr);
 		printk(KERN_WARNING PFX "Invalid hwaddr! Using random hwaddr\n");
 		random_ether_addr(priv->mac_addr);
 	}
@@ -455,7 +454,6 @@ static int __devinit agnx_pci_probe(stru
 	u32 mem_addr0, mem_len0;
 	u32 mem_addr1, mem_len1;
 	int err;
-	DECLARE_MAC_BUF(mac);
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -559,8 +557,8 @@ static int __devinit agnx_pci_probe(stru
 	agnx_hw_reset(priv);
 
 
-	printk(PFX "%s: hwaddr %s, Rev 0x%02x\n", wiphy_name(dev->wiphy),
-	       print_mac(mac, dev->wiphy->perm_addr), priv->revid);
+	printk(PFX "%s: hwaddr %pM, Rev 0x%02x\n", wiphy_name(dev->wiphy),
+	       dev->wiphy->perm_addr, priv->revid);
 	return 0;
 
  err_iounmap:
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
linux-next.patch
agnx-replace-print_mac-with-%pm.patch
reiserfs-fix-printk-format-warning.patch


From: akpm@linux-foundation.org
Subject: + mac80211-fix-warning-created-by-bit.patch added to -mm tree
Date: Wed, 24 Oct 2007 16:27:49 -0700
Message-ID: <200710242327.l9ONRnX7017876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148AbXJXX3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 19:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, jgarzik@redhat.com, linville@tuxdriver.com


The patch titled
     mac80211: fix warning created by BIT()
has been added to the -mm tree.  Its filename is
     mac80211-fix-warning-created-by-bit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mac80211: fix warning created by BIT()
From: Jeff Garzik <jeff@garzik.org>

Now that BIT() forces unsigned long, this warning appears:

net/mac80211/ieee80211_sta.c: In function `ieee80211_rx_mgmt_assoc_resp':
net/mac80211/ieee80211_sta.c:1187: warning: format `%d' expects type `int', but argument 7 has type `long unsigned int'

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/ieee80211_sta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/mac80211/ieee80211_sta.c~mac80211-fix-warning-created-by-bit net/mac80211/ieee80211_sta.c
--- a/net/mac80211/ieee80211_sta.c~mac80211-fix-warning-created-by-bit
+++ a/net/mac80211/ieee80211_sta.c
@@ -1182,7 +1182,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
 
 	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=0x%x "
-	       "status=%d aid=%d)\n",
+	       "status=%d aid=%ld)\n",
 	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
 	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));
 
_

Patches currently in -mm which might be from jeff@garzik.org are

acpi-sbs-fix-retval-warning.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
git-wireless.patch
mac80211-fix-warning-created-by-bit.patch
x86-fix-config_smp-warning-in-processorc.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
isdn-sc-fix-longstanding-warning.patch

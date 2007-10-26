From: akpm@linux-foundation.org
Subject: - mac80211-fix-warning-created-by-bit.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:37:49 -0700
Message-ID: <200710261837.l9QIbnZ9008700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765554AbXJZSit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:38:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jgarzik@redhat.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: fix warning created by BIT()
has been removed from the -mm tree.  Its filename was
     mac80211-fix-warning-created-by-bit.patch

This patch was dropped because it is obsolete

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

origin.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
git-wireless.patch
mac80211-fix-warning-created-by-bit.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
permit-silencing-of-__deprecated-warnings.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-warnings-for-longstanding-conditions-checkpatch-fixes.patch
isdn-sc-fix-longstanding-warning.patch

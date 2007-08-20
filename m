From: akpm@linux-foundation.org
Subject: - fix-libata-warnings-with-config_pm=n.patch removed from -mm tree
Date: Mon, 20 Aug 2007 11:56:30 -0700
Message-ID: <200708201856.l7KIuUb5017660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756749AbXHTS44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 14:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nix.or.die@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Fix libata warnings with CONFIG_PM=n
has been removed from the -mm tree.  Its filename was
     fix-libata-warnings-with-config_pm=n.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Fix libata warnings with CONFIG_PM=n
From: Gabriel C <nix.or.die@googlemail.com>

drivers/ata/libata-core.c:5993: warning: 'ata_host_disable_link_pm' defined but not used
drivers/ata/libata-core.c:6004: warning: 'ata_host_enable_link_pm' defined but not used

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/ata/libata-core.c~fix-libata-warnings-with-config_pm=n drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~fix-libata-warnings-with-config_pm=n
+++ a/drivers/ata/libata-core.c
@@ -5923,6 +5923,7 @@ int ata_flush_cache(struct ata_device *d
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static void ata_host_disable_link_pm(struct ata_host *host)
 {
 	int i;
@@ -5944,7 +5945,7 @@ static void ata_host_enable_link_pm(stru
 	}
 }
 
-#ifdef CONFIG_PM
+
 static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
 			       int wait)
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

git-powerpc.patch
git-kvm.patch
fix-libata-warnings-with-config_pm=n.patch
git-scsi-misc.patch
drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch

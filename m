From: akpm@linux-foundation.org
Subject: + fix-libata-warnings-with-config_pm=n.patch added to -mm tree
Date: Mon, 30 Jul 2007 13:33:23 -0700
Message-ID: <200707302033.l6UKXN7v029198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33038 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965885AbXG3Ud7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 16:33:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nix.or.die@googlemail.com


The patch titled
     Fix libata warnings with CONFIG_PM=n
has been added to the -mm tree.  Its filename is
     fix-libata-warnings-with-config_pm=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -5991,6 +5991,7 @@ int ata_flush_cache(struct ata_device *d
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static void ata_host_disable_link_pm(struct ata_host *host)
 {
 	int i;
@@ -6013,7 +6014,7 @@ static void ata_host_enable_link_pm(stru
 	}
 }
 
-#ifdef CONFIG_PM
+
 static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
 			       int wait)
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

origin.patch
fix-libata-warnings-with-config_pm=n.patch
drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
broken-lilo-check-on-make-install.patch
typo-fixes-errror-error.patch

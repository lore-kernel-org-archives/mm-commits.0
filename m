From: akpm@linux-foundation.org
Subject: + mmc-fix-section-mismatch-warnings-for-drivers-mmc-host.patch added to -mm tree
Date: Mon, 06 Aug 2007 12:25:35 -0700
Message-ID: <200708061925.l76JPZ57010776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752AbXHFT0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 15:26:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nix.or.die@googlemail.com, drzeus@drzeus.cx, sam@ravnborg.org


The patch titled
     mmc: fix section mismatch warnings for drivers/mmc/host
has been added to the -mm tree.  Its filename is
     mmc-fix-section-mismatch-warnings-for-drivers-mmc-host.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mmc: fix section mismatch warnings for drivers/mmc/host
From: Gabriel C <nix.or.die@googlemail.com>


WARNING: vmlinux.o(.init.text+0x29d40): Section mismatch: reference to .exit.text:wbsd_release_resources (between 'wbsd_init' and 'wbsd_probe')
WARNING: vmlinux.o(.init.text+0x29d49): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')
WARNING: vmlinux.o(.init.text+0x29f28): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/wbsd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/host/wbsd.c~mmc-fix-section-mismatch-warnings-for-drivers-mmc-host drivers/mmc/host/wbsd.c
--- a/drivers/mmc/host/wbsd.c~mmc-fix-section-mismatch-warnings-for-drivers-mmc-host
+++ a/drivers/mmc/host/wbsd.c
@@ -1265,7 +1265,7 @@ static int __devinit wbsd_alloc_mmc(stru
 	return 0;
 }
 
-static void __devexit wbsd_free_mmc(struct device *dev)
+static void wbsd_free_mmc(struct device *dev)
 {
 	struct mmc_host *mmc;
 	struct wbsd_host *host;
@@ -1357,7 +1357,7 @@ static int __devinit wbsd_request_region
 	return 0;
 }
 
-static void __devexit wbsd_release_regions(struct wbsd_host *host)
+static void wbsd_release_regions(struct wbsd_host *host)
 {
 	if (host->base)
 		release_region(host->base, 8);
@@ -1433,7 +1433,7 @@ err:
 		"Falling back on FIFO.\n", dma);
 }
 
-static void __devexit wbsd_release_dma(struct wbsd_host *host)
+static void wbsd_release_dma(struct wbsd_host *host)
 {
 	if (host->dma_addr) {
 		dma_unmap_single(mmc_dev(host->mmc), host->dma_addr,
@@ -1483,7 +1483,7 @@ static int __devinit wbsd_request_irq(st
 	return 0;
 }
 
-static void __devexit wbsd_release_irq(struct wbsd_host *host)
+static void  wbsd_release_irq(struct wbsd_host *host)
 {
 	if (!host->irq)
 		return;
@@ -1534,7 +1534,7 @@ static int __devinit wbsd_request_resour
  * Release all resources for the host.
  */
 
-static void __devexit wbsd_release_resources(struct wbsd_host *host)
+static void wbsd_release_resources(struct wbsd_host *host)
 {
 	wbsd_release_dma(host);
 	wbsd_release_irq(host);
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

linux-audit-list-is-subscribers-only.patch
git-kvm.patch
fix-libata-warnings-with-config_pm=n.patch
mmc-fix-section-mismatch-warnings-for-drivers-mmc-host.patch
drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch

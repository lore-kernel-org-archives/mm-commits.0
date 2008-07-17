From: akpm@linux-foundation.org
Subject: + ath5k-suspend-resume-fixes.patch added to -mm tree
Date: Wed, 16 Jul 2008 17:11:54 -0700
Message-ID: <200807170011.m6H0BtgP020946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbYGQAL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 20:11:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, jbarnes@virtuousgeek.org, mcgrof@gmail.com, mickflemm@gmail.com


The patch titled
     ath5k: suspend/resume fixes
has been added to the -mm tree.  Its filename is
     ath5k-suspend-resume-fixes.patch

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
Subject: ath5k: suspend/resume fixes
From: Jiri Slaby <jirislaby@gmail.com>

- free and re-request irq since it might have changed during suspend
- disable and enable msi
- don't set D0 state of the device, it's already done by the PCI layer
- do restore_state before enable_device, it's safer
- check ath5k_init return value

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN drivers/net/wireless/ath5k/base.c~ath5k-suspend-resume-fixes drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~ath5k-suspend-resume-fixes
+++ a/drivers/net/wireless/ath5k/base.c
@@ -592,6 +592,9 @@ ath5k_pci_suspend(struct pci_dev *pdev, 
 	ath5k_led_off(sc);
 
 	ath5k_stop_hw(sc);
+
+	free_irq(pdev->irq, sc);
+	pci_disable_msi(pdev);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
@@ -607,15 +610,12 @@ ath5k_pci_resume(struct pci_dev *pdev)
 	struct ath5k_hw *ah = sc->ah;
 	int i, err;
 
-	err = pci_set_power_state(pdev, PCI_D0);
-	if (err)
-		return err;
+	pci_restore_state(pdev);
 
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
 
-	pci_restore_state(pdev);
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to
 	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
@@ -623,7 +623,17 @@ ath5k_pci_resume(struct pci_dev *pdev)
 	 */
 	pci_write_config_byte(pdev, 0x41, 0);
 
-	ath5k_init(sc);
+	pci_enable_msi(pdev);
+
+	err = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
+	if (err) {
+		ATH5K_ERR(sc, "request_irq failed\n");
+		goto err_msi;
+	}
+
+	err = ath5k_init(sc);
+	if (err)
+		goto err_irq;
 	ath5k_led_enable(sc);
 
 	/*
@@ -637,6 +647,12 @@ ath5k_pci_resume(struct pci_dev *pdev)
 		ath5k_hw_reset_key(ah, i);
 
 	return 0;
+err_irq:
+	free_irq(pdev->irq, sc);
+err_msi:
+	pci_disable_msi(pdev);
+	pci_disable_device(pdev);
+	return err;
 }
 #endif /* CONFIG_PM */
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
ath5k-fix-memory-corruption.patch
ath5k-kill-tasklets-on-shutdown.patch
ath5k-flush-work.patch
ath5k-fix-dma-operation.patch
ath5k-suspend-resume-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
char-isicom-enable-disable-pci-device.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch
drivers-misc-phantom-note-pci.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch


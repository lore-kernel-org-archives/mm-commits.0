From: akpm@linux-foundation.org
Subject: + rt2860-possible-null-dereferences.patch added to -mm tree
Date: Wed, 02 Sep 2009 15:59:22 -0700
Message-ID: <200909022259.n82MxMN9011262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987AbZIBW7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 18:59:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, bzolnier@gmail.com, devel@driverdev.osuosl.org


The patch titled
     rt2860: possible NULL dereferences
has been added to the -mm tree.  Its filename is
     rt2860-possible-null-dereferences.patch

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
Subject: rt2860: possible NULL dereferences
From: Roel Kluin <roel.kluin@gmail.com>

Allocations may fail, prevent NULL dereferences.

Remaining bug: in drivers/staging/rt2860/rt_main_dev.c rt28xx_probe()
`handle' isn't freed in the case of later errors.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: <devel@driverdev.osuosl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rt2860/common/ba_action.c |    4 ++++
 drivers/staging/rt2860/common/cmm_data.c  |    2 ++
 drivers/staging/rt2860/rt_main_dev.c      |    2 ++
 3 files changed, 8 insertions(+)

diff -puN drivers/staging/rt2860/common/ba_action.c~rt2860-possible-null-dereferences drivers/staging/rt2860/common/ba_action.c
--- a/drivers/staging/rt2860/common/ba_action.c~rt2860-possible-null-dereferences
+++ a/drivers/staging/rt2860/common/ba_action.c
@@ -867,6 +867,8 @@ VOID BAOriSessionTearDown(
 			// force send specified TID DelBA
 			MLME_DELBA_REQ_STRUCT   DelbaReq;
 			MLME_QUEUE_ELEM *Elem = (MLME_QUEUE_ELEM *) kmalloc(sizeof(MLME_QUEUE_ELEM), MEM_ALLOC_FLAG);
+			if (Elem == NULL)
+				return;
 
 			NdisZeroMemory(&DelbaReq, sizeof(DelbaReq));
 			NdisZeroMemory(Elem, sizeof(MLME_QUEUE_ELEM));
@@ -900,6 +902,8 @@ VOID BAOriSessionTearDown(
 	{
 		MLME_DELBA_REQ_STRUCT   DelbaReq;
 		MLME_QUEUE_ELEM *Elem = (MLME_QUEUE_ELEM *) kmalloc(sizeof(MLME_QUEUE_ELEM), MEM_ALLOC_FLAG);
+		if (Elem == NULL)
+			return;
 
 		NdisZeroMemory(&DelbaReq, sizeof(DelbaReq));
 		NdisZeroMemory(Elem, sizeof(MLME_QUEUE_ELEM));
diff -puN drivers/staging/rt2860/common/cmm_data.c~rt2860-possible-null-dereferences drivers/staging/rt2860/common/cmm_data.c
--- a/drivers/staging/rt2860/common/cmm_data.c~rt2860-possible-null-dereferences
+++ a/drivers/staging/rt2860/common/cmm_data.c
@@ -2011,6 +2011,8 @@ UINT deaggregate_AMSDU_announce(
 		{
 		    // avoid local heap overflow, use dyanamic allocation
 		   MLME_QUEUE_ELEM *Elem = (MLME_QUEUE_ELEM *) kmalloc(sizeof(MLME_QUEUE_ELEM), MEM_ALLOC_FLAG);
+		   if (Elem == NULL)
+			return;
 		   memmove(Elem->Msg+(LENGTH_802_11 + LENGTH_802_1_H), pPayload, PayloadSize);
 		   Elem->MsgLen = LENGTH_802_11 + LENGTH_802_1_H + PayloadSize;
 		   WpaEAPOLKeyAction(pAd, Elem);
diff -puN drivers/staging/rt2860/rt_main_dev.c~rt2860-possible-null-dereferences drivers/staging/rt2860/rt_main_dev.c
--- a/drivers/staging/rt2860/rt_main_dev.c~rt2860-possible-null-dereferences
+++ a/drivers/staging/rt2860/rt_main_dev.c
@@ -777,6 +777,8 @@ INT __devinit   rt28xx_probe(
 
 	// Allocate RTMP_ADAPTER miniport adapter structure
 	handle = kmalloc(sizeof(struct os_cookie), GFP_KERNEL);
+	if (handle == NULL)
+		goto err_out_free_netdev;;
 	RT28XX_HANDLE_DEV_ASSIGN(handle, dev_p);
 
 	status = RTMPAllocAdapterBlock(handle, &pAd);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
x86-fix-x86_model-test-in-es7000_apic_is_cluster.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
octeon-false-positive-timeout.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
st-fix-test-of-value-range-in-st_set_options-fix.patch
comedi-null-dereference-of-amcc-in-v_pci_card_list_init.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
uml-fix-order-of-pud-and-pmd_free.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
hwmon-fix-freeing-of-gpio_data-and-irq.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch
gru-allocation-may-fail-in-quicktest1.patch
rt2860-possible-null-dereferences.patch


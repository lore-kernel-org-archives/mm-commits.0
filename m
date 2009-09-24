From: akpm@linux-foundation.org
Subject: [merged] gru-allocation-may-fail-in-quicktest1.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:12 -0700
Message-ID: <200909241937.n8OJbCbS004093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614AbZIXTl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:41:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: allocation may fail in quicktest1()
has been removed from the -mm tree.  Its filename was
     gru-allocation-may-fail-in-quicktest1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: allocation may fail in quicktest1()
From: Roel Kluin <roel.kluin@gmail.com>

The allocation may fail.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukservices.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/misc/sgi-gru/grukservices.c~gru-allocation-may-fail-in-quicktest1 drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-allocation-may-fail-in-quicktest1
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -937,6 +937,8 @@ static int quicktest1(unsigned long arg)
 
 	/* Need  1K cacheline aligned that does not cross page boundary */
 	p = kmalloc(4096, 0);
+	if (p == NULL)
+		return -ENOMEM;
 	mq = ALIGNUP(p, 1024);
 	memset(mes, 0xee, sizeof(mes));
 	dw = mq;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
hfc_usb-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
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
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch


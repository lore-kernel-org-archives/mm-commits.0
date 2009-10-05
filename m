From: akpm@linux-foundation.org
Subject: [merged] cyclades-read-buffer-overflow.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:20 -0700
Message-ID: <200910051839.n95IdKVP018875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754713AbZJESj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cyclades: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     cyclades-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cyclades: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

irq is declared with size NR_CARDS (4), but the loop containing this
segment runs up until NR_ISA_ADDRS (16), possibly reading from irq[i] (and
trying to use the result)

Identified by the Parfait static scanner.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/cyclades.c~cyclades-read-buffer-overflow drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~cyclades-read-buffer-overflow
+++ a/drivers/char/cyclades.c
@@ -3354,7 +3354,7 @@ static int __init cy_detect_isa(void)
 			continue;
 		}
 #ifdef MODULE
-		if (isparam && irq[i])
+		if (isparam && i < NR_CARDS && irq[i])
 			cy_isa_irq = irq[i];
 		else
 #endif
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hfc_usb-fix-read-buffer-overflow.patch
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
random-kmalloc-failure-ignored-in-init_std_data.patch


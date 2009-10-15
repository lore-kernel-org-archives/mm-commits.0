From: akpm@linux-foundation.org
Subject: [merged] net-hamradio-fix-test-in-receive.patch removed from -mm tree
Date: Thu, 15 Oct 2009 11:43:34 -0700
Message-ID: <200910151843.n9FIhYPa023383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935257AbZJOSok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 14:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, davem@davemloft.net, t.sailer@alumni.ethz.ch, mm-commits@vger.kernel.org


The patch titled
     net/hamradio: fix test in receive()
has been removed from the -mm tree.  Its filename was
     net-hamradio-fix-test-in-receive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/hamradio: fix test in receive()
From: Roel Kluin <roel.kluin@gmail.com>

The negation makes it a bool before the comparison and hence it will never
evaluate to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hamradio/baycom_epp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/hamradio/baycom_epp.c~net-hamradio-fix-test-in-receive drivers/net/hamradio/baycom_epp.c
--- a/drivers/net/hamradio/baycom_epp.c~net-hamradio-fix-test-in-receive
+++ a/drivers/net/hamradio/baycom_epp.c
@@ -597,7 +597,8 @@ static int receive(struct net_device *de
 						state = 0;
 
 					/* not flag received */
-					else if (!(bitstream & (0x1fe << j)) != (0x0fc << j)) {
+					else if ((bitstream & (0x1fe << j)) !=
+							(0x0fc << j)) {
 						if (state)
 							do_rxpacket(dev);
 						bc->hdlcrx.bufcnt = 0;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
powernow-k8-fix-test-in-get_transition_latency.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hfc_usb-fix-read-buffer-overflow.patch
hisax-fix-test-in-waitforxfw.patch
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
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch


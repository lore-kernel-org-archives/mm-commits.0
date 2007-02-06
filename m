From: akpm@linux-foundation.org
Subject: - cxacru-store-all-device-status-information-and-report-it-when-atm_proc_read-is-called.patch removed from -mm tree
Date: Mon, 05 Feb 2007 16:40:00 -0800
Message-ID: <200702060041.l160f3eR005186@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41880 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965381AbXBFAlY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 19:41:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@arlott.org, greg@kroah.com, simon@fire.lp0.eu, mm-commits@vger.kernel.org


The patch titled
     cxacru: store all device status information and report it when atm_proc_read is called
has been removed from the -mm tree.  Its filename was
     cxacru-store-all-device-status-information-and-report-it-when-atm_proc_read-is-called.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: cxacru: store all device status information and report it when atm_proc_read is called
From: Simon Arlott <simon@arlott.org>

There is much more (useful) line status information than is output through
usbatm, this patch stores the status array and overrides atm_proc_read to
output all of it.

This change may affect users polling the /proc/net/atm/cxacru file for line
up/down status, however better status information is already provided through
INFO level printks.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/atm/cxacru.c |  144 +++++++++++++++++++++++++++++++++++++
 1 files changed, 144 insertions(+)

diff -puN drivers/usb/atm/cxacru.c~cxacru-store-all-device-status-information-and-report-it-when-atm_proc_read-is-called drivers/usb/atm/cxacru.c
--- a/drivers/usb/atm/cxacru.c~cxacru-store-all-device-status-information-and-report-it-when-atm_proc_read-is-called
+++ a/drivers/usb/atm/cxacru.c
@@ -159,6 +159,7 @@ struct cxacru_data {
 
 	int line_status;
 	struct delayed_work poll_work;
+	u32 cxinf_status[CXINF_MAX];
 
 	/* contol handles */
 	struct mutex cm_serialize;
@@ -170,6 +171,146 @@ struct cxacru_data {
 	struct completion snd_done;
 };
 
+static int cxacru_proc_read(struct usbatm_data *usbatm_instance,
+	struct atm_dev *atm_dev, loff_t * pos, char *page)
+{
+	struct cxacru_data *instance = usbatm_instance->driver_data;
+	u32 *cxinf = instance->cxinf_status;
+	int left = *pos;
+
+	if (!left--)
+		return sprintf(page, "# %s\n", usbatm_instance->description);
+
+	if (!left--) {
+		if (cxinf[CXINF_LINE_STATUS] == 5) {
+			return sprintf(page, "# UP %u/%u\n",
+				cxinf[CXINF_DOWNSTREAM_RATE],
+				cxinf[CXINF_UPSTREAM_RATE]);
+		} else {
+			return sprintf(page, "# DOWN\n");
+		}
+	}
+
+	if (!left--)
+		return sprintf(page, "MAC=%02x:%02x:%02x:%02x:%02x:%02x\n",
+					atm_dev->esi[0], atm_dev->esi[1],
+					atm_dev->esi[2], atm_dev->esi[3],
+					atm_dev->esi[4], atm_dev->esi[5]);
+
+	if (!left--)
+		switch (cxinf[CXINF_LINK_STATUS]) {
+		case 1: return sprintf(page, "LINK_STATUS=\"not connected\"\n");
+		case 2: return sprintf(page, "LINK_STATUS=\"connected\"\n");
+		case 3: return sprintf(page, "LINK_STATUS=\"lost\"\n");
+		default:
+			return sprintf(page, "LINK_STATUS=\"unknown (%u)\"\n",
+						cxinf[CXINF_LINK_STATUS]);
+		}
+
+	if (!left--)
+		switch (cxinf[CXINF_LINE_STATUS]) {
+		case 0: return sprintf(page, "LINE_STATUS=\"down\"\n");
+		case 1: return sprintf(page, "LINE_STATUS=\"attempting to activate\"\n");
+		case 2: return sprintf(page, "LINE_STATUS=\"training\"\n");
+		case 3: return sprintf(page, "LINE_STATUS=\"channel analysis\"\n");
+		case 4: return sprintf(page, "LINE_STATUS=\"exchange\"\n");
+		case 5: return sprintf(page, "LINE_STATUS=\"up\"\n");
+		case 6: return sprintf(page, "LINE_STATUS=\"waiting\"\n");
+		case 7: return sprintf(page, "LINE_STATUS=\"initialising\"\n");
+		default:
+			return sprintf(page, "LINE_STATUS=\"unknown (%u)\"\n",
+						cxinf[CXINF_LINE_STATUS]);
+		}
+
+	if (!left--)
+		return sprintf(page, "\n");
+
+	if (cxinf[CXINF_LINE_STATUS] == 5) /* up */
+		if (!left--)
+			return sprintf(page, "DOWNSTREAM_RATE=%u\n",
+					cxinf[CXINF_DOWNSTREAM_RATE]);
+	if (!left--)
+		return sprintf(page,
+			"DOWNSTREAM_SNR_MARGIN=%d.%02u\n"
+			"DOWNSTREAM_ATTENUATION=%d.%02u\n"
+			"DOWNSTREAM_BITS_PER_FRAME=%u\n"
+			"DOWNSTREAM_CRC_ERRORS=%u\n"
+			"DOWNSTREAM_FEC_ERRORS=%u\n"
+			"DOWNSTREAM_HEC_ERRORS=%u\n"
+			"\n",
+			cxinf[CXINF_DOWNSTREAM_SNR_MARGIN] / 100,
+			cxinf[CXINF_DOWNSTREAM_SNR_MARGIN] % 100,
+			cxinf[CXINF_DOWNSTREAM_ATTENUATION] / 100,
+			cxinf[CXINF_DOWNSTREAM_ATTENUATION] % 100,
+			cxinf[CXINF_DOWNSTREAM_BITS_PER_FRAME],
+			cxinf[CXINF_DOWNSTREAM_CRC_ERRORS],
+			cxinf[CXINF_DOWNSTREAM_FEC_ERRORS],
+			cxinf[CXINF_DOWNSTREAM_HEC_ERRORS]);
+
+	if (cxinf[CXINF_LINE_STATUS] == 5) /* up */
+		if (!left--)
+			return sprintf(page, "UPSTREAM_RATE=%u\n",
+					cxinf[CXINF_UPSTREAM_RATE]);
+	if (!left--)
+		return sprintf(page,
+			"UPSTREAM_SNR_MARGIN=%d.%02u\n"
+			"UPSTREAM_ATTENUATION=%d.%02u\n"
+			"UPSTREAM_BITS_PER_FRAME=%u\n"
+			"UPSTREAM_CRC_ERRORS=%u\n"
+			"UPSTREAM_FEC_ERRORS=%u\n"
+			"UPSTREAM_HEC_ERRORS=%u\n"
+			"TRANSMITTER_POWER=%d\n"
+			"\n",
+			cxinf[CXINF_UPSTREAM_SNR_MARGIN] / 100,
+			cxinf[CXINF_UPSTREAM_SNR_MARGIN] % 100,
+			cxinf[CXINF_UPSTREAM_ATTENUATION] / 100,
+			cxinf[CXINF_UPSTREAM_ATTENUATION] % 100,
+			cxinf[CXINF_UPSTREAM_BITS_PER_FRAME],
+			cxinf[CXINF_UPSTREAM_CRC_ERRORS],
+			cxinf[CXINF_UPSTREAM_FEC_ERRORS],
+			cxinf[CXINF_UPSTREAM_HEC_ERRORS],
+			cxinf[CXINF_TRANSMITTER_POWER] - 256);
+
+	if (!left--)
+		return sprintf(page,
+			"AAL5_TX=%u\n"
+			"AAL5_TX_ERR=%u\n"
+			"AAL5_RX=%u\n"
+			"AAL5_RX_ERR=%u\n"
+			"AAL5_RX_DROP=%u\n"
+			"\n",
+			atomic_read(&atm_dev->stats.aal5.tx),
+			atomic_read(&atm_dev->stats.aal5.tx_err),
+			atomic_read(&atm_dev->stats.aal5.rx),
+			atomic_read(&atm_dev->stats.aal5.rx_err),
+			atomic_read(&atm_dev->stats.aal5.rx_drop));
+
+	if (!left--)
+		return sprintf(page,
+			"ADSL_HEADEND=%u\n"
+			"ADSL_HEADEND_ENVIRONMENT=%u\n"
+			"STARTUP_ATTEMPTS=%u\n"
+			"LINE_STARTABLE=%u\n"
+			"CONTROLLER_VERSION=%u\n",
+			cxinf[CXINF_ADSL_HEADEND],
+			cxinf[CXINF_ADSL_HEADEND_ENVIRONMENT],
+			cxinf[CXINF_STARTUP_ATTEMPTS],
+			cxinf[CXINF_LINE_STARTABLE],
+			cxinf[CXINF_CONTROLLER_VERSION]);
+
+	if (!left--)
+		switch (cxinf[CXINF_MODULATION]) {
+		case 1: return sprintf(page, "MODULATION=\"ANSI T1.413\"\n");
+		case 2: return sprintf(page, "MODULATION=\"ITU-T G.992.1 (G.DMT)\"\n");
+		case 3: return sprintf(page, "MODULATION=\"ITU-T G.992.2 (G.LITE)\"\n");
+		default:
+			return sprintf(page, "MODULATION=\"unknown (%u)\"\n",
+						cxinf[CXINF_MODULATION]);
+		}
+
+	return 0;
+}
+
 /* the following three functions are stolen from drivers/usb/core/message.c */
 static void cxacru_blocking_completion(struct urb *urb)
 {
@@ -395,6 +536,8 @@ static void cxacru_poll_status(struct wo
 		goto reschedule;
 	}
 
+	memcpy(instance->cxinf_status, buf, sizeof(instance->cxinf_status));
+
 	if (instance->line_status == buf[CXINF_LINE_STATUS])
 		goto reschedule;
 
@@ -842,6 +985,7 @@ static struct usbatm_driver cxacru_drive
 	.heavy_init	= cxacru_heavy_init,
 	.unbind		= cxacru_unbind,
 	.atm_start	= cxacru_atm_start,
+	.proc_read	= cxacru_proc_read,
 	.bulk_in	= CXACRU_EP_DATA,
 	.bulk_out	= CXACRU_EP_DATA,
 	.rx_padding	= 3,
_

Patches currently in -mm which might be from simon@arlott.org are

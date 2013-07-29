From: akpm@linux-foundation.org
Subject: + pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch added to -mm tree
Date: Mon, 29 Jul 2013 15:58:32 -0700
Message-ID: <51f6f398.6nReZRI30gcuSGzV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab3G2W6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:58:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jkosina@suse.cz, joe@perches.com

Subject: + pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch added to -mm tree
To: joe@perches.com,jkosina@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:58:32 -0700


The patch titled
     Subject: pktcdvd: add struct pktcdvd_device * to pkt_dump_sense()
has been added to the -mm tree.  Its filename is
     pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: pktcdvd: add struct pktcdvd_device * to pkt_dump_sense()

Allow the device name to be emitted with pkt_err when logging the sense
data.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense
+++ a/drivers/block/pktcdvd.c
@@ -755,17 +755,18 @@ static const char *sense_key_string(__u8
  * A generic sense dump / resolve mechanism should be implemented across
  * all ATAPI + SCSI devices.
  */
-static void pkt_dump_sense(struct packet_command *cgc)
+static void pkt_dump_sense(struct pktcdvd_device *pd,
+			   struct packet_command *cgc)
 {
 	struct request_sense *sense = cgc->sense;
 
 	if (sense)
-		pr_err("%*ph - sense %02x.%02x.%02x (%s)\n",
-		       CDROM_PACKET_SIZE, cgc->cmd,
-		       sense->sense_key, sense->asc, sense->ascq,
-		       sense_key_string(sense->sense_key));
+		pkt_err(pd, "%*ph - sense %02x.%02x.%02x (%s)\n",
+			CDROM_PACKET_SIZE, cgc->cmd,
+			sense->sense_key, sense->asc, sense->ascq,
+			sense_key_string(sense->sense_key));
 	else
-		pr_err("%*ph - no sense\n", CDROM_PACKET_SIZE, cgc->cmd);
+		pkt_err(pd, "%*ph - no sense\n", CDROM_PACKET_SIZE, cgc->cmd);
 }
 
 /*
@@ -808,7 +809,7 @@ static noinline_for_stack int pkt_set_sp
 	cgc.cmd[5] = write_speed & 0xff;
 
 	if ((ret = pkt_generic_packet(pd, &cgc)))
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 
 	return ret;
 }
@@ -1700,7 +1701,7 @@ static noinline_for_stack int pkt_set_wr
 	init_cdrom_command(&cgc, buffer, sizeof(*wp), CGC_DATA_READ);
 	cgc.sense = &sense;
 	if ((ret = pkt_mode_sense(pd, &cgc, GPMODE_WRITE_PARMS_PAGE, 0))) {
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 		return ret;
 	}
 
@@ -1715,7 +1716,7 @@ static noinline_for_stack int pkt_set_wr
 	init_cdrom_command(&cgc, buffer, size, CGC_DATA_READ);
 	cgc.sense = &sense;
 	if ((ret = pkt_mode_sense(pd, &cgc, GPMODE_WRITE_PARMS_PAGE, 0))) {
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 		return ret;
 	}
 
@@ -1757,7 +1758,7 @@ static noinline_for_stack int pkt_set_wr
 
 	cgc.buflen = cgc.cmd[8] = size;
 	if ((ret = pkt_mode_select(pd, &cgc))) {
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 		return ret;
 	}
 
@@ -1969,7 +1970,7 @@ static noinline_for_stack int pkt_write_
 	ret = pkt_mode_select(pd, &cgc);
 	if (ret) {
 		pkt_err(pd, "write caching control failed\n");
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 	} else if (!ret && set)
 		pkt_notice(pd, "enabled write caching\n");
 	return ret;
@@ -2007,7 +2008,7 @@ static noinline_for_stack int pkt_get_ma
 			     sizeof(struct mode_page_header);
 		ret = pkt_mode_sense(pd, &cgc, GPMODE_CAPABILITIES_PAGE, 0);
 		if (ret) {
-			pkt_dump_sense(&cgc);
+			pkt_dump_sense(pd, &cgc);
 			return ret;
 		}
 	}
@@ -2066,7 +2067,7 @@ static noinline_for_stack int pkt_media_
 	cgc.cmd[8] = 2;
 	ret = pkt_generic_packet(pd, &cgc);
 	if (ret) {
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 		return ret;
 	}
 	size = ((unsigned int) buf[0]<<8) + buf[1] + 2;
@@ -2081,7 +2082,7 @@ static noinline_for_stack int pkt_media_
 	cgc.cmd[8] = size;
 	ret = pkt_generic_packet(pd, &cgc);
 	if (ret) {
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 		return ret;
 	}
 
@@ -2136,7 +2137,7 @@ static noinline_for_stack int pkt_perfor
 	cgc.cmd[0] = GPCMD_SEND_OPC;
 	cgc.cmd[1] = 1;
 	if ((ret = pkt_generic_packet(pd, &cgc)))
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 	return ret;
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-dynamic-debug-jasons-not-there.patch
printk-move-to-separate-directory-for-easier-modification.patch
printk-move-to-separate-directory-for-easier-modification-fix.patch
printk-add-console_cmdlineh.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
linux-next.patch
maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-gpio-vt8500-remove-file-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-sirf-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
pktcdvd-convert-zone-macro-to-static-function-get_zone.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-consolidate-dprintk-and-vprintk-macros.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch
pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch
pktcdvd-convert-pr_notice-to-pkt_notice.patch
pktcdvd-convert-pr_info-to-pkt_info.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch


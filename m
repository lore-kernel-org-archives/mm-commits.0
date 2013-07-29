From: akpm@linux-foundation.org
Subject: + pktcdvd-convert-pr_notice-to-pkt_notice.patch added to -mm tree
Date: Mon, 29 Jul 2013 15:58:30 -0700
Message-ID: <51f6f396.J47MpzjtvrOTTyn/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab3G2W6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:58:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jkosina@suse.cz, joe@perches.com

Subject: + pktcdvd-convert-pr_notice-to-pkt_notice.patch added to -mm tree
To: joe@perches.com,jkosina@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:58:30 -0700


The patch titled
     Subject: pktcdvd: convert pr_notice to pkt_notice
has been added to the -mm tree.  Its filename is
     pktcdvd-convert-pr_notice-to-pkt_notice.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pktcdvd-convert-pr_notice-to-pkt_notice.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pktcdvd-convert-pr_notice-to-pkt_notice.patch

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
Subject: pktcdvd: convert pr_notice to pkt_notice

Add a new pkt_notice macro to prefix the name to the logging output.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-convert-pr_notice-to-pkt_notice drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-convert-pr_notice-to-pkt_notice
+++ a/drivers/block/pktcdvd.c
@@ -73,6 +73,8 @@
 
 #define pkt_err(pd, fmt, ...)						\
 	pr_err("%s: " fmt, pd->name, ##__VA_ARGS__)
+#define pkt_notice(pd, fmt, ...)					\
+	pr_notice("%s: " fmt, pd->name, ##__VA_ARGS__)
 
 #define pkt_dbg(level, pd, fmt, ...)					\
 do {									\
@@ -1818,7 +1820,7 @@ static int pkt_writable_disc(struct pktc
 	 * but i'm not sure, should we leave this to user apps? probably.
 	 */
 	if (di->disc_type == 0xff) {
-		pr_notice("unknown disc - no track?\n");
+		pkt_notice(pd, "unknown disc - no track?\n");
 		return 0;
 	}
 
@@ -1828,7 +1830,7 @@ static int pkt_writable_disc(struct pktc
 	}
 
 	if (di->erasable == 0) {
-		pr_notice("disc not erasable\n");
+		pkt_notice(pd, "disc not erasable\n");
 		return 0;
 	}
 
@@ -1884,7 +1886,7 @@ static noinline_for_stack int pkt_probe_
 	 */
 	pd->settings.size = be32_to_cpu(ti.fixed_packet_size) << 2;
 	if (pd->settings.size == 0) {
-		pr_notice("detected zero packet size!\n");
+		pkt_notice(pd, "detected zero packet size!\n");
 		return -ENXIO;
 	}
 	if (pd->settings.size > PACKET_MAX_SECTORS) {
@@ -1967,7 +1969,7 @@ static noinline_for_stack int pkt_write_
 		pkt_err(pd, "write caching control failed\n");
 		pkt_dump_sense(&cgc);
 	} else if (!ret && set)
-		pr_notice("enabled write caching on %s\n", pd->name);
+		pkt_notice(pd, "enabled write caching\n");
 	return ret;
 }
 
@@ -2082,11 +2084,11 @@ static noinline_for_stack int pkt_media_
 	}
 
 	if (!(buf[6] & 0x40)) {
-		pr_notice("disc type is not CD-RW\n");
+		pkt_notice(pd, "disc type is not CD-RW\n");
 		return 1;
 	}
 	if (!(buf[6] & 0x4)) {
-		pr_notice("A1 values on media are not valid, maybe not CDRW?\n");
+		pkt_notice(pd, "A1 values on media are not valid, maybe not CDRW?\n");
 		return 1;
 	}
 
@@ -2106,14 +2108,14 @@ static noinline_for_stack int pkt_media_
 			*speed = us_clv_to_speed[sp];
 			break;
 		default:
-			pr_notice("unknown disc sub-type %d\n", st);
+			pkt_notice(pd, "unknown disc sub-type %d\n", st);
 			return 1;
 	}
 	if (*speed) {
 		pr_info("maximum media speed: %d\n", *speed);
 		return 0;
 	} else {
-		pr_notice("unknown speed %d for sub-type %d\n", sp, st);
+		pkt_notice(pd, "unknown speed %d for sub-type %d\n", sp, st);
 		return 1;
 	}
 }
@@ -2378,8 +2380,8 @@ static void pkt_make_request(struct requ
 	}
 
 	if (!test_bit(PACKET_WRITABLE, &pd->flags)) {
-		pr_notice("WRITE for ro device %s (%llu)\n",
-			  pd->name, (unsigned long long)bio->bi_sector);
+		pkt_notice(pd, "WRITE for ro device (%llu)\n",
+			   (unsigned long long)bio->bi_sector);
 		goto end_io;
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


From: akpm@linux-foundation.org
Subject: + pktcdvd-convert-pr_info-to-pkt_info.patch added to -mm tree
Date: Mon, 29 Jul 2013 15:58:31 -0700
Message-ID: <51f6f397.lURjiwTAO60ElQRx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab3G2W6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:58:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jkosina@suse.cz, joe@perches.com

Subject: + pktcdvd-convert-pr_info-to-pkt_info.patch added to -mm tree
To: joe@perches.com,jkosina@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:58:31 -0700


The patch titled
     Subject: pktcdvd: convert pr_info to pkt_info
has been added to the -mm tree.  Its filename is
     pktcdvd-convert-pr_info-to-pkt_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pktcdvd-convert-pr_info-to-pkt_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pktcdvd-convert-pr_info-to-pkt_info.patch

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
Subject: pktcdvd: convert pr_info to pkt_info

Add a new pkt_info macro to prefix the name to the logging output.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-convert-pr_info-to-pkt_info drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-convert-pr_info-to-pkt_info
+++ a/drivers/block/pktcdvd.c
@@ -75,6 +75,8 @@
 	pr_err("%s: " fmt, pd->name, ##__VA_ARGS__)
 #define pkt_notice(pd, fmt, ...)					\
 	pr_notice("%s: " fmt, pd->name, ##__VA_ARGS__)
+#define pkt_info(pd, fmt, ...)						\
+	pr_info("%s: " fmt, pd->name, ##__VA_ARGS__)
 
 #define pkt_dbg(level, pd, fmt, ...)					\
 do {									\
@@ -1561,10 +1563,10 @@ work_to_do:
 
 static void pkt_print_settings(struct pktcdvd_device *pd)
 {
-	pr_info("%s packets, %u blocks, Mode-%c disc\n",
-		pd->settings.fp ? "Fixed" : "Variable",
-		pd->settings.size >> 2,
-		pd->settings.block_mode == 8 ? '1' : '2');
+	pkt_info(pd, "%s packets, %u blocks, Mode-%c disc\n",
+		 pd->settings.fp ? "Fixed" : "Variable",
+		 pd->settings.size >> 2,
+		 pd->settings.block_mode == 8 ? '1' : '2');
 }
 
 static int pkt_mode_sense(struct pktcdvd_device *pd, struct packet_command *cgc, int page_code, int page_control)
@@ -2112,7 +2114,7 @@ static noinline_for_stack int pkt_media_
 			return 1;
 	}
 	if (*speed) {
-		pr_info("maximum media speed: %d\n", *speed);
+		pkt_info(pd, "maximum media speed: %d\n", *speed);
 		return 0;
 	} else {
 		pkt_notice(pd, "unknown speed %d for sub-type %d\n", sp, st);
@@ -2239,7 +2241,7 @@ static int pkt_open_dev(struct pktcdvd_d
 			ret = -ENOMEM;
 			goto out_putdev;
 		}
-		pr_info("%lukB available on disc\n", lba << 1);
+		pkt_info(pd, "%lukB available on disc\n", lba << 1);
 	}
 
 	return 0;
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


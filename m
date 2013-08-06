From: akpm@linux-foundation.org
Subject: + pktcdvd-fix-defective-misuses-of-pkt_level.patch added to -mm
 tree
Date: Tue, 06 Aug 2013 13:20:59 -0700
Message-ID: <52015aab.ntFhX3p7oGNUWwvL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55806 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab3HFUVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 16:21:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com, joe@perches.com

Subject: + pktcdvd-fix-defective-misuses-of-pkt_level.patch added to -mm tree
To: joe@perches.com,dan.carpenter@oracle.com
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 13:20:59 -0700


The patch titled
     Subject: pktcdvd: Fix defective misuses of pkt_<level>
has been added to the -mm tree.  Its filename is
     pktcdvd-fix-defective-misuses-of-pkt_level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pktcdvd-fix-defective-misuses-of-pkt_level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pktcdvd-fix-defective-misuses-of-pkt_level.patch

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
Subject: pktcdvd: Fix defective misuses of pkt_<level>

Fix thinkos where pkt_<level> needs a valid pktcdvd_device * and the
pointer is known to be NULL.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com> (go smatch!)
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-fix-defective-misuses-of-pkt_level drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-fix-defective-misuses-of-pkt_level
+++ a/drivers/block/pktcdvd.c
@@ -2360,8 +2360,8 @@ static void pkt_make_request(struct requ
 
 	pd = q->queuedata;
 	if (!pd) {
-		pkt_err(pd, "%s incorrect request queue\n",
-			bdevname(bio->bi_bdev, b));
+		pr_err("%s incorrect request queue\n",
+		       bdevname(bio->bi_bdev, b));
 		goto end_io;
 	}
 
@@ -2841,7 +2841,7 @@ static int pkt_remove_dev(dev_t pkt_dev)
 			break;
 	}
 	if (idx == MAX_WRITERS) {
-		pkt_dbg(1, pd, "dev not setup\n");
+		pr_debug("dev not setup\n");
 		ret = -ENXIO;
 		goto out;
 	}
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-sirf-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
maintainers-append-to-directory-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
checkpatch-check-for-duplicate-signatures.patch
checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch
checkpatch-fix-networking-kernel-doc-block-comment-defect.patch
checkpatch-add-types-option-to-report-only-specific-message-types.patch
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
pktcdvd-fix-defective-misuses-of-pkt_level.patch
linux-next.patch


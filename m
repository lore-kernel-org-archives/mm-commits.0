From: akpm@linux-foundation.org
Subject: + aoe-identify-source-of-runt-aoe-packets.patch added to -mm tree
Date: Tue, 04 Dec 2012 15:48:55 -0800
Message-ID: <20121204234856.7D727200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40931 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2LDXs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 18:48:58 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so327373eei.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 15:48:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, axboe@kernel.dk


The patch titled
     Subject: aoe: identify source of runt AoE packets
has been added to the -mm tree.  Its filename is
     aoe-identify-source-of-runt-aoe-packets.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: identify source of runt AoE packets

This change only affects experimental AoE storage networks.

It modifies the console message about runt packets detected so that the
AoE major and minor addresses of the AoE target that generated the runt
are mentioned.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-identify-source-of-runt-aoe-packets drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-identify-source-of-runt-aoe-packets
+++ a/drivers/block/aoe/aoecmd.c
@@ -1217,8 +1217,10 @@ noskb:		if (buf)
 	case ATA_CMD_PIO_READ:
 	case ATA_CMD_PIO_READ_EXT:
 		if (skb->len < n) {
-			pr_err("aoe: runt data size in read.  skb->len=%d need=%ld\n",
-				skb->len, n);
+			pr_err("%s e%ld.%d.  skb->len=%d need=%ld\n",
+				"aoe: runt data size in read from",
+				(long) d->aoemajor, d->aoeminor,
+			       skb->len, n);
 			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 			break;
 		}
@@ -1233,7 +1235,9 @@ noskb:		if (buf)
 		break;
 	case ATA_CMD_ID_ATA:
 		if (skb->len < 512) {
-			pr_info("aoe: runt data size in ataid.  skb->len=%d\n",
+			pr_info("%s e%ld.%d.  skb->len=%d need=512\n",
+				"aoe: runt data size in ataid from",
+				(long) d->aoemajor, d->aoeminor,
 				skb->len);
 			break;
 		}
_

Patches currently in -mm which might be from ecashin@coraid.com are

linux-next.patch
linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
documentation-sparsetxt-document-context-annotations-for-lock-checking.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-fix.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch
aoe-provide-ata-identify-device-content-to-user-on-request.patch
aoe-improve-network-congestion-handling.patch
aoe-err-device-include-mac-addresses-for-unexpected-responses.patch
aoe-manipulate-aoedev-network-stats-under-lock.patch
aoe-use-high-resolution-rtts-with-fallback-to-low-res.patch
aoe-commands-in-retransmit-queue-use-new-destination-on-failure.patch
aoe-update-driver-internal-version-to-64.patch
aoe-copy-fallback-timing-information-on-destination-failover.patch
aoe-remove-vestigial-request-queue-allocation.patch
aoe-increase-default-cap-on-outstanding-aoe-commands-in-the-network.patch
aoe-cleanup-correct-comment-for-aoetgt-nout.patch
aoe-remove-call-to-request-handler-from-i-o-completion.patch
aoe-make-error-messages-more-specific-in-static-minor-allocation.patch
aoe-initialize-sysminor-to-avoid-compiler-warning.patch
aoe-return-real-minor-number-for-static-minors.patch
aoe-improve-handling-of-misbehaving-network-paths.patch
aoe-avoid-races-between-device-destruction-and-discovery.patch
aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target.patch
aoe-allow-user-to-disable-target-failure-timeout.patch
aoe-allow-comma-separator-in-aoe_iflist-value.patch
aoe-identify-source-of-runt-aoe-packets.patch
aoe-update-internal-version-number-to-81.patch


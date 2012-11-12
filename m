From: akpm@linux-foundation.org
Subject: [merged] aoe-avoid-running-request-handler-on-plugged-queue.patch removed from -mm tree
Date: Mon, 12 Nov 2012 13:09:56 -0800
Message-ID: <20121112210957.1C3D75C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63364 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab2KLVJ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 16:09:58 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so132689eei.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 13:09:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: avoid running request handler on plugged queue
has been removed from the -mm tree.  Its filename was
     aoe-avoid-running-request-handler-on-plugged-queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: avoid running request handler on plugged queue

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-avoid-running-request-handler-on-plugged-queue drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-avoid-running-request-handler-on-plugged-queue
+++ a/drivers/block/aoe/aoecmd.c
@@ -925,7 +925,7 @@ aoe_end_request(struct aoedev *d, struct
 
 	/* cf. http://lkml.org/lkml/2006/10/31/28 */
 	if (!fastfail)
-		q->request_fn(q);
+		__blk_run_queue(q);
 }
 
 static void
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


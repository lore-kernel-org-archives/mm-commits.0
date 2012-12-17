From: akpm@linux-foundation.org
Subject: [folded-merged] aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:47:44 -0800
Message-ID: <20121217234745.4F58F200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:64402 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2LQXrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:47:47 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so354973eei.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:47:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2
has been removed from the -mm tree.  Its filename was
     aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2.patch

This patch was dropped because it was folded into aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2

Dropped transmits are not common, but when they do occur, increasing
the transmit queue length often helps.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoenet.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/block/aoe/aoenet.c~aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2 drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2
+++ a/drivers/block/aoe/aoenet.c
@@ -50,13 +50,9 @@ __setup("aoe_iflist=", aoe_iflist_setup)
 static spinlock_t txlock;
 static struct sk_buff_head skbtxq;
 
-/* enters with txlock held
- *
- * Use __must_hold(&txlock) for sparse when upcoming patch adds it to
- * compiler.h.
- */
+/* enters with txlock held */
 static int
-tx(void)
+tx(void) __must_hold(&txlock)
 {
 	struct sk_buff *skb;
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
documentation-sparsetxt-document-context-annotations-for-lock-checking.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
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
aoe-fix-use-after-free-in-aoedev_by_aoeaddr.patch


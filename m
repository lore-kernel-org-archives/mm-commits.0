From: akpm@linux-foundation.org
Subject: + aoe-allow-comma-separator-in-aoe_iflist-value.patch added to -mm tree
Date: Tue, 04 Dec 2012 15:48:53 -0800
Message-ID: <20121204234854.1E68410004A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:59300 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2LDXs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 18:48:56 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so556465qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 15:48:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, axboe@kernel.dk


The patch titled
     Subject: aoe: allow comma separator in aoe_iflist value
has been added to the -mm tree.  Its filename is
     aoe-allow-comma-separator-in-aoe_iflist-value.patch

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
Subject: aoe: allow comma separator in aoe_iflist value

By default, the aoe driver uses any ethernet interface for AoE, but the
aoe_iflist module parameter provides a convenient way to limit AoE traffic
to a specific list of local network interfaces.

This change allows a list to be specified using the comma character as a
separator.  For example,

  modprobe aoe aoe_iflist=eth2,eth3

Before, it was inconvenient to get the quoting right in shell scripts when
setting aoe_iflist to have more than one network interface.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoenet.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-allow-comma-separator-in-aoe_iflist-value drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-allow-comma-separator-in-aoe_iflist-value
+++ a/drivers/block/aoe/aoe.h
@@ -11,7 +11,7 @@
 #define AOE_PARTITIONS (16)
 #endif
 
-#define WHITESPACE " \t\v\f\n"
+#define WHITESPACE " \t\v\f\n,"
 
 enum {
 	AOECMD_ATA,
diff -puN drivers/block/aoe/aoenet.c~aoe-allow-comma-separator-in-aoe_iflist-value drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-allow-comma-separator-in-aoe_iflist-value
+++ a/drivers/block/aoe/aoenet.c
@@ -31,7 +31,7 @@ enum {
 
 static char aoe_iflist[IFLISTSZ];
 module_param_string(aoe_iflist, aoe_iflist, IFLISTSZ, 0600);
-MODULE_PARM_DESC(aoe_iflist, "aoe_iflist=\"dev1 [dev2 ...]\"");
+MODULE_PARM_DESC(aoe_iflist, "aoe_iflist=dev1[,dev2...]");
 
 static wait_queue_head_t txwq;
 static struct ktstate kts;
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


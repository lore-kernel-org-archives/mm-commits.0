From: akpm@linux-foundation.org
Subject: + aoe-allow-user-to-disable-target-failure-timeout.patch added to -mm tree
Date: Tue, 04 Dec 2012 15:48:49 -0800
Message-ID: <20121204234850.9CB65200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:59625 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2LDXsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 18:48:53 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so323554wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 15:48:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, axboe@kernel.dk


The patch titled
     Subject: aoe: allow user to disable target failure timeout
has been added to the -mm tree.  Its filename is
     aoe-allow-user-to-disable-target-failure-timeout.patch

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
Subject: aoe: allow user to disable target failure timeout

With this change, the aoe driver treats the value zero as special for the
aoe_deadsecs module parameter.  Normally, this value specifies the number
of seconds during which the driver will continue to attempt retransmits to
an unresponsive AoE target.  After aoe_deadsecs has elapsed, the aoe
driver marks the aoe device as "down" and fails all I/O.

The new meaning of an aoe_deadsecs of zero is for the driver to retransmit
commands indefinitely.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/aoe/aoe.txt  |    4 +++-
 drivers/block/aoe/aoecmd.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN Documentation/aoe/aoe.txt~aoe-allow-user-to-disable-target-failure-timeout Documentation/aoe/aoe.txt
--- a/Documentation/aoe/aoe.txt~aoe-allow-user-to-disable-target-failure-timeout
+++ a/Documentation/aoe/aoe.txt
@@ -125,7 +125,9 @@ DRIVER OPTIONS
   The aoe_deadsecs module parameter determines the maximum number of
   seconds that the driver will wait for an AoE device to provide a
   response to an AoE command.  After aoe_deadsecs seconds have
-  elapsed, the AoE device will be marked as "down".
+  elapsed, the AoE device will be marked as "down".  A value of zero
+  is supported for testing purposes and makes the aoe driver keep
+  trying AoE commands forever.
 
   The aoe_maxout module parameter has a default of 128.  This is the
   maximum number of unresponded packets that will be sent to an AoE
diff -puN drivers/block/aoe/aoecmd.c~aoe-allow-user-to-disable-target-failure-timeout drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-allow-user-to-disable-target-failure-timeout
+++ a/drivers/block/aoe/aoecmd.c
@@ -812,7 +812,9 @@ rexmit_timer(ulong vp)
 		since = tsince_hr(f);
 		n = f->waited_total + since;
 		n /= USEC_PER_SEC;
-		if (n > aoe_deadsecs && !(f->flags & FFL_PROBE)) {
+		if (aoe_deadsecs
+		&& n > aoe_deadsecs
+		&& !(f->flags & FFL_PROBE)) {
 			/* Waited too long.  Device failure.
 			 * Hang all frames on first hash bucket for downdev
 			 * to clean up.
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


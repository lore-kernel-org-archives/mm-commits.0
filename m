From: akpm@linux-foundation.org
Subject: [merged] aoe-allow-user-to-disable-target-failure-timeout.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:11:21 -0800
Message-ID: <20121218201122.1335820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:40796 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2LRULY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:11:24 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so63367fav.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:11:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: allow user to disable target failure timeout
has been removed from the -mm tree.  Its filename was
     aoe-allow-user-to-disable-target-failure-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch


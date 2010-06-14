From: akpm@linux-foundation.org
Subject: + floppy-initialize-debug-jiffies-offset.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:39:16 -0700
Message-ID: <201006141939.o5EJdGx6026896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768Ab0FNTjV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:39:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, axboe@kernel.dk


The patch titled
     floppy: initialize debug jiffies offset
has been added to the -mm tree.  Its filename is
     floppy-initialize-debug-jiffies-offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: floppy: initialize debug jiffies offset
From: Stephen Hemminger <shemminger@vyatta.com>

Set debug jiffies offset at initialization.  Avoids wierd values showing
up if debugging enabled.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/block/floppy.c~floppy-initialize-debug-jiffies-offset drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-initialize-debug-jiffies-offset
+++ a/drivers/block/floppy.c
@@ -4175,6 +4175,9 @@ static int __init floppy_init(void)
 	int i, unit, drive;
 	int err, dr;
 
+	set_debugt();
+	interruptjiffies = resultjiffies = jiffies;
+
 #if defined(CONFIG_PPC)
 	if (check_legacy_ioport(FDC1))
 		return -ENODEV;
_

Patches currently in -mm which might be from shemminger@vyatta.com are

linux-next.patch
floppy-initialize-debug-jiffies-offset.patch
floppy-remove-unnecessary-inlines.patch
floppy-silence-warning-during-disk-test.patch
floppy-use-atomic-type-for-usage_count.patch
floppy-cmos-attribute-should-be-static.patch
floppy-fix-signed-unsigned-warnings.patch
floppy-use-wait_event_interruptible.patch
floppy-use-warning-macros.patch
floppy-make-controller-const.patch


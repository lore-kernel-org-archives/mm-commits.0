From: akpm@linux-foundation.org
Subject: + floppy-cmos-attribute-should-be-static.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:39:24 -0700
Message-ID: <201006141939.o5EJdOCf026918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab0FNTj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:39:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, axboe@kernel.dk


The patch titled
     floppy: cmos attribute should be static
has been added to the -mm tree.  Its filename is
     floppy-cmos-attribute-should-be-static.patch

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
Subject: floppy: cmos attribute should be static
From: Stephen Hemminger <shemminger@vyatta.com>

As reported by sparse, cmos attribute is local.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/floppy.c~floppy-cmos-attribute-should-be-static drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-cmos-attribute-should-be-static
+++ a/drivers/block/floppy.c
@@ -4127,7 +4127,7 @@ static ssize_t floppy_cmos_show(struct d
 	return sprintf(buf, "%X\n", UDP->cmos);
 }
 
-DEVICE_ATTR(cmos, S_IRUGO, floppy_cmos_show, NULL);
+static DEVICE_ATTR(cmos, S_IRUGO, floppy_cmos_show, NULL);
 
 static void floppy_device_release(struct device *dev)
 {
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


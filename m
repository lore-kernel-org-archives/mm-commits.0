From: akpm@linux-foundation.org
Subject: [merged]
 random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update.patch removed from -mm tree
Date: Tue, 28 May 2013 12:37:19 -0700
Message-ID: <51a5076f.BmAq48J3YoSryppJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab3E1ThU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:37:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, stable@vger.kernel.org, greg@kroah.com, jkosina@suse.cz

Subject: [merged] random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update.patch removed from -mm tree
To: jkosina@suse.cz,greg@kroah.com,stable@vger.kernel.org,tytso@mit.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:37:19 -0700


The patch titled
     Subject: random: fix accounting race condition with lockless irq entropy_count update
has been removed from the -mm tree.  Its filename was
     random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: random: fix accounting race condition with lockless irq entropy_count update

Commit 902c098a3663 ("random: use lockless techniques in the interrupt
path") turned IRQ path from being spinlock protected into lockless
cmpxchg-retry update.

That commit removed r->lock serialization between crediting entropy bits
from IRQ context and accounting when extracting entropy on userspace read
path, but didn't turn the r->entropy_count reads/updates in account() to
use cmpxchg as well.

It has been observed, that under certain circumstances this leads to
read() on /dev/urandom to return 0 (EOF), as r->entropy_count gets
corrupted and becomes negative, which in turn results in propagating 0 all
the way from account() to the actual read() call.

Convert the accounting code to be the proper lockless counterpart of what
has been partially done by 902c098a3663.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN drivers/char/random.c~random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update drivers/char/random.c
--- a/drivers/char/random.c~random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update
+++ a/drivers/char/random.c
@@ -865,16 +865,24 @@ static size_t account(struct entropy_sto
 	if (r->entropy_count / 8 < min + reserved) {
 		nbytes = 0;
 	} else {
+		int entropy_count, orig;
+retry:
+		entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 		/* If limited, never pull more than available */
-		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
-			nbytes = r->entropy_count/8 - reserved;
+		if (r->limit && nbytes + reserved >= entropy_count / 8)
+			nbytes = entropy_count/8 - reserved;
 
-		if (r->entropy_count / 8 >= nbytes + reserved)
-			r->entropy_count -= nbytes*8;
-		else
-			r->entropy_count = reserved;
+		if (entropy_count / 8 >= nbytes + reserved) {
+			entropy_count -= nbytes*8;
+			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+				goto retry;
+		} else {
+			entropy_count = reserved;
+			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+				goto retry;
+		}
 
-		if (r->entropy_count < random_write_wakeup_thresh)
+		if (entropy_count < random_write_wakeup_thresh)
 			wakeup_write = 1;
 	}
 
_

Patches currently in -mm which might be from jkosina@suse.cz are

linux-next.patch
lib-bitmapc-speed-up-bitmap_find_free_region.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch
rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch
rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot.patch
rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch
mwave-fix-info-leak-in-mwave_ioctl.patch


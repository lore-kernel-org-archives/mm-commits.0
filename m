From: akpm@linux-foundation.org
Subject: + random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update.patch added to -mm tree
Date: Tue, 23 Apr 2013 14:38:28 -0700
Message-ID: <20130423213828.7FABB31C256__5667.67532513968$1366753118$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:48356 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab3DWVia (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 17:38:30 -0400
Received: by mail-vb0-f74.google.com with SMTP id w16so122086vbb.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 14:38:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, greg@kroah.com, stable@vger.kernel.org, tytso@mit.edu


The patch titled
     Subject: random: fix accounting race condition with lockless irq entropy_count update
has been added to the -mm tree.  Its filename is
     random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
binfmt_elf-pie-make-pf_randomize-check-comment-more-accurate.patch
i2o-check-copy_from_user-size-parameter.patch
mwave-fix-info-leak-in-mwave_ioctl.patch
random-fix-accounting-race-condition-with-lockless-irq-entropy_count-update.patch
semaphore-give-an-unlikely-for-downs-timeout.patch
semaphore-boolize-semaphore_waiters-up.patch


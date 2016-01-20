From: akpm@linux-foundation.org
Subject: +
 ratelimit-fix-bug-in-time-interval-by-resetting-right-begin-time.patch
 added to -mm tree
Date: Wed, 20 Jan 2016 12:57:09 -0800
Message-ID: <569ff4a5.uL9ZSOs3bzHs1nnt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbcATU5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 15:57:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaewon31.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ratelimit: fix bug in time interval by resetting right begin time
has been added to the -mm tree.  Its filename is
     ratelimit-fix-bug-in-time-interval-by-resetting-right-begin-time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ratelimit-fix-bug-in-time-interval-by-resetting-right-begin-time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ratelimit-fix-bug-in-time-interval-by-resetting-right-begin-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@gmail.com>
Subject: ratelimit: fix bug in time interval by resetting right begin time

rs->begin in ratelimit is set in two cases.
1) when rs->begin was not initialized
2) when rs->interval was passed
For the case 2), current ratelimit sets the begin to 0. This incurrs improper
suppression. The begin value will be set in the next ratelimit call by 1).
Then the time interval check will be always false, and rs->printed will not be
initialized. Although enough time passed, ratelimit may return 0 if rs->printed
is not less than rs->burst. To reset interval properly, begin should be jiffies
rather than 0.

For an example code below,
	static DEFINE_RATELIMIT_STATE(mylimit, 1, 1);
	for (i = 1; i <= 10; i++) {
		if (__ratelimit(&mylimit))
			printk("ratelimit test count %d\n", i);
		msleep(3000);
	}
test result in the current code shows suppression even there is 3 seconds sleep.
[  78.391148] ratelimit test count 1
[  81.295988] ratelimit test count 2
[  87.315981] ratelimit test count 4
[  93.336267] ratelimit test count 6
[  99.356031] ratelimit test count 8
[ 105.376367] ratelimit test count 10

Signed-off-by: Jaewon Kim <jaewon31.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ratelimit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/ratelimit.c~ratelimit-fix-bug-in-time-interval-by-resetting-right-begin-time lib/ratelimit.c
--- a/lib/ratelimit.c~ratelimit-fix-bug-in-time-interval-by-resetting-right-begin-time
+++ a/lib/ratelimit.c
@@ -49,7 +49,7 @@ int ___ratelimit(struct ratelimit_state
 		if (rs->missed)
 			printk(KERN_WARNING "%s: %d callbacks suppressed\n",
 				func, rs->missed);
-		rs->begin   = 0;
+		rs->begin   = jiffies;
 		rs->printed = 0;
 		rs->missed  = 0;
 	}
_

Patches currently in -mm which might be from jaewon31.kim@gmail.com are

ratelimit-fix-bug-in-time-interval-by-resetting-right-begin-time.patch


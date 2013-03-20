From: akpm@linux-foundation.org
Subject: + ktime_add_ns-may-overflow-on-32bit-architectures.patch added to -mm tree
Date: Wed, 20 Mar 2013 15:46:09 -0700
Message-ID: <20130320224609.7EB7E31C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:52598 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab3CTWqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 18:46:11 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so208316vcb.4
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 15:46:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.engraf@sysgo.com, eric.dumazet@gmail.com, john.stultz@linaro.org, tglx@linutronix.de


The patch titled
     Subject: ktime_add_ns() may overflow on 32bit architectures
has been added to the -mm tree.  Its filename is
     ktime_add_ns-may-overflow-on-32bit-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Engraf <david.engraf@sysgo.com>
Subject: ktime_add_ns() may overflow on 32bit architectures

I've triggered an overflow when using ktime_add_ns() on a 32bit
architecture not supporting CONFIG_KTIME_SCALAR.

When passing a very high value for u64 nsec, e.g.  7881299347898368000 the
do_div() function converts this value to seconds (7881299347) which is
still to high to pass to the ktime_set() function as long.  The result in
my case is a negative value.

The problem on my system occurs in the tick-sched.c,
tick_nohz_stop_sched_tick() when time_delta is set to
timekeeping_max_deferment().  The check for time_delta < KTIME_MAX is
valid, thus ktime_add_ns() is called with a too large value resulting in a
negative expire value.  This leads to an endless loop in the ticker code:

time_delta: 7881299347898368000
expires = ktime_add_ns(last_update, time_delta)
expires: negative value

This error doesn't occurs on 64bit or architectures supporting
CONFIG_KTIME_SCALAR (e.g.  ARM, x86-32).  64-bit arches doesn't run into
this problem because ktime_add_ns() can directly calculate the result
without calling do_div() and ktime_set().

Signed-off-by: David Engraf <david.engraf@sysgo.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/hrtimer.c~ktime_add_ns-may-overflow-on-32bit-architectures kernel/hrtimer.c
--- a/kernel/hrtimer.c~ktime_add_ns-may-overflow-on-32bit-architectures
+++ a/kernel/hrtimer.c
@@ -275,6 +275,10 @@ ktime_t ktime_add_ns(const ktime_t kt, u
 	} else {
 		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
 
+		/* Make sure nsec fits into long */
+		if (unlikely(nsec > KTIME_SEC_MAX))
+			return (ktime_t){ .tv64 = KTIME_MAX };
+
 		tmp = ktime_set((long)nsec, rem);
 	}
 
_

Patches currently in -mm which might be from david.engraf@sysgo.com are

ktime_add_ns-may-overflow-on-32bit-architectures.patch


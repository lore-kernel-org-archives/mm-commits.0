From: akpm@linux-foundation.org
Subject: +
 lib-percpu_counterc-__this_cpu_write-doesnt-need-to-be-protected-by-spinlock.patch added to -mm tree
Date: Mon, 01 Jul 2013 16:07:48 -0700
Message-ID: <51d20bc4.bkXgTZERtzb5/yUu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3GAXHt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jul 2013 19:07:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fan.du@windriver.com

Subject: + lib-percpu_counterc-__this_cpu_write-doesnt-need-to-be-protected-by-spinlock.patch added to -mm tree
To: fan.du@windriver.com
From: akpm@linux-foundation.org
Date: Mon, 01 Jul 2013 16:07:48 -0700


The patch titled
     Subject: lib/percpu_counter.c: __this_cpu_write() doesn't need to be protected by spinlock
has been added to the -mm tree.  Its filename is
     lib-percpu_counterc-__this_cpu_write-doesnt-need-to-be-protected-by-spinlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-percpu_counterc-__this_cpu_write-doesnt-need-to-be-protected-by-spinlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-percpu_counterc-__this_cpu_write-doesnt-need-to-be-protected-by-spinlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fan Du <fan.du@windriver.com>
Subject: lib/percpu_counter.c: __this_cpu_write() doesn't need to be protected by spinlock

__this_cpu_write doesn't need to be protected by spinlock, AS we are doing
per cpu write with preempt disabled.  And another reason to remove
__this_cpu_write outside of spinlock: __percpu_counter_sum is not an
accurate counter.

Signed-off-by: Fan Du <fan.du@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/percpu_counter.c~lib-percpu_counterc-__this_cpu_write-doesnt-need-to-be-protected-by-spinlock lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_counterc-__this_cpu_write-doesnt-need-to-be-protected-by-spinlock
+++ a/lib/percpu_counter.c
@@ -80,8 +80,8 @@ void __percpu_counter_add(struct percpu_
 	if (count >= batch || count <= -batch) {
 		raw_spin_lock(&fbc->lock);
 		fbc->count += count;
-		__this_cpu_write(*fbc->counters, 0);
 		raw_spin_unlock(&fbc->lock);
+		__this_cpu_write(*fbc->counters, 0);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
_

Patches currently in -mm which might be from fan.du@windriver.com are

linux-next.patch
lib-percpu_counterc-__this_cpu_write-doesnt-need-to-be-protected-by-spinlock.patch


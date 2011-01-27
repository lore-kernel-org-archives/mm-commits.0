From: akpm@linux-foundation.org
Subject: + memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch added to -mm tree
Date: Thu, 27 Jan 2011 15:20:32 -0800
Message-ID: <201101272320.p0RNKWwJ005730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753750Ab1A0XUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 18:20:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     memcg: res_counter_read_u64(): fix potential races on 32-bit machines
has been added to the -mm tree.  Its filename is
     memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch

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
Subject: memcg: res_counter_read_u64(): fix potential races on 32-bit machines
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

res_counter_read_u64 reads u64 value without lock.  It's dangerous in a
32bit environment.  Add locking.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/res_counter.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN kernel/res_counter.c~memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines kernel/res_counter.c
--- a/kernel/res_counter.c~memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines
+++ a/kernel/res_counter.c
@@ -126,10 +126,24 @@ ssize_t res_counter_read(struct res_coun
 			pos, buf, s - buf);
 }
 
+#if BITS_PER_LONG == 32
+u64 res_counter_read_u64(struct res_counter *counter, int member)
+{
+	unsigned long flags;
+	u64 ret;
+
+	spin_lock_irqsave(&counter->lock, flags);
+	ret = *res_counter_member(counter, member);
+	spin_unlock_irqrestore(&counter->lock, flags);
+
+	return ret;
+}
+#else
 u64 res_counter_read_u64(struct res_counter *counter, int member)
 {
 	return *res_counter_member(counter, member);
 }
+#endif
 
 int res_counter_memparse_write_strategy(const char *buf,
 					unsigned long long *res)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memsw-handle-swapaccount-kernel-parameter-correctly.patch
memsw-deprecate-noswapaccount-kernel-parameter-and-schedule-it-for-removal.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-add-replace_page_cache_page-function.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch


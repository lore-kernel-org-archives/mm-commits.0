From: akpm@linux-foundation.org
Subject: + percpu_counter-use-this_cpu_ptr-instead-of-per_cpu_ptr.patch added to -mm tree
Date: Thu, 07 Oct 2010 14:59:06 -0700
Message-ID: <201010072159.o97Lx6Lr026660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755181Ab0JGV7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2010 17:59:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cl@linux.com, eric.dumazet@gmail.com, tj@kernel.org


The patch titled
     percpu_counter: use this_cpu_ptr() instead of per_cpu_ptr()
has been added to the -mm tree.  Its filename is
     percpu_counter-use-this_cpu_ptr-instead-of-per_cpu_ptr.patch

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
Subject: percpu_counter: use this_cpu_ptr() instead of per_cpu_ptr()
From: Christoph Lameter <cl@linux.com>

this_cpu_ptr() avoids an array lookup and can use the percpu offset of the
local cpu directly.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/percpu_counter.c~percpu_counter-use-this_cpu_ptr-instead-of-per_cpu_ptr lib/percpu_counter.c
--- a/lib/percpu_counter.c~percpu_counter-use-this_cpu_ptr-instead-of-per_cpu_ptr
+++ a/lib/percpu_counter.c
@@ -73,9 +73,9 @@ void __percpu_counter_add(struct percpu_
 {
 	s64 count;
 	s32 *pcount;
-	int cpu = get_cpu();
 
-	pcount = per_cpu_ptr(fbc->counters, cpu);
+	preempt_disable();
+	pcount = this_cpu_ptr(fbc->counters);
 	count = *pcount + amount;
 	if (count >= batch || count <= -batch) {
 		spin_lock(&fbc->lock);
@@ -85,7 +85,7 @@ void __percpu_counter_add(struct percpu_
 	} else {
 		*pcount = count;
 	}
-	put_cpu();
+	preempt_enable();
 }
 EXPORT_SYMBOL(__percpu_counter_add);
 
_

Patches currently in -mm which might be from cl@linux.com are

linux-next.patch
mm-compaction-fix-compactpagefailed-counting.patch
mm-mempolicy-check-return-code-of-check_range.patch
percpu_counter-use-this_cpu_ptr-instead-of-per_cpu_ptr.patch


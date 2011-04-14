From: akpm@linux-foundation.org
Subject: + percpu_counter-change-return-value-and-add-comments.patch added to -mm tree
Date: Thu, 14 Apr 2011 12:49:10 -0700
Message-ID: <201104141949.p3EJnAGG002652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759401Ab1DNTtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Apr 2011 15:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, eric.dumazet@gmail.com, tj@kernel.org


The patch titled
     percpu_counter: change return value and add comments
has been added to the -mm tree.  Its filename is
     percpu_counter-change-return-value-and-add-comments.patch

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
Subject: percpu_counter: change return value and add comments
From: Shaohua Li <shaohua.li@intel.com>

The percpu_counter_*_positive() API in UP case doesn't check if return
value is positive.  Add comments to explain why we don't.  Also if count <
0, returns 0 instead of 1 for *read_positive().

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/percpu_counter.h~percpu_counter-change-return-value-and-add-comments include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~percpu_counter-change-return-value-and-add-comments
+++ a/include/linux/percpu_counter.h
@@ -75,7 +75,7 @@ static inline s64 percpu_counter_read_po
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
 		return ret;
-	return 1;
+	return 0;
 }
 
 static inline int percpu_counter_initialized(struct percpu_counter *fbc)
@@ -133,6 +133,10 @@ static inline s64 percpu_counter_read(st
 	return fbc->count;
 }
 
+/*
+ * percpu_counter is intended to track positive number. In UP case, the number
+ * should never be negative.
+ */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
 	return fbc->count;
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
mmap-add-alignment-for-some-variables.patch
mmap-avoid-unnecessary-anon_vma-lock.patch
mmap-avoid-merging-cloned-vmas.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
percpu_counter-change-return-value-and-add-comments.patch


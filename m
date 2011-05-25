From: akpm@linux-foundation.org
Subject: [merged] percpu_counter-change-return-value-and-add-comments.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:20 -0700
Message-ID: <201105252030.p4PKUh2o014989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932190Ab1EYUbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:31:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, eric.dumazet@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     percpu_counter: change return value and add comments
has been removed from the -mm tree.  Its filename was
     percpu_counter-change-return-value-and-add-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: percpu_counter: change return value and add comments
From: Shaohua Li <shaohua.li@intel.com>

The percpu_counter_*_positive() API in UP case doesn't check if return
value is positive.  Add comments to explain why we don't.  Also if count <
0, returns 0 instead of 1 for *read_positive().

[akpm@linux-foundation.org: tweak comment]
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
+ * percpu_counter is intended to track positive numbers. In the UP case the
+ * number should never be negative.
+ */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
 	return fbc->count;
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch


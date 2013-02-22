From: akpm@linux-foundation.org
Subject: [merged] lockdep-make-lockdep_assert_held-not-have-a-return-value.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:10 -0800
Message-ID: <20130222203910.B45DC31C208@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:41800 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab3BVUjM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:39:12 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so103705ves.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:39:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes.berg@intel.com, mingo@redhat.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lockdep: make lockdep_assert_held() not have a return value
has been removed from the -mm tree.  Its filename was
     lockdep-make-lockdep_assert_held-not-have-a-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Berg <johannes.berg@intel.com>
Subject: lockdep: make lockdep_assert_held() not have a return value

I recently made the mistake of writing:

foo = lockdep_dereference_protected(..., lockdep_assert_held(...));

which is clearly bogus.  If lockdep is disabled in the config this would
cause a compile failure, if it is enabled then it compiles and causes a
puzzling warning about dereferencing without the correct protection.

Wrap the macro in "do { ...  } while (0)" to also fail compile for this
when lockdep is enabled.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/lockdep.h~lockdep-make-lockdep_assert_held-not-have-a-return-value include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-make-lockdep_assert_held-not-have-a-return-value
+++ a/include/linux/lockdep.h
@@ -359,7 +359,9 @@ extern void lockdep_trace_alloc(gfp_t ma
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
-#define lockdep_assert_held(l)	WARN_ON(debug_locks && !lockdep_is_held(l))
+#define lockdep_assert_held(l)	do {				\
+		WARN_ON(debug_locks && !lockdep_is_held(l));	\
+	} while (0)
 
 #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
 
_

Patches currently in -mm which might be from johannes.berg@intel.com are

origin.patch


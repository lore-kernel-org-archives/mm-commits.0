From: akpm@linux-foundation.org
Subject: + lockdep-make-lockdep_assert_held-not-have-a-return-value.patch added to -mm tree
Date: Wed, 23 Jan 2013 13:23:04 -0800
Message-ID: <20130123212304.A615B5A41C6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58033 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3AWVXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 16:23:06 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so153887qaq.3
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 13:23:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes.berg@intel.com, mingo@redhat.com, peterz@infradead.org


The patch titled
     Subject: lockdep: make lockdep_assert_held() not have a return value
has been added to the -mm tree.  Its filename is
     lockdep-make-lockdep_assert_held-not-have-a-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
lockdep-make-lockdep_assert_held-not-have-a-return-value.patch


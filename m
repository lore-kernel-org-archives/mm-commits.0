From: akpm@linux-foundation.org
Subject: [failures]
 compilerh-dont-use-temporary-variable-in-__compiletime_assert.patch removed from -mm tree
Date: Mon, 12 May 2014 14:16:46 -0700
Message-ID: <53713a3e.u2I3cnN8OHJoUj7d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758692AbaELVQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 17:16:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, paulmck@linux.vnet.ibm.com, luciano.coelho@intel.com, daniel.santos@pobox.com, johannes.berg@intel.com

Subject: [failures] compilerh-dont-use-temporary-variable-in-__compiletime_assert.patch removed from -mm tree
To: johannes.berg@intel.com,daniel.santos@pobox.com,luciano.coelho@intel.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 14:16:46 -0700


The patch titled
     Subject: compiler.h: don't use temporary variable in __compiletime_assert()
has been removed from the -mm tree.  Its filename was
     compilerh-dont-use-temporary-variable-in-__compiletime_assert.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Johannes Berg <johannes.berg@intel.com>
Subject: compiler.h: don't use temporary variable in __compiletime_assert()

Usually, BUG_ON and friends aren't even evaluated in sparse, but recently
compiletime_assert_atomic_type() was added, and that now results in a
sparse warning every time it is used.

The reason turns out to be the temporary variable, after it sparse no
longer considers the value to be a constant, and results in a warning and
an error.  The error is the more annoying part of this as it suppresses
any further warnings in the same file, hiding other problems.

Since this is all about compile time and the condition should be
side-effect free to start with, there's no downside (apart maybe from a
slight compilation time penalty?) to just duplicating it, leaving sparse
able to evaluate it at check time, getting rid of the warning and error.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Tested-by: Luciano Coelho <luciano.coelho@intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/compiler.h~compilerh-dont-use-temporary-variable-in-__compiletime_assert include/linux/compiler.h
--- a/include/linux/compiler.h~compilerh-dont-use-temporary-variable-in-__compiletime_assert
+++ a/include/linux/compiler.h
@@ -331,11 +331,10 @@ void ftrace_likely_update(struct ftrace_
 
 #define __compiletime_assert(condition, msg, prefix, suffix)		\
 	do {								\
-		bool __cond = !(condition);				\
 		extern void prefix ## suffix(void) __compiletime_error(msg); \
-		if (__cond)						\
+		if (!(condition))					\
 			prefix ## suffix();				\
-		__compiletime_error_fallback(__cond);			\
+		__compiletime_error_fallback(!(condition));		\
 	} while (0)
 
 #define _compiletime_assert(condition, msg, prefix, suffix) \
_

Patches currently in -mm which might be from johannes.berg@intel.com are

linux-next.patch


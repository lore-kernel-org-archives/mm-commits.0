From: akpm@linux-foundation.org
Subject: +
 compilerh-avoid-sparse-errors-in-__compiletime_error_fallback.patch added
 to -mm tree
Date: Thu, 15 May 2014 16:03:24 -0700
Message-ID: <537547bc.BueYSipfAOORLbSo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaEOXDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 19:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, paulmck@linux.vnet.ibm.com, luciano.coelho@intel.com, johannes@sipsolutions.net, johannes.berg@intel.com, daniel.santos@pobox.com, james.hogan@imgtec.com

Subject: + compilerh-avoid-sparse-errors-in-__compiletime_error_fallback.patch added to -mm tree
To: james.hogan@imgtec.com,daniel.santos@pobox.com,johannes.berg@intel.com,johannes@sipsolutions.net,luciano.coelho@intel.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 16:03:24 -0700


The patch titled
     Subject: compiler.h: avoid sparse errors in __compiletime_error_fallback()
has been added to the -mm tree.  Its filename is
     compilerh-avoid-sparse-errors-in-__compiletime_error_fallback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/compilerh-avoid-sparse-errors-in-__compiletime_error_fallback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/compilerh-avoid-sparse-errors-in-__compiletime_error_fallback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: James Hogan <james.hogan@imgtec.com>
Subject: compiler.h: avoid sparse errors in __compiletime_error_fallback()

Usually, BUG_ON and friends aren't even evaluated in sparse, but recently
compiletime_assert_atomic_type() was added, and that now results in a
sparse warning every time it is used.

The reason turns out to be the temporary variable, after it sparse no
longer considers the value to be a constant, and results in a warning and
an error.  The error is the more annoying part of this as it suppresses
any further warnings in the same file, hiding other problems.

Unfortunately the condition cannot be simply expanded out to avoid the
temporary variable since it breaks compiletime_assert on old versions of
GCC such as GCC 4.2.4 which the latest metag compiler is based on.

Therefore #ifndef __CHECKER__ out the __compiletime_error_fallback which
uses the potentially negative size array to trigger a conditional compiler
error, so that sparse doesn't see it.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Luciano Coelho <luciano.coelho@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN include/linux/compiler.h~compilerh-avoid-sparse-errors-in-__compiletime_error_fallback include/linux/compiler.h
--- a/include/linux/compiler.h~compilerh-avoid-sparse-errors-in-__compiletime_error_fallback
+++ a/include/linux/compiler.h
@@ -323,9 +323,18 @@ void ftrace_likely_update(struct ftrace_
 #endif
 #ifndef __compiletime_error
 # define __compiletime_error(message)
-# define __compiletime_error_fallback(condition) \
+/*
+ * Sparse complains of variable sized arrays due to the temporary variable in
+ * __compiletime_assert. Unfortunately we can't just expand it out to make
+ * sparse see a constant array size without breaking compiletime_assert on old
+ * versions of GCC (e.g. 4.2.4), so hide the array from sparse altogether.
+ */
+# ifndef __CHECKER__
+#  define __compiletime_error_fallback(condition) \
 	do { ((void)sizeof(char[1 - 2 * condition])); } while (0)
-#else
+# endif
+#endif
+#ifndef __compiletime_error_fallback
 # define __compiletime_error_fallback(condition) do { } while (0)
 #endif
 
_

Patches currently in -mm which might be from james.hogan@imgtec.com are

compilerh-avoid-sparse-errors-in-__compiletime_error_fallback.patch
linux-next.patch


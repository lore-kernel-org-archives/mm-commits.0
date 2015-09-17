From: akpm@linux-foundation.org
Subject: + kernelh-make-abs-work-with-64-bit-types.patch added to -mm tree
Date: Thu, 17 Sep 2015 14:36:38 -0700
Message-ID: <55fb3266.yHuY6+DaYTJdIL75%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbbIQVgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 17:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mina86@mina86.com, a.p.zijlstra@chello.nl, john.stultz@linaro.org, masami.hiramatsu.pt@hitachi.com, mingo@kernel.org, peterz@infradead.org, rostedt@goodmis.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: make abs() work with 64-bit types
has been added to the -mm tree.  Its filename is
     kernelh-make-abs-work-with-64-bit-types.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernelh-make-abs-work-with-64-bit-types.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernelh-make-abs-work-with-64-bit-types.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: kernel.h: make abs() work with 64-bit types

For 64-bit arguments, the abs macro casts it to an int which leads to lost
precision and may cause incorrect results.  To deal with 64-bit types
abs64 macro has been introduced but still there are places where abs macro
is used incorrectly.

To deal with the problem, expand abs macro such that it operates on s64
type when dealing with 64-bit types while still returning long when
dealing with smaller types.

This fixes one known bug (per John):

The internal clocksteering done for fine-grained error correction uses a
: logarithmic approximation, so any time adjtimex() adjusts the clock
: steering, timekeeping_freqadjust() quickly approximates the correct clock
: frequency over a series of ticks.
: 
: Unfortunately, the logic in timekeeping_freqadjust(), introduced in commit
: dc491596f639438 (Rework frequency adjustments to work better w/ nohz),
: used the abs() function with a s64 error value to calculate the size of
: the approximated adjustment to be made.
: 
: Per include/linux/kernel.h: "abs() should not be used for 64-bit types
: (s64, u64, long long) - use abs64()".
: 
: Thus on 32-bit platforms, this resulted in the clocksteering to take a
: quite dampended random walk trying to converge on the proper frequency,
: which caused the adjustments to be made much slower then intended (most
: easily observed when large adjustments are made).

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Reported-by: John Stultz <john.stultz@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   43 ++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff -puN include/linux/kernel.h~kernelh-make-abs-work-with-64-bit-types include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-make-abs-work-with-64-bit-types
+++ a/include/linux/kernel.h
@@ -200,28 +200,31 @@ extern int _cond_resched(void);
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
-/*
- * abs() handles unsigned and signed longs, ints, shorts and chars.  For all
- * input types abs() returns a signed long.
- * abs() should not be used for 64-bit types (s64, u64, long long) - use abs64()
- * for those.
+/**
+ * abs - return absolute value of an argument
+ * @x: the value.  If it is unsigned type, it is converted to signed type first
+ *   (s64, long or int depending on its size).
+ *
+ * Return: an absolute value of x.  If x is 64-bit, macro's return type is s64,
+ *   otherwise it is signed long.
  */
-#define abs(x) ({						\
-		long ret;					\
-		if (sizeof(x) == sizeof(long)) {		\
-			long __x = (x);				\
-			ret = (__x < 0) ? -__x : __x;		\
-		} else {					\
-			int __x = (x);				\
-			ret = (__x < 0) ? -__x : __x;		\
-		}						\
-		ret;						\
-	})
+#define abs(x) __builtin_choose_expr(sizeof(x) == sizeof(s64), ({	\
+		s64 __x = (x);						\
+		(__x < 0) ? -__x : __x;					\
+	}), ({								\
+		long ret;						\
+		if (sizeof(x) == sizeof(long)) {			\
+			long __x = (x);					\
+			ret = (__x < 0) ? -__x : __x;			\
+		} else {						\
+			int __x = (x);					\
+			ret = (__x < 0) ? -__x : __x;			\
+		}							\
+		ret;							\
+	}))
 
-#define abs64(x) ({				\
-		s64 __x = (x);			\
-		(__x < 0) ? -__x : __x;		\
-	})
+/* Deprecated, use abs instead. */
+#define abs64(x) abs((s64)(x))
 
 /**
  * reciprocal_scale - "scale" a value into range [0, ep_ro)
_

Patches currently in -mm which might be from mina86@mina86.com are

kernelh-make-abs-work-with-64-bit-types.patch


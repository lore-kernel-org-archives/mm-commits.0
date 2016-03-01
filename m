From: akpm@linux-foundation.org
Subject: + bug-set-warn-variable-before-calling-warn.patch added to -mm
 tree
Date: Tue, 01 Mar 2016 11:39:18 -0800
Message-ID: <56d5efe6.NQZceatubFpg2U9U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbcCATjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 14:39:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bug: set warn variable before calling WARN()
has been added to the -mm tree.  Its filename is
     bug-set-warn-variable-before-calling-warn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bug-set-warn-variable-before-calling-warn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bug-set-warn-variable-before-calling-warn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: bug: set warn variable before calling WARN()

This has hit me a couple of times already.  I would be debugging code and
the system would simply hang and then reboot.  Finally, I found that the
problem was caused by WARN_ON_ONCE() and friends.

The macro WARN_ON_ONCE(condition) is defined as:

	static bool __section(.data.unlikely) __warned;
	int __ret_warn_once = !!(condition);

	if (unlikely(__ret_warn_once))
		if (WARN_ON(!__warned))
			__warned = true;

	unlikely(__ret_warn_once);

Which looks great and all.  But what I have hit, is an issue when
WARN_ON() itself hits the same WARN_ON_ONCE() code.  Because, the variable
__warned is not yet set.  Then it too calls WARN_ON() and that triggers
the warning again.  It keeps doing this until the stack is overflowed and
the system crashes.

By setting __warned first before calling WARN_ON() makes the original
WARN_ON_ONCE() really only warn once, and not an infinite amount of times
if the WARN_ON() also triggers the warning.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN include/asm-generic/bug.h~bug-set-warn-variable-before-calling-warn include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~bug-set-warn-variable-before-calling-warn
+++ a/include/asm-generic/bug.h
@@ -110,9 +110,10 @@ extern void warn_slowpath_null(const cha
 	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
-	if (unlikely(__ret_warn_once))				\
-		if (WARN_ON(!__warned)) 			\
-			__warned = true;			\
+	if (unlikely(__ret_warn_once && !__warned)) {		\
+		__warned = true;				\
+		WARN_ON(1);					\
+	}							\
 	unlikely(__ret_warn_once);				\
 })
 
@@ -120,9 +121,10 @@ extern void warn_slowpath_null(const cha
 	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
-	if (unlikely(__ret_warn_once))				\
-		if (WARN(!__warned, format)) 			\
-			__warned = true;			\
+	if (unlikely(__ret_warn_once && !__warned)) {		\
+		__warned = true;				\
+		WARN(1, format);				\
+	}							\
 	unlikely(__ret_warn_once);				\
 })
 
@@ -130,9 +132,10 @@ extern void warn_slowpath_null(const cha
 	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
-	if (unlikely(__ret_warn_once))				\
-		if (WARN_TAINT(!__warned, taint, format))	\
-			__warned = true;			\
+	if (unlikely(__ret_warn_once && !__warned)) {		\
+		__warned = true;				\
+		WARN_TAINT(1, taint, format);			\
+	}							\
 	unlikely(__ret_warn_once);				\
 })
 
_

Patches currently in -mm which might be from rostedt@goodmis.org are

bug-set-warn-variable-before-calling-warn.patch


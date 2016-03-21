From: akpm@linux-foundation.org
Subject: [merged] bug-set-warn-variable-before-calling-warn.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:41:06 -0700
Message-ID: <56f04042.+TdRWUbxPPY0O5XJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbcCUTgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bug: set warn variable before calling WARN()
has been removed from the -mm tree.  Its filename was
     bug-set-warn-variable-before-calling-warn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



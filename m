From: akpm@linux-foundation.org
Subject: [merged] bug-switch-data-corruption-check-to-__must_check.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 12:28:43 -0800
Message-ID: <58b48bfb.R239fFqBBkn8ciZF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60440 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751902AbdB0UaM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:30:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: bug: switch data corruption check to __must_check
has been removed from the -mm tree.  Its filename was
     bug-switch-data-corruption-check-to-__must_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: bug: switch data corruption check to __must_check

The CHECK_DATA_CORRUPTION() macro was designed to have callers do
something meaningful/protective on failure.  However, using "return false"
in the macro too strictly limits the design patterns of callers.  Instead,
let callers handle the logic test directly, but make sure that the result
IS checked by forcing __must_check (which appears to not be able to be
used directly on macro expressions).

Link: http://lkml.kernel.org/r/20170206204547.GA125312@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |   12 ++++++-----
 lib/list_debug.c    |   45 ++++++++++++++++++++++--------------------
 2 files changed, 31 insertions(+), 26 deletions(-)

diff -puN include/linux/bug.h~bug-switch-data-corruption-check-to-__must_check include/linux/bug.h
--- a/include/linux/bug.h~bug-switch-data-corruption-check-to-__must_check
+++ a/include/linux/bug.h
@@ -124,18 +124,20 @@ static inline enum bug_trap_type report_
 
 /*
  * Since detected data corruption should stop operation on the affected
- * structures, this returns false if the corruption condition is found.
+ * structures. Return value must be checked and sanely acted on by caller.
  */
+static inline __must_check bool check_data_corruption(bool v) { return v; }
 #define CHECK_DATA_CORRUPTION(condition, fmt, ...)			 \
-	do {								 \
-		if (unlikely(condition)) {				 \
+	check_data_corruption(({					 \
+		bool corruption = unlikely(condition);			 \
+		if (corruption) {					 \
 			if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION)) { \
 				pr_err(fmt, ##__VA_ARGS__);		 \
 				BUG();					 \
 			} else						 \
 				WARN(1, fmt, ##__VA_ARGS__);		 \
-			return false;					 \
 		}							 \
-	} while (0)
+		corruption;						 \
+	}))
 
 #endif	/* _LINUX_BUG_H */
diff -puN lib/list_debug.c~bug-switch-data-corruption-check-to-__must_check lib/list_debug.c
--- a/lib/list_debug.c~bug-switch-data-corruption-check-to-__must_check
+++ a/lib/list_debug.c
@@ -20,15 +20,16 @@
 bool __list_add_valid(struct list_head *new, struct list_head *prev,
 		      struct list_head *next)
 {
-	CHECK_DATA_CORRUPTION(next->prev != prev,
-		"list_add corruption. next->prev should be prev (%p), but was %p. (next=%p).\n",
-		prev, next->prev, next);
-	CHECK_DATA_CORRUPTION(prev->next != next,
-		"list_add corruption. prev->next should be next (%p), but was %p. (prev=%p).\n",
-		next, prev->next, prev);
-	CHECK_DATA_CORRUPTION(new == prev || new == next,
-		"list_add double add: new=%p, prev=%p, next=%p.\n",
-		new, prev, next);
+	if (CHECK_DATA_CORRUPTION(next->prev != prev,
+			"list_add corruption. next->prev should be prev (%p), but was %p. (next=%p).\n",
+			prev, next->prev, next) ||
+	    CHECK_DATA_CORRUPTION(prev->next != next,
+			"list_add corruption. prev->next should be next (%p), but was %p. (prev=%p).\n",
+			next, prev->next, prev) ||
+	    CHECK_DATA_CORRUPTION(new == prev || new == next,
+			"list_add double add: new=%p, prev=%p, next=%p.\n",
+			new, prev, next))
+		return false;
 
 	return true;
 }
@@ -41,18 +42,20 @@ bool __list_del_entry_valid(struct list_
 	prev = entry->prev;
 	next = entry->next;
 
-	CHECK_DATA_CORRUPTION(next == LIST_POISON1,
-		"list_del corruption, %p->next is LIST_POISON1 (%p)\n",
-		entry, LIST_POISON1);
-	CHECK_DATA_CORRUPTION(prev == LIST_POISON2,
-		"list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
-		entry, LIST_POISON2);
-	CHECK_DATA_CORRUPTION(prev->next != entry,
-		"list_del corruption. prev->next should be %p, but was %p\n",
-		entry, prev->next);
-	CHECK_DATA_CORRUPTION(next->prev != entry,
-		"list_del corruption. next->prev should be %p, but was %p\n",
-		entry, next->prev);
+	if (CHECK_DATA_CORRUPTION(next == LIST_POISON1,
+			"list_del corruption, %p->next is LIST_POISON1 (%p)\n",
+			entry, LIST_POISON1) ||
+	    CHECK_DATA_CORRUPTION(prev == LIST_POISON2,
+			"list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
+			entry, LIST_POISON2) ||
+	    CHECK_DATA_CORRUPTION(prev->next != entry,
+			"list_del corruption. prev->next should be %p, but was %p\n",
+			entry, prev->next) ||
+	    CHECK_DATA_CORRUPTION(next->prev != entry,
+			"list_del corruption. next->prev should be %p, but was %p\n",
+			entry, next->prev))
+		return false;
+
 	return true;
 
 }
_

Patches currently in -mm which might be from keescook@chromium.org are



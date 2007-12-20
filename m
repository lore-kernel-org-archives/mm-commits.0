From: akpm@linux-foundation.org
Subject: - jbd2-remove-printk-from-j_assert-macros.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:38:51 -0800
Message-ID: <200712202338.lBKNcpSY019009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755822AbXLTXsh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: csnook@redhat.com, sct@redhat.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     jbd2: remove printk() from J_ASSERT macros
has been removed from the -mm tree.  Its filename was
     jbd2-remove-printk-from-j_assert-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jbd2: remove printk() from J_ASSERT macros
From: Chris Snook <csnook@redhat.com>

Remove printk from J_ASSERT to preserve registers during BUG.

Signed-off-by: Chris Snook <csnook@redhat.com>
Cc: "Stephen C. Tweedie" <sct@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jbd2.h |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN include/linux/jbd2.h~jbd2-remove-printk-from-j_assert-macros include/linux/jbd2.h
--- a/include/linux/jbd2.h~jbd2-remove-printk-from-j_assert-macros
+++ a/include/linux/jbd2.h
@@ -283,17 +283,7 @@ typedef struct journal_superblock_s
 #include <linux/fs.h>
 #include <linux/sched.h>
 
-#define JBD2_ASSERTIONS
-#ifdef JBD2_ASSERTIONS
-#define J_ASSERT(assert)						\
-do {									\
-	if (!(assert)) {						\
-		printk (KERN_EMERG					\
-			"Assertion failure in %s() at %s:%d: \"%s\"\n",	\
-			__FUNCTION__, __FILE__, __LINE__, # assert);	\
-		BUG();							\
-	}								\
-} while (0)
+#define J_ASSERT(assert)	BUG_ON(!(assert))
 
 #if defined(CONFIG_BUFFER_DEBUG)
 void buffer_assertion_failure(struct buffer_head *bh);
@@ -309,10 +299,6 @@ void buffer_assertion_failure(struct buf
 #define J_ASSERT_JH(jh, expr)	J_ASSERT(expr)
 #endif
 
-#else
-#define J_ASSERT(assert)	do { } while (0)
-#endif		/* JBD2_ASSERTIONS */
-
 #if defined(JBD2_PARANOID_IOFAIL)
 #define J_EXPECT(expr, why...)		J_ASSERT(expr)
 #define J_EXPECT_BH(bh, expr, why...)	J_ASSERT_BH(bh, expr)
_

Patches currently in -mm which might be from csnook@redhat.com are

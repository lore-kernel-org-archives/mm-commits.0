From: akpm@linux-foundation.org
Subject: + jbd2-remove-printk-from-j_assert-macros.patch added to -mm tree
Date: Mon, 20 Aug 2007 14:52:44 -0700
Message-ID: <200708202152.l7KLqiJ9024949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbXHTVxF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 17:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: csnook@redhat.com, sct@redhat.com, tytso@mit.edu


The patch titled
     jbd2: remove printk() from J_ASSERT macros
has been added to the -mm tree.  Its filename is
     jbd2-remove-printk-from-j_assert-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 15 deletions(-)

diff -puN include/linux/jbd2.h~jbd2-remove-printk-from-j_assert-macros include/linux/jbd2.h
--- a/include/linux/jbd2.h~jbd2-remove-printk-from-j_assert-macros
+++ a/include/linux/jbd2.h
@@ -255,17 +255,7 @@ typedef struct journal_superblock_s
 #include <linux/fs.h>
 #include <linux/sched.h>
 
-#define JBD_ASSERTIONS
-#ifdef JBD_ASSERTIONS
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
@@ -281,10 +271,6 @@ void buffer_assertion_failure(struct buf
 #define J_ASSERT_JH(jh, expr)	J_ASSERT(expr)
 #endif
 
-#else
-#define J_ASSERT(assert)	do { } while (0)
-#endif		/* JBD_ASSERTIONS */
-
 #if defined(JBD_PARANOID_IOFAIL)
 #define J_EXPECT(expr, why...)		J_ASSERT(expr)
 #define J_EXPECT_BH(bh, expr, why...)	J_ASSERT_BH(bh, expr)
_

Patches currently in -mm which might be from csnook@redhat.com are

jbd-remove-printk-from-j_assert-macros.patch
jbd2-remove-printk-from-j_assert-macros.patch

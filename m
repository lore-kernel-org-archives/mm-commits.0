From: akpm@linux-foundation.org
Subject: + obsolete-config-in-kernel-source-buffer_debug.patch added to -mm tree
Date: Fri, 05 Feb 2010 14:22:31 -0800
Message-ID: <201002052222.o15MMVs2024708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933918Ab0BEWXO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 17:23:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siccegge@stud.informatik.uni-erlangen.de, jack@suse.cz, tytso@mit.edu


The patch titled
     obsolete config in kernel source: BUFFER_DEBUG
has been added to the -mm tree.  Its filename is
     obsolete-config-in-kernel-source-buffer_debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: obsolete config in kernel source: BUFFER_DEBUG
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>

CONFIG_BUFFER_DEBUG seems to have been removed from the documentation
somewhere around 2.4.15 and seemingly hasn't been available even longer. 
It is, however, still referenced at one place from the jbd code (one is a
copy of the other header).  Time to clean it up

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jbd.h  |   11 -----------
 include/linux/jbd2.h |   11 -----------
 2 files changed, 22 deletions(-)

diff -puN include/linux/jbd.h~obsolete-config-in-kernel-source-buffer_debug include/linux/jbd.h
--- a/include/linux/jbd.h~obsolete-config-in-kernel-source-buffer_debug
+++ a/include/linux/jbd.h
@@ -246,19 +246,8 @@ typedef struct journal_superblock_s
 
 #define J_ASSERT(assert)	BUG_ON(!(assert))
 
-#if defined(CONFIG_BUFFER_DEBUG)
-void buffer_assertion_failure(struct buffer_head *bh);
-#define J_ASSERT_BH(bh, expr)						\
-	do {								\
-		if (!(expr))						\
-			buffer_assertion_failure(bh);			\
-		J_ASSERT(expr);						\
-	} while (0)
-#define J_ASSERT_JH(jh, expr)	J_ASSERT_BH(jh2bh(jh), expr)
-#else
 #define J_ASSERT_BH(bh, expr)	J_ASSERT(expr)
 #define J_ASSERT_JH(jh, expr)	J_ASSERT(expr)
-#endif
 
 #if defined(JBD_PARANOID_IOFAIL)
 #define J_EXPECT(expr, why...)		J_ASSERT(expr)
diff -puN include/linux/jbd2.h~obsolete-config-in-kernel-source-buffer_debug include/linux/jbd2.h
--- a/include/linux/jbd2.h~obsolete-config-in-kernel-source-buffer_debug
+++ a/include/linux/jbd2.h
@@ -277,19 +277,8 @@ typedef struct journal_superblock_s
 
 #define J_ASSERT(assert)	BUG_ON(!(assert))
 
-#if defined(CONFIG_BUFFER_DEBUG)
-void buffer_assertion_failure(struct buffer_head *bh);
-#define J_ASSERT_BH(bh, expr)						\
-	do {								\
-		if (!(expr))						\
-			buffer_assertion_failure(bh);			\
-		J_ASSERT(expr);						\
-	} while (0)
-#define J_ASSERT_JH(jh, expr)	J_ASSERT_BH(jh2bh(jh), expr)
-#else
 #define J_ASSERT_BH(bh, expr)	J_ASSERT(expr)
 #define J_ASSERT_JH(jh, expr)	J_ASSERT(expr)
-#endif
 
 #if defined(JBD2_PARANOID_IOFAIL)
 #define J_EXPECT(expr, why...)		J_ASSERT(expr)
_

Patches currently in -mm which might be from siccegge@stud.informatik.uni-erlangen.de are

linux-next.patch
obsolete-config-in-kernel-source-use_internal_timer.patch
obsolete-config-in-kernel-source-hso_autopm.patch
fbdev-remove-obsolete-config_fb_soft_cursor.patch
obsolete-config-in-kernel-source-lwmon5.patch
obsolete-config-in-kernel-source-buffer_debug.patch


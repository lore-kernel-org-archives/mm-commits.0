From: akpm@linux-foundation.org
Subject: [merged] bugh-prevent-double-evaulation-of-in-build_bug_on.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:20 -0800
Message-ID: <20130222203720.E596431C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:55856 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3BVUhW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:22 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so103369yhz.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, ak@linux.intel.com, bp@alien8.de, joe@perches.com, josh@joshtriplett.org, paul.gortmaker@windriver.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bug.h: prevent double evaulation of `condition' in BUILD_BUG_ON
has been removed from the -mm tree.  Its filename was
     bugh-prevent-double-evaulation-of-in-build_bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: bug.h: prevent double evaulation of `condition' in BUILD_BUG_ON

When calling BUILD_BUG_ON in an optimized build using gcc 4.3 and later,
the condition will be evaulated twice, possibily with side-effects.  This
patch eliminates that error.

[akpm@linux-foundation.org: tweak code layout]
Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/bug.h~bugh-prevent-double-evaulation-of-in-build_bug_on include/linux/bug.h
--- a/include/linux/bug.h~bugh-prevent-double-evaulation-of-in-build_bug_on
+++ a/include/linux/bug.h
@@ -59,9 +59,10 @@ struct pt_regs;
 extern int __build_bug_on_failed;
 #define BUILD_BUG_ON(condition)					\
 	do {							\
-		((void)sizeof(char[1 - 2*!!(condition)]));	\
-		if (condition) __build_bug_on_failed = 1;	\
-	} while(0)
+		bool __cond = !!(condition);			\
+		((void)sizeof(char[1 - 2 * __cond]));		\
+		if (__cond) __build_bug_on_failed = 1;		\
+	} while (0)
 #endif
 
 /**
_

Patches currently in -mm which might be from daniel.santos@pobox.com are

origin.patch


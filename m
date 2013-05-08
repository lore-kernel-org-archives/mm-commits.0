From: akpm@linux-foundation.org
Subject: [merged] remove-unused-random32-and-srandom32.patch removed from -mm tree
Date: Wed, 08 May 2013 11:34:42 -0700
Message-ID: <20130508183442.76CE031C088@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:33467 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216Ab3EHSen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:34:43 -0400
Received: by mail-qa0-f73.google.com with SMTP id bs12so232158qab.0
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:34:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: remove unused random32() and srandom32()
has been removed from the -mm tree.  Its filename was
     remove-unused-random32-and-srandom32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: remove unused random32() and srandom32()

After finishing a naming transition, remove unused backward
compatibility wrapper macros

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/random.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN include/linux/random.h~remove-unused-random32-and-srandom32 include/linux/random.h
--- a/include/linux/random.h~remove-unused-random32-and-srandom32
+++ a/include/linux/random.h
@@ -29,13 +29,6 @@ u32 prandom_u32(void);
 void prandom_bytes(void *buf, int nbytes);
 void prandom_seed(u32 seed);
 
-/*
- * These macros are preserved for backward compatibility and should be
- * removed as soon as a transition is finished.
- */
-#define random32() prandom_u32()
-#define srandom32(seed) prandom_seed(seed)

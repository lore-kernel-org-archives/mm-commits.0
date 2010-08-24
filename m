From: akpm@linux-foundation.org
Subject: + include-linux-pageblock-flagsh-fix-set_pageblock_flags-macro-definiton.patch added to -mm tree
Date: Tue, 24 Aug 2010 16:48:24 -0700
Message-ID: <201008242348.o7ONmODv023476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932841Ab0HXXtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Aug 2010 19:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zealcook@gmail.com, mel@csn.ul.ie


The patch titled
     include/linux/pageblock-flags.h: fix set_pageblock_flags() macro definiton
has been added to the -mm tree.  Its filename is
     include-linux-pageblock-flagsh-fix-set_pageblock_flags-macro-definiton.patch

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
Subject: include/linux/pageblock-flags.h: fix set_pageblock_flags() macro definiton
From: zeal <zealcook@gmail.com>

The presently-unused macro was missing one parameter.

Signed-off-by: zeal <zealcook@gmail.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/pageblock-flags.h~include-linux-pageblock-flagsh-fix-set_pageblock_flags-macro-definiton include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~include-linux-pageblock-flagsh-fix-set_pageblock_flags-macro-definiton
+++ a/include/linux/pageblock-flags.h
@@ -67,7 +67,8 @@ void set_pageblock_flags_group(struct pa
 
 #define get_pageblock_flags(page) \
 			get_pageblock_flags_group(page, 0, NR_PAGEBLOCK_BITS-1)
-#define set_pageblock_flags(page) \
-			set_pageblock_flags_group(page, 0, NR_PAGEBLOCK_BITS-1)
+#define set_pageblock_flags(page, flags) \
+			set_pageblock_flags_group(page, flags,	\
+						  0, NR_PAGEBLOCK_BITS-1)
 
 #endif	/* PAGEBLOCK_FLAGS_H */
_

Patches currently in -mm which might be from zealcook@gmail.com are

include-linux-pageblock-flagsh-fix-set_pageblock_flags-macro-definiton.patch


From: akpm@linux-foundation.org
Subject: + mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch added to -mm tree
Date: Wed, 30 Apr 2008 05:21:07 -0700
Message-ID: <200804301221.m3UCL7hw013186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174AbYD3MWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 08:22:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com, mingo@elte.hu


The patch titled
     Fix for memory initialisation debugging framework
has been added to the -mm tree.  Its filename is
     mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix for memory initialisation debugging framework
From: Mel Gorman <mel@csn.ul.ie>

This patch is a fix to
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch pointed out
by an off-list reviewer. The intention of the code was to change the printk
loglevel depending on the message level passed to mminit_dprintk(). What
actually happens is that for MMINIT_WARNING and levels, only the loglevel
is sent to printk() and not the message. This patch fixes the code to behave
as intended.

It can be folded safely into
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch without
causing collisions later in the set.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/internal.h~mm-add-a-basic-debugging-framework-for-memory-initialisation-fix mm/internal.h
--- a/mm/internal.h~mm-add-a-basic-debugging-framework-for-memory-initialisation-fix
+++ a/mm/internal.h
@@ -73,8 +73,8 @@ extern int mminit_loglevel;
 #define mminit_dprintk(level, prefix, fmt, arg...) \
 do { \
 	if (level < mminit_loglevel) { \
-		printk(level <= MMINIT_WARNING ? KERN_WARNING : KERN_DEBUG \
-			"mminit:: " prefix " " fmt, ##arg); \
+		printk(level <= MMINIT_WARNING ? KERN_WARNING : KERN_DEBUG); \
+		printk(KERN_CONT "mminit::" prefix " " fmt, ##arg); \
 	} \
 } while (0)
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
proc-pagetypeinfo-fix-output-for-memoryless-nodes.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch


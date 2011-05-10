From: akpm@linux-foundation.org
Subject: + mm-tracing-add-missing-gfp-flags-to-tracing.patch added to -mm tree
Date: Tue, 10 May 2011 14:54:53 -0700
Message-ID: <201105102154.p4ALsr45024262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab1EJVzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 May 2011 17:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aarcange@redhat.com


The patch titled
     mm: tracing: add missing GFP flags to tracing
has been added to the -mm tree.  Its filename is
     mm-tracing-add-missing-gfp-flags-to-tracing.patch

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
Subject: mm: tracing: add missing GFP flags to tracing
From: Mel Gorman <mgorman@suse.de>

include/linux/gfp.h and include/trace/events/gfpflags.h are out of sync. 
When tracing is enabled, certain flags are not recognised and the text
output is less useful as a result.  Add the missing flags.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/gfpflags.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/trace/events/gfpflags.h~mm-tracing-add-missing-gfp-flags-to-tracing include/trace/events/gfpflags.h
--- a/include/trace/events/gfpflags.h~mm-tracing-add-missing-gfp-flags-to-tracing
+++ a/include/trace/events/gfpflags.h
@@ -10,6 +10,7 @@
  */
 #define show_gfp_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
+	{(unsigned long)GFP_TRANSHUGE,		"GFP_TRANSHUGE"},	\
 	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"}, \
 	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
 	{(unsigned long)GFP_USER,		"GFP_USER"},		\
@@ -32,6 +33,9 @@
 	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
 	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
-	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"}		\
+	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
+	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
+	{(unsigned long)__GFP_NO_KSWAPD,	"GFP_NO_KSWAPD"},	\
+	{(unsigned long)__GFP_OTHER_NODE,	"GFP_OTHER_NODE"}	\
 	) : "GFP_NOWAIT"
 
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-tracing-add-missing-gfp-flags-to-tracing.patch


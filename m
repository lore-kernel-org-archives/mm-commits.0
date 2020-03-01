From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-mm=5Finitc-clean-code-use-build=5Fbug=5Fon-when-comparing?=
 =?US-ASCII?Q?-compile-time-constant.patch?= added to -mm tree
Date: Sat, 29 Feb 2020 18:08:31 -0800
Message-ID: <20200301020831.z_JleSR9S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727255AbgCACIc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 21:08:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mateusznosek0@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: clean code. Use BUILD_BUG_ON when comparing compile time constant
has been added to the -mm tree.  Its filename is
     mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/mm_init.c: clean code. Use BUILD_BUG_ON when comparing compile time constant

MAX_ZONELISTS is a compile time constant, so it should be compared using
BUILD_BUG_ON not BUG_ON.

Link: http://lkml.kernel.org/r/20200228224617.11343-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant
+++ a/mm/mm_init.c
@@ -37,7 +37,7 @@ void __init mminit_verify_zonelist(void)
 		struct zonelist *zonelist;
 		int i, listid, zoneid;
 
-		BUG_ON(MAX_ZONELISTS > 2);
+		BUILD_BUG_ON(MAX_ZONELISTS > 2);
 		for (i = 0; i < MAX_ZONELISTS * MAX_NR_ZONES; i++) {
 
 			/* Identify the zone and nodelist */
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch
mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch

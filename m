From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-mm=5Finitc-clean-code-use-build=5Fbug=5Fon-when-comparing?=
 =?US-ASCII?Q?-compile-time-constant.patch?= removed from -mm tree
Date: Tue, 07 Apr 2020 18:59:56 -0700
Message-ID: <20200408015956.BXzEsefdp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgDHB75 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mateusznosek0@gmail.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: mm/mm_init.c: clean code. Use BUILD_BUG_ON when comparing compile time constant
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/mm_init.c: clean code. Use BUILD_BUG_ON when comparing compile time constant

MAX_ZONELISTS is a compile time constant, so it should be compared using
BUILD_BUG_ON not BUG_ON.

Link: http://lkml.kernel.org/r/20200228224617.11343-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
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

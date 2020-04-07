From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 087/166] mm/mm_init.c: clean code. Use
 BUILD_BUG_ON when comparing compile time constant
Date: Mon, 06 Apr 2020 20:08:36 -0700
Message-ID: <20200407030836.Gjtk9qcWW%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDIi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:38 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mateusznosek0@gmail.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, torvalds@linux-foundation.org

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

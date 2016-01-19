From: akpm@linux-foundation.org
Subject: [merged] mm-fix-noisy-sparse-warning-in-libcfs_alloc_pre.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:00:18 -0800
Message-ID: <569e95d2.ptasUF10AlROCN8u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbcASUAS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stillcompiling@gmail.com, mgorman@techsingularity.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix noisy sparse warning in LIBCFS_ALLOC_PRE()
has been removed from the -mm tree.  Its filename was
     mm-fix-noisy-sparse-warning-in-libcfs_alloc_pre.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joshua Clayton <stillcompiling@gmail.com>
Subject: mm: fix noisy sparse warning in LIBCFS_ALLOC_PRE()

Running sparse on drivers/staging/lustre results in dozens of warnings:
include/linux/gfp.h:281:41: warning:
odd constant _Bool cast (400000 becomes 1)

Use "!!" to explicitly convert to bool and get rid of the warning.

Signed-off-by: Joshua Clayton <stillcompiling@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-fix-noisy-sparse-warning-in-libcfs_alloc_pre include/linux/gfp.h
--- a/include/linux/gfp.h~mm-fix-noisy-sparse-warning-in-libcfs_alloc_pre
+++ a/include/linux/gfp.h
@@ -278,7 +278,7 @@ static inline int gfpflags_to_migratetyp
 
 static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
 {
-	return (bool __force)(gfp_flags & __GFP_DIRECT_RECLAIM);
+	return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
 }
 
 #ifdef CONFIG_HIGHMEM
_

Patches currently in -mm which might be from stillcompiling@gmail.com are



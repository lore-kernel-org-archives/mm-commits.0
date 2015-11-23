From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-up-sparse-warning-in-gfpflags_allow_blocking.patch removed from -mm
 tree
Date: Mon, 23 Nov 2015 12:15:26 -0800
Message-ID: <565373de.UzW0fDiDm1GN/drC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbbKWUP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@poochiereds.net, jeff.layton@primarydata.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix up sparse warning in gfpflags_allow_blocking
has been removed from the -mm tree.  Its filename was
     mm-fix-up-sparse-warning-in-gfpflags_allow_blocking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Layton <jlayton@poochiereds.net>
Subject: mm: fix up sparse warning in gfpflags_allow_blocking

sparse says:

    include/linux/gfp.h:274:26: warning: incorrect type in return expression (different base types)
    include/linux/gfp.h:274:26:    expected bool
    include/linux/gfp.h:274:26:    got restricted gfp_t

...add a forced cast to silence the warning.

Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-fix-up-sparse-warning-in-gfpflags_allow_blocking include/linux/gfp.h
--- a/include/linux/gfp.h~mm-fix-up-sparse-warning-in-gfpflags_allow_blocking
+++ a/include/linux/gfp.h
@@ -271,7 +271,7 @@ static inline int gfpflags_to_migratetyp
 
 static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
 {
-	return gfp_flags & __GFP_DIRECT_RECLAIM;
+	return (bool __force)(gfp_flags & __GFP_DIRECT_RECLAIM);
 }
 
 #ifdef CONFIG_HIGHMEM
_

Patches currently in -mm which might be from jlayton@poochiereds.net are

fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread.patch


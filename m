From: akpm@linux-foundation.org
Subject: + mm-fix-noisy-sparse-warning-in-libcfs_alloc_pre.patch added to
 -mm tree
Date: Tue, 29 Dec 2015 13:27:54 -0800
Message-ID: <5682fada.GtA+PpD+6fqIqVF2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbbL2V1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Dec 2015 16:27:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stillcompiling@gmail.com, mgorman@techsingularity.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix noisy sparse warning in LIBCFS_ALLOC_PRE()
has been added to the -mm tree.  Its filename is
     mm-fix-noisy-sparse-warning-in-libcfs_alloc_pre.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-noisy-sparse-warning-in-libcfs_alloc_pre.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-noisy-sparse-warning-in-libcfs_alloc_pre.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joshua Clayton <stillcompiling@gmail.com>
Subject: mm: fix noisy sparse warning in LIBCFS_ALLOC_PRE()

running sparse on drivers/staging/lustre results in dozens of warnings:
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

mm-fix-noisy-sparse-warning-in-libcfs_alloc_pre.patch


From: akpm@linux-foundation.org
Subject: + mm-fix-up-sparse-warning-in-gfpflags_allow_blocking.patch added to -mm tree
Date: Fri, 20 Nov 2015 14:17:28 -0800
Message-ID: <564f9bf8.Y530DD3Dfx1E37Ei%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbbKTWR3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Nov 2015 17:17:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@poochiereds.net, jeff.layton@primarydata.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix up sparse warning in gfpflags_allow_blocking
has been added to the -mm tree.  Its filename is
     mm-fix-up-sparse-warning-in-gfpflags_allow_blocking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-up-sparse-warning-in-gfpflags_allow_blocking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-up-sparse-warning-in-gfpflags_allow_blocking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-up-sparse-warning-in-gfpflags_allow_blocking.patch
fsnotify-destroy-marks-with-call_srcu-instead-of-dedicated-thread.patch


From: akpm@linux-foundation.org
Subject: [merged] include-linux-gfph-work-around-apparent-sparse-confusion.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:55 -0700
Message-ID: <201105252026.p4PKQI31014484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756513Ab1EYUpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/gfp.h: work around apparent sparse confusion
has been removed from the -mm tree.  Its filename was
     include-linux-gfph-work-around-apparent-sparse-confusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/gfp.h: work around apparent sparse confusion
From: Dave Hansen <dave@linux.vnet.ibm.com>

Running sparse on page_alloc.c today, it errors out:
        include/linux/gfp.h:254:17: error: bad constant expression
        include/linux/gfp.h:254:17: error: cannot size expression

which is a line in gfp_zone():

        BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);

That's really unfortunate, because it ends up hiding all of the other
legitimate sparse messages like this:
        mm/page_alloc.c:5315:59: warning: incorrect type in argument 1 (different base types)
        mm/page_alloc.c:5315:59:    expected unsigned long [unsigned] [usertype] size
        mm/page_alloc.c:5315:59:    got restricted gfp_t [usertype] <noident>
...

Having sparse be able to catch these very oopsable bugs is a lot more
important than keeping a BUILD_BUG_ON().  Kill the BUILD_BUG_ON().

Compiles on x86_64 with and without CONFIG_DEBUG_VM=y.  defconfig boots
fine for me.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN include/linux/gfp.h~include-linux-gfph-work-around-apparent-sparse-confusion include/linux/gfp.h
--- a/include/linux/gfp.h~include-linux-gfph-work-around-apparent-sparse-confusion
+++ a/include/linux/gfp.h
@@ -249,14 +249,9 @@ static inline enum zone_type gfp_zone(gf
 
 	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
 					 ((1 << ZONES_SHIFT) - 1);

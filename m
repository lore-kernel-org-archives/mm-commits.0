From: akpm@linux-foundation.org
Subject: [merged] make-gfp_notrack-definition-unconditional.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:41 -0700
Message-ID: <20121009181441.B03AC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:57225 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab2JISOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:14:42 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so574663yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:14:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, mgorman@suse.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: make GFP_NOTRACK definition unconditional
has been removed from the -mm tree.  Its filename was
     make-gfp_notrack-definition-unconditional.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: make GFP_NOTRACK definition unconditional

There was a general sentiment in a recent discussion (See
https://lkml.org/lkml/2012/9/18/258) that the __GFP flags should be
defined unconditionally.  Currently, the only offender is GFP_NOTRACK,
which is conditional to KMEMCHECK.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/linux/gfp.h~make-gfp_notrack-definition-unconditional include/linux/gfp.h
--- a/include/linux/gfp.h~make-gfp_notrack-definition-unconditional
+++ a/include/linux/gfp.h
@@ -30,11 +30,7 @@ struct vm_area_struct;
 #define ___GFP_HARDWALL		0x20000u
 #define ___GFP_THISNODE		0x40000u
 #define ___GFP_RECLAIMABLE	0x80000u
-#ifdef CONFIG_KMEMCHECK
 #define ___GFP_NOTRACK		0x200000u
-#else
-#define ___GFP_NOTRACK		0
-#endif
 #define ___GFP_OTHER_NODE	0x800000u
 #define ___GFP_WRITE		0x1000000u
 
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch


From: akpm@linux-foundation.org
Subject: + make-gfp_notrack-definition-unconditional.patch added to -mm tree
Date: Mon, 01 Oct 2012 13:01:45 -0700
Message-ID: <20121001200146.2A884200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43238 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2JAUBs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 16:01:48 -0400
Received: by bkwq16 with SMTP id q16so385303bkw.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 13:01:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, mgorman@suse.de


The patch titled
     Subject: make GFP_NOTRACK definition unconditional
has been added to the -mm tree.  Its filename is
     make-gfp_notrack-definition-unconditional.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
memcg-cleanup-kmem-tcp-ifdefs.patch
memcg-move-mem_cgroup_is_root-upwards.patch
make-gfp_notrack-definition-unconditional.patch
idr-rename-max_level-to-max_idr_level.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch


From: akpm@linux-foundation.org
Subject: + mm-vmalloc-fix-vmalloc-users-tracking-properly-fix.patch added
 to -mm tree
Date: Tue, 09 May 2017 14:16:24 -0700
Message-ID: <591231a8.lNaxor5Izj7gPRCE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdEIVQZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 17:16:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-fix-vmalloc-users-tracking-properly-fix
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-vmalloc-users-tracking-properly-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-vmalloc-users-tracking-properly-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-vmalloc-users-tracking-properly-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm-vmalloc-fix-vmalloc-users-tracking-properly-fix

I've noticed that I forgot to revert the comment for the originally
inlined __vmalloc_node_flags which is no longer relevant.

Link: http://lkml.kernel.org/r/20170509211054.GB16325@dhcp22.suse.cz

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/vmalloc.h~mm-vmalloc-fix-vmalloc-users-tracking-properly-fix include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmalloc-fix-vmalloc-users-tracking-properly-fix
+++ a/include/linux/vmalloc.h
@@ -87,11 +87,6 @@ static inline void *__vmalloc_node_flags
 	return __vmalloc_node_flags(size, node, flags);
 }
 #else
-/*
- * We really want to have this inlined due to caller tracking. This
- * function is used by the highlevel vmalloc apis and so we want to track
- * their callers and inlining will achieve that.
- */
 extern void *__vmalloc_node_flags_caller(unsigned long size,
 					int node, gfp_t flags, void* caller);
 #endif
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-vmalloc-fix-vmalloc-users-tracking-properly-fix.patch


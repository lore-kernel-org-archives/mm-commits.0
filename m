From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmalloc-fix-vmalloc-users-tracking-properly-fix.patch removed from -mm
 tree
Date: Fri, 12 May 2017 15:41:47 -0700
Message-ID: <59163a2b.xuTL5gbp4jxH8aYG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38382 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753257AbdELWls (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-fix-vmalloc-users-tracking-properly-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-vmalloc-users-tracking-properly-fix.patch

This patch was dropped because it was folded into mm-vmalloc-fix-vmalloc-users-tracking-properly.patch

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

mm-vmalloc-fix-vmalloc-users-tracking-properly.patch


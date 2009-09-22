From: akpm@linux-foundation.org
Subject: [merged] mm-remove-obsoleted-alloc_pages-cpuset-comment.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:22 -0700
Message-ID: <200909222037.n8MKbMC5031710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbZIVUhx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:37:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, menage@google.com, miaox@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove obsoleted alloc_pages cpuset comment
has been removed from the -mm tree.  Its filename was
     mm-remove-obsoleted-alloc_pages-cpuset-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove obsoleted alloc_pages cpuset comment
From: David Rientjes <rientjes@google.com>

When a cpuset's nodemask is updated, all attached tasks have their cached
task->mems_allowed updated by a heap instead of requiring an explicit call
to cpuset_update_task_memory_state(), which has since been removed in
58568d2a8215cb6f55caf2332017d7bdff954e1c ("cpuset,mm: update tasks'
mems_allowed in time").

Remove the obsoleted comment from the page allocator.

Cc: Paul Menage <menage@google.com>
Acked-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-obsoleted-alloc_pages-cpuset-comment mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-obsoleted-alloc_pages-cpuset-comment
+++ a/mm/page_alloc.c
@@ -1627,10 +1627,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();

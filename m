From: akpm@linux-foundation.org
Subject: + mm-remove-obsoleted-alloc_pages-cpuset-comment.patch added to -mm tree
Date: Fri, 26 Jun 2009 13:28:46 -0700
Message-ID: <200906262028.n5QKSkkE019514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbZFZU2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 16:28:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, menage@google.com, miaox@cn.fujitsu.com


The patch titled
     mm: remove obsoleted alloc_pages cpuset comment
has been added to the -mm tree.  Its filename is
     mm-remove-obsoleted-alloc_pages-cpuset-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-obsoleted-alloc_pages-cpuset-comment mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-obsoleted-alloc_pages-cpuset-comment
+++ a/mm/page_alloc.c
@@ -1620,10 +1620,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();

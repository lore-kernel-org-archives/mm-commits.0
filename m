From: akpm@linux-foundation.org
Subject: + vmemmap-warn-about-page_structs-with-remote-distance.patch added to -mm tree
Date: Tue, 28 Oct 2008 14:38:23 -0700
Message-ID: <200810282138.m9SLcNnl010853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871AbYJ1Via (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 17:38:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, cl@linux-foundation.org


The patch titled
     vmemmap: warn about page_structs with remote distance
has been added to the -mm tree.  Its filename is
     vmemmap-warn-about-page_structs-with-remote-distance.patch

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
Subject: vmemmap: warn about page_structs with remote distance
From: David Rientjes <rientjes@google.com>

It's insufficient to simply compare node ids when warning about offnode
page_structs since it's possible to still have local affinity.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse-vmemmap.c~vmemmap-warn-about-page_structs-with-remote-distance mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~vmemmap-warn-about-page_structs-with-remote-distance
+++ a/mm/sparse-vmemmap.c
@@ -64,7 +64,7 @@ void __meminit vmemmap_verify(pte_t *pte
 	unsigned long pfn = pte_pfn(*pte);
 	int actual_node = early_pfn_to_nid(pfn);
 
-	if (actual_node != node)
+	if (node_distance(actual_node, node) > LOCAL_DISTANCE)
 		printk(KERN_WARNING "[%lx-%lx] potential offnode "
 			"page_structs\n", start, end - 1);
 }
_

Patches currently in -mm which might be from rientjes@google.com are

oom-do-not-dump-task-state-for-non-thread-group-leaders.patch
vmemmap-warn-about-page_structs-with-remote-distance.patch


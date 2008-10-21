From: akpm@linux-foundation.org
Subject: + mm-page_cgroup-needs-linux-vmalloch-for-vmalloc_node-vfree.patch added to -mm tree
Date: Mon, 20 Oct 2008 20:48:26 -0700
Message-ID: <200810210348.m9L3mQal024770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425AbYJUDtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 23:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: page_cgroup needs linux/vmalloc.h for vmalloc_node()/vfree().
has been added to the -mm tree.  Its filename is
     mm-page_cgroup-needs-linux-vmalloch-for-vmalloc_node-vfree.patch

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
Subject: mm: page_cgroup needs linux/vmalloc.h for vmalloc_node()/vfree().
From: Paul Mundt <lethal@linux-sh.org>

mm/page_cgroup.c: In function 'init_section_page_cgroup':
mm/page_cgroup.c:111: error: implicit declaration of function 'vmalloc_node'
mm/page_cgroup.c:111: warning: assignment makes pointer from integer without a cast
mm/page_cgroup.c: In function '__free_page_cgroup':
mm/page_cgroup.c:140: error: implicit declaration of function 'vfree'

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_cgroup.c~mm-page_cgroup-needs-linux-vmalloch-for-vmalloc_node-vfree mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-page_cgroup-needs-linux-vmalloch-for-vmalloc_node-vfree
+++ a/mm/page_cgroup.c
@@ -5,6 +5,7 @@
 #include <linux/page_cgroup.h>
 #include <linux/hash.h>
 #include <linux/memory.h>
+#include <linux/vmalloc.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
mm-page_cgroup-needs-linux-vmalloch-for-vmalloc_node-vfree.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch


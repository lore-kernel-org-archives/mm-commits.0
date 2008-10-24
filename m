From: akpm@linux-foundation.org
Subject: - mm-page_cgroup-needs-linux-vmalloch-for-vmalloc_node-vfree.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:40:26 -0700
Message-ID: <200810241940.m9OJeQ8e000899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512AbYJXTm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Oct 2008 15:42:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, heiko.carstens@de.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: page_cgroup needs linux/vmalloc.h for vmalloc_node()/vfree().
has been removed from the -mm tree.  Its filename was
     mm-page_cgroup-needs-linux-vmalloch-for-vmalloc_node-vfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
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
linux-next.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch


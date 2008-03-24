From: akpm@linux-foundation.org
Subject: + mm-allocate-section_map-for-sparse_init-update.patch added to -mm tree
Date: Mon, 24 Mar 2008 12:47:43 -0700
Message-ID: <200803241947.m2OJlhsC022305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781AbYCXTsY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 15:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel.send@gmail.com, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, y-goto@jp.fujitsu.com, yhlu.kernel@gmail.com


The patch titled
     mm: allocate section_map for sparse_init (update)
has been added to the -mm tree.  Its filename is
     mm-allocate-section_map-for-sparse_init-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: allocate section_map for sparse_init (update)
From: Yinghai Lu <yhlu.kernel.send@gmail.com>

allocate section_map in bootmem instead of using __initdata.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/sparse.c~mm-allocate-section_map-for-sparse_init-update mm/sparse.c
--- a/mm/sparse.c~mm-allocate-section_map-for-sparse_init-update
+++ a/mm/sparse.c
@@ -335,8 +335,7 @@ void __init sparse_init(void)
 								usemap);
 	}
 
-	for_each_online_node(node)
-		free_bootmem_node(NODE_DATA(node), __pa(section_map), size);
+	free_bootmem(__pa(section_map), size);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
_

Patches currently in -mm which might be from yhlu.kernel.send@gmail.com are

origin.patch
mm-allocate-section_map-for-sparse_init-update.patch
mm-offset-align-in-alloc_bootmem-v3.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-v2.patch


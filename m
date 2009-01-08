From: akpm@linux-foundation.org
Subject: - memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:06 -0800
Message-ID: <200901082248.n08Mm6BM027486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761341AbZAHWsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: do not recalculate section unnecessarily in init_section_page_cgroup
has been removed from the -mm tree.  Its filename was
     memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: do not recalculate section unnecessarily in init_section_page_cgroup
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

In init_section_page_cgroup() the section a given pfn belongs to is
calculated at the top of the function and, despite the fact that the
pfn/section correspondence does not change, it is recalculated further
down the same function.  By computing this just once and reusing that
value we save some bytes in the object file and do not waste CPU cycles.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/page_cgroup.c~memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup
+++ a/mm/page_cgroup.c
@@ -103,13 +103,11 @@ struct page_cgroup *lookup_page_cgroup(s
 /* __alloc_bootmem...() is protected by !slab_available() */
 static int __init_refok init_section_page_cgroup(unsigned long pfn)
 {
-	struct mem_section *section;
+	struct mem_section *section = __pfn_to_section(pfn);
 	struct page_cgroup *base, *pc;
 	unsigned long table_size;
 	int nid, index;
 
-	section = __pfn_to_section(pfn);

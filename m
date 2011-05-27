From: akpm@linux-foundation.org
Subject: [merged] memcg-mark-init_section_page_cgroup-properly.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:02 -0700
Message-ID: <201105271956.p4RJu7pj017520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757118Ab1E0T4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: mark init_section_page_cgroup() properly
has been removed from the -mm tree.  Its filename was
     memcg-mark-init_section_page_cgroup-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: mark init_section_page_cgroup() properly
From: Namhyung Kim <namhyung@gmail.com>

Commit ca371c0d7e23 ("memcg: fix page_cgroup fatal error in FLATMEM")
removes call to alloc_bootmem() in the function so that it can be marked
as __meminit to reduce memory usage when MEMORY_HOTPLUG=n.

Also as the new helper function alloc_page_cgroup() is called only in the
function, it should be marked too.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_cgroup.c~memcg-mark-init_section_page_cgroup-properly mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-mark-init_section_page_cgroup-properly
+++ a/mm/page_cgroup.c
@@ -130,7 +130,7 @@ struct page *lookup_cgroup_page(struct p
 	return page;
 }
 
-static void *__init_refok alloc_page_cgroup(size_t size, int nid)
+static void *__meminit alloc_page_cgroup(size_t size, int nid)
 {
 	void *addr = NULL;
 
@@ -162,7 +162,7 @@ static void free_page_cgroup(void *addr)
 }
 #endif
 
-static int __init_refok init_section_page_cgroup(unsigned long pfn)
+static int __meminit init_section_page_cgroup(unsigned long pfn)
 {
 	struct page_cgroup *base, *pc;
 	struct mem_section *section;
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch


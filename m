From: akpm@linux-foundation.org
Subject: + memcg-mark-init_section_page_cgroup-properly.patch added to -mm tree
Date: Tue, 12 Apr 2011 14:43:11 -0700
Message-ID: <201104122143.p3CLhBpt004420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932668Ab1DLVnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 17:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: mark init_section_page_cgroup() properly
has been added to the -mm tree.  Its filename is
     memcg-mark-init_section_page_cgroup-properly.patch

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

mm-nommu-sort-mm-mmap-list-properly.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-nommu-dont-scan-the-vma-list-when-deleting.patch
mm-nommu-find-vma-using-the-sorted-vma-list.patch
mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma.patch
mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private.patch
mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch


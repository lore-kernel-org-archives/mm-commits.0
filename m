From: akpm@linux-foundation.org
Subject: + memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch added to -mm tree
Date: Tue, 12 Apr 2011 14:43:13 -0700
Message-ID: <201104122143.p3CLhDmq004423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932674Ab1DLVn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 17:43:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix off-by-one when calculating swap cgroup map length
has been added to the -mm tree.  Its filename is
     memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch

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
Subject: memcg: fix off-by-one when calculating swap cgroup map length
From: Namhyung Kim <namhyung@gmail.com>

It allocated one more page than necessary if @max_pages was a multiple of
SC_PER_PAGE.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_cgroup.c~memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length
+++ a/mm/page_cgroup.c
@@ -475,7 +475,7 @@ int swap_cgroup_swapon(int type, unsigne
 	if (!do_swap_account)
 		return 0;
 
-	length = ((max_pages/SC_PER_PAGE) + 1);
+	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
 	array_size = length * sizeof(void *);
 
 	array = vmalloc(array_size);
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


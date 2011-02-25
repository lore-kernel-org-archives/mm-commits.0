From: akpm@linux-foundation.org
Subject: + memcg-more-mem_cgroup_uncharge-batching.patch added to -mm tree
Date: Thu, 24 Feb 2011 16:22:30 -0800
Message-ID: <201102250022.p1P0MUHh003670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756694Ab1BYAXQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 19:23:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: more mem_cgroup_uncharge() batching
has been added to the -mm tree.  Its filename is
     memcg-more-mem_cgroup_uncharge-batching.patch

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
Subject: memcg: more mem_cgroup_uncharge() batching
From: Hugh Dickins <hughd@google.com>

It seems odd that truncate_inode_pages_range(), called not only when
truncating but also when evicting inodes, has mem_cgroup_uncharge_start
and _end() batching in its second loop to clear up a few leftovers, but
not in its first loop that does almost all the work: add them there too.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/truncate.c~memcg-more-mem_cgroup_uncharge-batching mm/truncate.c
--- a/mm/truncate.c~memcg-more-mem_cgroup_uncharge-batching
+++ a/mm/truncate.c
@@ -232,6 +232,7 @@ void truncate_inode_pages_range(struct a
 	next = start;
 	while (next <= end &&
 	       pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
+		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 			pgoff_t page_index = page->index;
@@ -254,6 +255,7 @@ void truncate_inode_pages_range(struct a
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);
+		mem_cgroup_uncharge_end();
 		cond_resched();
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
memcg-more-mem_cgroup_uncharge-batching.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-rename-drop_anon_vma-to-put_anon_vma.patch
mm-move-anon_vma-ref-out-from-under-config_foo.patch
mm-simplify-anon_vma-refcounts.patch
mm-remove-worrying-dead-code-from-find_get_pages.patch
mm-dont-return-0-too-early-from-find_get_pages.patch
prio_tree-debugging-patch.patch


From: akpm@linux-foundation.org
Subject: [merged] vmscan-fix-bad-page-removal-from-lru.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:10:49 -0700
Message-ID: <200906241910.n5OJAncX011005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118AbZFXTLD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:11:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, mingo@elte.hu, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     vmscan: fix bad page removal from LRU
has been removed from the -mm tree.  Its filename was
     vmscan-fix-bad-page-removal-from-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: fix bad page removal from LRU
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

A page isolated is "cursor_page" not "page".  This causes list corruption.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Tested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-fix-bad-page-removal-from-lru mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-bad-page-removal-from-lru
+++ a/mm/vmscan.c
@@ -932,7 +932,7 @@ static unsigned long isolate_lru_pages(u
 				continue;
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
-				mem_cgroup_del_lru(page);
+				mem_cgroup_del_lru(cursor_page);
 				nr_taken++;
 				scan++;
 			}
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
elf-limit-max-map-count-to-safe-value.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch


From: akpm@linux-foundation.org
Subject: + vmscan-fix-bad-page-removal-from-lru.patch added to -mm tree
Date: Tue, 23 Jun 2009 07:39:46 -0700
Message-ID: <200906231439.n5NEdksF018222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755721AbZFWOku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 10:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, mingo@elte.hu, nishimura@mxp.nes.nec.co.jp


The patch titled
     vmscan: fix bad page removal from LRU
has been added to the -mm tree.  Its filename is
     vmscan-fix-bad-page-removal-from-lru.patch

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
vmscan-fix-bad-page-removal-from-lru.patch
elf-limit-max-map-count-to-safe-value.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch


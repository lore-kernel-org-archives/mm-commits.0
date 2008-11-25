From: akpm@linux-foundation.org
Subject: + memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch added to -mm tree
Date: Tue, 25 Nov 2008 15:54:36 -0800
Message-ID: <200811252354.mAPNsaQO025991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115AbYKYXy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 18:54:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     memcg: reclaim shouldn't change zone->recent_rotated statistics
has been added to the -mm tree.  Its filename is
     memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch

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
Subject: memcg: reclaim shouldn't change zone->recent_rotated statistics
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

memcg reclaim shouldn't change zone->recent_rotated statistics.  If
memcgroup reclaim changes zone statistics, global reclaim can get a bit
confused.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics mm/vmscan.c
--- a/mm/vmscan.c~memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics
+++ a/mm/vmscan.c
@@ -1292,7 +1292,8 @@ static void shrink_active_list(unsigned 
 	 * This helps balance scan pressure between file and anonymous
 	 * pages in get_scan_ratio.
 	 */
-	zone->recent_rotated[!!file] += pgmoved;
+	if (scan_global_lru(sc))
+		zone->recent_rotated[!!file] += pgmoved;
 
 	/*
 	 * Move the pages to the [file or anon] inactive list.
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
vmscan-evict-streaming-io-first.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch


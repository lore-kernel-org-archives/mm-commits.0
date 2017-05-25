From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mlock-fix-mlock-count-can-not-decrease-in-race-condition.patch removed from -mm tree
Date: Thu, 25 May 2017 14:54:15 -0700
Message-ID: <59275287.0pJj++c8Sr8+BT1T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40544 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939150AbdEYVyR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 17:54:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, hannes@cmpxchg.org, hughd@google.com, joern@logfs.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, stable@vger.kernel.org, vbabka@suse.cz, walken@google.com, wangkefeng.wang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock.c: fix mlock count can not decrease in race condition
has been removed from the -mm tree.  Its filename was
     mlock-fix-mlock-count-can-not-decrease-in-race-condition.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/mlock.c: fix mlock count can not decrease in race condition

Kefeng reported that when running the follow test the mlock count in
meminfo cannot be decreased:

 [1] testcase
 linux:~ # cat test_mlockal
 grep Mlocked /proc/meminfo
  for j in `seq 0 10`
  do
 	for i in `seq 4 15`
 	do
 		./p_mlockall >> log &
 	done
 	sleep 0.2
 done
 # wait some time to let mlock counter decrease and 5s may not enough
 sleep 5
 grep Mlocked /proc/meminfo

 linux:~ # cat p_mlockall.c
 #include <sys/mman.h>
 #include <stdlib.h>
 #include <stdio.h>

 #define SPACE_LEN	4096

 int main(int argc, char ** argv)
 {
 	int ret;
 	void *adr = malloc(SPACE_LEN);
 	if (!adr)
 		return -1;

 	ret = mlockall(MCL_CURRENT | MCL_FUTURE);
 	printf("mlockall ret = %d\n", ret);

 	ret = munlockall();
 	printf("munlockall ret = %d\n", ret);

 	free(adr);
 	return 0;
 }

In __munlock_pagevec() we ClearPageMlock but isolation_failed in race
condition, and we do not count these page into delta_munlocked, which
causes mlock counter inaccuracy because we cleared the PageMlock and
cannot count down the number in the future.

Fix it by counting the number of pages whose PageMlock flag is cleared.

[akpm@linux-foundation.org: coding-style fixes]
Fixes: 1ebb7cc6a583 ("mm: munlock: batch NR_MLOCK zone state updates")
Link: http://lkml.kernel.org/r/1495620504-7007-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Reported-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joern Engel <joern@logfs.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/mlock.c~mlock-fix-mlock-count-can-not-decrease-in-race-condition mm/mlock.c
--- a/mm/mlock.c~mlock-fix-mlock-count-can-not-decrease-in-race-condition
+++ a/mm/mlock.c
@@ -284,7 +284,7 @@ static void __munlock_pagevec(struct pag
 {
 	int i;
 	int nr = pagevec_count(pvec);
-	int delta_munlocked;
+	int munlocked = 0;
 	struct pagevec pvec_putback;
 	int pgrescued = 0;
 
@@ -296,6 +296,7 @@ static void __munlock_pagevec(struct pag
 		struct page *page = pvec->pages[i];
 
 		if (TestClearPageMlocked(page)) {
+			munlocked--;
 			/*
 			 * We already have pin from follow_page_mask()
 			 * so we can spare the get_page() here.
@@ -315,8 +316,8 @@ static void __munlock_pagevec(struct pag
 		pagevec_add(&pvec_putback, pvec->pages[i]);
 		pvec->pages[i] = NULL;
 	}
-	delta_munlocked = -nr + pagevec_count(&pvec_putback);
-	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
+	if (munlocked)
+		__mod_zone_page_state(zone, NR_MLOCK, munlocked);
 	spin_unlock_irq(zone_lru_lock(zone));
 
 	/* Now we can release pins of pages that we are not munlocking */
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are



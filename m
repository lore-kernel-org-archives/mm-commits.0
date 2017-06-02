From: akpm@linux-foundation.org
Subject: [patch 12/15] mlock: fix mlock count can not decrease in race
 condition
Date: Fri, 02 Jun 2017 14:46:43 -0700
Message-ID: <5931dcc3.C46cHCwPPHku41KU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51544 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVqo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:46:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, xieyisheng1@huawei.com, guohanjun@huawei.com, hannes@cmpxchg.org, hughd@google.com, joern@logfs.org, mgorman@suse.de, mhocko@suse.cz, qiuxishi@huawei.com, riel@redhat.com, stable@vger.kernel.org, vbabka@suse.cz, walken@google.com, wangkefeng.wang@huawei.com, zhongjiang@huawei.com

From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mlock: fix mlock count can not decrease in race condition

Kefeng reported that when running the follow test, the mlock count in
meminfo will increase permanently:

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
	 	printf("mlcokall ret = %d\n", ret);
	
	 	ret = munlockall();
	 	printf("munlcokall ret = %d\n", ret);
	
	 	free(adr);
	 	return 0;
	 }

In __munlock_pagevec() we should decrement NR_MLOCK for each page where we
clear the PageMlocked flag.  Commit 1ebb7cc6a583 ("mm: munlock: batch
NR_MLOCK zone state updates") has introduced a bug where we don't
decrement NR_MLOCK for pages where we clear the flag, but fail to isolate
them from the lru list (e.g.  when the pages are on some other cpu's
percpu pagevec).  Since PageMlocked stays cleared, the NR_MLOCK accounting
gets permanently disrupted by this.

Fix it by counting the number of page whose PageMlock flag is cleared. 

Fixes: 1ebb7cc6a583 (" mm: munlock: batch NR_MLOCK zone state updates")
Link: http://lkml.kernel.org/r/1495678405-54569-1-git-send-email-xieyisheng1@huawei.com
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
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: zhongjiang <zhongjiang@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/mlock.c~mlock-fix-mlock-count-can-not-decrease-in-race-condition mm/mlock.c
--- a/mm/mlock.c~mlock-fix-mlock-count-can-not-decrease-in-race-condition
+++ a/mm/mlock.c
@@ -284,7 +284,7 @@ static void __munlock_pagevec(struct pag
 {
 	int i;
 	int nr = pagevec_count(pvec);
-	int delta_munlocked;
+	int delta_munlocked = -nr;
 	struct pagevec pvec_putback;
 	int pgrescued = 0;
 
@@ -304,6 +304,8 @@ static void __munlock_pagevec(struct pag
 				continue;
 			else
 				__munlock_isolation_failed(page);
+		} else {
+			delta_munlocked++;
 		}
 
 		/*
@@ -315,7 +317,6 @@ static void __munlock_pagevec(struct pag
 		pagevec_add(&pvec_putback, pvec->pages[i]);
 		pvec->pages[i] = NULL;
 	}
-	delta_munlocked = -nr + pagevec_count(&pvec_putback);
 	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
 	spin_unlock_irq(zone_lru_lock(zone));
 
_

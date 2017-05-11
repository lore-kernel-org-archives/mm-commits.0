From: akpm@linux-foundation.org
Subject: + mm-vmscan-scan-until-it-founds-eligible-pages-fix.patch added
 to -mm tree
Date: Thu, 11 May 2017 15:27:08 -0700
Message-ID: <5914e53c.6REwjRxGdnWKCIMl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753810AbdEKW1J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 May 2017 18:27:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-scan-until-it-founds-eligible-pages-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-scan-until-it-founds-eligible-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-scan-until-it-founds-eligible-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-scan-until-it-founds-eligible-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-scan-until-it-founds-eligible-pages-fix

Clean up mind-bending `for' statement.   Tweak comment text.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-scan-until-it-founds-eligible-pages-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-scan-until-it-founds-eligible-pages-fix
+++ a/mm/vmscan.c
@@ -1472,10 +1472,10 @@ static unsigned long isolate_lru_pages(u
 	unsigned long scan, total_scan, nr_pages;
 	LIST_HEAD(pages_skipped);
 
-	for (total_scan = scan = 0; scan < nr_to_scan &&
-					nr_taken < nr_to_scan &&
-					!list_empty(src);
-					total_scan++) {
+	scan = 0;
+	for (total_scan = 0;
+	     scan < nr_to_scan && nr_taken < nr_to_scan && !list_empty(src);
+	     total_scan++) {
 		struct page *page;
 
 		page = lru_to_page(src);
@@ -1490,10 +1490,10 @@ static unsigned long isolate_lru_pages(u
 		}
 
 		/*
-		 * Do not count skipped pages because it makes the function to
-		 * return with none isolated pages if the LRU mostly contains
-		 * ineligible pages so that VM cannot reclaim any pages and
-		 * trigger premature OOM.
+		 * Do not count skipped pages because that makes the function
+		 * return with no isolated pages if the LRU mostly contains
+		 * ineligible pages.  This causes the VM to not reclaim any
+		 * pages, triggering a premature OOM.
 		 */
 		scan++;
 		switch (__isolate_lru_page(page, mode)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes.patch
gcov-support-gcc-71-v2-checkpatch-fixes.patch
mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes.patch
tigran-has-moved.patch
mm-vmscan-scan-until-it-founds-eligible-pages-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


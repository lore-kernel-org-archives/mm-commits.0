From: akpm@linux-foundation.org
Subject: + swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch added to -mm tree
Date: Mon, 15 Jul 2013 14:12:29 -0700
Message-ID: <51e465bd.i+q+HrPsL0PZ9WAg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab3GOVMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Jul 2013 17:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, valdis.kletnieks@vt.edu, shentino@gmail.com, hughd@google.com, akpm@linux-foundation.org

Subject: + swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch added to -mm tree
To: akpm@linux-foundation.org,hughd@google.com,shentino@gmail.com,valdis.kletnieks@vt.edu
From: akpm@linux-foundation.org
Date: Mon, 15 Jul 2013 14:12:29 -0700


The patch titled
     Subject: swap-warn-when-a-swap-area-overflows-the-maximum-size-fix
has been added to the -mm tree.  Its filename is
     swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch

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
Subject: swap-warn-when-a-swap-area-overflows-the-maximum-size-fix

fix warning

mm/swapfile.c: In function 'read_swap_header':
mm/swapfile.c:1960: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type '__u32'

Cc: Hugh Dickins <hughd@google.com>
Cc: Raymond Jennings <shentino@gmail.com>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~swap-warn-when-a-swap-area-overflows-the-maximum-size-fix mm/swapfile.c
--- a/mm/swapfile.c~swap-warn-when-a-swap-area-overflows-the-maximum-size-fix
+++ a/mm/swapfile.c
@@ -1911,6 +1911,7 @@ static unsigned long read_swap_header(st
 	int i;
 	unsigned long maxpages;
 	unsigned long swapfilepages;
+	unsigned long last_page;
 
 	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
 		printk(KERN_ERR "Unable to find swap-space signature\n");
@@ -1953,14 +1954,15 @@ static unsigned long read_swap_header(st
 	 */
 	maxpages = swp_offset(pte_to_swp_entry(
 			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
-	if (swap_header->info.last_page > maxpages) {
+	last_page = swap_header->info.last_page;
+	if (last_page > maxpages) {
 		printk(KERN_WARNING
 			"Truncating oversized swap area, only using %luk out of %luk\n",
 			maxpages << (PAGE_SHIFT - 10),
-			swap_header->info.last_page << (PAGE_SHIFT - 10));
+			last_page << (PAGE_SHIFT - 10));
 	}
-	if (maxpages > swap_header->info.last_page) {
-		maxpages = swap_header->info.last_page + 1;
+	if (maxpages > last_page) {
+		maxpages = last_page + 1;
 		/* p->max is an unsigned int: don't overflow it */
 		if ((unsigned int)maxpages == 0)
 			maxpages = UINT_MAX;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
mm.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


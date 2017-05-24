From: akpm@linux-foundation.org
Subject: +
 mlock-fix-mlock-count-can-not-decrease-in-race-condition-checkpatch-fixes.patch added to -mm tree
Date: Wed, 24 May 2017 15:04:48 -0700
Message-ID: <59260380.ftqNb5h+L2Os7uHQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033616AbdEXWEt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 18:04:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, xieyisheng1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mlock-fix-mlock-count-can-not-decrease-in-race-condition-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mlock-fix-mlock-count-can-not-decrease-in-race-condition-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mlock-fix-mlock-count-can-not-decrease-in-race-condition-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mlock-fix-mlock-count-can-not-decrease-in-race-condition-checkpatch-fixes.patch

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
Subject: mlock-fix-mlock-count-can-not-decrease-in-race-condition-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#53: 
Fixes 1ebb7cc6a583 (" mm: munlock: batch NR_MLOCK zone state updates")

ERROR: space prohibited before that '--' (ctx:WxO)
#89: FILE: mm/mlock.c:299:
+			munlocked --;
 			          ^

total: 2 errors, 0 warnings, 25 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mlock-fix-mlock-count-can-not-decrease-in-race-condition.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Yisheng Xie <xieyisheng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mlock.c~mlock-fix-mlock-count-can-not-decrease-in-race-condition-checkpatch-fixes mm/mlock.c
--- a/mm/mlock.c~mlock-fix-mlock-count-can-not-decrease-in-race-condition-checkpatch-fixes
+++ a/mm/mlock.c
@@ -296,7 +296,7 @@ static void __munlock_pagevec(struct pag
 		struct page *page = pvec->pages[i];
 
 		if (TestClearPageMlocked(page)) {
-			munlocked --;
+			munlocked--;
 			/*
 			 * We already have pin from follow_page_mask()
 			 * so we can spare the get_page() here.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch
mlock-fix-mlock-count-can-not-decrease-in-race-condition-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


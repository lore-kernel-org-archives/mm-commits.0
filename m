From: akpm@linux-foundation.org
Subject: + mm-swap-sort-swap-entries-before-free-fix.patch added to -mm
 tree
Date: Thu, 25 May 2017 16:24:00 -0700
Message-ID: <59276790.LWYWPR1pmFvFWAML%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165995AbdEYXYB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 19:24:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-sort-swap-entries-before-free-fix
has been added to the -mm tree.  Its filename is
     mm-swap-sort-swap-entries-before-free-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-sort-swap-entries-before-free-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-sort-swap-entries-before-free-fix.patch

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
Subject: mm-swap-sort-swap-entries-before-free-fix

tweak comment

Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~mm-swap-sort-swap-entries-before-free-fix mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-sort-swap-entries-before-free-fix
+++ a/mm/swapfile.c
@@ -1218,10 +1218,9 @@ void swapcache_free_entries(swp_entry_t
 	p = NULL;
 
 	/*
-	 * Sort swap entries by swap device, so each lock is only
-	 * taken once.  Although nr_swapfiles isn't absolute correct,
-	 * but the overhead of sort() is so low that it isn't
-	 * necessary to optimize further.
+	 * Sort swap entries by swap device, so each lock is only taken once.
+	 * nr_swapfiles isn't absolutely correct, but the overhead of sort() is
+	 * so low that it isn't necessary to optimize further.
 	 */
 	if (nr_swapfiles > 1)
 		sort(entries, n, sizeof(entries[0]), swp_entry_cmp, NULL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch
mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-swap-sort-swap-entries-before-free-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


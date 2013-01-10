From: akpm@linux-foundation.org
Subject: + mm-forcibly-swapout-when-we-are-out-of-page-cache-fix.patch added to -mm tree
Date: Wed, 09 Jan 2013 16:26:21 -0800
Message-ID: <20130110002622.4162D82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:64172 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab3AJA0X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 19:26:23 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so323447vbi.5
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 16:26:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bfreed@google.com, dan.magenheimer@oracle.com, hannes@cmpxchg.org, hughd@google.com, mel@csn.ul.ie, minchan@kernel.org, riel@redhat.com, semenzato@google.com, sonnyrao@google.com


The patch titled
     Subject: mm-forcibly-swapout-when-we-are-out-of-page-cache-fix
has been added to the -mm tree.  Its filename is
     mm-forcibly-swapout-when-we-are-out-of-page-cache-fix.patch

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
Subject: mm-forcibly-swapout-when-we-are-out-of-page-cache-fix

tweak comment

Cc: Bryan Freed <bfreed@google.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sonny Rao <sonnyrao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-forcibly-swapout-when-we-are-out-of-page-cache-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-forcibly-swapout-when-we-are-out-of-page-cache-fix
+++ a/mm/vmscan.c
@@ -1729,9 +1729,8 @@ static void get_scan_count(struct lruvec
 		if (unlikely(file + free <= high_wmark_pages(zone))) {
 			scan_balance = SCAN_ANON;
 			/*
-			 * From now on, we have to swap out
-			 * for peventing OOM kill although
-			 * we sacrifice power consumption.
+			 * Force writeout even in laptop mode, as consuming
+			 * some more energy is preferable to declaring oom.
 			 */
 			sc->may_writepage = 1;
 			goto out;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch
drivers-rtc-rtc-da9055c-fix-cross-section-reference.patch
arch-mn10300-kconfig-select-config_generic_atomic64.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
kernel-auditc-avoid-negative-sleep-durations.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
mm-forcibly-swapout-when-we-are-out-of-page-cache-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
aio-smoosh-struct-kiocb-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


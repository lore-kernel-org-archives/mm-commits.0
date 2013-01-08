From: akpm@linux-foundation.org
Subject: + generic-dynamic-per-cpu-refcounting-doc-fix.patch added to -mm tree
Date: Tue, 08 Jan 2013 12:28:13 -0800
Message-ID: <20130108202814.142F2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:47875 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3AHU2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 15:28:15 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so20504qaq.1
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 12:28:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, koverstreet@google.com


The patch titled
     Subject: generic-dynamic-per-cpu-refcounting-doc-fix
has been added to the -mm tree.  Its filename is
     generic-dynamic-per-cpu-refcounting-doc-fix.patch

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
Subject: generic-dynamic-per-cpu-refcounting-doc-fix

a little tidy

Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-refcount.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN include/linux/percpu-refcount.h~generic-dynamic-per-cpu-refcounting-doc-fix include/linux/percpu-refcount.h
--- a/include/linux/percpu-refcount.h~generic-dynamic-per-cpu-refcounting-doc-fix
+++ a/include/linux/percpu-refcount.h
@@ -21,19 +21,18 @@
  * BACKGROUND:
  *
  * Percpu refcounts are quite useful for performance, but if we blindly
- * converted all refcounts to percpu counters we'd waste quite a bit of memory
- * think about all the refcounts embedded in kobjects, files, etc. most of which
- * aren't used much.
- *
- * These start out as simple atomic counters - a little bigger than a bare
- * atomic_t, 16 bytes instead of 4 - but if we exceed some arbitrary number of
- * gets in one second, we then switch to percpu counters.
+ * converted all refcounts to percpu counters we'd waste quite a bit of memory.
+ *
+ * Think about all the refcounts embedded in kobjects, files, etc. most of which
+ * aren't used much. These start out as simple atomic counters - a little bigger
+ * than a bare atomic_t, 16 bytes instead of 4 - but if we exceed some arbitrary
+ * number of gets in one second, we then switch to percpu counters.
  *
  * This heuristic isn't perfect because it'll fire if the refcount was only
  * being used on one cpu; ideally we'd be able to count the number of cache
  * misses on percpu_ref_get() or something similar, but that'd make the non
  * percpu path significantly heavier/more complex. We can count the number of
- * gets() without any extra atomic instructions, on arches that support
+ * gets() without any extra atomic instructions on arches that support
  * atomic64_t - simply by changing the atomic_inc() to atomic_add_return().
  *
  * USAGE:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
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
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-fix-fix.patch
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


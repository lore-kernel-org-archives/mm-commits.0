From: akpm@linux-foundation.org
Subject: + pps-pps_kc_hardpps_lock-can-be-static.patch added to -mm tree
Date: Tue, 23 Apr 2013 14:29:19 -0700
Message-ID: <20130423212919.6EF4931C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:64241 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3DWV3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 17:29:20 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so121250qcs.5
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 14:29:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, giometti@enneenne.com


The patch titled
     Subject: pps: pps_kc_hardpps_lock can be static
has been added to the -mm tree.  Its filename is
     pps-pps_kc_hardpps_lock-can-be-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: pps: pps_kc_hardpps_lock can be static

drivers/pps/kc.c:37:1: sparse: symbol 'pps_kc_hardpps_lock' was not declared. Should it be static?
drivers/pps/kc.c:39:19: sparse: symbol 'pps_kc_hardpps_dev' was not declared. Should it be static?
drivers/pps/kc.c:40:5: sparse: symbol 'pps_kc_hardpps_mode' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/pps/kc.c~pps-pps_kc_hardpps_lock-can-be-static drivers/pps/kc.c
--- a/drivers/pps/kc.c~pps-pps_kc_hardpps_lock-can-be-static
+++ a/drivers/pps/kc.c
@@ -34,10 +34,10 @@
  */
 
 /* state variables to bind kernel consumer */
-DEFINE_SPINLOCK(pps_kc_hardpps_lock);
+static DEFINE_SPINLOCK(pps_kc_hardpps_lock);
 /* PPS API (RFC 2783): current source and mode for kernel consumer */
-struct pps_device *pps_kc_hardpps_dev;	/* unique pointer to device */
-int pps_kc_hardpps_mode;		/* mode bits for kernel consumer */
+static struct pps_device *pps_kc_hardpps_dev;	/* unique pointer to device */
+static int pps_kc_hardpps_mode;		/* mode bits for kernel consumer */
 
 /* pps_kc_bind - control PPS kernel consumer binding
  * @pps: the PPS source
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix.patch
hwpoison-check-dirty-flag-to-match-against-clean-page.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch
sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups-fix.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch
x86-dont-show-trace-beyond-show_stacknull-null.patch
sparc32-make-show_stack-acquire-%fp-if-_ksp-is-not-specified.patch
dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors.patch
dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer.patch
dump_stack-implement-arch-specific-hardware-description-in-task-dumps.patch
dump_stack-unify-debug-information-printed-by-show_regs.patch
arc-print-fatal-signals-reduce-duplicated-information.patch
drivers-rtc-rtc-max6902c-use-register-defines-instead-of-magic-numbers.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
fat-additions-to-support-fat_fallocate-fix.patch
ipc-refactor-msg-list-search-into-separate-function-fix.patch
pps-pps_kc_hardpps_lock-can-be-static.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch


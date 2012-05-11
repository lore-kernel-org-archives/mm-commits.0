From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch added to -mm tree
Date: Fri, 11 May 2012 13:47:33 -0700
Message-ID: <20120511204734.29F1DA02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40214 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab2EKUrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 May 2012 16:47:36 -0400
Received: by eeit10 with SMTP id t10so155494eei.1
        for <mm-commits@vger.kernel.org>; Fri, 11 May 2012 13:47:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alexander.stein@systec-electronic.com, bryan.wu@canonical.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch

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
Subject: drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix

revert unintentional rename of pca955x_ledsel()

Cc: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca955x.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/leds/leds-pca955x.c~drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix drivers/leds/leds-pca955x.c
--- a/drivers/leds/leds-pca955x.c~drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix
+++ a/drivers/leds/leds-pca955x.c
@@ -133,7 +133,7 @@ static inline int pca95xx_num_led_regs(i
  * Return an LED selector register value based on an existing one, with
  * the appropriate 2-bit state value set for the given LED number (0-3).
  */
-static inline u8 pca955x_ledel(u8 oldval, int led_num, int state)
+static inline u8 pca955x_ledsel(u8 oldval, int led_num, int state)
 {
 	return (oldval & (~(0x3 << (led_num << 1)))) |
 		((state & 0x3) << (led_num << 1));
@@ -213,13 +213,13 @@ static void pca955x_led_work(struct work
 
 	switch (pca955x_led->brightness) {
 	case LED_FULL:
-		ls = pca955x_ledel(ls, ls_led, PCA955X_LS_LED_ON);
+		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_LED_ON);
 		break;
 	case LED_OFF:
-		ls = pca955x_ledel(ls, ls_led, PCA955X_LS_LED_OFF);
+		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_LED_OFF);
 		break;
 	case LED_HALF:
-		ls = pca955x_ledel(ls, ls_led, PCA955X_LS_BLINK0);
+		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_BLINK0);
 		break;
 	default:
 		/*
@@ -231,7 +231,7 @@ static void pca955x_led_work(struct work
 		 */
 		pca955x_write_pwm(pca955x->client, 1,
 				255 - pca955x_led->brightness);
-		ls = pca955x_ledel(ls, ls_led, PCA955X_LS_BLINK1);
+		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_BLINK1);
 		break;
 	}
 
_
Subject: Subject: drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
isdn-add-missing-kern_cont-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


From: akpm@linux-foundation.org
Subject: + goldfish-framebuffer-driver-fix.patch added to -mm tree
Date: Thu, 07 Feb 2013 14:33:20 -0800
Message-ID: <20130207223320.D458A1CA15E@corp2gmr1-1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:37305 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab3BGWdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2013 17:33:24 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so103128fav.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Feb 2013 14:33:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, FlorianSchandinat@gmx.de, alan@linux.intel.com, arve@android.com, bruce.j.beare@intel.com, jun.nakajima@intel.com, mikechan@google.com, sheng@linux.intel.com, thomas.keel@intel.com, tomi.valkeinen@ti.com, xiaohui.xin@intel.com, yunhong.jiang@intel.com


The patch titled
     Subject: goldfish-framebuffer-driver-fix
has been added to the -mm tree.  Its filename is
     goldfish-framebuffer-driver-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: goldfish-framebuffer-driver-fix

fix (silly) sparse warnings

Cc: Alan Cox <alan@linux.intel.com>
Cc: Arve Hj=F8nnev=E5g <arve@android.com>
Cc: Bruce Beare <bruce.j.beare@intel.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Jun Nakajima <jun.nakajima@intel.com>
Cc: Mike A. Chan <mikechan@google.com>
Cc: Sheng Yang <sheng@linux.intel.com>
Cc: Tom Keel <thomas.keel@intel.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Xiaohui Xin <xiaohui.xin@intel.com>
Cc: Yunhong Jiang <yunhong.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/goldfishfb.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/video/goldfishfb.c~goldfish-framebuffer-driver-fix dr=
ivers/video/goldfishfb.c
--- a/drivers/video/goldfishfb.c~goldfish-framebuffer-driver-fix
+++ a/drivers/video/goldfishfb.c
@@ -244,11 +244,12 @@ static int goldfish_fb_probe(struct plat
 	fb->fb.var.blue.length =3D 5;
=20
 	framesize =3D width * height * 2 * 2;
-	fb->fb.screen_base =3D dma_alloc_coherent(&pdev->dev, framesize,
+	fb->fb.screen_base =3D (char __force __iomem *)dma_alloc_coherent(
+						&pdev->dev, framesize,
 						&fbpaddr, GFP_KERNEL);
 	pr_debug("allocating frame buffer %d * %d, got %p\n",
 					width, height, fb->fb.screen_base);
-	if (fb->fb.screen_base =3D=3D 0) {
+	if (fb->fb.screen_base =3D=3D NULL) {
 		ret =3D -ENOMEM;
 		goto err_alloc_screen_base_failed;
 	}
@@ -277,7 +278,8 @@ err_register_framebuffer_failed:
 err_request_irq_failed:
 err_fb_set_var_failed:
 	dma_free_coherent(&pdev->dev, framesize,
-				fb->fb.screen_base, fb->fb.fix.smem_start);
+				(void *)fb->fb.screen_base,
+				fb->fb.fix.smem_start);
 err_alloc_screen_base_failed:
 err_no_irq:
 	iounmap(fb->reg_base);
@@ -296,7 +298,7 @@ static int goldfish_fb_remove(struct pla
 	unregister_framebuffer(&fb->fb);
 	free_irq(fb->irq, fb);
=20
-	dma_free_coherent(&pdev->dev, framesize, fb->fb.screen_base,
+	dma_free_coherent(&pdev->dev, framesize, (void *)fb->fb.screen_base,
 						fb->fb.fix.smem_start);
 	iounmap(fb->reg_base);
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch=
-fixes.patch
i-need-old-gcc.patch
drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.pat=
ch
goldfish-framebuffer-driver-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patc=
h
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.pat=
ch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-p=
agespatch-fix-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fi=
x-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fi=
x-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-f=
ix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-f=
ix-fix.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix=
=2Epatch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes=
=2Epatch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix=
=2Epatch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patc=
h
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patc=
h
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-erro=
r-on-thp-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patc=
h
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.=
patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_bo=
undaries-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fi=
x.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attr=
ibutes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.=
patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditional=
ly-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patc=
h
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

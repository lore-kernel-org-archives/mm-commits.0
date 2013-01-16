From: akpm@linux-foundation.org
Subject: + signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch added to -mm tree
Date: Wed, 16 Jan 2013 12:38:00 -0800
Message-ID: <20130116203800.C3939100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56186 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3APUiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 15:38:03 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so226921qaq.5
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 12:38:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, avagin@openvz.org, dhowells@redhat.com, gorcunov@openvz.org, mtk.manpages@gmail.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de, viro@zeniv.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix
has been added to the -mm tree.  Its filename is
     signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch

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
Subject: signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix

fix __user annotations, tidy comments and code layout

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/signalfd.c~signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix fs/signalfd.c
--- a/fs/signalfd.c~signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix
+++ a/fs/signalfd.c
@@ -75,14 +75,14 @@ static unsigned int signalfd_poll(struct
 }
 
 /*
- * Copy a whole siginfo into users spaces.
+ * Copy a whole siginfo into userspace.
  * The main idea of this format is that it should be enough
  * for restoring siginfo back into the kernel.
  */
 static int signalfd_copy_raw_info(struct signalfd_siginfo __user *siginfo,
 					siginfo_t *kinfo)
 {
-	siginfo_t *uinfo = (siginfo_t *) siginfo;
+	siginfo_t __user *uinfo = (siginfo_t __user *)siginfo;
 	int err;
 
 	BUILD_BUG_ON(sizeof(siginfo_t) != sizeof(struct signalfd_siginfo));
@@ -91,19 +91,20 @@ static int signalfd_copy_raw_info(struct
 
 #ifdef CONFIG_COMPAT
 	if (unlikely(is_compat_task())) {
-		compat_siginfo_t *compat_uinfo = (compat_siginfo_t *) siginfo;
+		compat_siginfo_t __user *compat_uinfo;
 
+		compat_uinfo = (compat_siginfo_t __user *)siginfo;
 		err |= copy_siginfo_to_user32(compat_uinfo, kinfo);
 		err |= put_user(kinfo->si_code, &compat_uinfo->si_code);
 
-		return err ? -EFAULT: sizeof(*compat_uinfo);
+		return err ? -EFAULT : sizeof(*compat_uinfo);
 	}
 #endif
 
 	err |= copy_siginfo_to_user(uinfo, kinfo);
 	err |= put_user(kinfo->si_code, &uinfo->si_code);
 
-	return err ? -EFAULT: sizeof(*uinfo);
+	return err ? -EFAULT : sizeof(*uinfo);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
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
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
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
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
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
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


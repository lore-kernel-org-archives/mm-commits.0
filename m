From: akpm@linux-foundation.org
Subject: + include-linux-tickh-fix-warning.patch added to -mm tree
Date: Wed, 24 Oct 2012 15:17:23 -0700
Message-ID: <20121024230635.D542C200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:46489 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2JXXGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 19:06:39 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so64891lah.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 16:06:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rafael.j.wysocki@intel.com, riel@redhat.com, youquan.song@intel.com


The patch titled
     Subject: include/linux/tick.h: fix warning
has been added to the -mm tree.  Its filename is
     include-linux-tickh-fix-warning.patch

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
Subject: include/linux/tick.h: fix warning

In file included from init/main.c:43:
include/linux/tick.h: In function 'menu_hrtimer_cancel':
include/linux/tick.h:148: warning: 'return' with a value, in function returning void
In file included from kernel/softirq.c:27:
include/linux/tick.h: In function 'menu_hrtimer_cancel':
include/linux/tick.h:148: warning: 'return' with a value, in function returning void
etc.

Repairs 25d77b76d7aef ("cpuidle: Quickly notice prediction failure for repeat
mode").

Cc: Rik van Riel <riel@redhat.com>
Cc: Youquan Song <youquan.song@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tick.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/tick.h~include-linux-tickh-fix-warning include/linux/tick.h
--- a/include/linux/tick.h~include-linux-tickh-fix-warning
+++ a/include/linux/tick.h
@@ -145,7 +145,9 @@ static inline u64 get_cpu_iowait_time_us
 # ifdef CONFIG_CPU_IDLE_GOV_MENU
 extern void menu_hrtimer_cancel(void);
 # else
-static inline void menu_hrtimer_cancel(void) { return -1; }
+static inline void menu_hrtimer_cancel(void)
+{
+}
 # endif /* CONFIG_CPU_IDLE_GOV_MENU */
 
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pidns-limit-the-nesting-depth-of-pid-namespaces-fix.patch
revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-linux-tickh-fix-warning.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes.patch
random-make-it-possible-to-enable-debugging-without-rebuild-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


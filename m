From: akpm@linux-foundation.org
Subject: + kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch added to -mm tree
Date: Wed, 11 Jul 2012 16:32:14 -0700
Message-ID: <20120711233215.33D7720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:53074 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422Ab2GKXcS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 19:32:18 -0400
Received: by eaao13 with SMTP id o13so87396eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 16:32:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, ebiederm@xmission.com, gorcunov@openvz.org, keescook@chromium.org, oleg@redhat.com, rusty@rustcorp.com.au, serge.hallyn@canonical.com, xiyou.wangcong@gmail.com


The patch titled
     Subject: kernel/kmod.c: document call_usermodehelper_fns() a bit
has been added to the -mm tree.  Its filename is
     kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch

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
Subject: kernel/kmod.c: document call_usermodehelper_fns() a bit

This function's interface is, uh, subtle.  Attempt to apologise for it.

Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/kmod.c~kernel-kmodc-document-call_usermodehelper_fns-a-bit kernel/kmod.c
--- a/kernel/kmod.c~kernel-kmodc-document-call_usermodehelper_fns-a-bit
+++ a/kernel/kmod.c
@@ -577,6 +577,12 @@ unlock:
 	return retval;
 }
 
+/*
+ * call_usermodehelper_fns() will not run the caller-provided cleanup function
+ * if a memory allocation failure is experienced.  So the caller might need to
+ * check the call_usermodehelper_fns() return value: if it is -ENOMEM, perform
+ * the necessaary cleanup within the caller.
+ */
 int call_usermodehelper_fns(
 	char *path, char **argv, char **envp, int wait,
 	int (*init)(struct subprocess_info *info, struct cred *new),
_
Subject: Subject: kernel/kmod.c: document call_usermodehelper_fns() a bit

Patches currently in -mm which might be from akpm@linux-foundation.org are

memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled.patch
drivers-gpio-gpio-tps65910c-fix-config_of_gpio=n-build.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
sysfs-fail-dentry-revalidation-after-namespace-change-fix.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
resource-make-sure-requested-range-intersects-root-range-fix.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


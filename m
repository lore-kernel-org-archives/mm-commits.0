From: akpm@linux-foundation.org
Subject: + kernel-sysc-avoid-argv_freenull.patch added to -mm tree
Date: Wed, 11 Jul 2012 16:31:45 -0700
Message-ID: <20120711233145.AB4EA100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:60263 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494Ab2GKXbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 19:31:48 -0400
Received: by vbnl22 with SMTP id l22so181172vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 16:31:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@linux.intel.com, ebiederm@xmission.com, gorcunov@openvz.org, keescook@chromium.org, rientjes@google.com, serge.hallyn@canonical.com, xiyou.wangcong@gmail.com


The patch titled
     Subject: kernel/sys.c: avoid argv_free(NULL)
has been added to the -mm tree.  Its filename is
     kernel-sysc-avoid-argv_freenull.patch

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
Subject: kernel/sys.c: avoid argv_free(NULL)

If argv_split() failed, the code will end up calling argv_free(NULL).  Fix
it up and clean things up a bit.

Addresses Coverity report 703573.

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-avoid-argv_freenull kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-avoid-argv_freenull
+++ a/kernel/sys.c
@@ -2196,25 +2196,25 @@ static void argv_cleanup(struct subproce
 int orderly_poweroff(bool force)
 {
 	int argc;
-	char **argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
+	char **argv;
 	static char *envp[] = {
 		"HOME=/",
 		"PATH=/sbin:/bin:/usr/sbin:/usr/bin",
 		NULL
 	};
-	int ret = -ENOMEM;
+	int ret;
 
+	argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
 	if (argv == NULL) {
 		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
 		       __func__, poweroff_cmd);
-		goto out;
+		return -ENOMEM;
 	}
 
 	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
 				      NULL, argv_cleanup, NULL);
-out:
 	if (likely(!ret))
-		return 0;
+		return 0;		/* success */
 
 	if (ret == -ENOMEM)
 		argv_free(argv);
_
Subject: Subject: kernel/sys.c: avoid argv_free(NULL)

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


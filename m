From: akpm@linux-foundation.org
Subject: + drivers-gpio-gpio-tps65910c-fix-config_of_gpio=n-build.patch added to -mm tree
Date: Tue, 10 Jul 2012 16:12:46 -0700
Message-ID: <20120710235918.BC502100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:58077 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab2GJX7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 19:59:20 -0400
Received: by yenl3 with SMTP id l3so67251yen.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 16:59:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, grant.likely@secretlab.ca, linus.walleij@stericsson.com


The patch titled
     Subject: drivers/gpio/gpio-tps65910.c: fix CONFIG_OF_GPIO=n build
has been added to the -mm tree.  Its filename is
     drivers-gpio-gpio-tps65910c-fix-config_of_gpio=n-build.patch

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
Subject: drivers/gpio/gpio-tps65910.c: fix CONFIG_OF_GPIO=n build

drivers/gpio/gpio-tps65910.c: In function 'tps65910_gpio_probe':
drivers/gpio/gpio-tps65910.c:152: error: 'struct gpio_chip' has no member named 'of_node'

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpio-tps65910.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/gpio/gpio-tps65910.c~drivers-gpio-gpio-tps65910c-fix-config_of_gpio=n-build drivers/gpio/gpio-tps65910.c
--- a/drivers/gpio/gpio-tps65910.c~drivers-gpio-gpio-tps65910c-fix-config_of_gpio=n-build
+++ a/drivers/gpio/gpio-tps65910.c
@@ -149,7 +149,9 @@ static int __devinit tps65910_gpio_probe
 	tps65910_gpio->gpio_chip.set	= tps65910_gpio_set;
 	tps65910_gpio->gpio_chip.get	= tps65910_gpio_get;
 	tps65910_gpio->gpio_chip.dev = &pdev->dev;
+#ifdef CONFIG_OF_GPIO
 	tps65910_gpio->gpio_chip.of_node = tps65910->dev->of_node;
+#endif
 	if (pdata && pdata->gpio_base)
 		tps65910_gpio->gpio_chip.base = pdata->gpio_base;
 	else
_
Subject: Subject: drivers/gpio/gpio-tps65910.c: fix CONFIG_OF_GPIO=n build

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes.patch
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
tmpfs-implement-numa-node-interleaving-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
drivers-gpio-gpio-tps65910c-fix-config_of_gpio=n-build.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
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


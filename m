From: akpm@linux-foundation.org
Subject: + mm-hugetlb-add-new-hugetlb-cgroup-fix.patch added to -mm tree
Date: Tue, 26 Jun 2012 12:33:09 -0700
Message-ID: <20120626193309.BDDD2A040B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:52913 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2FZTdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 15:33:12 -0400
Received: by bkty5 with SMTP id y5so14178bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 12:33:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm-hugetlb-add-new-hugetlb-cgroup-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-new-hugetlb-cgroup-fix.patch

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
Subject: mm-hugetlb-add-new-hugetlb-cgroup-fix

s/CONFIG_CGROUP_HUGETLB_RES_CTLR/CONFIG_MEMCG_HUGETLB/g

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup_subsys.h  |    2 +-
 include/linux/hugetlb_cgroup.h |    2 +-
 init/Kconfig                   |    2 +-
 mm/Makefile                    |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/cgroup_subsys.h~mm-hugetlb-add-new-hugetlb-cgroup-fix include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~mm-hugetlb-add-new-hugetlb-cgroup-fix
+++ a/include/linux/cgroup_subsys.h
@@ -73,7 +73,7 @@ SUBSYS(net_prio)
 
 /* */
 
-#ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
+#ifdef CONFIG_MEMCG_HUGETLB
 SUBSYS(hugetlb)
 #endif
 
diff -puN include/linux/hugetlb_cgroup.h~mm-hugetlb-add-new-hugetlb-cgroup-fix include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb-add-new-hugetlb-cgroup-fix
+++ a/include/linux/hugetlb_cgroup.h
@@ -19,7 +19,7 @@
 
 struct hugetlb_cgroup;
 
-#ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
+#ifdef CONFIG_MEMCG_HUGETLB
 static inline bool hugetlb_cgroup_disabled(void)
 {
 	if (hugetlb_subsys.disabled)
diff -puN init/Kconfig~mm-hugetlb-add-new-hugetlb-cgroup-fix init/Kconfig
--- a/init/Kconfig~mm-hugetlb-add-new-hugetlb-cgroup-fix
+++ a/init/Kconfig
@@ -751,7 +751,7 @@ config CGROUP_MEM_RES_CTLR_KMEM
 	  the kmem extension can use it to guarantee that no group of processes
 	  will ever exhaust kernel resources alone.
 
-config CGROUP_HUGETLB_RES_CTLR
+config MEMCG_HUGETLB
 	bool "HugeTLB Resource Controller for Control Groups"
 	depends on RESOURCE_COUNTERS && HUGETLB_PAGE && EXPERIMENTAL
 	default n
diff -puN mm/Makefile~mm-hugetlb-add-new-hugetlb-cgroup-fix mm/Makefile
--- a/mm/Makefile~mm-hugetlb-add-new-hugetlb-cgroup-fix
+++ a/mm/Makefile
@@ -49,7 +49,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
-obj-$(CONFIG_CGROUP_HUGETLB_RES_CTLR) += hugetlb_cgroup.o
+obj-$(CONFIG_MEMCG_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
diff -puN mm/hugetlb_cgroup.c~mm-hugetlb-add-new-hugetlb-cgroup-fix mm/hugetlb_cgroup.c
_
Subject: Subject: mm-hugetlb-add-new-hugetlb-cgroup-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
tmpfs-implement-numa-node-interleaving-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
x86-mce-use-new-printk-recursion-disabling-interface-fix.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
printk-have-printk-never-buffer-its-data.patch


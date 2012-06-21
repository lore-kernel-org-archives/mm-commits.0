From: akpm@linux-foundation.org
Subject: + include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch added to -mm tree
Date: Thu, 21 Jun 2012 16:29:26 -0700
Message-ID: <20120621232926.A88B6A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:58881 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600Ab2FUX33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 19:29:29 -0400
Received: by fat25 with SMTP id 25so70207fat.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 16:29:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, tglx@tglx.de


The patch titled
     Subject: include/linux/time.h: make NSEC_PER_SEC 64-bit on 32-bit architectures	
has been added to the -mm tree.  Its filename is
     include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch

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
Subject: include/linux/time.h: make NSEC_PER_SEC 64-bit on 32-bit architectures	

Nanoseconds are usually represented with 64-bit types (s64 and sometimes
u64).  The 32-bit definition of NSEC_PER_SEC can lead to compile-time and
runtime arithmetic overflows on 32-bit systems.

So switch NSEC_PER_SEC to a 64-bit type using "LL".

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@tglx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/time.h~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures include/linux/time.h
--- a/include/linux/time.h~include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures
+++ a/include/linux/time.h
@@ -37,7 +37,7 @@ extern struct timezone sys_tz;
 #define NSEC_PER_USEC	1000L
 #define NSEC_PER_MSEC	1000000L
 #define USEC_PER_SEC	1000000L
-#define NSEC_PER_SEC	1000000000L
+#define NSEC_PER_SEC	1000000000LL
 #define FSEC_PER_SEC	1000000000000000LL
 
 #define TIME_T_MAX	(time_t)((1UL << ((sizeof(time_t) << 3) - 1)) - 1)
_
Subject: Subject: include/linux/time.h: make NSEC_PER_SEC 64-bit on 32-bit architectures	

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
fs-jbd2-commitc-use-new-kmap_atomic-api.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
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
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


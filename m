From: akpm@linux-foundation.org
Subject: +
 kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write.patch added to -mm tree
Date: Wed, 16 Apr 2014 12:12:51 -0700
Message-ID: <534ed633.huusemw7YRGjcj4q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaDPTMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 15:12:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robert.moore@intel.com, rafael.j.wysocki@intel.com, lv.zheng@intel.com, luis.henriques@canonical.com, lenb@kernel.org, eric.piel@tremplin-utc.net, cl@linux.com, akpm@linux-foundation.org

Subject: + kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write.patch added to -mm tree
To: akpm@linux-foundation.org,cl@linux.com,eric.piel@tremplin-utc.net,lenb@kernel.org,luis.henriques@canonical.com,lv.zheng@intel.com,rafael.j.wysocki@intel.com,robert.moore@intel.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 12:12:51 -0700


The patch titled
     Subject: kernel/watchdog.c:touch_softlockup_watchdog(): use raw_cpu_write()
has been added to the -mm tree.  Its filename is
     kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write.patch

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
Subject: kernel/watchdog.c:touch_softlockup_watchdog(): use raw_cpu_write()

BUG: using __this_cpu_write() in preemptible [00000000] code: systemd-udevd/497
caller is __this_cpu_preempt_check+0x13/0x20
CPU: 3 PID: 497 Comm: systemd-udevd Tainted: G        W     3.15.0-rc1 #9
Hardware name: Hewlett-Packard HP EliteBook 8470p/179B, BIOS 68ICF Ver. F.02 04/27/2012
 ffffffff81a14db5 ffff88022c80b8e0 ffffffff81604ba4 0000000000000003
 ffff88022c80b908 ffffffff81313431 0000000000000000 0000000000000032
 00000000000003e8 ffff88022c80b918 ffffffff81313473 ffff88022c80b928
Call Trace:
 [<ffffffff81604ba4>] dump_stack+0x4e/0x7a
 [<ffffffff81313431>] check_preemption_disabled+0xe1/0xf0
 [<ffffffff81313473>] __this_cpu_preempt_check+0x13/0x20
 [<ffffffff810e4eb8>] touch_nmi_watchdog+0x28/0x40

Reported-by: Luis Henriques <luis.henriques@canonical.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/watchdog.c~kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write
+++ a/kernel/watchdog.c
@@ -138,7 +138,11 @@ static void __touch_watchdog(void)
 
 void touch_softlockup_watchdog(void)
 {
-	__this_cpu_write(watchdog_touch_ts, 0);
+	/*
+	 * Preemption can be enabled.  It doesn't matter which CPU's timestamp
+	 * gets zeroed here, so use the raw_ operation.
+	 */
+	raw_cpu_write(watchdog_touch_ts, 0);
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write.patch
wait-explain-the-shadowing-and-type-inconsistencies.patch
mips-export-flush_icache_range-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


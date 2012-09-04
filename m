From: akpm@linux-foundation.org
Subject: [merged] revert-netpoll-re-enable-irq-in-poll_napi.patch removed from -mm tree
Date: Tue, 04 Sep 2012 12:26:24 -0700
Message-ID: <20120904192624.86BF9100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:48533 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab2IDT0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 15:26:25 -0400
Received: by ghbz15 with SMTP id z15so751033ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 12:26:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amwang@redhat.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "netpoll: re-enable irq in poll_napi()"
has been removed from the -mm tree.  Its filename was
     revert-netpoll-re-enable-irq-in-poll_napi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "netpoll: re-enable irq in poll_napi()"

Revert

: commit 6bdb7fe31046ac50b47e83c35cd6c6b6160a475d
: Author:     Amerigo Wang <amwang@redhat.com>
: AuthorDate: Fri Aug 10 01:24:50 2012 +0000
: Commit:     David S. Miller <davem@davemloft.net>
: CommitDate: Tue Aug 14 14:33:33 2012 -0700

because it makes my netconsole-using x86_64 box lock duing boot.

Cc: David Miller <davem@davemloft.net>
Cc: Cong Wang <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/netpoll.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN net/core/netpoll.c~revert-netpoll-re-enable-irq-in-poll_napi net/core/netpoll.c
--- a/net/core/netpoll.c~revert-netpoll-re-enable-irq-in-poll_napi
+++ a/net/core/netpoll.c
@@ -168,24 +168,16 @@ static void poll_napi(struct net_device 
 	struct napi_struct *napi;
 	int budget = 16;
 
-	WARN_ON_ONCE(!irqs_disabled());
-
 	list_for_each_entry(napi, &dev->napi_list, dev_list) {
-		local_irq_enable();
 		if (napi->poll_owner != smp_processor_id() &&
 		    spin_trylock(&napi->poll_lock)) {
-			rcu_read_lock_bh();
 			budget = poll_one_napi(rcu_dereference_bh(dev->npinfo),
 					       napi, budget);
-			rcu_read_unlock_bh();
 			spin_unlock(&napi->poll_lock);
 
-			if (!budget) {
-				local_irq_disable();
+			if (!budget)
 				break;
-			}
 		}
-		local_irq_disable();
 	}
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


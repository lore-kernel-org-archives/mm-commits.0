From: akpm@linux-foundation.org
Subject: + kernel-panicc-display-reason-at-end-pr_emerg-fix.patch added to -mm tree
Date: Tue, 11 Feb 2014 15:34:55 -0800
Message-ID: <52fab39f.9gmzAg9H4/4URy8a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbaBKXe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 18:34:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be, akpm@linux-foundation.org

Subject: + kernel-panicc-display-reason-at-end-pr_emerg-fix.patch added to -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 15:34:55 -0800


The patch titled
     Subject: kernel-panicc-display-reason-at-end-pr_emerg-fix
has been added to the -mm tree.  Its filename is
     kernel-panicc-display-reason-at-end-pr_emerg-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-panicc-display-reason-at-end-pr_emerg-fix.patch

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
Subject: kernel-panicc-display-reason-at-end-pr_emerg-fix

missed a couple of pr_ conversions

Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/panic.c~kernel-panicc-display-reason-at-end-pr_emerg-fix kernel/panic.c
--- a/kernel/panic.c~kernel-panicc-display-reason-at-end-pr_emerg-fix
+++ a/kernel/panic.c
@@ -275,8 +275,7 @@ unsigned long get_taint(void)
 void add_taint(unsigned flag, enum lockdep_ok lockdep_ok)
 {
 	if (lockdep_ok == LOCKDEP_NOW_UNRELIABLE && __debug_locks_off())
-		printk(KERN_WARNING
-		       "Disabling lock debugging due to kernel taint\n");
+		pr_warn("Disabling lock debugging due to kernel taint\n");
 
 	set_bit(flag, &tainted_mask);
 }
@@ -381,8 +380,7 @@ late_initcall(init_oops_id);
 void print_oops_end_marker(void)
 {
 	init_oops_id();
-	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
-		(unsigned long long)oops_id);
+	pr_warn("---[ end trace %016llx ]---\n", (unsigned long long)oops_id);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


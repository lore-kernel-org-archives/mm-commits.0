From: akpm@linux-foundation.org
Subject: [merged] drivers-block-paride-bpck6c-fix-build.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:26:02 -0800
Message-ID: <20120111212603.32A4E100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:47685 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKV0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:26:05 -0500
Received: by qcsg15 with SMTP id g15so135238qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:26:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mchehab@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/block/paride/bpck6.c: fix build
has been removed from the -mm tree.  Its filename was
     drivers-block-paride-bpck6c-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/block/paride/bpck6.c: fix build

i386 allmodconfig:

drivers/block/paride/bpck6.c:24: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'verbose'

We can't use "bool" before declaring the typedef to define it.

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/bpck6.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/block/paride/bpck6.c~drivers-block-paride-bpck6c-fix-build drivers/block/paride/bpck6.c
--- a/drivers/block/paride/bpck6.c~drivers-block-paride-bpck6c-fix-build
+++ a/drivers/block/paride/bpck6.c
@@ -20,9 +20,6 @@
 */
 
 
-/* PARAMETERS */
-static bool verbose; /* set this to 1 to see debugging messages and whatnot */
-
 #define BACKPACK_VERSION "2.0.2"
 
 #include <linux/module.h>
@@ -36,8 +33,8 @@ static bool verbose; /* set this to 1 to
 #include "ppc6lnx.c"
 #include "paride.h"
 
+static bool verbose; /* set this to 1 to see debugging messages and whatnot */
  
-
 #define PPCSTRUCT(pi) ((Interface *)(pi->private))
 
 /****************************************************************/
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-nfs-nfs4procc-fix-printk-warnings.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
drivers-parport-parport_pcc-fix-warnings.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


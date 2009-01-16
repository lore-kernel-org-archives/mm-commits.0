From: akpm@linux-foundation.org
Subject: [merged] revert-mm-vmalloc-use-mutex-for-purge.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:34 -0800
Message-ID: <200901161917.n0GJHYqE026120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937043AbZAPTSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:18:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bdonlan@gmail.com, christophe@saout.de, jeremy@goop.org, mingo@elte.hu, nickpiggin@yahoo.com.au, npiggin@suse.de, torvalds@linux-foundation.org, mm-commits@


The patch titled
     revert "mm: vmalloc use mutex for purge"
has been removed from the -mm tree.  Its filename was
     revert-mm-vmalloc-use-mutex-for-purge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "mm: vmalloc use mutex for purge"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit e97a630eb0f5b8b380fd67504de6cedebb489003
Author:     Nick Piggin <npiggin@suse.de>
AuthorDate: Tue Jan 6 14:39:19 2009 -0800
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Tue Jan 6 15:59:01 2009 -0800

    mm: vmalloc use mutex for purge

Bryan Donlan reports:

: After testing 2.6.29-rc1 on xen-x86 with a btrfs root filesystem, I
: got the OOPS quoted below and a hard freeze shortly after boot.
: Boot messages and config are attached.
: 
: ------------[ cut here ]------------
: Kernel BUG at c05ef80d [verbose debug info unavailable]
: invalid opcode: 0000 [#1] SMP
: last sysfs file: /sys/block/xvdc/size
: Modules linked in:
: 
: Pid: 0, comm: swapper Not tainted (2.6.29-rc1 #6)
: EIP: 0061:[<c05ef80d>] EFLAGS: 00010087 CPU: 2
: EIP is at schedule+0x7cd/0x950
: EAX: d5aeca80 EBX: 00000002 ECX: 00000000 EDX: d4cb9a40
: ESI: c12f5600 EDI: d4cb9a40 EBP: d6033fa4 ESP: d6033ef4
:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
: Process swapper (pid: 0, ti=d6032000 task=d6020b70 task.ti=d6032000)
: Stack:
:  000d85bc 00000000 000186a0 00000000 0dd11410 c0105417 c12efe00 0dc367c3
:  00000011 c0105d46 d5a5d310 deadbeef d4cb9a40 c07cc600 c05f1340 c12e0060
:  deadbeef d6020b70 d6020d08 00000002 c014377d 00000000 c12f5600 00002c22
: Call Trace:
:  [<c0105417>] xen_force_evtchn_callback+0x17/0x30
:  [<c0105d46>] check_events+0x8/0x12
:  [<c05f1340>] _spin_unlock_irqrestore+0x20/0x40
:  [<c014377d>] hrtimer_start_range_ns+0x12d/0x2e0
:  [<c014c4f6>] tick_nohz_restart_sched_tick+0x146/0x160
:  [<c0107485>] cpu_idle+0xa5/0xc0

and bisected it to this commit.

Let's remove it now while we have a think about the problem.


Reported-by: Bryan Donlan <bdonlan@gmail.com>
Tested-by: Christophe Saout <christophe@saout.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~revert-mm-vmalloc-use-mutex-for-purge mm/vmalloc.c
--- a/mm/vmalloc.c~revert-mm-vmalloc-use-mutex-for-purge
+++ a/mm/vmalloc.c
@@ -14,7 +14,6 @@
 #include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
@@ -496,7 +495,7 @@ static atomic_t vmap_lazy_nr = ATOMIC_IN
 static void __purge_vmap_area_lazy(unsigned long *start, unsigned long *end,
 					int sync, int force_flush)
 {
-	static DEFINE_MUTEX(purge_lock);
+	static DEFINE_SPINLOCK(purge_lock);
 	LIST_HEAD(valist);
 	struct vmap_area *va;
 	int nr = 0;
@@ -507,10 +506,10 @@ static void __purge_vmap_area_lazy(unsig
 	 * the case that isn't actually used at the moment anyway.
 	 */
 	if (!sync && !force_flush) {
-		if (!mutex_trylock(&purge_lock))
+		if (!spin_trylock(&purge_lock))
 			return;
 	} else
-		mutex_lock(&purge_lock);
+		spin_lock(&purge_lock);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(va, &vmap_area_list, list) {
@@ -542,7 +541,7 @@ static void __purge_vmap_area_lazy(unsig
 			__free_vmap_area(va);
 		spin_unlock(&vmap_area_lock);
 	}
-	mutex_unlock(&purge_lock);
+	spin_unlock(&purge_lock);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
i-need-old-gcc.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-net-mlx4-profilec-fix-min-warning.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
regulator-minor-cleanup-of-virtual-consumer-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch


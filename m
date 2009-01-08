From: akpm@linux-foundation.org
Subject: - kmemleak-add-the-base-support-fix.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:45:53 -0800
Message-ID: <200901082245.n08MjrTO025423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763400AbZAHWqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:46:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     kmemleak-add-the-base-support-fix
has been removed from the -mm tree.  Its filename was
     kmemleak-add-the-base-support-fix.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemleak-add-the-base-support-fix
From: Andrew Morton <akpm@linux-foundation.org>

prio_tree_init() can be run even earlier, so we may as well do so.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~kmemleak-add-the-base-support-fix init/main.c
--- a/init/main.c~kmemleak-add-the-base-support-fix
+++ a/init/main.c
@@ -651,6 +651,7 @@ asmlinkage void __init start_kernel(void
 		initrd_start = 0;
 	}
 #endif
+	prio_tree_init();
 	vmalloc_init();
 	vfs_caches_init_early();
 	cpuset_init_early();
@@ -660,7 +661,6 @@ asmlinkage void __init start_kernel(void
 	cpu_hotplug_init();
 	kmem_cache_init();
 	percpu_alloc_init();
-	prio_tree_init();
 	kmemleak_init();
 	kmemtrace_init();
 	debug_objects_mem_init();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
kernel-trace-ring_bufferc-use-div_round_up-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
kmemleak-add-the-base-support-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch


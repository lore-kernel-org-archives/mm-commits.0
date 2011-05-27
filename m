From: akpm@linux-foundation.org
Subject: [merged] irq-remove-procfs-smp_affinity_list-when-unregistering-irq-proc.patch removed from -mm tree
Date: Fri, 27 May 2011 12:59:33 -0700
Message-ID: <201105271957.p4RJvcoC017705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005Ab1E0UNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:13:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, tglx@linutronix.de, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     irq: remove procfs smp_affinity_list when unregistering irq proc
has been removed from the -mm tree.  Its filename was
     irq-remove-procfs-smp_affinity_list-when-unregistering-irq-proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: irq: remove procfs smp_affinity_list when unregistering irq proc
From: Yinghai Lu <yinghai@kernel.org>

[  274.239264] ------------[ cut here ]------------
[  274.239500] WARNING: at fs/proc/generic.c:850 remove_proc_entry+0x24c/0x27a()
[  274.251761] remove_proc_entry: removing non-empty directory 'irq/184', leaking at least 'smp_affinity_list'
[  274.271696] Modules linked in:
[  274.271880] Pid: 1, comm: swapper Tainted: G        W   2.6.39-tip-yh-07723-gf48dc10-dirty #1051
[  274.291734] Call Trace:
[  274.291892]  [<ffffffff8107cfa8>] warn_slowpath_common+0x85/0x9d
[  274.311582]  [<ffffffff8107d063>] warn_slowpath_fmt+0x46/0x48
[  274.311874]  [<ffffffff8118994e>] remove_proc_entry+0x24c/0x27a
[  274.331549]  [<ffffffff813336ca>] ? vsnprintf+0x3ed/0x429
[  274.331798]  [<ffffffff81333746>] ? sprintf+0x40/0x42
[  274.351430]  [<ffffffff810cde65>] unregister_irq_proc+0xb5/0xd2
[  274.351715]  [<ffffffff810ca64b>] free_desc+0x22/0x61
[  274.371461]  [<ffffffff810ca6c5>] irq_free_descs+0x3b/0x73
[  274.371738]  [<ffffffff81053bb3>] free_irq_at+0x31/0x36
[  274.391409]  [<ffffffff810553e6>] destroy_irq+0x74/0x7c
[  274.391662]  [<ffffffff81055619>] native_teardown_msi_irq+0xe/0x10
[  274.411407]  [<ffffffff8136239c>] default_teardown_msi_irqs+0x57/0x79
[  274.411735]  [<ffffffff81361c49>] free_msi_irqs+0x84/0xe2
[  274.431394]  [<ffffffff8136294d>] pci_disable_msi+0x35/0x39
[  274.431678]  [<ffffffff816574e2>] e1000e_reset_interrupt_capability+0x55/0x63
[  274.451420]  [<ffffffff81657701>] e1000_test_msi_interrupt+0x30/0x114
[  274.451749]  [<ffffffff81657853>] e1000_test_msi+0x6e/0xc5
[  274.471429]  [<ffffffff81658add>] e1000_open+0x10f/0x1e2
[  274.471731]  [<ffffffff81afed63>] __dev_open+0x9c/0xca
[  274.491282]  [<ffffffff81afef9d>] __dev_change_flags+0xad/0x130
[  274.491561]  [<ffffffff81aff0a1>] dev_change_flags+0x21/0x56
[  274.511370]  [<ffffffff82737d6b>] ic_open_devs+0xe3/0x233
[  274.511637]  [<ffffffff827394cf>] ip_auto_config+0xa5/0x2c0
[  274.531432]  [<ffffffff8273942a>] ? root_nfs_parse_addr+0xb5/0xb5
[  274.531780]  [<ffffffff810002cf>] do_one_initcall+0x57/0x134
[  274.551599]  [<ffffffff826ecf91>] kernel_init+0x137/0x1bb
[  274.551884]  [<ffffffff81c2e354>] kernel_thread_helper+0x4/0x10
[  274.571423]  [<ffffffff81c268c0>] ? retint_restore_args+0xe/0xe
[  274.591165]  [<ffffffff826ece5a>] ? start_kernel+0x3d3/0x3d3
[  274.591483]  [<ffffffff81c2e350>] ? gs_change+0xb/0xb
[  274.611129] ---[ end trace e07c035be3c974e5 ]---

caused by:
| commit 4b060420a596095869a6d7849caa798d23839cd1
| Author: Mike Travis <travis@sgi.com>
| Date:   Tue May 24 17:13:12 2011 -0700
|
|    bitmap, irq: add smp_affinity_list interface to /proc/irq

It forgets to remove it in the exit path

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/proc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/irq/proc.c~irq-remove-procfs-smp_affinity_list-when-unregistering-irq-proc kernel/irq/proc.c
--- a/kernel/irq/proc.c~irq-remove-procfs-smp_affinity_list-when-unregistering-irq-proc
+++ a/kernel/irq/proc.c
@@ -352,6 +352,7 @@ void unregister_irq_proc(unsigned int ir
 #ifdef CONFIG_SMP
 	remove_proc_entry("smp_affinity", desc->dir);
 	remove_proc_entry("affinity_hint", desc->dir);
+	remove_proc_entry("smp_affinity_list", desc->dir);
 	remove_proc_entry("node", desc->dir);
 #endif
 	remove_proc_entry("spurious", desc->dir);
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch
pci-dmar-update-dmar-units-devices-list-during-hotplug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


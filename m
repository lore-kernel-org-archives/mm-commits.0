From: akpm@linux-foundation.org
Subject: + memcg-fix-mem_cgroup_get_reclaim_stat_from_page.patch added to -mm tree
Date: Tue, 13 Jan 2009 15:02:22 -0800
Message-ID: <200901132302.n0DN2MBM028245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbZAMXD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 18:03:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     memcg: fix mem_cgroup_get_reclaim_stat_from_page
has been added to the -mm tree.  Its filename is
     memcg-fix-mem_cgroup_get_reclaim_stat_from_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix mem_cgroup_get_reclaim_stat_from_page
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

In case of swapin, a new page is added to lru before it is charged,
so page->pc->mem_cgroup points to NULL or last mem_cgroup the page
was charged before.

In the latter case, if the mem_cgroup has already freed by rmdir,
the area pointed to by page->pc->mem_cgroup may have invalid data.

Actually, I saw general protection fault.

    general protection fault: 0000 [#1] SMP
    last sysfs file: /sys/devices/system/cpu/cpu15/cache/index1/shared_cpu_map
    CPU 4
    Modules linked in: ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp ipv6 autofs4 hidp rfcomm l2cap bluetooth sunrpc dm_mirror dm_region_hash dm_log dm_multipath dm_mod rfkill input_polldev sbs sbshc battery ac lp sg ide_cd_mod cdrom button serio_raw acpi_memhotplug parport_pc e1000 rtc_cmos parport rtc_core rtc_lib i2c_i801 i2c_core shpchp pcspkr ata_piix libata megaraid_mbox megaraid_mm sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
    Pid: 26038, comm: page01 Tainted: G        W  2.6.28-rc9-mm1-mmotm-2008-12-22-16-14-f2ab3dea #1
    RIP: 0010:[<ffffffff8028e710>]  [<ffffffff8028e710>] update_page_reclaim_stat+0x2f/0x42
    RSP: 0000:ffff8801ee457da8  EFLAGS: 00010002
    RAX: 32353438312021c8 RBX: 0000000000000000 RCX: 32353438312021c8
    RDX: 0000000000000000 RSI: ffff8800cb0b1000 RDI: ffff8801164d1d28
    RBP: ffff880110002cb8 R08: ffff88010f2eae23 R09: 0000000000000001
    R10: ffff8800bc514b00 R11: ffff880110002c00 R12: 0000000000000000
    R13: ffff88000f484100 R14: 0000000000000003 R15: 00000000001200d2
    FS:  00007f8a261726f0(0000) GS:ffff88010f2eaa80(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    CR2: 00007f8a25d22000 CR3: 00000001ef18c000 CR4: 00000000000006e0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Process page01 (pid: 26038, threadinfo ffff8801ee456000, task ffff8800b585b960)
    Stack:
     ffffe200071ee568 ffff880110001f00 0000000000000000 ffffffff8028ea17
     ffff88000f484100 0000000000000000 0000000000000020 00007f8a25d22000
     ffff8800bc514b00 ffffffff8028ec34 0000000000000000 0000000000016fd8
    Call Trace:
     [<ffffffff8028ea17>] ? ____pagevec_lru_add+0xc1/0x13c
     [<ffffffff8028ec34>] ? drain_cpu_pagevecs+0x36/0x89
     [<ffffffff802a4f8c>] ? swapin_readahead+0x78/0x98
     [<ffffffff8029a37a>] ? handle_mm_fault+0x3d9/0x741
     [<ffffffff804da654>] ? do_page_fault+0x3ce/0x78c
     [<ffffffff804d7a42>] ? trace_hardirqs_off_thunk+0x3a/0x3c
     [<ffffffff804d860f>] ? page_fault+0x1f/0x30
    Code: cc 55 48 8d af b8 0d 00 00 48 89 f7 53 89 d3 e8 39 85 02 00 48 63 d3 48 ff 44 d5 10 45 85 e4 74 05 48 ff 44 d5 00 48 85 c0 74 0e <48> ff 44 d0 10 45 85 e4 74 04 48 ff 04 d0 5b 5d 41 5c c3 41 54
    RIP  [<ffffffff8028e710>] update_page_reclaim_stat+0x2f/0x42
     RSP <ffff8801ee457da8>

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-mem_cgroup_get_reclaim_stat_from_page mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-mem_cgroup_get_reclaim_stat_from_page
+++ a/mm/memcontrol.c
@@ -358,6 +358,10 @@ void mem_cgroup_rotate_lru_list(struct p
 		return;
 
 	pc = lookup_page_cgroup(page);
+	/*
+	 * Used bit is set without atomic ops but after smp_wmb().
+	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
+	 */
 	smp_rmb();
 	/* unused page is not rotated. */
 	if (!PageCgroupUsed(pc))
@@ -374,7 +378,10 @@ void mem_cgroup_add_lru_list(struct page
 	if (mem_cgroup_disabled())
 		return;
 	pc = lookup_page_cgroup(page);
-	/* barrier to sync with "charge" */
+	/*
+	 * Used bit is set without atomic ops but after smp_wmb().
+	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
+	 */
 	smp_rmb();
 	if (!PageCgroupUsed(pc))
 		return;
@@ -559,6 +566,14 @@ mem_cgroup_get_reclaim_stat_from_page(st
 		return NULL;
 
 	pc = lookup_page_cgroup(page);
+	/*
+	 * Used bit is set without atomic ops but after smp_wmb().
+	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
+	 */
+	smp_rmb();
+	if (!PageCgroupUsed(pc))
+		return NULL;
+
 	mz = page_cgroup_zoneinfo(pc);
 	if (!mz)
 		return NULL;
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memcg-fix-mem_cgroup_get_reclaim_stat_from_page.patch
memcg-fix-error-path-of-mem_cgroup_move_parent.patch
memcg-fix-hierarchical-reclaim.patch
memcg-make-oom-less-frequently.patch


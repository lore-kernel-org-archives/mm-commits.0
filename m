From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-hotplog-postpone-the-reset-of-obsolete-pgdat.patch removed from
 -mm tree
Date: Fri, 27 Mar 2015 11:16:49 -0700
Message-ID: <55159e91.+g3uTJipl4I1wBaR%akpm__31511.8697625168$1427480266$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbbC0SQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guz.fnst@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, qiuxishi@huawei.com, rientjes@google.com, stable@vger.kernel.org, tangchen@cn.fujitsu.com, xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory hotplug: postpone the reset of obsolete pgdat
has been removed from the -mm tree.  Its filename was
     mm-memory-hotplog-postpone-the-reset-of-obsolete-pgdat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: mm/memory hotplug: postpone the reset of obsolete pgdat

Qiu Xishi reported the following BUG when testing hot-add/hot-remove node under
stress condition.
[ 1422.011064] BUG: unable to handle kernel paging request at 0000000000025f60
[ 1422.011086] IP: [<ffffffff81126b91>] next_online_pgdat+0x1/0x50
[ 1422.011178] PGD 0
[ 1422.011180] Oops: 0000 [#1] SMP
[ 1422.011409] ACPI: Device does not support D3cold
[ 1422.011961] Modules linked in: fuse nls_iso8859_1 nls_cp437 vfat fat loop dm_mod coretemp mperf crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 pcspkr microcode igb dca i2c_algo_bit ipv6 megaraid_sas iTCO_wdt i2c_i801 i2c_core iTCO_vendor_support tg3 sg hwmon ptp lpc_ich pps_core mfd_core acpi_pad rtc_cmos button ext3 jbd mbcache sd_mod crc_t10dif scsi_dh_alua scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh ahci libahci libata scsi_mod [last unloaded: rasf]
[ 1422.012006] CPU: 23 PID: 238 Comm: kworker/23:1 Tainted: G           O 3.10.15-5885-euler0302 #1
[ 1422.012024] Hardware name: HUAWEI TECHNOLOGIES CO.,LTD. Huawei N1/Huawei N1, BIOS V100R001 03/02/2015
[ 1422.012065] Workqueue: events vmstat_update
[ 1422.012084] task: ffffa800d32c0000 ti: ffffa800d32ae000 task.ti: ffffa800d32ae000
[ 1422.012165] RIP: 0010:[<ffffffff81126b91>]  [<ffffffff81126b91>] next_online_pgdat+0x1/0x50
[ 1422.012205] RSP: 0018:ffffa800d32afce8  EFLAGS: 00010286
[ 1422.012225] RAX: 0000000000001440 RBX: ffffffff81da53b8 RCX: 0000000000000082
[ 1422.012226] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000000
[ 1422.012254] RBP: ffffa800d32afd28 R08: ffffffff81c93bfc R09: ffffffff81cbdc96
[ 1422.012272] R10: 00000000000040ec R11: 00000000000000a0 R12: ffffa800fffb3440
[ 1422.012290] R13: ffffa800d32afd38 R14: 0000000000000017 R15: ffffa800e6616800
[ 1422.012292] FS:  0000000000000000(0000) GS:ffffa800e6600000(0000) knlGS:0000000000000000
[ 1422.012314] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1422.012328] CR2: 0000000000025f60 CR3: 0000000001a0b000 CR4: 00000000001407e0
[ 1422.012328] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1422.012328] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1422.012328] Stack:
[ 1422.012328]  ffffa800d32afd28 ffffffff81126ca5 ffffa800ffffffff ffffffff814b4314
[ 1422.012328]  ffffa800d32ae010 0000000000000000 ffffa800e6616180 ffffa800fffb3440
[ 1422.012328]  ffffa800d32afde8 ffffffff81128220 ffffffff00000013 0000000000000038
[ 1422.012328] Call Trace:
[ 1422.012328]  [<ffffffff81126ca5>] ? next_zone+0xc5/0x150
[ 1422.012328]  [<ffffffff814b4314>] ? __schedule+0x544/0x780
[ 1422.012328]  [<ffffffff81128220>] refresh_cpu_vm_stats+0xd0/0x140
[ 1422.012328]  [<ffffffff811282a1>] vmstat_update+0x11/0x50
[ 1422.012328]  [<ffffffff81064c24>] process_one_work+0x194/0x3d0
[ 1422.012328]  [<ffffffff810660bb>] worker_thread+0x12b/0x410
[ 1422.012328]  [<ffffffff81065f90>] ? manage_workers+0x1a0/0x1a0
[ 1422.012328]  [<ffffffff8106ba66>] kthread+0xc6/0xd0
[ 1422.012328]  [<ffffffff8106b9a0>] ? kthread_freezable_should_stop+0x70/0x70
[ 1422.012328]  [<ffffffff814be0ac>] ret_from_fork+0x7c/0xb0
[ 1422.012328]  [<ffffffff8106b9a0>] ? kthread_freezable_should_stop+0x70/0x70

The cause is the "memset(pgdat, 0, sizeof(*pgdat))" at the end of
try_offline_node, which will reset the all content of pgdat to 0, as the
pgdat is accessed lock-lee, so that the users still using the pgdat will
panic, such as the vmstat_update routine.

process A:				offline node XX:

vmstat_updat()
   refresh_cpu_vm_stats()
     for_each_populated_zone()
       find online node XX
     cond_resched()
					offline cpu and memory, then try_offline_node()
					node_set_offline(nid), and memset(pgdat, 0, sizeof(*pgdat))
       zone = next_zone(zone)
         pg_data_t *pgdat = zone->zone_pgdat;  // here pgdat is NULL now
           next_online_pgdat(pgdat)
             next_online_node(pgdat->node_id);  // NULL pointer access


So the solution here is postponing the reset of obsolete pgdat from
try_offline_node() to hotadd_new_pgdat(), and just resetting
pgdat->nr_zones and pgdat->classzone_idx to be 0 rather than the memset 0
to avoid breaking pointer information in pgdat.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Reported-by: Xishi Qiu <qiuxishi@huawei.com>
Suggested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory-hotplog-postpone-the-reset-of-obsolete-pgdat mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory-hotplog-postpone-the-reset-of-obsolete-pgdat
+++ a/mm/memory_hotplug.c
@@ -1092,6 +1092,10 @@ static pg_data_t __ref *hotadd_new_pgdat
 			return NULL;
 
 		arch_refresh_nodedata(nid, pgdat);
+	} else {
+		/* Reset the nr_zones and classzone_idx to 0 before reuse */
+		pgdat->nr_zones = 0;
+		pgdat->classzone_idx = 0;
 	}
 
 	/* we can use NODE_DATA(nid) from here */
@@ -1977,15 +1981,6 @@ void try_offline_node(int nid)
 		if (is_vmalloc_addr(zone->wait_table))
 			vfree(zone->wait_table);
 	}

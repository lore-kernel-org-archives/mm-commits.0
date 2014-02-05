From: akpm@linux-foundation.org
Subject: + drivers-edac-edac_mc_sysfsc-poll-timeout-cannot-be-zero.patch
 added to -mm tree
Date: Tue, 04 Feb 2014 16:12:05 -0800
Message-ID: <52f181d5.qf41n5cgdPqcJa6u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbaBEAMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 19:12:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mchehab@infradead.org, dougthompson@xmission.com, prarit@redhat.com

Subject: + drivers-edac-edac_mc_sysfsc-poll-timeout-cannot-be-zero.patch added to -mm tree
To: prarit@redhat.com,dougthompson@xmission.com,mchehab@infradead.org
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 16:12:05 -0800


The patch titled
     Subject: drivers/edac/edac_mc_sysfs.c: poll timeout cannot be zero
has been added to the -mm tree.  Its filename is
     drivers-edac-edac_mc_sysfsc-poll-timeout-cannot-be-zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-edac-edac_mc_sysfsc-poll-timeout-cannot-be-zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-edac-edac_mc_sysfsc-poll-timeout-cannot-be-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Prarit Bhargava <prarit@redhat.com>
Subject: drivers/edac/edac_mc_sysfs.c: poll timeout cannot be zero

If you do

echo 0 > /sys/module/edac_core/parameters/edac_mc_poll_msec

the following stack trace is output because the edac module is not
designed to poll with a timeout of zero.

------------[ cut here ]------------
WARNING: CPU: 12 PID: 0 at lib/list_debug.c:33 __list_add+0xac/0xc0()
list_add corruption. prev->next should be next (ffff8808291dd1b8), but was           (null). (prev=ffff8808286fe3f8).
Modules linked in: sg nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache cfg80211 rfkill x86_pkg_temp_thermal coretemp kvm_intel kvm ixgbe e1000e crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt ptp sb_edac iTCO_vendor_support pps_core mdio ipmi_devintf edac_core ioatdma microcode shpchp lpc_ich pcspkr i2c_i801 dca mfd_core ipmi_si wmi ipmi_msghandler nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sd_mod sr_mod cdrom crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect sysimgblt isci i2c_algo_bit drm_kms_helper ttm drm libsas ahci libahci scsi_transport_sas libata i2c_core dm_mirror dm_region_hash dm_log dm_mod
CPU: 12 PID: 0 Comm: swapper/12 Not tainted 3.13.0+ #1
Hardware name: Intel Corporation LH Pass ........../SVRBD-ROW_T, BIOS SE5C600.86B.01.08.0003.022620131521 02/26/2013
 0000000000000009 ffff88082f683cc8 ffffffff815f1945 ffff88082f683d10
 ffff88082f683d00 ffffffff81069dad ffff880826f9b248 ffff8808291dd1b8
 ffff8808286fe3f8 ffff8808291dc000 0000000000000000 ffff88082f683d60
Call Trace:
 <IRQ>  [<ffffffff815f1945>] dump_stack+0x45/0x56
 [<ffffffff81069dad>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81069e1c>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff812dd0fc>] __list_add+0xac/0xc0
 [<ffffffff8107570b>] __internal_add_timer+0xab/0x130
 [<ffffffff81075907>] internal_add_timer+0x17/0x40
 [<ffffffff81077dfa>] mod_timer_pinned+0xca/0x170
 [<ffffffff8149f7f0>] ? pid_param_set+0x130/0x130
 [<ffffffff8149fa7a>] intel_pstate_timer_func+0x28a/0x380
 [<ffffffff8149f7f0>] ? pid_param_set+0x130/0x130
 [<ffffffff810757d6>] call_timer_fn+0x36/0x100
 [<ffffffff8149f7f0>] ? pid_param_set+0x130/0x130
 [<ffffffff810767ff>] run_timer_softirq+0x1ff/0x2f0
 [<ffffffff8106f3b5>] __do_softirq+0xf5/0x2e0
 [<ffffffff8106f87d>] irq_exit+0x10d/0x120
 [<ffffffff816042b5>] smp_apic_timer_interrupt+0x45/0x60
 [<ffffffff81602c1d>] apic_timer_interrupt+0x6d/0x80
 <EOI>  [<ffffffff814a022f>] ? cpuidle_enter_state+0x4f/0xc0
 [<ffffffff814a0228>] ? cpuidle_enter_state+0x48/0xc0
 [<ffffffff814a0359>] cpuidle_idle_call+0xb9/0x1f0
 [<ffffffff8101e44e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810c327e>] cpu_startup_entry+0x9e/0x240
 [<ffffffff81043544>] start_secondary+0x1e4/0x290
---[ end trace 078b214fc68689e6 ]---
------------[ cut here ]------------
------------[ cut here ]------------
kernel BUG at kernel/timer.c:1084!
invalid opcode: 0000 [#1] SMP
Modules linked in: sg nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache cfg80211 rfkill x86_pkg_temp_thermal coretemp kvm_intel kvm ixgbe e1000e crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt ptp sb_edac iTCO_vendor_support pps_core mdio ipmi_devintf edac_core ioatdma microcode shpchp lpc_ich pcspkr i2c_i801 dca mfd_core ipmi_si wmi ipmi_msghandler nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sd_mod sr_mod cdrom crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect sysimgblt isci i2c_algo_bit drm_kms_helper ttm drm libsas ahci libahci scsi_transport_sas libata i2c_core dm_mirror dm_region_hash dm_log dm_mod
CPU: 12 PID: 0 Comm: swapper/12 Tainted: G        W    3.13.0+ #1
Hardware name: Intel Corporation LH Pass ........../SVRBD-ROW_T, BIOS SE5C600.86B.01.08.0003.022620131521 02/26/2013
task: ffff880428eadd30 ti: ffff880428eb8000 task.ti: ffff880428eb8000
RIP: 0010:[<ffffffff810759c3>]  [<ffffffff810759c3>] cascade+0x93/0xa0
RSP: 0018:ffff88082f683e70  EFLAGS: 00010083
RAX: ffffffff81c64580 RBX: 0000000000000000 RCX: ffff88082f683ed8
RDX: 0000000000000019 RSI: ffff8808286f83f8 RDI: ffff8808291dc000
RBP: ffff88082f683ea0 R08: ffff8808291dd3b8 R09: 0000000000000100
R10: 0000000000000000 R11: ffff88082f6839fe R12: ffff8808291dc000
R13: ffff88082f683e70 R14: 0000000000000019 R15: ffff88082f683ed8
FS:  0000000000000000(0000) GS:ffff88082f680000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004a4fb0 CR3: 00000000018f8000 CR4: 00000000000407e0
Stack:
 ffff8808286f83f8 ffff880826f9b248 ffff8808291dc000 0000000000000000
 ffffffff81083c10 0000000000000002 ffff88082f683f10 ffffffff81076845
 ffff8808291ddc28 ffff8808291dd828 ffff8808291dd428 ffff8808291dd028
Call Trace:
 <IRQ>
 [<ffffffff81083c10>] ? __queue_work+0x320/0x320
 [<ffffffff81076845>] run_timer_softirq+0x245/0x2f0
 [<ffffffff8106f3b5>] __do_softirq+0xf5/0x2e0
 [<ffffffff8106f87d>] irq_exit+0x10d/0x120
 [<ffffffff816042b5>] smp_apic_timer_interrupt+0x45/0x60
 [<ffffffff81602c1d>] apic_timer_interrupt+0x6d/0x80
 <EOI>
 [<ffffffff814a022f>] ? cpuidle_enter_state+0x4f/0xc0
 [<ffffffff814a0228>] ? cpuidle_enter_state+0x48/0xc0
 [<ffffffff814a0359>] cpuidle_idle_call+0xb9/0x1f0
 [<ffffffff8101e44e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810c327e>] cpu_startup_entry+0x9e/0x240
 [<ffffffff81043544>] start_secondary+0x1e4/0x290
Code: 49 39 cc 75 26 48 89 de 48 89 c3 4c 89 e7 e8 b5 fc ff ff 4c 39 eb 48 8b 03 75 dd 48 83 c4 10 44 89 f0 5b 41 5c 41 5d 41 5e 5d c3 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89
RIP  [<ffffffff810759c3>] cascade+0x93/0xa0
 RSP <ffff88082f683e70>
WARNING: CPU: 36 PID: 1154 at kernel/workqueue.c:1461 __queue_delayed_work+0xed/0x1a0()
[ 3108.665556] Modules linked in: sg nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache cfg80211 rfkill x86_pkg_temp_thermal coretemp kvm_intel kvm ixgbe e1000e crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt ptp sb_edac iTCO_vendor_support pps_core mdio ipmi_devintf edac_core ioatdma microcode shpchp lpc_ich pcspkr i2c_i801 dca mfd_core ipmi_si wmi ipmi_msghandler nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sd_mod sr_mod cdrom crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect sysimgblt isci i2c_algo_bit drm_kms_helper ttm drm libsas ahci libahci scsi_transport_sas libata i2c_core dm_mirror dm_region_hash dm_log dm_mod
[ 3108.737843] CPU: 36 PID: 1154 Comm: kworker/u481:3 Tainted: G        W    3.13.0+ #1
[ 3108.746480] Hardware name: Intel Corporation LH Pass ........../SVRBD-ROW_T, BIOS SE5C600.86B.01.08.0003.022620131521 02/26/2013
[ 3108.759435] Workqueue: edac-poller edac_mc_workq_function [edac_core]
[ 3108.766630]  0000000000000009 ffff880425137d70 ffffffff815f1945 0000000000000000
[ 3108.774932]  ffff880425137da8 ffffffff81069dad 0000000000002000 ffff880826bb1200
[ 3108.783230]  ffff8808286fe3f8 ffff880036371000 0000000000003c20 ffff880425137db8
[ 3108.791521] Call Trace:
[ 3108.794265]  [<ffffffff815f1945>] dump_stack+0x45/0x56
[ 3108.800015]  [<ffffffff81069dad>] warn_slowpath_common+0x7d/0xa0
[ 3108.806732]  [<ffffffff81069e8a>] warn_slowpath_null+0x1a/0x20
[ 3108.813238]  [<ffffffff81083d1d>] __queue_delayed_work+0xed/0x1a0
[ 3108.820034]  [<ffffffff81084077>] queue_delayed_work_on+0x27/0x50
[ 3108.826831]  [<ffffffffa14b0392>] edac_mc_workq_function+0x72/0xa0 [edac_core]
[ 3108.834908]  [<ffffffff81085c3b>] process_one_work+0x17b/0x460
[ 3108.841414]  [<ffffffff810869db>] worker_thread+0x11b/0x400
[ 3108.847635]  [<ffffffff810868c0>] ? rescuer_thread+0x3e0/0x3e0
[ 3108.854143]  [<ffffffff8108d612>] kthread+0xd2/0xf0
[ 3108.859584]  [<ffffffff8108d540>] ? kthread_create_on_node+0x180/0x180
[ 3108.866873]  [<ffffffff81601efc>] ret_from_fork+0x7c/0xb0
[ 3108.872896]  [<ffffffff8108d540>] ? kthread_create_on_node+0x180/0x180
[ 3108.880176] ---[ end trace 078b214fc68689e7 ]---

This patch adds a range check in the edac_mc_poll_msec code to check for 0.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-edac_mc_sysfsc-poll-timeout-cannot-be-zero drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-edac_mc_sysfsc-poll-timeout-cannot-be-zero
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -61,7 +61,7 @@ static int edac_set_poll_msec(const char
 	ret = kstrtol(val, 0, &l);
 	if (ret)
 		return ret;
-	if ((int)l != l)
+	if (!l || ((int)l != l))
 		return -EINVAL;
 	*((int *)kp->arg) = l;
 
_

Patches currently in -mm which might be from prarit@redhat.com are

drivers-edac-edac_mc_sysfsc-poll-timeout-cannot-be-zero.patch
linux-next.patch


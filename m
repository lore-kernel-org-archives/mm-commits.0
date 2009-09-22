From: akpm@linux-foundation.org
Subject: [merged] proc-kcore-work-around-a-bug.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:36:43 -0700
Message-ID: <200909222036.n8MKahLr030436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbZIVUin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, kbowa@tuxedu.org, nick@craig-wood.com, penberg@cs.helsinki.fi, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     /proc/kcore: work around a BUG()
has been removed from the -mm tree.  Its filename was
     proc-kcore-work-around-a-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/kcore: work around a BUG()
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Works around a BUG() which is triggered when the kernel accesses holes in
vmalloc regions.

BUG: unable to handle kernel paging request at fa54c000
IP: [<c04f687a>] read_kcore+0x260/0x31a
*pde = 3540b067 *pte = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1c.2/0000:03:00.0/ieee80211/phy0/rfkill0/state
Modules linked in: fuse sco bridge stp llc bnep l2cap bluetooth sunrpc nf_conntrack_ftp ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq dm_multipath uinput usb_storage arc4 ecb snd_hda_codec_realtek snd_hda_intel ath5k snd_hda_codec snd_hwdep iTCO_wdt snd_pcm iTCO_vendor_support pcspkr i2c_i801 mac80211 joydev snd_timer serio_raw r8169 snd soundcore mii snd_page_alloc ath cfg80211 ata_generic i915 drm i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
Sep  4 12:45:16 tuxedu kernel: Pid: 2266, comm: cat Not tainted (2.6.31-rc8 #2) Joybook Lite U101
EIP: 0060:[<c04f687a>] EFLAGS: 00010286 CPU: 0
EIP is at read_kcore+0x260/0x31a
EAX: f5e5ea00 EBX: fa54d000 ECX: 00000400 EDX: 00001000
ESI: fa54c000 EDI: f44ad000 EBP: e4533f4c ESP: e4533f24
DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cat (pid: 2266, ti=e4532000 task=f09d19a0 task.ti=e4532000)
Stack:
00005000 00000000 f44ad000 09d9c000 00003000 fa54c000 00001000 f6d16f60
 e4520b80 fffffffb e4533f70 c04ef8eb e4533f98 00008000 09d97000 c04f661a
 e4520b80 09d97000 c04ef88c e4533f8c c04ba531 e4533f98 c04c0930 e4520b80
Call Trace:
[<c04ef8eb>] ? proc_reg_read+0x5f/0x73
[<c04f661a>] ? read_kcore+0x0/0x31a
[<c04ef88c>] ? proc_reg_read+0x0/0x73
[<c04ba531>] ? vfs_read+0x82/0xe1
[<c04c0930>] ? path_put+0x1a/0x1d
[<c04ba62e>] ? sys_read+0x40/0x62
[<c0403298>] ? sysenter_do_call+0x12/0x2d
Code: 39 f3 89 ca 0f 43 f3 89 fb 29 f2 29 f3 39 cf 0f 46 d3 29 55 dc 8d 1c 32 f6 40 0c 01 75 18 89 d1 89 f7 c1 e9 02 2b 7d ec 03 7d e0 <f3> a5 89 d1 83 e1 03 74 02 f3 a4 8b 00 83 7d dc 00 74 04 85 c0
EIP: [<c04f687a>] read_kcore+0x260/0x31a SS:ESP 0068:e4533f24
CR2: 00000000fa54c000


To access vmalloc area which may have memory holes, copy_from_user is
useful.  So this:

 # cat /proc/kcore > /dev/null

will not panic.

This is a minimal fix, suitable for 2.6.30.x and 2.6.31.  More extensive
/proc/kcore changes are planned for 2.6.32.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Nick Craig-Wood <nick@craig-wood.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Reported-by: <kbowa@tuxedu.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~proc-kcore-work-around-a-bug fs/proc/kcore.c
--- a/fs/proc/kcore.c~proc-kcore-work-around-a-bug
+++ a/fs/proc/kcore.c
@@ -361,7 +361,13 @@ read_kcore(struct file *file, char __use
 				/* don't dump ioremap'd stuff! (TA) */
 				if (m->flags & VM_IOREMAP)
 					continue;
-				memcpy(elf_buf + (vmstart - start),
+				/*
+				 * we may access memory holes, then use
+				 * ex_table. checking return value just for
+				 * avoid warnings.
+				 */
+				vmsize = __copy_from_user_inatomic(
+					elf_buf + (vmstart - start),
 					(char *)vmstart, vmsize);
 			}
 			read_unlock(&vmlist_lock);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
kcore-fix-proc-kcores-statst_size.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-types.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
walk-system-ram-range-fix.patch
walk-system-ram-range-fix-2.patch
kcore-use-registerd-physmem-information.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
kcore-register-vmemmap-range.patch
kcore-register-vmemmap-range-fix.patch
kcore-register-module-area-in-generic-way.patch
kcore-more-fixes-for-init.patch
proc-kcore-fix-statst_size.patch
proc-kcore-update-statst_size-after-memory-hotplug.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch


From: akpm@linux-foundation.org
Subject: +
 mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out-fix.patch
 added to -mm tree
Date: Tue, 01 Aug 2017 15:42:26 -0700
Message-ID: <598103d2.uuwTB+gcRZiVoESw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41766 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751802AbdHAWm1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2017 18:42:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, n-horiguchi@ah.jp.nec.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: Fix swap_page_trans_huge_swapped on HDD
has been added to the -mm tree.  Its filename is
     mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: Fix swap_page_trans_huge_swapped on HDD

To fix the following kernel bug,

[  112.690842] ===> testcase 'mm/shmem_swap' start
[ 112.788440] Adding 40956k swap on
/mnt/tests/examples/regression/kernel/mm_regression/mm_regression/work/swapfile.
Priority:-2 extents:1 across:40956k FS
[  112.815903] bash (17346): drop_caches: 3
[  112.975713] BUG: unable to handle kernel NULL pointer dereference at 0000000000000007
[  112.984464] IP: swap_page_trans_huge_swapped+0x49/0xd0
[  112.990202] PGD 805e62067
[  112.990202] P4D 805e62067
[  112.993219] PUD 80447b067
[  112.996236] PMD 0
[  112.999253]
[  113.003155] Oops: 0000 [#1] SMP
[ 113.006658] Modules linked in: nfsv4 dns_resolver nfs fscache
xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4
iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack libcrc32c ipt_REJECT nf_reject_ipv4 tun
bridge stp llc ebtable_filter ebtables ip6_tables iptable_filter
intel_rapl x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm
iTCO_wdt nfsd iTCO_vendor_support mei_me auth_rpcgss mei lpc_ich
ipmi_si ipmi_devintf irqbypass nfs_acl shpchp sg mfd_core ie31200_edac
lockd ipmi_msghandler pcspkr video acpi_pad grace sunrpc ip_tables
sr_mod sd_mod cdrom tg3 ata_generic pata_acpi ata_piix ptp libata
megaraid_sas crc32c_intel pps_core dm_mirror dm_region_hash dm_log
dm_mod
[  113.077676] CPU: 0 PID: 17431 Comm: test_alloc_gene Not tainted 4.13.0-rc3-mm1-v4.13-rc3-mmotm-2017-07-31-16-56+ #1
[  113.089323] Hardware name: NEC Express5800/T110g-E [N8100-2187Y]/GA-6LASV1, BIOS 4.6.1204 10/17/2014
[  113.099516] task: ffffa06705de9740 task.stack: ffffac0947c0c000
[  113.106124] RIP: 0010:swap_page_trans_huge_swapped+0x49/0xd0
[  113.112438] RSP: 0018:ffffac0947c0fb38 EFLAGS: 00010246
[  113.118269] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000040
[  113.126233] RDX: 0000000000000001 RSI: 00000000000005d6 RDI: ffffa06705674cfc
[  113.134196] RBP: ffffac0947c0fb60 R08: 0000000000000000 R09: ffffffff88ca2180
[  113.142161] R10: 0000000000000230 R11: ffffa066e7a9b451 R12: ffffa06705674c00
[  113.150123] R13: 00000000000005d6 R14: 0000000000000400 R15: ffffac0944001000
[  113.158088] FS:  00007f855b243740(0000) GS:ffffa0672fc00000(0000) knlGS:0000000000000000
[  113.167118] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  113.173529] CR2: 0000000000000007 CR3: 0000000808de2002 CR4: 00000000001606f0
[  113.181493] Call Trace:
[  113.184222]  free_swap_and_cache+0x73/0x1d0
[  113.188889]  shmem_free_swap+0x5e/0x70
[  113.193072]  shmem_undo_range+0x4bd/0x8b0
[  113.197547]  shmem_truncate_range+0x14/0x40
[  113.202211]  shmem_evict_inode+0xba/0x190
[  113.206686]  evict+0xd3/0x1a0
[  113.210004]  iput+0x17d/0x1d0
[  113.213316]  dentry_unlink_inode+0xb9/0xf0
[  113.217887]  __dentry_kill+0xc7/0x170
[  113.221994]  dput+0x19c/0x1d0
[  113.225311]  __fput+0x188/0x210
[  113.228813]  ____fput+0xe/0x10
[  113.232221]  task_work_run+0x86/0xa0
[  113.236209]  exit_to_usermode_loop+0x6d/0x99
[  113.240981]  syscall_return_slowpath+0xad/0xd0
[  113.245961]  entry_SYSCALL_64_fastpath+0xa3/0xa5
[  113.251127] RIP: 0033:0x7f855a940b17
[  113.255113] RSP: 002b:00007fff955b5048 EFLAGS: 00000206 ORIG_RAX: 000000000000001f
[  113.263562] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f855a940b17
[  113.271524] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000028001
[  113.279488] RBP: 00007fff955b5060 R08: 0000000000000000 R09: 0000000000000000
[  113.287450] R10: 00007fff955b4dd0 R11: 0000000000000206 R12: 0000000000401da0
[  113.295414] R13: 00007fff955b5350 R14: 0000000000000000 R15: 0000000000000000
[ 113.303378] Code: f5 41 54 49 89 fc 53 48 8b 47 70 4c 8b 7f 68 48 85
c0 74 70 4c 89 f3 48 c1 eb 06 48 01 c3 48 89 df e8 fc 10 54 00 48 85
db 74 59 <f6> 43 07 04 75 31 48 b8 ff ff ff ff ff ff ff 01 49 21 c5 43
80
[  113.324450] RIP: swap_page_trans_huge_swapped+0x49/0xd0 RSP: ffffac0947c0fb38
[  113.332413] CR2: 0000000000000007
[  113.336121] ---[ end trace 2cd503b4980b0afc ]---
[  113.341281] Kernel panic - not syncing: Fatal exception
[  113.347398] Kernel Offset: 0x7000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Link: http://lkml.kernel.org/r/874ltsm0bi.fsf@yhuang-dev.intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out-fix mm/swapfile.c
--- a/mm/swapfile.c~mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out-fix
+++ a/mm/swapfile.c
@@ -1374,7 +1374,7 @@ static bool swap_page_trans_huge_swapped
 	bool ret = false;
 
 	ci = lock_cluster_or_swap_info(si, offset);
-	if (!cluster_is_huge(ci)) {
+	if (!ci || !cluster_is_huge(ci)) {
 		if (map[roffset] != SWAP_HAS_CACHE)
 			ret = true;
 		goto unlock_out;
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out-fix.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix.patch
mm-thp-swap-dont-allocate-huge-cluster-for-file-backed-swap-device.patch
block-thp-make-block_device_operationsrw_page-support-thp.patch
test-code-to-write-thp-to-swap-device-as-a-whole.patch
mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch
memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
memcg-thp-swap-avoid-to-duplicated-charge-thp-in-swap-cache.patch
memcg-thp-swap-make-mem_cgroup_swapout-support-thp.patch
mm-thp-swap-delay-splitting-thp-after-swapped-out.patch
mm-thp-swap-add-thp-swapping-out-fallback-counting.patch


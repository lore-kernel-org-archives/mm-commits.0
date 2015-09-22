From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch added to -mm tree
Date: Tue, 22 Sep 2015 11:55:02 -0700
Message-ID: <5601a406.HJm1lIc9wBSoANfN%akpm__18031.9540355869$1442948143$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759392AbbIVSzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 14:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, aarcange@redhat.com, hughd@google.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, stable@vger.kernel.org, sund_sky@126.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlbfs: skip shared VMAs when unmapping private pages to satisfy a fault
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: hugetlbfs: skip shared VMAs when unmapping private pages to satisfy a fault

SunDong reported the following on
https://bugzilla.kernel.org/show_bug.cgi?id=103841

	I think I find a linux bug, I have the test cases is constructed. I
	can stable recurring problems in fedora22(4.0.4) kernel version,
	arch for x86_64.  I construct transparent huge page, when the parent
	and child process with MAP_SHARE, MAP_PRIVATE way to access the same
	huge page area, it has the opportunity to lead to huge page copy on
	write failure, and then it will munmap the child corresponding mmap
	area, but then the child mmap area with VM_MAYSHARE attributes, child
	process munmap this area can trigger VM_BUG_ON in set_vma_resv_flags
	functions (vma - > vm_flags & VM_MAYSHARE).

There were a number of problems with the report (e.g.  it's hugetlbfs that
triggers this, not transparent huge pages) but it was fundamentally
correct in that a VM_BUG_ON in set_vma_resv_flags() can be triggered that
looks like this

	 vma ffff8804651fd0d0 start 00007fc474e00000 end 00007fc475e00000
	 next ffff8804651fd018 prev ffff8804651fd188 mm ffff88046b1b1800
	 prot 8000000000000027 anon_vma           (null) vm_ops ffffffff8182a7a0
	 pgoff 0 file ffff88106bdb9800 private_data           (null)
	 flags: 0x84400fb(read|write|shared|mayread|maywrite|mayexec|mayshare|dontexpand|hugetlb)
	 ------------
	 kernel BUG at mm/hugetlb.c:462!
	 SMP
	 Modules linked in: xt_pkttype xt_LOG xt_limit iscsi_ibft iscsi_boot_sysfs af_packet ip6t_REJECT nf_reject_ipv6
xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT nf_reject_ipv4 iptable_raw xt_CT iptable_filter ip6table_mangle
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
ip6_tables x_tables intel_powerclamp coretemp kvm_intel kvm mgag200 ttm drm_kms_helper drm crct10dif_pclmul crc32_pclmul crc32c_intel
ghash_clmulni_intel aesni_intel aes_x86_64 lrw ipmi_devintf gf128mul iTCO_wdt gpio_ich iTCO_vendor_support glue_helper ablk_helper
dcdbas i7core_edac cryptd syscopyarea sysfillrect bnx2 sysimgblt lpc_ich serio_raw edac_core i2c_algo_bit shpchp mfd_core ipmi_si
tpm_tis tpm ipmi_msghandler wmi acpi_power_meter button acpi_cpufreq processor dm_mod sr_mod cdrom ata_generic hid_generic usbhid hid
uhci_hcd ehci_pci ehci_hcd usbcore ata_piix usb_common megaraid_sas sg
	 CPU: 38 PID: 26839 Comm: map Not tainted 4.0.4-default #1
	 Hardware name: Dell Inc. PowerEdge R810/0TT6JF, BIOS 2.7.4 04/26/2012
	 task: ffff88085ed10490 ti: ffff88085ed14000 task.ti: ffff88085ed14000
	 set_vma_resv_flags+0x2d/0x30

The VM_BUG_ON is correct because private and shared mappings have
different reservation accounting but the warning clearly shows that the
VMA is shared.

When a private COW fails to allocate a new page then only the process that
created the VMA gets the page -- all the children unmap the page.  If the
children access that data in the future then they get killed.

The problem is that the same file is mapped shared and private.  During
the COW, the allocation fails, the VMAs are traversed to unmap the other
private pages but a shared VMA is found and the bug is triggered.  This
patch identifies such VMAs and skips them.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: SunDong <sund_sky@126.com>
Reviewed-by: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault
+++ a/mm/hugetlb.c
@@ -3202,6 +3202,14 @@ static void unmap_ref_private(struct mm_
 			continue;
 
 		/*
+		 * Shared VMAs have their own reserves and do not affect
+		 * MAP_PRIVATE accounting but it is possible that a shared
+		 * VMA is using the same page so check and skip such VMAs.
+		 */
+		if (iter_vma->vm_flags & VM_MAYSHARE)
+			continue;
+
+		/*
 		 * Unmap the page from other VMAs without their own reserves.
 		 * They get marked to be SIGKILLed if they fault in these
 		 * areas. This is because a future no-page fault on this VMA
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch


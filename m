From: akpm@linux-foundation.org
Subject: [patch 11/12] dax: fix device-dax region base
Date: Thu, 25 Aug 2016 15:17:14 -0700
Message-ID: <57bf6e6a.CWn91154CfPeXd/4%akpm__33863.5830711157$1472164942$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932818AbcHYWmQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 18:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dan.j.williams@intel.com, m.abhilash-kumar@hpe.com, stable@vger.kernel.org, toshi.kani@hpe.com

From: Dan Williams <dan.j.williams@intel.com>
Subject: dax: fix device-dax region base

The data offset for a dax region needs to account for a reservation in the
resource range.  Otherwise, device-dax is allowing mappings directly into
the memmap or device-info-block area with crash signatures like the
following:

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
 IP: [<ffffffff811ac851>] get_zone_device_page+0x11/0x30
 Call Trace:
   follow_devmap_pmd+0x298/0x2c0
   follow_page_mask+0x275/0x530
   __get_user_pages+0xe3/0x750
   __gfn_to_pfn_memslot+0x1b2/0x450 [kvm]
   ? hrtimer_try_to_cancel+0x2c/0x120
   ? kvm_read_l1_tsc+0x55/0x60 [kvm]
   try_async_pf+0x66/0x230 [kvm]
   ? kvm_host_page_size+0x90/0xa0 [kvm]
   tdp_page_fault+0x130/0x280 [kvm]
   kvm_mmu_page_fault+0x5f/0xf0 [kvm]
   handle_ept_violation+0x94/0x180 [kvm_intel]
   vmx_handle_exit+0x1d3/0x1440 [kvm_intel]
   ? atomic_switch_perf_msrs+0x6f/0xa0 [kvm_intel]
   ? vmx_vcpu_run+0x2d1/0x490 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0x81d/0x16a0 [kvm]
   ? wake_up_q+0x44/0x80
   kvm_vcpu_ioctl+0x33c/0x620 [kvm]
   ? __vfs_write+0x37/0x160
   do_vfs_ioctl+0xa2/0x5d0
   SyS_ioctl+0x79/0x90
   entry_SYSCALL_64_fastpath+0x1a/0xa4

Fixes: ab68f2622136 ("/dev/dax, pmem: direct access to persistent memory")
Link: http://lkml.kernel.org/r/147205536732.1606.8994275381938837346.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Abhilash Kumar Mulumudi <m.abhilash-kumar@hpe.com>
Reported-by: Toshi Kani <toshi.kani@hpe.com>
Tested-by: Toshi Kani <toshi.kani@hpe.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/pmem.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/dax/pmem.c~dax-fix-device-dax-region-base drivers/dax/pmem.c
--- a/drivers/dax/pmem.c~dax-fix-device-dax-region-base
+++ a/drivers/dax/pmem.c
@@ -116,6 +116,9 @@ static int dax_pmem_probe(struct device
 	if (rc)
 		return rc;
 
+	/* adjust the dax_region resource to the start of data */
+	res.start += le64_to_cpu(pfn_sb->dataoff);
+
 	nd_region = to_nd_region(dev->parent);
 	dax_region = alloc_dax_region(dev, nd_region->id, &res,
 			le32_to_cpu(pfn_sb->align), addr, PFN_DEV|PFN_MAP);
_

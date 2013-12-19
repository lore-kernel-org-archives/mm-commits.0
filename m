From: akpm@linux-foundation.org
Subject: +
 drivers-dma-ioat-dmac-check-dma-mapping-error-in-ioat_dma_self_test.patch
 added to -mm tree
Date: Thu, 19 Dec 2013 15:31:41 -0800
Message-ID: <52b381dd.xD3kf/H6NbILhtyJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab3LSXbm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 18:31:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vinod.koul@intel.com, kyungmin.park@samsung.com, dan.j.williams@intel.com, b.zolnierkie@samsung.com, jiang.liu@linux.intel.com

Subject: + drivers-dma-ioat-dmac-check-dma-mapping-error-in-ioat_dma_self_test.patch added to -mm tree
To: jiang.liu@linux.intel.com,b.zolnierkie@samsung.com,dan.j.williams@intel.com,kyungmin.park@samsung.com,vinod.koul@intel.com
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 15:31:41 -0800


The patch titled
     Subject: drivers/dma/ioat/dma.c: check DMA mapping error in ioat_dma_self_test()
has been added to the -mm tree.  Its filename is
     drivers-dma-ioat-dmac-check-dma-mapping-error-in-ioat_dma_self_test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-dma-ioat-dmac-check-dma-mapping-error-in-ioat_dma_self_test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-dma-ioat-dmac-check-dma-mapping-error-in-ioat_dma_self_test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: drivers/dma/ioat/dma.c: check DMA mapping error in ioat_dma_self_test()

Check DMA mapping return values in function ioat_dma_self_test() to get
rid of following warning message.

[   20.582159] ------------[ cut here ]------------
[   20.582170] WARNING: CPU: 0 PID: 1203 at lib/dma-debug.c:937 check_unmap+0x4cc
0/0x9a0()
[   20.582197] ioatdma 0000:00:04.0: DMA-API: device driver failed to check map
error[device address=0x000000085191b000] [size=2000 bytes] [mapped as single]
[   20.582202] Modules linked in: ioatdma(+) mac_hid wmi acpi_pad lp parport hidd
_generic usbhid hid ixgbe isci dca libsas ahci ptp libahci scsi_transport_sas mee
garaid_sas pps_core mdio
[   20.582313] CPU: 0 PID: 1203 Comm: systemd-udevd Not tainted 3.13.0-rc4+ #8
[   20.582320] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BRIVTII
N1.86B.0044.L09.1311181644 11/18/2013
[   20.582324]  0000000000000009 ffff8810432fb818 ffffffff8185ddb1 ffff8810432fbb
860
[   20.582361]  ffff8810432fb850 ffffffff81073b1d ffff881037831c80 ffff880850f8ff
310
[   20.582382]  ffffffff82a89710 0000000000000292 ffffffff81cc7b85 ffff8810432fbb
8b0
[   20.582390] Call Trace:
[   20.582402]  [<ffffffff8185ddb1>] dump_stack+0x4d/0x66
[   20.582413]  [<ffffffff81073b1d>] warn_slowpath_common+0x7d/0xa0
[   20.582418]  [<ffffffff81073b8c>] warn_slowpath_fmt+0x4c/0x50
[   20.582449]  [<ffffffff8144bb2a>] ? driver_filter+0x2a/0xe0
[   20.582454]  [<ffffffff8144d940>] check_unmap+0x4c0/0x9a0
[   20.582458]  [<ffffffff8144dea1>] debug_dma_unmap_page+0x81/0x90
[   20.582466]  [<ffffffffa0107ea2>] ioat_dma_self_test+0x3d2/0x680 [ioatdma]
[   20.582476]  [<ffffffffa010edd2>] ioat3_dma_self_test+0x12/0x30 [ioatdma]
[   20.582490]  [<ffffffffa0108dc4>] ioat_probe+0xf4/0x110 [ioatdma]
[   20.582500]  [<ffffffffa010f058>] ioat3_dma_probe+0x268/0x410 [ioatdma]
[   20.582505]  [<ffffffffa0106192>] ioat_pci_probe+0x122/0x1b0 [ioatdma]
[   20.582516]  [<ffffffff8146ac15>] local_pci_probe+0x45/0xa0
[   20.582522]  [<ffffffff8146b595>] ? pci_match_device+0xc5/0xd0
[   20.582530]  [<ffffffff8146b6b9>] pci_device_probe+0xd9/0x130
[   20.582537]  [<ffffffff8155bc81>] driver_probe_device+0x171/0x490
[   20.582566]  [<ffffffff8155c073>] __driver_attach+0x93/0xa0
[   20.582577]  [<ffffffff8155bfe0>] ? __device_attach+0x40/0x40
[   20.582583]  [<ffffffff8155981b>] bus_for_each_dev+0x6b/0xb0
[   20.582587]  [<ffffffff8155b51e>] driver_attach+0x1e/0x20
[   20.582593]  [<ffffffff8155b068>] bus_add_driver+0x1f8/0x2b0
[   20.582604]  [<ffffffffa011a000>] ? 0xffffffffa0119fff
[   20.582614]  [<ffffffff8155c931>] driver_register+0x81/0x110
[   20.582627]  [<ffffffff81469a00>] __pci_register_driver+0x60/0x70
[   20.582637]  [<ffffffffa011a089>] ioat_init_module+0x89/0x1000 [ioatdma]
[   20.582655]  [<ffffffff81002132>] do_one_initcall+0xe2/0x250
[   20.582661]  [<ffffffffa011a000>] ? 0xffffffffa0119fff
[   20.582668]  [<ffffffff81064dd3>] ? set_memory_nx+0x43/0x50
[   20.582675]  [<ffffffff81116523>] load_module+0x2313/0x2a00
[   20.582690]  [<ffffffff811114c0>] ? store_uevent+0x40/0x40
[   20.582696]  [<ffffffff81116ce9>] SyS_init_module+0xd9/0x130
[   20.582702]  [<ffffffff8187502d>] system_call_fastpath+0x1a/0x1f
[   20.582704] ---[ end trace 990c591681d27c31 ]---
[   20.582706] Mapped at:
[   20.582708]  [<ffffffff8144c66e>] debug_dma_map_page+0xbe/0x180
[   20.582712]  [<ffffffffa0107c7b>] ioat_dma_self_test+0x1ab/0x680 [ioatdma]
[   20.582716]  [<ffffffffa010edd2>] ioat3_dma_self_test+0x12/0x30 [ioatdma]
[   20.582720]  [<ffffffffa0108dc4>] ioat_probe+0xf4/0x110 [ioatdma]
[   20.582725]  [<ffffffffa010f058>] ioat3_dma_probe+0x268/0x410 [ioatdma]

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat/dma.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/dma/ioat/dma.c~drivers-dma-ioat-dmac-check-dma-mapping-error-in-ioat_dma_self_test drivers/dma/ioat/dma.c
--- a/drivers/dma/ioat/dma.c~drivers-dma-ioat-dmac-check-dma-mapping-error-in-ioat_dma_self_test
+++ a/drivers/dma/ioat/dma.c
@@ -817,7 +817,15 @@ int ioat_dma_self_test(struct ioatdma_de
 	}
 
 	dma_src = dma_map_single(dev, src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, dma_src)) {
+		dev_err(dev, "mapping src buffer failed\n");
+		goto free_resources;
+	}
 	dma_dest = dma_map_single(dev, dest, IOAT_TEST_SIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, dma_dest)) {
+		dev_err(dev, "mapping dest buffer failed\n");
+		goto unmap_src;
+	}
 	flags = DMA_PREP_INTERRUPT;
 	tx = device->common.device_prep_dma_memcpy(dma_chan, dma_dest, dma_src,
 						   IOAT_TEST_SIZE, flags);
@@ -855,8 +863,9 @@ int ioat_dma_self_test(struct ioatdma_de
 	}
 
 unmap_dma:
-	dma_unmap_single(dev, dma_src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
 	dma_unmap_single(dev, dma_dest, IOAT_TEST_SIZE, DMA_FROM_DEVICE);
+unmap_src:
+	dma_unmap_single(dev, dma_src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
 free_resources:
 	dma->device_free_chan_resources(dma_chan);
 out:
_

Patches currently in -mm which might be from jiang.liu@linux.intel.com are

drivers-dma-ioat-dmac-check-dma-mapping-error-in-ioat_dma_self_test.patch


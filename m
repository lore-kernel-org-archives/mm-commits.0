From: akpm@linux-foundation.org
Subject: +
 drivers-dma-coherent-use-memset_io-for-dma_memory_io-mappings.patch added
 to -mm tree
Date: Mon, 29 Feb 2016 15:32:39 -0800
Message-ID: <56d4d517.7fHcepsv0VigW2K1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbcB2Xck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 18:32:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brian.starkey@arm.com, catalin.marinas@arm.com, dan.j.williams@intel.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: dma-coherent: use memset_io for DMA_MEMORY_IO mappings
has been added to the -mm tree.  Its filename is
     drivers-dma-coherent-use-memset_io-for-dma_memory_io-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-dma-coherent-use-memset_io-for-dma_memory_io-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-dma-coherent-use-memset_io-for-dma_memory_io-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Starkey <brian.starkey@arm.com>
Subject: drivers: dma-coherent: use memset_io for DMA_MEMORY_IO mappings

Use memset_io() for DMA_MEMORY_IO mappings which are mapped as I/O memory,
and regular memset() for DMA_MEMORY_MAP mappings.

This fixes the below alignment fault on arm64 for DMA_MEMORY_IO mappings,
where memset() uses the DC ZVA instruction which is invalid on device
memory.

   Unhandled fault: alignment fault (0x96000061) at 0xffffff8000380000
   Internal error: : 96000061 [#1] PREEMPT SMP
   Modules linked in: hdlcd(+) clk_scpi
   CPU: 4 PID: 1355 Comm: systemd-udevd Not tainted 4.4.0-rc1+ #5
   Hardware name: ARM Juno development board (r0) (DT)
   task: ffffffc9763eee00 ti: ffffffc9758c4000 task.ti: ffffffc9758c4000
   PC is at __efistub_memset+0x1ac/0x200
   LR is at dma_alloc_from_coherent+0xb0/0x120
   pc : [<ffffffc00030ff2c>] lr : [<ffffffc00042a918>] pstate: 400001c5
   sp : ffffffc9758c79a0
   x29: ffffffc9758c79a0 x28: ffffffc000635cd0
   x27: 0000000000000124 x26: ffffffc000119ef4
   x25: 0000000000010000 x24: 0000000000000140
   x23: ffffffc07e9ac3a8 x22: ffffffc9758c7a58
   x21: ffffffc9758c7a68 x20: 0000000000000004
   x19: ffffffc07e9ac380 x18: 0000000000000001
   x17: 0000007fae1bbba8 x16: ffffffc0001b2d1c
   x15: ffffffffffffffff x14: 0ffffffffffffffe
   x13: 0000000000000010 x12: ffffff800837ffff
   x11: ffffff800837ffff x10: 0000000040000000
   x9 : 0000000000000000 x8 : ffffff8000380000
   x7 : 0000000000000000 x6 : 000000000000003f
   x5 : 0000000000000040 x4 : 0000000000000000
   x3 : 0000000000000004 x2 : 000000000000ffc0
   x1 : 0000000000000000 x0 : ffffff8000380000

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-coherent.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/base/dma-coherent.c~drivers-dma-coherent-use-memset_io-for-dma_memory_io-mappings drivers/base/dma-coherent.c
--- a/drivers/base/dma-coherent.c~drivers-dma-coherent-use-memset_io-for-dma_memory_io-mappings
+++ a/drivers/base/dma-coherent.c
@@ -187,7 +187,10 @@ int dma_alloc_from_coherent(struct devic
 	 */
 	*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
 	*ret = mem->virt_base + (pageno << PAGE_SHIFT);
-	memset(*ret, 0, size);
+	if (mem->flags & DMA_MEMORY_MAP)
+		memset(*ret, 0, size);
+	else
+		memset_io(*ret, 0, size);
 	spin_unlock_irqrestore(&mem->spinlock, flags);
 
 	return 1;
_

Patches currently in -mm which might be from brian.starkey@arm.com are

memremap-dont-modify-flags.patch
memremap-add-memremap_wc-flag.patch
drivers-dma-coherent-use-memremap_wc-for-dma_memory_map.patch
drivers-dma-coherent-use-memset_io-for-dma_memory_io-mappings.patch


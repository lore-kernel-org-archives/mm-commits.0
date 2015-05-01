From: akpm@linux-foundation.org
Subject: + powerpc-use-for_each_sg.patch added to -mm tree
Date: Fri, 01 May 2015 14:40:26 -0700
Message-ID: <5543f2ca.oa/llElTinK7jSJa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbbEAVk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2015 17:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, benh@kernel.crashing.org, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: use for_each_sg()
has been added to the -mm tree.  Its filename is
     powerpc-use-for_each_sg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-use-for_each_sg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-use-for_each_sg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: powerpc: use for_each_sg()

This replaces the plain loop over the sglist array with for_each_sg()
macro which consists of sg_next() function calls.  Since powerpc does
select ARCH_HAS_SG_CHAIN, it is necessary to use for_each_sg() in order to
loop over each sg element.  This also help find problems with drivers that
do not properly initialize their sg tables when CONFIG_DEBUG_SG is
enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vio.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/kernel/vio.c~powerpc-use-for_each_sg arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~powerpc-use-for_each_sg
+++ a/arch/powerpc/kernel/vio.c
@@ -557,11 +557,11 @@ static int vio_dma_iommu_map_sg(struct d
 	struct vio_dev *viodev = to_vio_dev(dev);
 	struct iommu_table *tbl;
 	struct scatterlist *sgl;
-	int ret, count = 0;
+	int ret, count;
 	size_t alloc_size = 0;
 
 	tbl = get_iommu_table_base(dev);
-	for (sgl = sglist; count < nelems; count++, sgl++)
+	for_each_sg(sglist, sgl, nelems, count)
 		alloc_size += roundup(sgl->length, IOMMU_PAGE_SIZE(tbl));
 
 	if (vio_cmo_alloc(viodev, alloc_size)) {
@@ -577,7 +577,7 @@ static int vio_dma_iommu_map_sg(struct d
 		return ret;
 	}
 
-	for (sgl = sglist, count = 0; count < ret; count++, sgl++)
+	for_each_sg(sglist, sgl, ret, count)
 		alloc_size -= roundup(sgl->dma_length, IOMMU_PAGE_SIZE(tbl));
 	if (alloc_size)
 		vio_cmo_dealloc(viodev, alloc_size);
@@ -594,10 +594,10 @@ static void vio_dma_iommu_unmap_sg(struc
 	struct iommu_table *tbl;
 	struct scatterlist *sgl;
 	size_t alloc_size = 0;
-	int count = 0;
+	int count;
 
 	tbl = get_iommu_table_base(dev);
-	for (sgl = sglist; count < nelems; count++, sgl++)
+	for_each_sg(sglist, sgl, nelems, count)
 		alloc_size += roundup(sgl->dma_length, IOMMU_PAGE_SIZE(tbl));
 
 	dma_iommu_ops.unmap_sg(dev, sglist, nelems, direction, attrs);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch
lib-scatterlist-mark-input-buffer-parameters-as-const.patch
linux-next.patch
m68k-use-for_each_sg.patch
arc-use-for_each_sg.patch
metag-use-for_each_sg.patch
xtensa-use-for_each_sg.patch
mips-use-for_each_sg.patch
frv-use-for_each_sg.patch
avr32-use-for_each_sg.patch
powerpc-use-for_each_sg.patch
sparc-use-for_each_sg.patch
parisc-use-for_each_sg.patch


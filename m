From: akpm@linux-foundation.org
Subject: + errh-allow-is_err_value-to-handle-properly-more-types.patch
 added to -mm tree
Date: Wed, 03 Feb 2016 14:57:45 -0800
Message-ID: <56b285e9.d8ITU0+XCvkvyuSQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbcBCW5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 17:57:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.hajda@samsung.com, b.zolnierkie@samsung.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: err.h: allow IS_ERR_VALUE to handle properly more types
has been added to the -mm tree.  Its filename is
     errh-allow-is_err_value-to-handle-properly-more-types.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/errh-allow-is_err_value-to-handle-properly-more-types.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/errh-allow-is_err_value-to-handle-properly-more-types.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrzej Hajda <a.hajda@samsung.com>
Subject: err.h: allow IS_ERR_VALUE to handle properly more types

Current implementation of IS_ERR_VALUE works correctly only with following
types:

- unsigned long,

- short, int, long.

Other types are handled incorrectly either on 32-bit either on 64-bit
either on both architectures.

The patch fixes it by comparing argument with MAX_ERRNO casted to
argument's type for unsigned types and comparing with zero for signed
types.  As a result all integer types bigger than char are handled
properly.

I have analyzed usage of IS_ERR_VALUE using coccinelle and in about 35
cases it is used incorrectly, ie it can hide errors depending of 32/64 bit
architecture.  Instead of fixing usage I propose to enhance the macro to
cover more types.

And just for the record: the macro is used 101 times with signed
variables, I am not sure if it should be preferred over simple comparison
"ret < 0", but the new version can do it as well.

And below list of detected potential errors:
drivers/char/mem.c:698:45-46: WARNING: incorrect argument type in IS_ERR_VALUE(( unsigned long long ) offset)
drivers/media/platform/soc_camera/atmel-isi.c:1089:21-22: WARNING: incorrect argument type in IS_ERR_VALUE(irq)
drivers/net/ethernet/freescale/fs_enet/mac-scc.c:149:36-37: WARNING: incorrect argument type in IS_ERR_VALUE(fep -> ring_mem_addr)
drivers/net/ethernet/freescale/ucc_geth.c:2237:48-49: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> tx_bd_ring_offset [ j ])
drivers/net/ethernet/freescale/ucc_geth.c:2314:48-49: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> rx_bd_ring_offset [ j ])
drivers/net/ethernet/freescale/ucc_geth.c:2524:44-45: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> tx_glbl_pram_offset)
drivers/net/ethernet/freescale/ucc_geth.c:2544:45-46: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> thread_dat_tx_offset)
drivers/net/ethernet/freescale/ucc_geth.c:2571:46-47: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> send_q_mem_reg_offset)
drivers/net/ethernet/freescale/ucc_geth.c:2612:42-43: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> scheduler_offset)
drivers/net/ethernet/freescale/ucc_geth.c:2659:54-55: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> tx_fw_statistics_pram_offset)
drivers/net/ethernet/freescale/ucc_geth.c:2696:44-45: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> rx_glbl_pram_offset)
drivers/net/ethernet/freescale/ucc_geth.c:2715:45-46: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> thread_dat_rx_offset)
drivers/net/ethernet/freescale/ucc_geth.c:2736:54-55: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> rx_fw_statistics_pram_offset)
drivers/net/ethernet/freescale/ucc_geth.c:2756:53-54: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> rx_irq_coalescing_tbl_offset)
drivers/net/ethernet/freescale/ucc_geth.c:2822:44-45: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> rx_bd_qs_tbl_offset)
drivers/net/ethernet/freescale/ucc_geth.c:2908:47-48: WARNING: incorrect argument type in IS_ERR_VALUE(ugeth -> exf_glbl_param_offset)
drivers/net/ethernet/freescale/ucc_geth.c:292:36-37: WARNING: incorrect argument type in IS_ERR_VALUE(init_enet_offset)
drivers/net/ethernet/freescale/ucc_geth.c:3042:39-40: WARNING: incorrect argument type in IS_ERR_VALUE(init_enet_pram_offset)
drivers/soc/fsl/qe/ucc_fast.c:271:60-61: WARNING: incorrect argument type in IS_ERR_VALUE(uccf -> ucc_fast_tx_virtual_fifo_base_offset)
drivers/soc/fsl/qe/ucc_fast.c:284:60-61: WARNING: incorrect argument type in IS_ERR_VALUE(uccf -> ucc_fast_rx_virtual_fifo_base_offset)
drivers/soc/fsl/qe/ucc_slow.c:186:38-39: WARNING: incorrect argument type in IS_ERR_VALUE(uccs -> us_pram_offset)
drivers/soc/fsl/qe/ucc_slow.c:213:38-39: WARNING: incorrect argument type in IS_ERR_VALUE(uccs -> rx_base_offset)
drivers/soc/fsl/qe/ucc_slow.c:224:38-39: WARNING: incorrect argument type in IS_ERR_VALUE(uccs -> tx_base_offset)
drivers/tty/serial/clps711x.c:471:29-30: WARNING: incorrect argument type in IS_ERR_VALUE(s -> port . irq)
drivers/tty/serial/digicolor-usart.c:485:30-31: WARNING: incorrect argument type in IS_ERR_VALUE(dp -> port . irq)
drivers/usb/gadget/udc/fsl_qe_udc.c:2369:26-27: WARNING: incorrect argument type in IS_ERR_VALUE(tmp_addr)
drivers/video/fbdev/exynos/exynos_mipi_dsi.c:406:27-28: WARNING: incorrect argument type in IS_ERR_VALUE(dsim -> irq)
net/ipv4/netfilter/arp_tables.c:1427:39-40: WARNING: incorrect argument type in IS_ERR_VALUE(iter1 -> counters . pcnt)
net/ipv4/netfilter/arp_tables.c:530:34-35: WARNING: incorrect argument type in IS_ERR_VALUE(e -> counters . pcnt)
net/ipv4/netfilter/ip_tables.c:1614:34-35: WARNING: incorrect argument type in IS_ERR_VALUE(e -> counters . pcnt)
net/ipv4/netfilter/ip_tables.c:674:34-35: WARNING: incorrect argument type in IS_ERR_VALUE(e -> counters . pcnt)
net/ipv6/netfilter/ip6_tables.c:1624:34-35: WARNING: incorrect argument type in IS_ERR_VALUE(e -> counters . pcnt)
net/ipv6/netfilter/ip6_tables.c:687:34-35: WARNING: incorrect argument type in IS_ERR_VALUE(e -> counters . pcnt)
drivers/net/ethernet/freescale/fs_enet/mac-fcc.c:110:35-36: WARNING: unknown argument type in IS_ERR_VALUE(fpi -> dpram_offset)

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/err.h~errh-allow-is_err_value-to-handle-properly-more-types include/linux/err.h
--- a/include/linux/err.h~errh-allow-is_err_value-to-handle-properly-more-types
+++ a/include/linux/err.h
@@ -18,7 +18,9 @@
 
 #ifndef __ASSEMBLY__
 
-#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
+#define IS_ERR_VALUE(x) ((typeof(x))(-1) <= 0 \
+				? unlikely((x) <= -1) \
+				: unlikely((x) >= (typeof(x))-MAX_ERRNO))
 
 static inline void * __must_check ERR_PTR(long error)
 {
_

Patches currently in -mm which might be from a.hajda@samsung.com are

errh-allow-is_err_value-to-handle-properly-more-types.patch


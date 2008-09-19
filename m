From: akpm@linux-foundation.org
Subject: - serial-make-uart_ports-ioport-unsigned-long.patch removed from -mm tree
Date: Fri, 19 Sep 2008 15:06:38 -0700
Message-ID: <200809192206.m8JM6cgP008841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbYISWGz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 18:06:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, alan@lxorguk.ukuu.org.uk, joy@entuzijast.net, mm-commits@vger.kernel.org


The patch titled
     serial: make uart_port's ioport "unsigned long"
has been removed from the -mm tree.  Its filename was
     serial-make-uart_ports-ioport-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: make uart_port's ioport "unsigned long"
From: David Miller <davem@davemloft.net>

Otherwise the top 32-bits of the resource value get chopped off on 64-bit
systems, and the resulting I/O accesses go to random places.

Thanks to testing and debugging by Josip Rodin, which helped track this
down.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Josip Rodin <joy@entuzijast.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/serial_core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/serial_core.h~serial-make-uart_ports-ioport-unsigned-long include/linux/serial_core.h
--- a/include/linux/serial_core.h~serial-make-uart_ports-ioport-unsigned-long
+++ a/include/linux/serial_core.h
@@ -241,7 +241,7 @@ typedef unsigned int __bitwise__ upf_t;
 
 struct uart_port {
 	spinlock_t		lock;			/* port lock */
-	unsigned int		iobase;			/* in/out[bwl] */
+	unsigned long		iobase;			/* in/out[bwl] */
 	unsigned char __iomem	*membase;		/* read/write[bwl] */
 	unsigned int		irq;			/* irq number */
 	unsigned int		uartclk;		/* base uart clock */
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
sys_paccept-disable-paccept-until-api-design-is-resolved.patch
linux-next.patch
configure-out-igmp-support.patch
drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
sunrpc-do-not-pin-sunrpc-module-in-the-memory.patch
drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch
drivers-net-mlx4-allocc-needs-mmh.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
compat-generic-compat-get-settimeofday.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
sparc64-use-iommu_num_pages-function-in-iommu-code.patch
serial-make-uart_ports-ioport-unsigned-long-fix.patch
serial-allow-8250-to-be-used-on-sparc.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
radeonfb-misc-cleanup-of-engine-and-dst-cache-handling.patch
radeonfb-accelerate-imageblit-and-other-improvements.patch
sysctl-simplify-strategy.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch


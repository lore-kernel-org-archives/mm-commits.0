From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-impl?=
 =?US-ASCII?Q?ementation.patch?= added to -mm tree
Date: Thu, 09 Jul 2020 17:33:38 -0700
Message-ID: <20200710003338.nDTsYk8aM%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgGJAdk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 20:33:40 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: allenbh@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, dalias@libc.org, dave.jiang@intel.com, davem@davemloft.net, deller@gmx.de, geert+renesas@glider.be, geert@linux-m68k.org, ink@jurassic.park.msu.ru, James.Bottomley@HansenPartnership.com, jasowang@redhat.com, jdmason@kudzu.us, krzk@kernel.org, kuba@kernel.org, kvalo@codeaurora.org, mattst88@gmail.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com, paulus@samba.org, rth@twiddle.net, ysato@users.sourceforge.jp


The patch titled
     Subject: ntb: intel: constify ioreadX() iomem argument (as in generic implementation)
has been added to the -mm tree.  Its filename is
     ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: ntb: intel: constify ioreadX() iomem argument (as in generic implementation)

The ioreadX() helpers have inconsistent interface.  On some architectures
void *__iomem address argument is a pointer to const, on some not.

Implementations of ioreadX() do not modify the memory under the address so
they can be converted to a "const" version for const-safety and
consistency among architectures.

Link: http://lkml.kernel.org/r/20200709072837.5869-4-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Cc: Allen Hubbe <allenbh@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jon Mason <jdmason@kudzu.us>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ntb/hw/intel/ntb_hw_gen1.c  |    2 +-
 drivers/ntb/hw/intel/ntb_hw_gen3.h  |    2 +-
 drivers/ntb/hw/intel/ntb_hw_intel.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/ntb/hw/intel/ntb_hw_gen1.c~ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation
+++ a/drivers/ntb/hw/intel/ntb_hw_gen1.c
@@ -1205,7 +1205,7 @@ int intel_ntb_peer_spad_write(struct ntb
 			       ndev->peer_reg->spad);
 }
 
-static u64 xeon_db_ioread(void __iomem *mmio)
+static u64 xeon_db_ioread(const void __iomem *mmio)
 {
 	return (u64)ioread16(mmio);
 }
--- a/drivers/ntb/hw/intel/ntb_hw_gen3.h~ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation
+++ a/drivers/ntb/hw/intel/ntb_hw_gen3.h
@@ -91,7 +91,7 @@
 #define GEN3_DB_TOTAL_SHIFT		33
 #define GEN3_SPAD_COUNT			16
 
-static inline u64 gen3_db_ioread(void __iomem *mmio)
+static inline u64 gen3_db_ioread(const void __iomem *mmio)
 {
 	return ioread64(mmio);
 }
--- a/drivers/ntb/hw/intel/ntb_hw_intel.h~ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation
+++ a/drivers/ntb/hw/intel/ntb_hw_intel.h
@@ -103,7 +103,7 @@ struct intel_ntb_dev;
 struct intel_ntb_reg {
 	int (*poll_link)(struct intel_ntb_dev *ndev);
 	int (*link_is_up)(struct intel_ntb_dev *ndev);
-	u64 (*db_ioread)(void __iomem *mmio);
+	u64 (*db_ioread)(const void __iomem *mmio);
 	void (*db_iowrite)(u64 db_bits, void __iomem *mmio);
 	unsigned long			ntb_ctl;
 	resource_size_t			db_size;
_

Patches currently in -mm which might be from krzk@kernel.org are

iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
rtl818x-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch

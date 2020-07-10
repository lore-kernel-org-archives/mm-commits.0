From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-?=
 =?US-ASCII?Q?implementation.patch?= added to -mm tree
Date: Thu, 09 Jul 2020 17:33:42 -0700
Message-ID: <20200710003342.nOxyLwrV4%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgGJAdo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 20:33:44 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: allenbh@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, dalias@libc.org, dave.jiang@intel.com, davem@davemloft.net, deller@gmx.de, geert+renesas@glider.be, geert@linux-m68k.org, ink@jurassic.park.msu.ru, James.Bottomley@HansenPartnership.com, jasowang@redhat.com, jdmason@kudzu.us, krzk@kernel.org, kuba@kernel.org, kvalo@codeaurora.org, mattst88@gmail.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com, paulus@samba.org, rth@twiddle.net, ysato@users.sourceforge.jp


The patch titled
     Subject: virtio: pci: constify ioreadX() iomem argument (as in generic implementation)
has been added to the -mm tree.  Its filename is
     virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch

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
Subject: virtio: pci: constify ioreadX() iomem argument (as in generic implementation)

The ioreadX() helpers have inconsistent interface.  On some architectures
void *__iomem address argument is a pointer to const, on some not.

Implementations of ioreadX() do not modify the memory under the address so
they can be converted to a "const" version for const-safety and
consistency among architectures.

Link: http://lkml.kernel.org/r/20200709072837.5869-5-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Allen Hubbe <allenbh@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Jiang <dave.jiang@intel.com>
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

 drivers/virtio/virtio_pci_modern.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/virtio/virtio_pci_modern.c~virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation
+++ a/drivers/virtio/virtio_pci_modern.c
@@ -27,16 +27,16 @@
  * method, i.e. 32-bit accesses for 32-bit fields, 16-bit accesses
  * for 16-bit fields and 8-bit accesses for 8-bit fields.
  */
-static inline u8 vp_ioread8(u8 __iomem *addr)
+static inline u8 vp_ioread8(const u8 __iomem *addr)
 {
 	return ioread8(addr);
 }
-static inline u16 vp_ioread16 (__le16 __iomem *addr)
+static inline u16 vp_ioread16 (const __le16 __iomem *addr)
 {
 	return ioread16(addr);
 }
 
-static inline u32 vp_ioread32(__le32 __iomem *addr)
+static inline u32 vp_ioread32(const __le32 __iomem *addr)
 {
 	return ioread32(addr);
 }
_

Patches currently in -mm which might be from krzk@kernel.org are

iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
rtl818x-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch

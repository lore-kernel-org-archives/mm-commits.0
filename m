Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0BD2C433E3
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A051F207DE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790493;
	bh=2oPW9NaFSdnxptDubxIxrFzivnSPbhX1CrFVhGrTxBg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0psqvCpcKu5RB6Cgu1V1J+/feCp+pRhmsIatzyrt1ezq0sGhNnOf83Nzn6midYiaC
	 zo0YOfJlhvbif2mUhFRAI3aaKoutC9njArA6PLKs48u3BfgNC3h5CVHJC0l4jvKveR
	 DmtB+JefjNTewYxzHzIt6eglyQrR3eu5XQoC7NHU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgHRWld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbgHRWld (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:41:33 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC91720786;
        Tue, 18 Aug 2020 22:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790492;
        bh=2oPW9NaFSdnxptDubxIxrFzivnSPbhX1CrFVhGrTxBg=;
        h=Date:From:To:Subject:From;
        b=dyCMGYoCkn4h0uGa9IdFIe7P6asA+r3NC8VsgX17cfg7GluNPrBcU4LOnw6Ragk7n
         jPHhMEVXf3kLXvLtT7fdz72urYSHtbcGvWwsRX0xUstpmMsqTS3ZkQoi3KfcMzts7/
         nYu902TUzWB5URve4sRg0jNqTBJwFpGwnbPXJCo8=
Date:   Tue, 18 Aug 2020 15:41:31 -0700
From:   akpm@linux-foundation.org
To:     allenbh@gmail.com, arnd@arndb.de, benh@kernel.crashing.org,
        dalias@libc.org, dave.jiang@intel.com, davem@davemloft.net,
        deller@gmx.de, geert+renesas@glider.be, geert@linux-m68k.org,
        ink@jurassic.park.msu.ru, James.Bottomley@HansenPartnership.com,
        jasowang@redhat.com, jdmason@kudzu.us, krzk@kernel.org,
        kuba@kernel.org, kvalo@codeaurora.org, mattst88@gmail.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com,
        paulus@samba.org, rth@twiddle.net, ysato@users.sourceforge.jp
Subject:  [merged]
 =?US-ASCII?Q?virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-?=
 =?US-ASCII?Q?implementation.patch?= removed from -mm tree
Message-ID: <20200818224131.rayd862Yl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio: pci: constify ioreadX() iomem argument (as in generic implementation)
has been removed from the -mm tree.  Its filename was
     virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA89C433E5
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9FBD20658
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529478;
	bh=i+nyD7xd9VyyeoEpf2iFCSOJNPJOk0blUhiLaBmHq2o=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Bw3AUD41nKPZnac3jb0SsuH6ukZyFGk2oEBprUqvPe4Hyz9oDYZKct6+NwEJkHnTp
	 XdDvXVoaPGMoElWZG0C/Fo73bVOG84wQaxtcb0IzBuCCYmOgccHljocsqn07YyQEXm
	 6xLKajLWtT4gZjtwMD16PYItwsbvRxCA5ODtrmdc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbgHOWKb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729292AbgHOWK3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 307F522D75;
        Sat, 15 Aug 2020 00:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451542;
        bh=i+nyD7xd9VyyeoEpf2iFCSOJNPJOk0blUhiLaBmHq2o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=p3ltblVoHHUhnCha58EuSDVKlFQPbdPlxSf/Q/nH/+s6TkzXT/shEw82v2YmIYbfv
         MAmUKjPbZRWks4NDAf/4TriknrQnoCuFs/S9UCsAmrHNjp9GJzlwCJrOMi4OdQmrpw
         +z0JTU4uispRcuP4++yJVGFc+24nqCbClhWkGYqE=
Date:   Fri, 14 Aug 2020 17:32:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, allenbh@gmail.com, arnd@arndb.de,
        benh@kernel.crashing.org, dalias@libc.org, dave.jiang@intel.com,
        davem@davemloft.net, deller@gmx.de, geert+renesas@glider.be,
        geert@linux-m68k.org, ink@jurassic.park.msu.ru,
        James.Bottomley@HansenPartnership.com, jasowang@redhat.com,
        jdmason@kudzu.us, krzk@kernel.org, kuba@kernel.org,
        kvalo@codeaurora.org, linux-mm@kvack.org, mattst88@gmail.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com,
        paulus@samba.org, rth@twiddle.net, torvalds@linux-foundation.org,
        ysato@users.sourceforge.jp
Subject:  [patch 39/39] virtio: pci: constify ioreadX() iomem
 argument (as in generic implementation)
Message-ID: <20200815003220.Ss739d0Ak%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

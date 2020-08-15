Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9053CC433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D45C2065C
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529478;
	bh=7KO4+EkIJ2AUj7695q0cFr2Xbpx7P4vYy8PKnB4dm8U=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=OnowgZsiNLWWwrB2LFFMW2qhMwzv9hYf5aAnUJUsbxg5qVmitW8DN7fr4oyK+rcSK
	 vp5SFCltBR8lHJsgtVuFs/TfjFOWjMBsxPpM+zEwcCrzAd+tcHAaCc8QOs1PmuqdFW
	 fY7xGeiNjjhFGugKOic+DbJ9okV3htG7XZDwEelI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgHOWLF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729494AbgHOWKb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4556022D70;
        Sat, 15 Aug 2020 00:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451537;
        bh=7KO4+EkIJ2AUj7695q0cFr2Xbpx7P4vYy8PKnB4dm8U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jtfn1U7Wu/y7EB4Y0D2zdmOkqQ7VwG8i3pa0nhRpxP/RdIkECHaxNzA8rWyOwPCGT
         pZNg2dvrVQtQRknhGOQtG4Q4vUjGWiyyRNQXqjfN3BD1Z5Dt4mh7mN2HyeBm0sRwF9
         X7/HrXNcPDEh4Zj6NhlR5/xBhFtAY9+oGGJV8cgc=
Date:   Fri, 14 Aug 2020 17:32:15 -0700
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
Subject:  [patch 38/39] ntb: intel: constify ioreadX() iomem
 argument (as in generic implementation)
Message-ID: <20200815003215.t6wUvyo7W%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E14C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F5A720789
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790493;
	bh=wOyLXlAY4XS4kePwQ7vqKkm/1HS1vIvJ0ptyz+8zPJg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=kKLw3sKMQx/17ex3ddTXPfh810u8mk6qW6KGq07+BBJypuAmYDOkLltl2TAf5w5Eo
	 liE/2ODWqJH/4ZpUWWFkQ+INdxLXNIg0AWol9EUfHrJEgNvR5SIwgPjafXYDCBVEor
	 sbXd8lytQQttF6pKV3nR4G9UYxiH0kKQUg2gCiPw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgHRWld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgHRWla (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:41:30 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4D0720674;
        Tue, 18 Aug 2020 22:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790489;
        bh=wOyLXlAY4XS4kePwQ7vqKkm/1HS1vIvJ0ptyz+8zPJg=;
        h=Date:From:To:Subject:From;
        b=KDk6cRn0+ZirKbq4CqjKAc5+20+xWX5AUXq7ugy05Gys/YwqDV/DJC30wbrKWChpR
         6kHLOxUUJ3YbycVYzaWzisv9kJ4TaNOjxbf1FzImZ4ADtpbp1KNSzVKGmNl0Dw0xpx
         DrjYMRqjTeVyMy09N51ppgU8Wod//PxPta2lsdtg=
Date:   Tue, 18 Aug 2020 15:41:28 -0700
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
 =?US-ASCII?Q?ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-impl?=
 =?US-ASCII?Q?ementation.patch?= removed from -mm tree
Message-ID: <20200818224128.n0U73Gyo4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntb: intel: constify ioreadX() iomem argument (as in generic implementation)
has been removed from the -mm tree.  Its filename was
     ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



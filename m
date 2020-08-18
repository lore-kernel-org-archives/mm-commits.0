Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F27C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4DC7207DA
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790489;
	bh=hCKQtSnqPn+B2ydZzwNCAVfhUINh016gPD6eGGB4rlM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ObMsuAhVupb7YDO1EUtp2ULzDjJAs048BlH80541Trcr/cBIUReyPJ2W8J7kwaKYy
	 6hanc+OLH7iMHL5+9oYrZBh0yNuRbP09pjTicmL01OJVDLc1AKgVABwjt2VsVayJBo
	 OGj0xllhPMYX8LUPamY5oY0XlhsShPQva98D3CEQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgHRWl3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgHRWl1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:41:27 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEB8E207BB;
        Tue, 18 Aug 2020 22:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790486;
        bh=hCKQtSnqPn+B2ydZzwNCAVfhUINh016gPD6eGGB4rlM=;
        h=Date:From:To:Subject:From;
        b=pTfWFf/6xh+0AgkWKMOQL2q2JcJ4IRkk71rhUF/ciCH+PueKCDdQdiXuWEr+Np62b
         DwRVyvhLWwB0iZwXjQuHPdcY6o+ASNWt9W/U6mvSuZ+JUIOBl5bFOnJMuJ+NTjC8px
         rpRIGUSYnfhfnDotkC5a6acIF5yrtZlIV6zqXiNM=
Date:   Tue, 18 Aug 2020 15:41:25 -0700
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
 rtl818x-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
 removed from -mm tree
Message-ID: <20200818224125.n4GQLhhpQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rtl818x: constify ioreadX() iomem argument (as in generic implementation)
has been removed from the -mm tree.  Its filename was
     rtl818x-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: rtl818x: constify ioreadX() iomem argument (as in generic implementation)

The ioreadX() helpers have inconsistent interface.  On some architectures
void *__iomem address argument is a pointer to const, on some not.

Implementations of ioreadX() do not modify the memory under the address so
they can be converted to a "const" version for const-safety and
consistency among architectures.

Link: http://lkml.kernel.org/r/20200709072837.5869-3-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
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
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8180.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8180.h~rtl818x-constify-ioreadx-iomem-argument-as-in-generic-implementation
+++ a/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8180.h
@@ -150,17 +150,17 @@ void rtl8180_write_phy(struct ieee80211_
 void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam);
 void rtl8180_set_anaparam2(struct rtl8180_priv *priv, u32 anaparam2);
 
-static inline u8 rtl818x_ioread8(struct rtl8180_priv *priv, u8 __iomem *addr)
+static inline u8 rtl818x_ioread8(struct rtl8180_priv *priv, const u8 __iomem *addr)
 {
 	return ioread8(addr);
 }
 
-static inline u16 rtl818x_ioread16(struct rtl8180_priv *priv, __le16 __iomem *addr)
+static inline u16 rtl818x_ioread16(struct rtl8180_priv *priv, const __le16 __iomem *addr)
 {
 	return ioread16(addr);
 }
 
-static inline u32 rtl818x_ioread32(struct rtl8180_priv *priv, __le32 __iomem *addr)
+static inline u32 rtl818x_ioread32(struct rtl8180_priv *priv, const __le32 __iomem *addr)
 {
 	return ioread32(addr);
 }
_

Patches currently in -mm which might be from krzk@kernel.org are



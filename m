Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1BDC433E3
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44A0E20774
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529463;
	bh=1XcmYHKVaP7Fh5Cla3P5RL1yXeio0QYHdzOkbdJ7R0E=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=LihM5mj0cUnBVwaw96R+p/k7D7HgUBQcojsLysthWXRKOeJ+Ju7k5OapVHgkQDl/b
	 Pg40Gr8RpkW8FFbPo9M6cjAEiGHminR3B4DSxW/eSS2bkw+91lWmCbOl9i2mjeg5af
	 AuV6zta43Z634BrrnZNv9Tyaw00DRUh5e6g9JMgo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgHOWKx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729467AbgHOWKb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AE9322DA7;
        Sat, 15 Aug 2020 00:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451533;
        bh=1XcmYHKVaP7Fh5Cla3P5RL1yXeio0QYHdzOkbdJ7R0E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=17bpltuVBLV6kJlOsOa83xHUUo5YWyro0qeNdfxPvGxHVMNrF14zz6WqMCVDe5Ujq
         gvs27ilBo5mhFgkmjOsmRJGT1jULqK9UG0nBNGu7iFbXkAn3JV4WsotBQTh2R9WWGe
         EyPHekyW2FpC22G97oVURMAT5ork4le2YQ3AdFdU=
Date:   Fri, 14 Aug 2020 17:32:11 -0700
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
Subject:  [patch 37/39] rtl818x: constify ioreadX() iomem argument
 (as in generic implementation)
Message-ID: <20200815003211.5lNPlWdP9%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

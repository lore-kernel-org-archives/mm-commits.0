Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D09AC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 704472080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196036;
	bh=EKEA4pwdWZ5hpTSKkqIaHBuLjcJF511h/S+3ne8ycBY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xMvAqjXA6nlsu92avkrJD+HIDchuz9tRWvRIQNxFbrp4yvz4JDpuzf4bzzQtv2tuJ
	 KuPwLLB1zeUoiWnHihDwO3790VGkpc+aJzPSnhyT0qCWwvtC8yws93nn1dPMkRQR7E
	 TVovnXG9sRm+DxuaCjEarN+ip5UM4M7f21nMfdkA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHLBd4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgHLBdz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9919B2076C;
        Wed, 12 Aug 2020 01:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196035;
        bh=EKEA4pwdWZ5hpTSKkqIaHBuLjcJF511h/S+3ne8ycBY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=J0roobCiWgKfasg4BV995+IgJgKvSyvK4HXpRvvZGCRktUHGCI8uSWKIYYdQE/nhN
         sfGbq8H9w0iKrg77IthZmLHRobQo4k7rPoxdT+OJireAd/QW3fuEdBnB2qppXnNpKo
         pzAp2+OYsDXJ694Ymqw1qX+QxdzFbnbKCdU3UIe8=
Date:   Tue, 11 Aug 2020 18:33:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, ink@jurassic.park.msu.ru,
        linux-mm@kvack.org, lkp@intel.com, luc.vanoostenryck@gmail.com,
        mattst88@gmail.com, mm-commits@vger.kernel.org, rth@twiddle.net,
        sboyd@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 069/165] alpha: fix annotation of
 io{read,write}{16,32}be()
Message-ID: <20200812013354.U9pSdlJwk%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: alpha: fix annotation of io{read,write}{16,32}be()

These accessors must be used to read/write a big-endian bus.  The value
returned or written is native-endian.

However, these accessors are defined using be{16,32}_to_cpu() or
cpu_to_be{16,32}() to make the endian conversion but these expect a
__be{16,32} when none is present.  Keeping them would need a force cast
that would solve nothing at all.

So, do the conversion using swab{16,32}, like done in asm-generic for
similar situations.

Link: http://lkml.kernel.org/r/20200622114232.80039-1-luc.vanoostenryck@gmail.com
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/io.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/alpha/include/asm/io.h~fix-annotation-of-ioreadwrite1632be
+++ a/arch/alpha/include/asm/io.h
@@ -489,10 +489,10 @@ extern inline void writeq(u64 b, volatil
 }
 #endif
 
-#define ioread16be(p) be16_to_cpu(ioread16(p))
-#define ioread32be(p) be32_to_cpu(ioread32(p))
-#define iowrite16be(v,p) iowrite16(cpu_to_be16(v), (p))
-#define iowrite32be(v,p) iowrite32(cpu_to_be32(v), (p))
+#define ioread16be(p) swab16(ioread16(p))
+#define ioread32be(p) swab32(ioread32(p))
+#define iowrite16be(v,p) iowrite16(swab16(v), (p))
+#define iowrite32be(v,p) iowrite32(swab32(v), (p))
 
 #define inb_p		inb
 #define inw_p		inw
_

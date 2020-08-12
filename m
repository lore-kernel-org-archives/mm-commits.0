Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961D7C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A7A720774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266213;
	bh=NkYLZZBElQv6pJh4/HGQSz6sWhdoAUgaGY/xm5AZ4ws=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=txc5bH4c+ppkdztMtIJBTpL9Zeg2mLbNj+b/v//i0ZEOCAKBb0QJdQmj1RYzWa/Su
	 twPd/45qKPKlsddZy49SbKMK0ks+p1LAz/ovySvn/R4vRx8aSNKShQPMC+h68C1Evo
	 sHW1RYH+W6zsFwXBYBVfmDN+KrX+RV82yZF2cP7Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgHLVDc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbgHLVDb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:31 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8765420774;
        Wed, 12 Aug 2020 21:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266210;
        bh=NkYLZZBElQv6pJh4/HGQSz6sWhdoAUgaGY/xm5AZ4ws=;
        h=Date:From:To:Subject:From;
        b=pX+OlDovhH0vG1p81WvyVLOZ7OfK2jEeZgBwOxOJSz72yvFt/PJG4aH2STNvbFlo8
         /9xDqR2MbSbUA1eu1UIxU6TRHrrzDclNYCJqgDrWEMGmVp6inutoJ9U4093CFHb9PW
         638DxAYoevgg726VhZQ3PRGrwOZMKeZN8oUzoRBM=
Date:   Wed, 12 Aug 2020 14:03:30 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, ink@jurassic.park.msu.ru, lkp@intel.com,
        luc.vanoostenryck@gmail.com, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rth@twiddle.net, sboyd@kernel.org
Subject:  [merged] fix-annotation-of-ioreadwrite1632be.patch
 removed from -mm tree
Message-ID: <20200812210330.IW_2H5o9J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: fix annotation of io{read,write}{16,32}be()
has been removed from the -mm tree.  Its filename was
     fix-annotation-of-ioreadwrite1632be.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from luc.vanoostenryck@gmail.com are



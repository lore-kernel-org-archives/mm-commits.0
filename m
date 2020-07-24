Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5376EC433E1
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 00:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CCE0206E3
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 00:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595551083;
	bh=hHVdqKroiefvALzTZgAoJ8j/q2r6mRXTSsGx4zEtLQU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vA9BVRal/OgcVf3M306jq1MjByUFufYca7DnMrY74DY9rjxoYSARST4Pzw+wtnWEW
	 0dAzZAlbiqg7cMIdoJMwEBsU/IpzSbkK8mB+r6axirrcQ8ymhwrsZzuSvgjpXvcAQU
	 uF22qFNVolJmsV1lkHUxkQXLsW7/UJ4Cvi/qRZ34=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgGXAiD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 20:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbgGXAiC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 20:38:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BF9B2064B;
        Fri, 24 Jul 2020 00:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595551081;
        bh=hHVdqKroiefvALzTZgAoJ8j/q2r6mRXTSsGx4zEtLQU=;
        h=Date:From:To:Subject:From;
        b=du3Ao6z+wXJHErhsfDzjMldWDAyLBQnndfrvSW6FnyOG8aE2cWODrRypemtx2Wew3
         sSZD6U4G7jL0RoTW+PFDA480yIJAKhVNr7RoycIDbJwDmZcAyiAioStxu6Lzt1v0lW
         mZQKOfnEmNIChMWWHrlFLfBKxuyBadhMhXw/jkEI=
Date:   Thu, 23 Jul 2020 17:38:01 -0700
From:   akpm@linux-foundation.org
To:     dalias@libc.org, geert+renesas@glider.be,
        glaubitz@physik.fu-berlin.de, krzk@kernel.org,
        kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org,
        ysato@users.sourceforge.jp
Subject:  +
 =?US-ASCII?Q?iomap-constify-ioreadx-iomem-argument-as-in-generic-implemen?=
 =?US-ASCII?Q?tation-fix.patch?= added to -mm tree
Message-ID: <20200724003801.sjXZaLFc3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: clk: fix assignment from incompatible pointer type for ioreadX()
has been added to the -mm tree.  Its filename is
     iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix.patch

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
Subject: sh: clk: fix assignment from incompatible pointer type for ioreadX()

The ioreadX() helpers accept now pointer to const memory so declaration
of read function needs updating.

This fixes build errors like:

    drivers/sh/clk/cpg.c: In function `sh_clk_mstp_enable':
    drivers/sh/clk/cpg.c:49:9: error: assignment from incompatible pointer type [-Werror=incompatible-pointer-types]
        read = ioread8;

Link: http://lkml.kernel.org/r/20200723082017.24053-1-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sh/clk/cpg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/sh/clk/cpg.c~iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix
+++ a/drivers/sh/clk/cpg.c
@@ -40,7 +40,7 @@ static int sh_clk_mstp_enable(struct clk
 {
 	sh_clk_write(sh_clk_read(clk) & ~(1 << clk->enable_bit), clk);
 	if (clk->status_reg) {
-		unsigned int (*read)(void __iomem *addr);
+		unsigned int (*read)(const void __iomem *addr);
 		int i;
 		void __iomem *mapped_status = (phys_addr_t)clk->status_reg -
 			(phys_addr_t)clk->enable_reg + clk->mapped_reg;
_

Patches currently in -mm which might be from krzk@kernel.org are

iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix.patch
rtl818x-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch


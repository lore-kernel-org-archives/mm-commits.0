Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227D0C433E4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 02:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E292D207DF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 02:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595557510;
	bh=S/CXM2iWzDCaqy1s0f2hCQcXCeZPDLWhTtgsHvKuK48=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xzfNfGZ+0x+CSTR410rd1P9j/pVDHo5AFt5Gtmk3XGd6FTyAaCywbSCqmmlG87nYF
	 ++I3lOEO6yCElWGhvgiJrsg1Rem+bsU75tqo20/YdP9+DQeGhcgPvveHSFoMa3jIjZ
	 8lA15jcuvqavv2UshQfF6yugMckBSiHbCCdqmITs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgGXCZJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 22:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbgGXCZJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 22:25:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9EC20737;
        Fri, 24 Jul 2020 02:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595557509;
        bh=S/CXM2iWzDCaqy1s0f2hCQcXCeZPDLWhTtgsHvKuK48=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GCpL13HY0s2F4gulvX7XT2BAeTp7l6Kc7rmy57R4up2kaHaR6FLtE4ksQNjQ6dZ4k
         WhoeEBDikIhAdGI5wPjppDtg0kVjb0C+nsdrQSALkwNgX/7WLqUtT5QdYe/w2ZAZZg
         AI1d8496SWtAM1+NlgDymWajdIKbzIg5wAgNO4VQ=
Date:   Thu, 23 Jul 2020 19:25:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com,
        dalias@libc.org, geert+renesas@glider.be,
        glaubitz@physik.fu-berlin.de, krzk@kernel.org,
        kuninori.morimoto.gx@renesas.com, linux@roeck-us.net,
        mm-commits@vger.kernel.org, romain.naour@gmail.com,
        sam@ravnborg.org, ysato@users.sourceforge.jp
Subject:  [merged] sh-add-missing-export_symbol-for-__delay.patch
 removed from -mm tree
Message-ID: <20200724022508.6icnfiFcg%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: add missing EXPORT_SYMBOL() for __delay
has been removed from the -mm tree.  Its filename was
     sh-add-missing-export_symbol-for-__delay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: morimoto <kuninori.morimoto.gx@renesas.com>
Subject: sh: add missing EXPORT_SYMBOL() for __delay

__delay() is used from kernel module.  We need EXPORT_SYMBOL(), otherwise
we will get compile error.

ERROR: "__delay" [drivers/net/phy/mdio-cavium.ko] undefined!

Link: https://marc.info/?l=linux-kernel&m=157611811927852
Signed-off-by: morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Romain Naour <romain.naour@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/lib/delay.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sh/lib/delay.c~sh-add-missing-export_symbol-for-__delay
+++ a/arch/sh/lib/delay.c
@@ -41,6 +41,7 @@ inline void __const_udelay(unsigned long
 		: "macl", "mach");
 	__delay(++xloops);
 }
+EXPORT_SYMBOL(__delay);
 
 void __udelay(unsigned long usecs)
 {
_

Patches currently in -mm which might be from kuninori.morimoto.gx@renesas.com are

sh-clkfwk-remove-r8-r16-r32.patch
sh-use-generic-strncpy.patch


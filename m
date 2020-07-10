Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E005AC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 20:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B69DC2077D
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 20:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594413079;
	bh=+yenj5okVreKa2vV4lhWwC/xmLlr2l2nG/UfiH2L5P0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=p75wC4mbscI91d6D3foikZ6sROAFGvt9wg6L9P2eiXTSwgm1kZVk7Sww3s/drR9B5
	 kx3ZZjLuG0ILaT3Z6snUzUKuTCDO5dVB1F450tJ8cr8NTLC03rmRFyi4K7pFEiF+Un
	 buirUl5HyQmZvcZ1XP1HU1NmMApLlJVAI79ElgJg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGJUbT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 16:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgGJUbS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 16:31:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 233E520748;
        Fri, 10 Jul 2020 20:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594413078;
        bh=+yenj5okVreKa2vV4lhWwC/xmLlr2l2nG/UfiH2L5P0=;
        h=Date:From:To:Subject:From;
        b=jEOvtS1kNBI/F4DlZkyn8yCyDWbHGbz0+4JZdAYDD+mDJz+CtWxyEjoNxlNzQvmfL
         wqBp+VvEy807ti3j6b+XgEU0uVL2zWo84pHlCGNy12o8DIz3c866KyFNhyPnJDJLuk
         9ANJKK/+UuhVHloeFpePfC6SKqBfXeexVdesIGiY=
Date:   Fri, 10 Jul 2020 13:31:17 -0700
From:   akpm@linux-foundation.org
To:     andy.shevchenko@gmail.com, arnd@arndb.de, emil.l.velikov@gmail.com,
        geert@linux-m68k.org, keescook@chromium.org,
        linus.walleij@linaro.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, rikard.falkeborn@gmail.com,
        syednwaris@gmail.com, vilhelm.gray@gmail.com,
        yamada.masahiro@socionext.com
Subject:  [merged] kbuild-move-wtype-limits-to-w=2.patch removed
 from -mm tree
Message-ID: <20200710203117.weersaKjS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: move -Wtype-limits to W=2
has been removed from the -mm tree.  Its filename was
     kbuild-move-wtype-limits-to-w=2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: kbuild: move -Wtype-limits to W=2

-Wtype-limits is included in -Wextra which is added at W=1.  It warns
(among other things) that 'comparison of an unsigned variable `< 0` is
always false.  This causes noisy warnings, especially when used in macros,
hence it is more suitable for W=2.

Link: http://lkml.kernel.org/r/20200708190756.16810-1-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Syed Nayyar Waris <syednwaris@gmail.com>
Cc: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <michal.lkml@markovi.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/Makefile.extrawarn~kbuild-move-wtype-limits-to-w=2
+++ a/scripts/Makefile.extrawarn
@@ -35,6 +35,7 @@ KBUILD_CFLAGS += $(call cc-option, -Wstr
 # The following turn off the warnings enabled by -Wextra
 KBUILD_CFLAGS += -Wno-missing-field-initializers
 KBUILD_CFLAGS += -Wno-sign-compare
+KBUILD_CFLAGS += -Wno-type-limits
 
 KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN1
 
@@ -66,6 +67,7 @@ KBUILD_CFLAGS += -Wshadow
 KBUILD_CFLAGS += $(call cc-option, -Wlogical-op)
 KBUILD_CFLAGS += -Wmissing-field-initializers
 KBUILD_CFLAGS += -Wsign-compare
+KBUILD_CFLAGS += -Wtype-limits
 KBUILD_CFLAGS += $(call cc-option, -Wmaybe-uninitialized)
 KBUILD_CFLAGS += $(call cc-option, -Wunused-macros)
 
_

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are

bits-add-tests-of-genmask.patch


Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48341C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24D632078D
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790482;
	bh=528jT62P/nUxbzpHbj1bn8L1vyw2/GJgndcoKupB8zQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LG9Vv0nNBXIxwSfdUnntPAdnJz+jmHxcTPqXcHo6UDsfjSyZlFgDmJJDfc08T/MwI
	 6Dp0r1z7vOgqfr5pESdW47SMWKs3MSpM4T+0HCqFsE1yyxvqcH+MmMFthC9u5iXKcd
	 81bCKzwqQp0zyE08dHyCZQodF7E/6vhwNph57Gak=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgHRWlV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbgHRWlV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:41:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6991820789;
        Tue, 18 Aug 2020 22:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790480;
        bh=528jT62P/nUxbzpHbj1bn8L1vyw2/GJgndcoKupB8zQ=;
        h=Date:From:To:Subject:From;
        b=CduP91ac8EzyLafX9HxC5DAKJZQadl1QRYt1DQUMKaujz340PzLimDkHP9zaR6LBG
         oaDaCNUQ0JzJNEhZFPLWUX6WaLklmBTKrymAhhmUsNRc2PJR28H3g9BEGyI3jfV1IU
         iiUe6iWo5+9TsVZcpUtS4vF0Hc/xIdoq22fG9Th4=
Date:   Tue, 18 Aug 2020 15:41:20 -0700
From:   akpm@linux-foundation.org
To:     amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com,
        dalias@libc.org, geert+renesas@glider.be,
        glaubitz@physik.fu-berlin.de, krzk@kernel.org,
        kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org,
        romain.naour@gmail.com, sam@ravnborg.org,
        ysato@users.sourceforge.jp
Subject:  [merged] sh-use-generic-strncpy.patch removed from -mm
 tree
Message-ID: <20200818224120.B5YV4ejoo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: use generic strncpy()
has been removed from the -mm tree.  Its filename was
     sh-use-generic-strncpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: sh: use generic strncpy()

Current SH will get below warning at strncpy()

In file included from ${LINUX}/arch/sh/include/asm/string.h:3,
                 from ${LINUX}/include/linux/string.h:20,
                 from ${LINUX}/include/linux/bitmap.h:9,
                 from ${LINUX}/include/linux/nodemask.h:95,
                 from ${LINUX}/include/linux/mmzone.h:17,
                 from ${LINUX}/include/linux/gfp.h:6,
                 from ${LINUX}/innclude/linux/slab.h:15,
                 from ${LINUX}/linux/drivers/mmc/host/vub300.c:38:
${LINUX}/drivers/mmc/host/vub300.c: In function 'new_system_port_status':
${LINUX}/arch/sh/include/asm/string_32.h:51:42: warning: array subscript\
  80 is above array bounds of 'char[26]' [-Warray-bounds]
   : "0" (__dest), "1" (__src), "r" (__src+__n)
                                     ~~~~~^~~~

In general, strncpy() should behave like below.

	char dest[10];
	char *src = "12345";

	strncpy(dest, src, 10);
	// dest = {'1', '2', '3', '4', '5',
	           '\0','\0','\0','\0','\0'}

But, current SH strnpy() has 2 issues.
1st is it will access to out-of-memory (= src + 10).
2nd is it needs big fixup for it, and maintenance __asm__
code is difficult.

To solve these issues, this patch simply uses generic strncpy()
instead of architecture specific one.

Link: https://marc.info/?l=linux-renesas-soc&m=157664657013309
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Romain Naour <romain.naour@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/string_32.h |   26 --------------------------
 1 file changed, 26 deletions(-)

--- a/arch/sh/include/asm/string_32.h~sh-use-generic-strncpy
+++ a/arch/sh/include/asm/string_32.h
@@ -28,32 +28,6 @@ static inline char *strcpy(char *__dest,
 	return __xdest;
 }
 
-#define __HAVE_ARCH_STRNCPY
-static inline char *strncpy(char *__dest, const char *__src, size_t __n)
-{
-	register char *__xdest = __dest;
-	unsigned long __dummy;
-
-	if (__n == 0)
-		return __xdest;
-
-	__asm__ __volatile__(
-		"1:\n"
-		"mov.b	@%1+, %2\n\t"
-		"mov.b	%2, @%0\n\t"
-		"cmp/eq	#0, %2\n\t"
-		"bt/s	2f\n\t"
-		" cmp/eq	%5,%1\n\t"
-		"bf/s	1b\n\t"
-		" add	#1, %0\n"
-		"2:"
-		: "=r" (__dest), "=r" (__src), "=&z" (__dummy)
-		: "0" (__dest), "1" (__src), "r" (__src+__n)
-		: "memory", "t");
-
-	return __xdest;
-}
-
 #define __HAVE_ARCH_STRCMP
 static inline int strcmp(const char *__cs, const char *__ct)
 {
_

Patches currently in -mm which might be from kuninori.morimoto.gx@renesas.com are



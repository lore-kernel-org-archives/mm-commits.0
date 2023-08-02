Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD1BC04A94
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 17:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjHBRm4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 13:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjHBRmz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 13:42:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D79AC
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 10:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC673615A2
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 17:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2724FC433C8;
        Wed,  2 Aug 2023 17:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690998170;
        bh=vs5Tr4yKCrjOUWgflfEogeYMyKwKkD4HUEOAFXWoyhc=;
        h=Date:To:From:Subject:From;
        b=jF398/+2cBh6J0TlZ1f+obV4QyUhBQsXxU/96yHMXCwskscTsPnxYvvbDLfsRPGbX
         C1RBYhKtmezxONe4Itepthg/V7k0InPL1XUK0Q0jOVMXwHQkoftdsZYqC0bZ5NerAv
         4ryTm5w4FptvsvAFX8/n2t/Oi87B+cJLW6AfVvNs=
Date:   Wed, 02 Aug 2023 10:42:47 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        linux@roeck-us.net, glaubitz@physik.fu-berlin.de,
        geert@linux-m68k.org, dalias@libc.org, bhe@redhat.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-add-asm-generic-ioh-including-fix.patch added to mm-unstable branch
Message-Id: <20230802174250.2724FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: fix asm-generic/io.h inclusion
has been added to the -mm mm-unstable branch.  Its filename is
     sh-add-asm-generic-ioh-including-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-add-asm-generic-ioh-including-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: sh: fix asm-generic/io.h inclusion
Date: Wed, 2 Aug 2023 16:16:41 +0200

A recent cleanup patch started using the generic asm/io.h header from
the sh version, but unfortunately this caused build regressions in many
configurations, such as:

include/asm-generic/io.h:636:15: error: redefinition of `inb_p'

I added some of the missing defines that are needed to keep using the
sh specific implementations rather than the generic ones where they
clash. I build all sh defconfig files to catch the various combinations
of CONFIG_MMU, CONFIG_GENERIC_IOMAP and CONFIG_NO_IOPORT_MAP, this should
cover them all.

A lot of the sh specific functions are equivalent to the generic ones
and could in fact be removed, but it would be best to only do that with
actual runtime testing.

In particular, the indirect ioport_map() implementation is only used
for the "microdev" platform that appears to be broken beyond repair
for as long as the git history goes, so removing both microdev and the
custom ioport handling in favor of the asm-generic/io.h version would
be a great cleanup, but this can be done another time if anyone feels
motivated to clean up arch/sh.

Link: https://lkml.kernel.org/r/20230802141658.2064864-1-arnd@kernel.org
Fixes: e41f1f7ff6c2b ("sh: add <asm-generic/io.h> including")
Link: https://lore.kernel.org/lkml/09094baf-dadf-4bce-9f63-f2a1f255f9a8@app.fastmail.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/io.h          |   24 ++++++++++++++++++++++++
 arch/sh/include/asm/io_noioport.h |   14 --------------
 2 files changed, 24 insertions(+), 14 deletions(-)

--- a/arch/sh/include/asm/io.h~sh-add-asm-generic-ioh-including-fix
+++ a/arch/sh/include/asm/io.h
@@ -119,6 +119,10 @@ void __raw_readsl(const void __iomem *ad
 
 __BUILD_MEMORY_STRING(__raw_, q, u64)
 
+#define ioport_map ioport_map
+#define ioport_unmap ioport_unmap
+#define pci_iounmap pci_iounmap
+
 #define ioread8 ioread8
 #define ioread16 ioread16
 #define ioread16be ioread16be
@@ -241,6 +245,26 @@ __BUILD_IOPORT_STRING(q, u64)
 
 #endif
 
+#define inb(addr)      inb(addr)
+#define inw(addr)      inw(addr)
+#define inl(addr)      inl(addr)
+#define outb(x, addr)  outb((x), (addr))
+#define outw(x, addr)  outw((x), (addr))
+#define outl(x, addr)  outl((x), (addr))
+
+#define inb_p(addr)    inb(addr)
+#define inw_p(addr)    inw(addr)
+#define inl_p(addr)    inl(addr)
+#define outb_p(x, addr)        outb((x), (addr))
+#define outw_p(x, addr)        outw((x), (addr))
+#define outl_p(x, addr)        outl((x), (addr))
+
+#define insb insb
+#define insw insw
+#define insl insl
+#define outsb outsb
+#define outsw outsw
+#define outsl outsl
 
 #define IO_SPACE_LIMIT 0xffffffff
 
--- a/arch/sh/include/asm/io_noioport.h~sh-add-asm-generic-ioh-including-fix
+++ a/arch/sh/include/asm/io_noioport.h
@@ -46,20 +46,6 @@ static inline void ioport_unmap(void __i
 	BUG();
 }
 
-#define inb_p(addr)	inb(addr)
-#define inw_p(addr)	inw(addr)
-#define inl_p(addr)	inl(addr)
-#define outb_p(x, addr)	outb((x), (addr))
-#define outw_p(x, addr)	outw((x), (addr))
-#define outl_p(x, addr)	outl((x), (addr))
-
-#define insb insb
-#define insw insw
-#define insl insl
-#define outsb outsb
-#define outsw outsw
-#define outsl outsl
-
 static inline void insb(unsigned long port, void *dst, unsigned long count)
 {
 	BUG();
_

Patches currently in -mm which might be from arnd@arndb.de are

sh-add-asm-generic-ioh-including-fix.patch
iomem-remove-__weak-ioremap_cache-helper.patch
gcov-shut-up-missing-prototype-warnings-for-internal-stubs.patch


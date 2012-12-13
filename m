From: akpm@linux-foundation.org
Subject: + asm-generic-io-dont-perform-swab-during-inout-string-functions.patch added to -mm tree
Date: Thu, 13 Dec 2012 14:46:36 -0800
Message-ID: <20121213224637.281AF820062@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:42877 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab2LMWqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Dec 2012 17:46:38 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so277633ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Dec 2012 14:46:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, arnd@arndb.de, benh@kernel.crashing.org, vapier@gentoo.org


The patch titled
     Subject: asm-generic: io: don't perform swab during {in,out} string functions
has been added to the -mm tree.  Its filename is
     asm-generic-io-dont-perform-swab-during-inout-string-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: asm-generic: io: don't perform swab during {in,out} string functions

The {in,out}s{b,w,l} functions are designed to operate on a stream of
bytes and therefore should not perform any byte-swapping, regardless of
the CPU byte order.

This patch fixes the generic IO header so that {in,out}s{b,w,l} call the
__raw_{read,write} functions directly rather than going via the
endian-correcting accessors.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ben Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/io.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/asm-generic/io.h~asm-generic-io-dont-perform-swab-during-inout-string-functions include/asm-generic/io.h
--- a/include/asm-generic/io.h~asm-generic-io-dont-perform-swab-during-inout-string-functions
+++ a/include/asm-generic/io.h
@@ -153,7 +153,7 @@ static inline void insb(unsigned long ad
 	if (count) {
 		u8 *buf = buffer;
 		do {
-			u8 x = inb(addr);
+			u8 x = __raw_readb(addr + PCI_IOBASE);
 			*buf++ = x;
 		} while (--count);
 	}
@@ -166,7 +166,7 @@ static inline void insw(unsigned long ad
 	if (count) {
 		u16 *buf = buffer;
 		do {
-			u16 x = inw(addr);
+			u16 x = __raw_readw(addr + PCI_IOBASE);
 			*buf++ = x;
 		} while (--count);
 	}
@@ -179,7 +179,7 @@ static inline void insl(unsigned long ad
 	if (count) {
 		u32 *buf = buffer;
 		do {
-			u32 x = inl(addr);
+			u32 x = __raw_readl(addr + PCI_IOBASE);
 			*buf++ = x;
 		} while (--count);
 	}
@@ -192,7 +192,7 @@ static inline void outsb(unsigned long a
 	if (count) {
 		const u8 *buf = buffer;
 		do {
-			outb(*buf++, addr);
+			__raw_writeb(*buf++, addr + PCI_IOBASE);
 		} while (--count);
 	}
 }
@@ -204,7 +204,7 @@ static inline void outsw(unsigned long a
 	if (count) {
 		const u16 *buf = buffer;
 		do {
-			outw(*buf++, addr);
+			__raw_writew(*buf++, addr + PCI_IOBASE);
 		} while (--count);
 	}
 }
@@ -216,7 +216,7 @@ static inline void outsl(unsigned long a
 	if (count) {
 		const u32 *buf = buffer;
 		do {
-			outl(*buf++, addr);
+			__raw_writel(*buf++, addr + PCI_IOBASE);
 		} while (--count);
 	}
 }
_

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch
linux-next.patch
asm-generic-io-dont-perform-swab-during-inout-string-functions.patch
mtd-nand-gpio-use-ioreadwrite_rep-accessors.patch
musb-tusb6010-use-ioreadwrite_rep-accessors.patch
usb-musb-use-ioreadwrite_rep-accessors.patch


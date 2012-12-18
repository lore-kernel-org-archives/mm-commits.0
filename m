From: akpm@linux-foundation.org
Subject: [merged] asm-generic-io-dont-perform-swab-during-inout-string-functions.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:03 -0800
Message-ID: <20121218200303.9FB6382004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:45931 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:03:04 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so125227qch.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:03:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, arnd@arndb.de, benh@kernel.crashing.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic: io: don't perform swab during {in,out} string functions
has been removed from the -mm tree.  Its filename was
     asm-generic-io-dont-perform-swab-during-inout-string-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -154,7 +154,7 @@ static inline void insb(unsigned long ad
 	if (count) {
 		u8 *buf = buffer;
 		do {
-			u8 x = inb(addr);
+			u8 x = __raw_readb(addr + PCI_IOBASE);
 			*buf++ = x;
 		} while (--count);
 	}
@@ -167,7 +167,7 @@ static inline void insw(unsigned long ad
 	if (count) {
 		u16 *buf = buffer;
 		do {
-			u16 x = inw(addr);
+			u16 x = __raw_readw(addr + PCI_IOBASE);
 			*buf++ = x;
 		} while (--count);
 	}
@@ -180,7 +180,7 @@ static inline void insl(unsigned long ad
 	if (count) {
 		u32 *buf = buffer;
 		do {
-			u32 x = inl(addr);
+			u32 x = __raw_readl(addr + PCI_IOBASE);
 			*buf++ = x;
 		} while (--count);
 	}
@@ -193,7 +193,7 @@ static inline void outsb(unsigned long a
 	if (count) {
 		const u8 *buf = buffer;
 		do {
-			outb(*buf++, addr);
+			__raw_writeb(*buf++, addr + PCI_IOBASE);
 		} while (--count);
 	}
 }
@@ -205,7 +205,7 @@ static inline void outsw(unsigned long a
 	if (count) {
 		const u16 *buf = buffer;
 		do {
-			outw(*buf++, addr);
+			__raw_writew(*buf++, addr + PCI_IOBASE);
 		} while (--count);
 	}
 }
@@ -217,7 +217,7 @@ static inline void outsl(unsigned long a
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


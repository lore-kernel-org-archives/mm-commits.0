From: akpm@linux-foundation.org
Subject: + asm-generic-ioh-add-big-endian-versions-of-ioreadwrite1632.patch added to -mm tree
Date: Tue, 01 Jun 2010 15:35:04 -0700
Message-ID: <201006012235.o51MZ4a5022872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756528Ab0FAWfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 18:35:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, arnd@arndb.de


The patch titled
     asm-generic/io.h: add big endian versions of io{read,write}{16,32}
has been added to the -mm tree.  Its filename is
     asm-generic-ioh-add-big-endian-versions-of-ioreadwrite1632.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic/io.h: add big endian versions of io{read,write}{16,32}
From: Mike Frysinger <vapier@gentoo.org>

The asm-generic/iomap.h provides these functions already, but the
non-generic fallback defines do not.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/io.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/asm-generic/io.h~asm-generic-ioh-add-big-endian-versions-of-ioreadwrite1632 include/asm-generic/io.h
--- a/include/asm-generic/io.h~asm-generic-ioh-add-big-endian-versions-of-ioreadwrite1632
+++ a/include/asm-generic/io.h
@@ -188,11 +188,15 @@ static inline void outsl(unsigned long a
 #ifndef CONFIG_GENERIC_IOMAP
 #define ioread8(addr)		readb(addr)
 #define ioread16(addr)		readw(addr)
+#define ioread16be(addr)	be16_to_cpu(ioread16(addr))
 #define ioread32(addr)		readl(addr)
+#define ioread32be(addr)	be32_to_cpu(ioread32(addr))
 
 #define iowrite8(v, addr)	writeb((v), (addr))
 #define iowrite16(v, addr)	writew((v), (addr))
+#define iowrite16be(v, addr)	iowrite16(be16_to_cpu(v), (addr))
 #define iowrite32(v, addr)	writel((v), (addr))
+#define iowrite32be(v, addr)	iowrite32(be32_to_cpu(v), (addr))
 
 #define ioread8_rep(p, dst, count) \
 	insb((unsigned long) (p), (dst), (count))
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
flat-split-the-stack-data-alignments.patch
flat-fix-unmap-len-in-load-error-path.patch
asm-generic-ioh-add-big-endian-versions-of-ioreadwrite1632.patch


From: akpm@linux-foundation.org
Subject: [merged] m32r-add-io_rep-helpers.patch removed from -mm tree
Date: Wed, 30 Dec 2015 12:40:19 -0800
Message-ID: <56844133.xl3dPua5+x9r2P5P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbbL3UkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Dec 2015 15:40:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: add io*_rep helpers
has been removed from the -mm tree.  Its filename was
     m32r-add-io_rep-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: add io*_rep helpers

m32r allmodconfig was failing with the error: error: implicit declaration
of function 'read'

On checking io.h it turned out that 'read' is not defined but 'readb' is
defined and 'ioread8' will then obviously mean 'readb'.

At the same time some of the helper functions ioreadN_rep() and
iowriteN_rep() were missing which also led to the build failure.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/io.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN arch/m32r/include/asm/io.h~m32r-add-io_rep-helpers arch/m32r/include/asm/io.h
--- a/arch/m32r/include/asm/io.h~m32r-add-io_rep-helpers
+++ a/arch/m32r/include/asm/io.h
@@ -168,13 +168,21 @@ static inline void _writel(unsigned long
 #define writew_relaxed writew
 #define writel_relaxed writel
 
-#define ioread8 read
+#define ioread8 readb
 #define ioread16 readw
 #define ioread32 readl
 #define iowrite8 writeb
 #define iowrite16 writew
 #define iowrite32 writel
 
+#define ioread8_rep(p, dst, count) insb((unsigned long)(p), (dst), (count))
+#define ioread16_rep(p, dst, count) insw((unsigned long)(p), (dst), (count))
+#define ioread32_rep(p, dst, count) insl((unsigned long)(p), (dst), (count))
+
+#define iowrite8_rep(p, src, count) outsb((unsigned long)(p), (src), (count))
+#define iowrite16_rep(p, src, count) outsw((unsigned long)(p), (src), (count))
+#define iowrite32_rep(p, src, count) outsl((unsigned long)(p), (src), (count))
+
 #define ioread16be(addr)	be16_to_cpu(readw(addr))
 #define ioread32be(addr)	be32_to_cpu(readl(addr))
 #define iowrite16be(v, addr)	writew(cpu_to_be16(v), (addr))
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-4.patch


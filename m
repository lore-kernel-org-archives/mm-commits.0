From: akpm@linux-foundation.org
Subject: + sh-fix-build-error-by-adding-generic-ioport_map-unmap.patch
 added to -mm tree
Date: Wed, 06 Aug 2014 12:49:55 -0700
Message-ID: <53e286e3.8R/OGzRN1JwpKc/o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:35933 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbaHFTt5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 15:49:57 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so774390pdj.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 12:49:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobby.prani@gmail.com, geert@linux-m68k.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: Fix build error by adding generic ioport_{map/unmap}()
has been added to the -mm tree.  Its filename is
     sh-fix-build-error-by-adding-generic-ioport_map-unmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-fix-build-error-by-adding-generic-ioport_map-unmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-fix-build-error-by-adding-generic-ioport_map-unmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pranith Kumar <bobby.prani@gmail.com>
Subject: sh: Fix build error by adding generic ioport_{map/unmap}()

Fix build error as reported by Geert Uytterhoeven here:
http://kisskb.ellerman.id.au/kisskb/buildresult/11607865/

The error happens when CONFIG_HAS_IOPORT_MAP=n because of which there are
missing definitions of ioport_map/unmap(). Fix this build error by adding these
prototypes.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: <stable@vger.kernel.org>	[3.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/io_noioport.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN arch/sh/include/asm/io_noioport.h~sh-fix-build-error-by-adding-generic-ioport_map-unmap arch/sh/include/asm/io_noioport.h
--- a/arch/sh/include/asm/io_noioport.h~sh-fix-build-error-by-adding-generic-ioport_map-unmap
+++ a/arch/sh/include/asm/io_noioport.h
@@ -34,6 +34,17 @@ static inline void outl(unsigned int x,
 	BUG();
 }
 
+static inline void __iomem *ioport_map(unsigned long port, unsigned int size)
+{
+	BUG();
+	return NULL;
+}
+
+static inline void ioport_unmap(void __iomem *addr)
+{
+	BUG();
+}
+
 #define inb_p(addr)	inb(addr)
 #define inw_p(addr)	inw(addr)
 #define inl_p(addr)	inl(addr)
_

Patches currently in -mm which might be from bobby.prani@gmail.com are

origin.patch
sh-fix-build-error-by-adding-generic-ioport_map-unmap.patch
linux-next.patch


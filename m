From: akpm@linux-foundation.org
Subject: [merged] cris-provide-inout_p.patch removed from -mm tree
Date: Fri, 24 Jan 2014 10:58:17 -0800
Message-ID: <52e2b7c9.j7lgmUMprRMueoJD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaAXS6S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, starvik@axis.com, jesper.nilsson@axis.com, geert@linux-m68k.org

Subject: [merged] cris-provide-inout_p.patch removed from -mm tree
To: geert@linux-m68k.org,jesper.nilsson@axis.com,starvik@axis.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:17 -0800


The patch titled
     Subject: cris: provide {in,out}[wl]_p()
has been removed from the -mm tree.  Its filename was
     cris-provide-inout_p.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: cris: provide {in,out}[wl]_p()

drivers/staging/comedi/drivers/das6402.c: In function 'intr_handler':
drivers/staging/comedi/drivers/das6402.c:164:3: error: implicit declaration of function 'outw_p' [-Werror=implicit-function-declaration]
drivers/staging/speakup/speakup_dtlk.c: In function 'synth_probe':
drivers/staging/speakup/speakup_dtlk.c:362:2: error: implicit declaration of function 'inw_p' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/io.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/cris/include/asm/io.h~cris-provide-inout_p arch/cris/include/asm/io.h
--- a/arch/cris/include/asm/io.h~cris-provide-inout_p
+++ a/arch/cris/include/asm/io.h
@@ -169,7 +169,11 @@ static inline void outsl(unsigned int po
 }
 
 #define inb_p(port)             inb(port)
+#define inw_p(port)             inw(port)
+#define inl_p(port)             inl(port)
 #define outb_p(val, port)       outb((val), (port))
+#define outw_p(val, port)       outw((val), (port))
+#define outl_p(val, port)       outl((val), (port))
 
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch


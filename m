From: akpm@linux-foundation.org
Subject: - net-core-skbuffc-gcc-323-compilation-error.patch removed from -mm tree
Date: Mon, 21 May 2007 13:09:35 -0700
Message-ID: <200705212009.l4LK9YfA018777@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935692AbXEUUKv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:10:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikpe@it.uu.se, mm-commits@vger.kernel.org


The patch titled
     net/core/skbuff.c gcc-3.2.3 compilation error
has been removed from the -mm tree.  Its filename was
     net-core-skbuffc-gcc-323-compilation-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/core/skbuff.c gcc-3.2.3 compilation error
From: Mikael Pettersson <mikpe@it.uu.se>

Compiling 2.6.22-rc1 with gcc-3.2.3 for i486 fails with:

  gcc -m32 -Wp,-MD,net/core/.skbuff.o.d  -nostdinc -isystem /home/mikpe/pkgs/linux-x86/gnu/lib/gcc-lib/i486-pc-linux-gnu/3.2.3/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -O2 -pipe -msoft-float -mregparm=3 -freg-struct-return -mpreferred-stack-boundary=4  -march=i486 -ffreestanding -maccumulate-outgoing-args -DCONFIG_AS_CFI=1  -Iinclude/asm-i386/mach-default -fomit-frame-pointer       -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(skbuff)"  -D"KBUILD_MODNAME=KBUILD_STR(skbuff)" -c -o net/core/skbuff.o net/core/skbuff.c
net/core/skbuff.c:648:1: directives may not be used inside a macro argument
net/core/skbuff.c:647:39: unterminated argument list invoking macro "memcpy"
net/core/skbuff.c: In function `pskb_expand_head':
net/core/skbuff.c:651: `memcpy' undeclared (first use in this function)
net/core/skbuff.c:651: (Each undeclared identifier is reported only once
net/core/skbuff.c:651: for each function it appears in.)
net/core/skbuff.c:651: syntax error before "skb"
make[2]: *** [net/core/skbuff.o] Error 1
make[1]: *** [net/core] Error 2
make: *** [net] Error 2

The patch implements a simple workaround which is to clone the offending
memcpy() call and specialise it for the two different scenarios.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/skbuff.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN net/core/skbuff.c~net-core-skbuffc-gcc-323-compilation-error net/core/skbuff.c
--- a/net/core/skbuff.c~net-core-skbuffc-gcc-323-compilation-error
+++ a/net/core/skbuff.c
@@ -644,11 +644,10 @@ int pskb_expand_head(struct sk_buff *skb
 
 	/* Copy only real data... and, alas, header. This should be
 	 * optimized for the cases when header is void. */
-	memcpy(data + nhead, skb->head,
 #ifdef NET_SKBUFF_DATA_USES_OFFSET
-		skb->tail);
+	memcpy(data + nhead, skb->head, skb->tail);
 #else
-		skb->tail - skb->head);
+	memcpy(data + nhead, skb->head, skb->tail - skb->head);
 #endif
 	memcpy(data + size, skb_end_pointer(skb),
 	       sizeof(struct skb_shared_info));
_

Patches currently in -mm which might be from mikpe@it.uu.se are

origin.patch

From: akpm@linux-foundation.org
Subject: - pcmcia-ppc64-needs-64-bit-ioaddr_t.patch removed from -mm tree
Date: Mon, 14 May 2007 17:05:21 -0700
Message-ID: <200705150005.l4F05LLL029678@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754259AbXEOAFm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 20:05:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, benh@kernel.crashing.org, linux@dominikbrodowski.net, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     pcmcia: ppc64 needs 64-bit ioaddr_t
has been removed from the -mm tree.  Its filename was
     pcmcia-ppc64-needs-64-bit-ioaddr_t.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: pcmcia: ppc64 needs 64-bit ioaddr_t
From: Olof Johansson <olof@lixom.net>

ppc64 really needs ioaddr_t to be 64-bit, since I/O addresses really
are MMIO addresses, and remapped to a high range.

While the type is exported to userspace, there hasn't been any platforms
with PCMCIA on 64-bit powerpc until now, so changing it won't regress
any existing users.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/pcmcia/cs_types.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/pcmcia/cs_types.h~pcmcia-ppc64-needs-64-bit-ioaddr_t include/pcmcia/cs_types.h
--- a/include/pcmcia/cs_types.h~pcmcia-ppc64-needs-64-bit-ioaddr_t
+++ a/include/pcmcia/cs_types.h
@@ -21,12 +21,16 @@
 #include <sys/types.h>
 #endif
 
-#if defined(__arm__) || defined(__mips__)
+#if defined(__powerpc64__)
+/* I/O addresses are really MMIO addresses on PPC, and can thus be 64 bits */
+typedef unsigned long ioaddr_t;
+#elif defined(__arm__) || defined(__mips__)
 /* This (ioaddr_t) is exposed to userspace & hence cannot be changed. */
 typedef u_int   ioaddr_t;
 #else
 typedef u_short	ioaddr_t;
 #endif
+
 typedef unsigned long kio_addr_t;
 
 typedef u_short	socket_t;
_

Patches currently in -mm which might be from olof@lixom.net are

8xx-mpc885ads-pcmcia-support.patch
8xx-mpc885ads-pcmcia-support-fix.patch
8xx-fix-whitespace-and-indentation.patch
dts-kill-hardcoded-phandles.patch
pcmcia-ppc64-needs-64-bit-ioaddr_t.patch

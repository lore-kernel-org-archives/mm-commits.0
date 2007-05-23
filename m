From: akpm@linux-foundation.org
Subject: - af_rxrpc-af_rxrpc-depends-on-ipv4.patch removed from -mm tree
Date: Wed, 23 May 2007 13:20:59 -0700
Message-ID: <200705232020.l4NKKwtg030992@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756649AbXEWUVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 16:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     AF_RXRPC: AF_RXRPC depends on IPv4
has been removed from the -mm tree.  Its filename was
     af_rxrpc-af_rxrpc-depends-on-ipv4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: AF_RXRPC: AF_RXRPC depends on IPv4
From: David Howells <dhowells@redhat.com>

Add a dependency for CONFIG_AF_RXRPC on CONFIG_INET.  This fixes this error:

net/built-in.o: In function `rxrpc_get_peer':
(.text+0x42824): undefined reference to `ip_route_output_key'

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rxrpc/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN net/rxrpc/Kconfig~af_rxrpc-af_rxrpc-depends-on-ipv4 net/rxrpc/Kconfig
--- a/net/rxrpc/Kconfig~af_rxrpc-af_rxrpc-depends-on-ipv4
+++ a/net/rxrpc/Kconfig
@@ -4,7 +4,7 @@
 
 config AF_RXRPC
 	tristate "RxRPC session sockets"
-	depends on EXPERIMENTAL
+	depends on INET && EXPERIMENTAL
 	select KEYS
 	help
 	  Say Y or M here to include support for RxRPC session sockets (just
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
documentation-memory-barrierstxt-various-fixes.patch
git-mtd.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-fix.patch
romfs-printk-format-warnings.patch
mutex-subsystem-synchro-test-module.patch

From: akpm@linux-foundation.org
Subject: + af_rxrpc-af_rxrpc-depends-on-ipv4.patch added to -mm tree
Date: Mon, 14 May 2007 12:33:06 -0700
Message-ID: <200705141933.l4EJX6lp024269@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbXENTd0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 15:33:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     AF_RXRPC: AF_RXRPC depends on IPv4
has been added to the -mm tree.  Its filename is
     af_rxrpc-af_rxrpc-depends-on-ipv4.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

nommu-add-ioremap_page_range.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
af_rxrpc-af_rxrpc-depends-on-ipv4.patch
remove-slab_ctor_constructor.patch
split-usermodehelper-setup-from-execution.patch
mutex-subsystem-synchro-test-module.patch

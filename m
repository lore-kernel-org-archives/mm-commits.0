From: akpm@linux-foundation.org
Subject: - e1000e-triggers-sparc32-gcc-bug.patch removed from -mm tree
Date: Mon, 28 Apr 2008 02:55:16 -0700
Message-ID: <200804280955.m3S9tG0E020817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765222AbYD1J4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 05:56:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ZenIV.linux.org.uk, auke-jan.h.kok@intel.com, davem@davemloft.net, jesse.brandeburg@intel.com, jgarzik@pobox.comviro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     e1000e triggers sparc32 gcc bug
has been removed from the -mm tree.  Its filename was
     e1000e-triggers-sparc32-gcc-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e triggers sparc32 gcc bug
From: Al Viro <viro@ZenIV.linux.org.uk>

...  and isn't possible on sparc32 boxen anyway, unless somebody had done
JavaStation with PCIE lately.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/Kconfig~e1000e-triggers-sparc32-gcc-bug drivers/net/Kconfig
--- a/drivers/net/Kconfig~e1000e-triggers-sparc32-gcc-bug
+++ a/drivers/net/Kconfig
@@ -2011,7 +2011,7 @@ config E1000_DISABLE_PACKET_SPLIT
 
 config E1000E
 	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
-	depends on PCI
+	depends on PCI && (!SPARC32 || BROKEN)
 	---help---
 	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
 	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,
_

Patches currently in -mm which might be from viro@ZenIV.linux.org.uk are

origin.patch
git-kvm.patch
ecryptfs-protect-crypt_stat-flags-in-ecryptfs_open.patch


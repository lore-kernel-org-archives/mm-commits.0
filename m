From: akpm@linux-foundation.org
Subject: + e1000e-triggers-sparc32-gcc-bug.patch added to -mm tree
Date: Sun, 27 Apr 2008 19:54:29 -0700
Message-ID: <200804280254.m3S2sTUW004414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761188AbYD1CzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 22:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, auke-jan.h.kok@intel.com, davem@davemloft.net, jesse.brandeburg@intel.com, jgarzik@pobox.comviro@ZenIV.linux.org.uk


The patch titled
     e1000e triggers sparc32 gcc bug
has been added to the -mm tree.  Its filename is
     e1000e-triggers-sparc32-gcc-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 	default E1000
 	---help---
 	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
_

Patches currently in -mm which might be from viro@ZenIV.linux.org.uk are

origin.patch
git-kvm.patch
e1000e-triggers-sparc32-gcc-bug.patch
git-scsi-misc.patch
ecryptfs-protect-crypt_stat-flags-in-ecryptfs_open.patch


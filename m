From: akpm@linux-foundation.org
Subject: + do-not-select-macintosh-drivers-by-default.patch added to -mm tree
Date: Wed, 09 May 2007 21:10:29 -0700
Message-ID: <200705100410.l4A4ATd3011669@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756333AbXEJEKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:10:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bbpetkov@yahoo.de, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     Do not select macintosh drivers by default
has been added to the -mm tree.  Its filename is
     do-not-select-macintosh-drivers-by-default.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Do not select macintosh drivers by default
From: Borislav Petkov <bbpetkov@yahoo.de>

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/macintosh/Kconfig~do-not-select-macintosh-drivers-by-default drivers/macintosh/Kconfig
--- a/drivers/macintosh/Kconfig~do-not-select-macintosh-drivers-by-default
+++ a/drivers/macintosh/Kconfig
@@ -2,7 +2,7 @@
 menuconfig MACINTOSH_DRIVERS
 	bool "Macintosh device drivers"
 	depends on PPC || MAC || X86
-	default y
+	default y if PPC || MAC
 
 if MACINTOSH_DRIVERS
 
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
do-not-select-macintosh-drivers-by-default.patch

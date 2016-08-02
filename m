From: akpm@linux-foundation.org
Subject: [patch 028/111] init/Kconfig: make COMPILE_TEST depend on !UML
Date: Tue, 02 Aug 2016 14:03:27 -0700
Message-ID: <57a10a9f.obspIqbZuBuUv8Og%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709AbcHBVRA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, richard@nod.at, arnd@arndb.de, viro@zeniv.linux.org.uk

From: Richard Weinberger <richard@nod.at>
Subject: init/Kconfig: make COMPILE_TEST depend on !UML

UML is a bit special since it does not have iomem nor dma.  That means a
lot of drivers will not build if they miss a dependency on HAS_IOMEM. 
s390 used to have the same issues but since it gained PCI support UML is
the only stranger.

We are tired of patching dozens of new drivers after every merge window
just to un-break allmod/yesconfig UML builds.  One could argue that a
decent driver has to know on what it depends and therefore a missing
HAS_IOMEM dependency is a clear driver bug.  But the dependency not
obvious and not everyone does UML builds with COMPILE_TEST enabled when
developing a device driver.

A possible solution to make these builds succeed on UML would be providing
stub functions for ioremap() and friends which fail upon runtime.  Another
one is simply disabling COMPILE_TEST for UML.  Since it is the least
hassle and does not force use to fake iomem support let's do the latter.

Link: http://lkml.kernel.org/r/1466152995-28367-1-git-send-email-richard@nod.at
Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/Kconfig~make-compile_test-depend-on-uml init/Kconfig
--- a/init/Kconfig~make-compile_test-depend-on-uml
+++ a/init/Kconfig
@@ -55,6 +55,7 @@ config CROSS_COMPILE
 
 config COMPILE_TEST
 	bool "Compile also drivers which will not load"
+	depends on !UML
 	default n
 	help
 	  Some drivers can be compiled on a different platform than they are
_

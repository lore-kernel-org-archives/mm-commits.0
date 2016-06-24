From: akpm@linux-foundation.org
Subject: + make-compile_test-depend-on-uml.patch added to -mm tree
Date: Fri, 24 Jun 2016 13:14:38 -0700
Message-ID: <576d94ae.Nc8pFnQCDwYxprAj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbcFXUOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 16:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, arnd@arndb.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: make COMPILE_TEST depend on !UML
has been added to the -mm tree.  Its filename is
     make-compile_test-depend-on-uml.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/make-compile_test-depend-on-uml.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/make-compile_test-depend-on-uml.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from richard@nod.at are

make-compile_test-depend-on-uml.patch


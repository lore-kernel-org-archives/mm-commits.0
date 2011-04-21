From: akpm@linux-foundation.org
Subject: + uml-fix-hppfs-build.patch added to -mm tree
Date: Thu, 21 Apr 2011 12:26:02 -0700
Message-ID: <201104211926.p3LJQ2of025382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829Ab1DUT1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Apr 2011 15:27:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, danner.simon@gmail.com, hch@infradead.org, jdike@addtoit.com, richard@nod.at


The patch titled
     uml: fix hppfs build
has been added to the -mm tree.  Its filename is
     uml-fix-hppfs-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix hppfs build
From: Randy Dunlap <randy.dunlap@oracle.com>

Make HoneyPot ProcFS depend on CONFIG_PROC_FS so that it will build. 
Recommended by Christoph Hellwig.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=33692

Reported-by: Simon Danner <danner.simon@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.um |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/Kconfig.um~uml-fix-hppfs-build arch/um/Kconfig.um
--- a/arch/um/Kconfig.um~uml-fix-hppfs-build
+++ a/arch/um/Kconfig.um
@@ -47,7 +47,7 @@ config HOSTFS
 
 config HPPFS
 	tristate "HoneyPot ProcFS (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && PROC_FS
 	help
 	  hppfs (HoneyPot ProcFS) is a filesystem which allows UML /proc
 	  entries to be overridden, removed, or fabricated from the host.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
hid-example-fix-some-build-issues.patch
drivers-staging-olpc_dcon-olpc_dcon_xo_1c-needs-delayh.patch
uml-fix-hppfs-build.patch
drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch


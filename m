From: akpm@linux-foundation.org
Subject: + pc8736x_gpio-depends-on-x86_32.patch added to -mm tree
Date: Wed, 11 Aug 2010 12:37:18 -0700
Message-ID: <201008111937.o7BJbIqk010512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758522Ab0HKThx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Aug 2010 15:37:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jim.cromie@gmail.com, jordan.crouse@amd.com


The patch titled
     pc8736x_gpio: depends on X86_32
has been added to the -mm tree.  Its filename is
     pc8736x_gpio-depends-on-x86_32.patch

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
Subject: pc8736x_gpio: depends on X86_32
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning for PC8736x_GPIO by restricting it to
X86_32.

warning: (SCx200_GPIO && SCx200 || PC8736x_GPIO && X86) selects NSC_GPIO which has unmet direct dependencies (X86_32)

NSC_GPIO is X86_32 only.  The other driver (SCx200_GPIO) that selects
NSC_GPIO is X86_32 only (indirectly, since SCx200 depends on X86_32),
so limit this driver also.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~pc8736x_gpio-depends-on-x86_32 drivers/char/Kconfig
--- a/drivers/char/Kconfig~pc8736x_gpio-depends-on-x86_32
+++ a/drivers/char/Kconfig
@@ -1002,7 +1002,7 @@ config SCx200_GPIO
 
 config PC8736x_GPIO
 	tristate "NatSemi PC8736x GPIO Support"
-	depends on X86
+	depends on X86_32
 	default SCx200_GPIO	# mostly N
 	select NSC_GPIO		# needed for support routines
 	help
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
mm-fix-fatal-kernel-doc-error.patch
pc8736x_gpio-depends-on-x86_32.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


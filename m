From: akpm@linux-foundation.org
Subject: + drivers-gpio-is-platform-neutral.patch added to -mm tree
Date: Sat, 19 Jun 2010 14:11:59 -0700
Message-ID: <201006192111.o5JLBsS8015173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab0FSVMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 Jun 2010 17:12:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     drivers/gpio is platform-neutral
has been added to the -mm tree.  Its filename is
     drivers-gpio-is-platform-neutral.patch

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
Subject: drivers/gpio is platform-neutral
From: David Brownell <david-b@pacbell.net>

Update Kconfig and Makefile in drivers/gpio to discourage inappropriate
addition of platform-specific code.

Signed-by: David Brownell <dbrownell@users.sourceforge.net>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig  |    2 +-
 drivers/gpio/Makefile |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/gpio/Kconfig~drivers-gpio-is-platform-neutral drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~drivers-gpio-is-platform-neutral
+++ a/drivers/gpio/Kconfig
@@ -1,5 +1,5 @@
 #
-# GPIO infrastructure and expanders
+# platform-neutral GPIO infrastructure and expanders
 #
 
 config ARCH_WANT_OPTIONAL_GPIOLIB
diff -puN drivers/gpio/Makefile~drivers-gpio-is-platform-neutral drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~drivers-gpio-is-platform-neutral
+++ a/drivers/gpio/Makefile
@@ -1,4 +1,8 @@
-# gpio support: dedicated expander chips, etc
+# generic gpio support: dedicated expander chips, etc
+#
+# NOTE: platform-specific GPIO drivers don't belong in the
+drivers/gpio directory; put them with other platform setup
+# code, IRQ controllers, board init, etc.
 
 ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

linux-next.patch
drivers-gpio-is-platform-neutral.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
gpio-max730x-make-pullups-configurable-via-platformdata.patch


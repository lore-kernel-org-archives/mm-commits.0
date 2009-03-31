From: akpm@linux-foundation.org
Subject: + xtensa-variant-specific-code.patch added to -mm tree
Date: Mon, 30 Mar 2009 17:00:09 -0700
Message-ID: <200903310000.n2V009Dm031374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761565AbZCaAEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 20:04:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jw@emlix.com, chris@zankel.net, dg@emlix.com, os@emlix.com


The patch titled
     xtensa: variant-specific code
has been added to the -mm tree.  Its filename is
     xtensa-variant-specific-code.patch

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
Subject: xtensa: variant-specific code
From: Johannes Weiner <jw@emlix.com>

Allow the variant to provide own code.  Add empty dummy Makefiles for
the existing variants.

The s6000 has circuits that require own drivers.  Allow these to live
in the variant-specific directory.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Daniel Glockner <dg@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Makefile                 |    3 +++
 arch/xtensa/variants/dc232b/Makefile |    1 +
 arch/xtensa/variants/fsf/Makefile    |    1 +
 3 files changed, 5 insertions(+)

diff -puN arch/xtensa/Makefile~xtensa-variant-specific-code arch/xtensa/Makefile
--- a/arch/xtensa/Makefile~xtensa-variant-specific-code
+++ a/arch/xtensa/Makefile
@@ -68,6 +68,9 @@ LIBGCC := $(shell $(CC) $(KBUILD_CFLAGS)
 
 head-y		:= arch/xtensa/kernel/head.o
 core-y		+= arch/xtensa/kernel/ arch/xtensa/mm/
+ifneq ($(VARIANT),)
+core-y		+= arch/xtensa/variants/$(VARIANT)/
+endif
 ifneq ($(PLATFORM),)
 core-y		+= arch/xtensa/platforms/$(PLATFORM)/
 endif
diff -puN /dev/null arch/xtensa/variants/dc232b/Makefile
--- /dev/null
+++ a/arch/xtensa/variants/dc232b/Makefile
@@ -0,0 +1 @@
+# dc232b Makefile
diff -puN /dev/null arch/xtensa/variants/fsf/Makefile
--- /dev/null
+++ a/arch/xtensa/variants/fsf/Makefile
@@ -0,0 +1 @@
+# fsf Makefile
_

Patches currently in -mm which might be from jw@emlix.com are

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
xtensa-add-flat-support.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch


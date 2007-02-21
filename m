From: akpm@linux-foundation.org
Subject: + kbuild-add-the-code-maturity-levels-deprecated-and-obsolete.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:39:47 -0800
Message-ID: <200702212039.l1LKdl5L025181@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43321 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506AbXBUUj5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:39:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, bzolnier@gmail.com, sam@ravnborg.org


The patch titled
     kbuild: Add the code maturity levels DEPRECATED and OBSOLETE.
has been added to the -mm tree.  Its filename is
     kbuild-add-the-code-maturity-levels-deprecated-and-obsolete.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kbuild: Add the code maturity levels DEPRECATED and OBSOLETE.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Add two new maturity levels of DEPRECATED and OBSOLETE to the kbuild
structure.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff -puN init/Kconfig~kbuild-add-the-code-maturity-levels-deprecated-and-obsolete init/Kconfig
--- a/init/Kconfig~kbuild-add-the-code-maturity-levels-deprecated-and-obsolete
+++ a/init/Kconfig
@@ -29,9 +29,10 @@ config EXPERIMENTAL
 	  <file:Documentation/BUG-HUNTING>, and
 	  <file:Documentation/oops-tracing.txt> in the kernel source).
 
-	  This option will also make obsoleted drivers available. These are
-	  drivers that have been replaced by something else, and/or are
-	  scheduled to be removed in a future kernel release.
+	  At the moment, this option also makes obsolete drivers available,
+	  but such drivers really should be removed from the EXPERIMENTAL
+	  category and added to either DEPRECATED or OBSOLETE, depending
+	  on their status.
 
 	  Unless you intend to help test and develop a feature or driver that
 	  falls into this category, or you have a situation that requires
@@ -40,6 +41,29 @@ config EXPERIMENTAL
 	  you say Y here, you will be offered the choice of using features or
 	  drivers that are currently considered to be in the alpha-test phase.
 
+config DEPRECATED
+	bool "Prompt for deprecated code/drivers"
+	default y
+	---help---
+	  Code that is tagged as "deprecated" is officially still available
+	  for use but will typically have already been scheduled for removal
+	  at some point, so it's in your best interests to start looking for
+	  an alternative.
+
+	  Check the file Documentation/feature-removal-schedule.txt to see
+	  if a particular feature has an official scheduled removal date.
+
+config OBSOLETE
+	bool "Prompt for obsolete code/drivers"
+	default n
+	---help---
+	  Code that is tagged as "obsolete" is officially no longer supported
+	  and shouldn't play a part in any normal build, but those features
+	  might still be available if you absolutely need access to them.
+
+	  You are *strongly* discouraged from continuing to depend on
+	  obsolete code on an ongoing, long-term basis.
+
 config BROKEN
 	bool
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-avr32.patch
git-dvb.patch
kbuild-add-the-code-maturity-levels-deprecated-and-obsolete.patch
git-mips.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch

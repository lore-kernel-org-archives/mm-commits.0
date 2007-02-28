From: akpm@linux-foundation.org
Subject: - kbuild-add-the-code-maturity-levels-deprecated-and-obsolete.patch removed from -mm tree
Date: Tue, 27 Feb 2007 23:22:16 -0800
Message-ID: <200702280722.l1S7MGPE009788@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43109 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbXB1HWW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 02:22:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, bzolnier@gmail.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: Add the code maturity levels DEPRECATED and OBSOLETE.
has been removed from the -mm tree.  Its filename was
     kbuild-add-the-code-maturity-levels-deprecated-and-obsolete.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: kbuild: Add the code maturity levels DEPRECATED and OBSOLETE.
From: "Robert P. J. Day" <rpjday@mindspring.com>

To go along with the code maturity level of EXPERIMENTAL, add levels of
DEPRECATED and OBSOLETE, so that developers can officially tag any Kconfig
selections as one of those levels, and they can with one selection choose to
remove any deprecated and/or obsolete features from their build.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

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
+	  Code that has been tagged as "deprecated" generally still works and
+	  is probably still supported, but there is already a newer and better
+	  alternative available and you should seriously consider switching to
+	  that newer alternative.
+
+	  Code that is marked as deprecated for quite some time also has a
+	  tendency to eventually become "obsolete," at which point it will
+	  probably be removed entirely from the kernel.
+
+config OBSOLETE
+	bool "Prompt for obsolete code/drivers"
+	default n
+	---help---
+	  Code that has been tagged as "obsolete" is no longer officially
+	  supported and shouldn't play a part in any normal build.  Obsolete
+	  code might already be scheduled for removal as well, so you might
+	  want to check the file Documentation/feature-removal-schedule.txt for
+	  any proposed removal dates.
+
 config BROKEN
 	bool
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-avr32.patch
git-dvb.patch
kbuild-add-the-code-maturity-levels-deprecated-and-obsolete.patch
git-mips.patch
mips-remove-unreferenced-_ioc_slmask-macro-in-ioctlh.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch

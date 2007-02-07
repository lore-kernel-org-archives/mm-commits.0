From: akpm@linux-foundation.org
Subject: - kbuild-correctly-skip-tilded-backups-in-localversion-files.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:52:27 -0800
Message-ID: <200702071952.l17JqRaa025242@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33620 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422744AbXBGTwg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:52:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olecom@flower.upol.cz, bastian@waldi.eu.org, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: correctly skip tilded backups in localversion files
has been removed from the -mm tree.  Its filename was
     kbuild-correctly-skip-tilded-backups-in-localversion-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kbuild: correctly skip tilded backups in localversion files
From: Oleg Verych <olecom@flower.upol.cz>

Tildes as in path as in filenames are handled correctly now: only files,
containing tilde '~', are backups, thus are not valid.

Definition of `space' was removed, scripts/Kbuild.include has one.  That
definition was taken right from the GNU make manual, while Kbuild's version is
original.

Original report by Bastian Blank:

 The following patch fixes the problem that localversion files where
 ignored if the tree lives in a path which contains a ~. It changes the
 test to apply to the filename only.

 Debian allows versions which contains ~ in it. The upstream part of the
 version is in the directory name of the build tree and we got weird
 results because the localversion files was just got ignored in this
 case.

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Bastian Blank <bastian@waldi.eu.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff -puN Makefile~kbuild-correctly-skip-tilded-backups-in-localversion-files Makefile
--- a/Makefile~kbuild-correctly-skip-tilded-backups-in-localversion-files
+++ a/Makefile
@@ -776,7 +776,7 @@ $(vmlinux-dirs): prepare scripts
 #	  $(EXTRAVERSION)		eg, -rc6
 #	$(localver-full)
 #	  $(localver)
-#	    localversion*		(all localversion* files)
+#	    localversion*		(files without backups, containing '~')
 #	    $(CONFIG_LOCALVERSION)	(from kernel config setting)
 #	  $(localver-auto)		(only if CONFIG_LOCALVERSION_AUTO is set)
 #	    ./scripts/setlocalversion	(SCM tag, if one exists)
@@ -787,17 +787,12 @@ $(vmlinux-dirs): prepare scripts
 # moment, only git is supported but other SCMs can edit the script
 # scripts/setlocalversion and add the appropriate checks as needed.
 
-nullstring :=
-space      := $(nullstring) # end of line
+pattern = ".*/localversion[^~]*"
+string  = $(shell cat /dev/null \
+	   `find $(objtree) $(srctree) -maxdepth 1 -regex $(pattern) | sort`)
 
-___localver = $(objtree)/localversion* $(srctree)/localversion*
-__localver  = $(sort $(wildcard $(___localver)))
-# skip backup files (containing '~')
-_localver = $(foreach f, $(__localver), $(if $(findstring ~, $(f)),,$(f)))
-
-localver = $(subst $(space),, \
-	   $(shell cat /dev/null $(_localver)) \
-	   $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
+localver = $(subst $(space),, $(string) \
+			      $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
 
 # If CONFIG_LOCALVERSION_AUTO is set scripts/setlocalversion is called
 # and if the SCM is know a tag from the SCM is appended.
_

Patches currently in -mm which might be from olecom@flower.upol.cz are

origin.patch
deprecate-smbfs-in-favour-of-cifs-docs.patch

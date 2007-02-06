From: akpm@linux-foundation.org
Subject: - kbuild-dont-ignore-localversion-files-if-the-path-includes-a.patch removed from -mm tree
Date: Tue, 06 Feb 2007 14:59:55 -0800
Message-ID: <200702062259.l16Mxt5t031882@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54523 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030335AbXBFXAB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:00:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bastian@waldi.eu.org, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: don't ignore localversion files if the path includes a ~
has been removed from the -mm tree.  Its filename was
     kbuild-dont-ignore-localversion-files-if-the-path-includes-a.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: kbuild: don't ignore localversion files if the path includes a ~
From: Bastian Blank <bastian@waldi.eu.org>

Fix the problem that localversion files were ignored if the tree lives in
a path which contains a ~.  It changes the test to apply to the filename
only.

Debian allows versions which contains ~ in it.  The upstream part of the
version is in the directory name of the build tree and we got weird results
because the localversion files was just got ignored in this case.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~kbuild-dont-ignore-localversion-files-if-the-path-includes-a Makefile
--- a/Makefile~kbuild-dont-ignore-localversion-files-if-the-path-includes-a
+++ a/Makefile
@@ -793,7 +793,7 @@ space      := $(nullstring) # end of lin
 ___localver = $(objtree)/localversion* $(srctree)/localversion*
 __localver  = $(sort $(wildcard $(___localver)))
 # skip backup files (containing '~')
-_localver = $(foreach f, $(__localver), $(if $(findstring ~, $(f)),,$(f)))
+_localver = $(foreach f, $(__localver), $(if $(findstring ~, $(notdir $(f))),,$(f)))
 
 localver = $(subst $(space),, \
 	   $(shell cat /dev/null $(_localver)) \
_

Patches currently in -mm which might be from bastian@waldi.eu.org are

kbuild-correctly-skip-tilded-backups-in-localversion-files.patch
kbuild-dont-ignore-localversion-files-if-the-path-includes-a.patch

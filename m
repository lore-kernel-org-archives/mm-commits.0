From: akpm@osdl.org
Subject: + kbuild-dont-ignore-localversion-files-if-the-path-includes-a.patch added to -mm tree
Date: Wed, 10 Jan 2007 17:12:55 -0800
Message-ID: <200701110112.l0B1CtYG013416@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43110 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965289AbXAKBNX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 20:13:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bastian@waldi.eu.org, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     kbuild: don't ignore localversion files if the path includes a ~
has been added to the -mm tree.  Its filename is
     kbuild-dont-ignore-localversion-files-if-the-path-includes-a.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Makefile |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

kbuild-dont-ignore-localversion-files-if-the-path-includes-a.patch

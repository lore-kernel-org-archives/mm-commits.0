From: akpm@linux-foundation.org
Subject: - git-kbuild-scripts-kconfig-confc-needs-localeh.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:48:48 -0800
Message-ID: <200801290148.m0T1mmJw027375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49184 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754509AbYA2B6U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:58:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyle@mcmartin.ca, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     git-kbuild: scripts/kconfig/conf.c needs locale.h
has been removed from the -mm tree.  Its filename was
     git-kbuild-scripts-kconfig-confc-needs-localeh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-kbuild: scripts/kconfig/conf.c needs locale.h
From: Kyle McMartin <kyle@mcmartin.ca>

oldconfig fails for me on Debian.  kconfig/conf.c is using setlocale()
without including the locale.h header.

  HOSTCC  scripts/kconfig/conf.o
scripts/kconfig/conf.c: In function 'main':
scripts/kconfig/conf.c:502: warning: implicit declaration of function
'setlocale'
scripts/kconfig/conf.c:502: error: 'LC_ALL' undeclared (first use in
this function)
scripts/kconfig/conf.c:502: error: (Each undeclared identifier is
reported only once

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/conf.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/kconfig/conf.c~git-kbuild-scripts-kconfig-confc-needs-localeh scripts/kconfig/conf.c
--- a/scripts/kconfig/conf.c~git-kbuild-scripts-kconfig-confc-needs-localeh
+++ a/scripts/kconfig/conf.c
@@ -3,6 +3,8 @@
  * Released under the terms of the GNU GPL v2.0.
  */
 
+#include <locale.h>
+
 #include <ctype.h>
 #include <stdio.h>
 #include <stdlib.h>
_

Patches currently in -mm which might be from kyle@mcmartin.ca are

git-drm.patch
git-kbuild.patch
parisc-new-termios-definitions.patch
kill-warnings-in-mptbaseh-on-parisc64.patch
git-x86.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
alpha-parisc-removing-config-variable-debug_rwlock.patch
documentation-about-unaligned-memory-access.patch
add-cmpxchg_local-to-parisc.patch
modules-make-module_address_lookup-safe.patch
modules-make-module_address_lookup-safe-fix.patch

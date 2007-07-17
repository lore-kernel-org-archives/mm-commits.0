From: akpm@linux-foundation.org
Subject: - use-posix-bre-in-headers-install-target.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:09:10 -0700
Message-ID: <200707172309.l6HN9Ado012350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935486AbXGQXPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     use POSIX BRE in headers install target
has been removed from the -mm tree.  Its filename was
     use-posix-bre-in-headers-install-target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use POSIX BRE in headers install target
From: Mike Frysinger <vapier@gentoo.org>

The sed expression used at the moment in scripts/Makefile.headersinst
relies on the (handy) GNU extension where you can escape ERE's in an
otherwise BRE without using the GNU -r option.  The following patch
replaces this "\+" usage with a functionally equivalent POSIX BRE compliant
"\{1,\}".  Tested with `make headers_install` against blackfin/x86_64/i386
targets.

Stupid whiny OS X users and their crappy sed ;)

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.headersinst |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN scripts/Makefile.headersinst~use-posix-bre-in-headers-install-target scripts/Makefile.headersinst
--- a/scripts/Makefile.headersinst~use-posix-bre-in-headers-install-target
+++ a/scripts/Makefile.headersinst
@@ -11,13 +11,13 @@ UNIFDEF := scripts/unifdef -U__KERNEL__
 
 # Eliminate the contents of (and inclusions of) compiler.h
 HDRSED  := sed 	-e "s/ inline / __inline__ /g" \
-		-e "s/[[:space:]]__user[[:space:]]\+/ /g" \
-		-e "s/(__user[[:space:]]\+/ (/g" \
-		-e "s/[[:space:]]__force[[:space:]]\+/ /g" \
-		-e "s/(__force[[:space:]]\+/ (/g" \
-		-e "s/[[:space:]]__iomem[[:space:]]\+/ /g" \
-		-e "s/(__iomem[[:space:]]\+/ (/g" \
-		-e "s/[[:space:]]__attribute_const__[[:space:]]\+/\ /g" \
+		-e "s/[[:space:]]__user[[:space:]]\{1,\}/ /g" \
+		-e "s/(__user[[:space:]]\{1,\}/ (/g" \
+		-e "s/[[:space:]]__force[[:space:]]\{1,\}/ /g" \
+		-e "s/(__force[[:space:]]\{1,\}/ (/g" \
+		-e "s/[[:space:]]__iomem[[:space:]]\{1,\}/ /g" \
+		-e "s/(__iomem[[:space:]]\{1,\}/ (/g" \
+		-e "s/[[:space:]]__attribute_const__[[:space:]]\{1,\}/\ /g" \
 		-e "s/[[:space:]]__attribute_const__$$//" \
 		-e "/^\#include <linux\/compiler.h>/d"
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

git-kbuild.patch
x86_64-hide-cond_syscall-behind-__kernel__.patch

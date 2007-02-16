From: akpm@linux-foundation.org
Subject: + kbuild-override-build-timestamp.patch added to -mm tree
Date: Fri, 16 Feb 2007 14:05:59 -0800
Message-ID: <200702162205.l1GM5xrF011073@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38473 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946158AbXBPWGF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 17:06:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, sam@ravnborg.org


The patch titled
     kbuild: override build timestamp
has been added to the -mm tree.  Its filename is
     kbuild-override-build-timestamp.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kbuild: override build timestamp
From: Olaf Hering <olaf@aepfle.de>

Pass a timestamp to kbuild via an enviroment variable.

    TZ=UTC BUILD_TIMESTAMP=2007-01-01 make -kj O=../O vmlinux

This can be used when the kernel source is in a SCM and uname -v
is supposed to give the commit date and not the package build time.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mkcompile_h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN scripts/mkcompile_h~kbuild-override-build-timestamp scripts/mkcompile_h
--- a/scripts/mkcompile_h~kbuild-override-build-timestamp
+++ a/scripts/mkcompile_h
@@ -30,7 +30,12 @@ UTS_VERSION="#$VERSION"
 CONFIG_FLAGS=""
 if [ -n "$SMP" ] ; then CONFIG_FLAGS="SMP"; fi
 if [ -n "$PREEMPT" ] ; then CONFIG_FLAGS="$CONFIG_FLAGS PREEMPT"; fi
-UTS_VERSION="$UTS_VERSION $CONFIG_FLAGS `LC_ALL=C LANG=C date`"
+if [ -n "$BUILD_TIMESTAMP" ]; then
+  TIMESTAMP="`LC_ALL=C LANG=C date -d "$BUILD_TIMESTAMP"`"
+else
+  TIMESTAMP="`LC_ALL=C LANG=C date`"
+fi
+UTS_VERSION="$UTS_VERSION $CONFIG_FLAGS $TIMESTAMP"
 
 # Truncate to maximum length
 
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
kbuild-override-build-timestamp.patch
cleanup-variable-usage-in-mesh-interrupt-handler.patch
keep-track-of-network-interface-renaming.patch

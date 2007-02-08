From: akpm@linux-foundation.org
Subject: - search-a-little-harder-for-mkimage.patch removed from -mm tree
Date: Wed, 07 Feb 2007 21:19:36 -0800
Message-ID: <200702080519.l185JaGH005989@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56023 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161314AbXBHFTm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 00:19:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, sam@ravnborg.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     search a little harder for mkimage
has been removed from the -mm tree.  Its filename was
     search-a-little-harder-for-mkimage.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: search a little harder for mkimage
From: "Mike Frysinger" <vapier.adi@gmail.com>

Check to see if `${CROSS_COMPILE}mkimage` exists and if not, fall back to
the standard `mkimage`

The Blackfin toolchain includes mkimage, but we dont want to namespace
collide with any of the user's system setup, so we prefix it with our
toolchain name.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mkuboot.sh |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN scripts/mkuboot.sh~search-a-little-harder-for-mkimage scripts/mkuboot.sh
--- a/scripts/mkuboot.sh~search-a-little-harder-for-mkimage
+++ a/scripts/mkuboot.sh
@@ -4,12 +4,15 @@
 # Build U-Boot image when `mkimage' tool is available.
 #
 
-MKIMAGE=$(type -path mkimage)
+MKIMAGE=$(type -path ${CROSS_COMPILE}mkimage)
 
 if [ -z "${MKIMAGE}" ]; then
-	# Doesn't exist
-	echo '"mkimage" command not found - U-Boot images will not be built' >&2
-	exit 0;
+	MKIMAGE=$(type -path mkimage)
+	if [ -z "${MKIMAGE}" ]; then
+		# Doesn't exist
+		echo '"mkimage" command not found - U-Boot images will not be built' >&2
+		exit 0;
+	fi
 fi
 
 # Call "mkimage" to create U-Boot image
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

search-a-little-harder-for-mkimage.patch
scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath.patch

From: akpm@linux-foundation.org
Subject: - uml-enable-raw.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:02 -0800
Message-ID: <200703020507.l22572OO000847@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42352 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422752AbXCBFHF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: allan.graves@gmail.com, blaisorblade@yahoo.it, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: enable RAW
has been removed from the -mm tree.  Its filename was
     uml-enable-raw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: enable RAW
From: Allan Graves <allan.graves@gmail.com>

Add the RAW device driver options to the UML Kconfig.char file so that you may
use them in UML.

Signed-off-by: Allan Graves<allan.graves@gmail.com>
Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.char |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN arch/um/Kconfig.char~uml-enable-raw arch/um/Kconfig.char
--- a/arch/um/Kconfig.char~uml-enable-raw
+++ a/arch/um/Kconfig.char
@@ -146,6 +146,25 @@ config LEGACY_PTYS
 	  security.  This option enables these legacy devices; on most
 	  systems, it is safe to say N.
 
+config RAW_DRIVER
+        tristate "RAW driver (/dev/raw/rawN) (OBSOLETE)"
+        help
+          The raw driver permits block devices to be bound to /dev/raw/rawN.
+          Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O.
+          See the raw(8) manpage for more details.
+
+          The raw driver is deprecated and will be removed soon.
+          Applications should simply open the device (eg /dev/hda1)
+          with the O_DIRECT flag.
+
+config MAX_RAW_DEVS
+        int "Maximum number of RAW devices to support (1-8192)"
+        depends on RAW_DRIVER
+        default "256"
+        help
+          The maximum number of RAW devices that are supported.
+          Default is 256. Increase this number in case you need lots of
+          raw devices.
 
 config LEGACY_PTY_COUNT
 	int "Maximum number of legacy PTY in use"
_

Patches currently in -mm which might be from allan.graves@gmail.com are

origin.patch

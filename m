From: akpm@linux-foundation.org
Subject: + uml-enable-raw.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:21:37 -0800
Message-ID: <200702220021.l1M0Lb3I031086@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59233 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965025AbXBVAVn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:21:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: allan.graves@gmail.com, blaisorblade@yahoo.it, jdike@addtoit.com


The patch titled
     uml: enable RAW
has been added to the -mm tree.  Its filename is
     uml-enable-raw.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 19 insertions(+)

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

uml-enable-raw.patch

From: akpm@linux-foundation.org
Subject: + uml-gprof-needs-to-depend-on-frame_pointer.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:29:14 -0800
Message-ID: <200711060229.lA62TEs6031848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51122 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486AbXKFC3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:29:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magotari@gmail.com, jdike@linux.intel.com


The patch titled
     uml: GPROF needs to depend on FRAME_POINTER
has been added to the -mm tree.  Its filename is
     uml-gprof-needs-to-depend-on-frame_pointer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: GPROF needs to depend on FRAME_POINTER
From: Karol Swietlicki <magotari@gmail.com>

This is a short Kconfig fix for a problem in User Mode Linux.  Frame pointers
are required for gprof support to work.

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/Kconfig.debug~uml-gprof-needs-to-depend-on-frame_pointer arch/um/Kconfig.debug
--- a/arch/um/Kconfig.debug~uml-gprof-needs-to-depend-on-frame_pointer
+++ a/arch/um/Kconfig.debug
@@ -4,7 +4,7 @@ source "lib/Kconfig.debug"
 
 config GPROF
 	bool "Enable gprof support"
-	depends on DEBUG_INFO
+	depends on DEBUG_INFO && FRAME_POINTER
 	help
 	  This allows profiling of a User-Mode Linux kernel with the gprof
 	  utility.
_

Patches currently in -mm which might be from magotari@gmail.com are

uml-remove-xmm-checking-on-x86.patch
uml-fix-urls-in-kconfig-and-help-strings.patch
uml-improve-detection-of-host-cmov.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-remove-now-unused-code.patch
uml-gprof-needs-to-depend-on-frame_pointer.patch

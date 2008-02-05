From: akpm@linux-foundation.org
Subject: - uml-gprof-needs-to-depend-on-frame_pointer.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:46 -0800
Message-ID: <200802052235.m15MZR3O012614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762262AbYBEWlJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magotari@gmail.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: GPROF needs to depend on FRAME_POINTER
has been removed from the -mm tree.  Its filename was
     uml-gprof-needs-to-depend-on-frame_pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch

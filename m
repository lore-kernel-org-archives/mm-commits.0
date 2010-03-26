From: akpm@linux-foundation.org
Subject: [merged] blackfin-enable-debug_section_mismatch.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:36:01 -0400
Message-ID: <201003261937.o2QJb0Gu016568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626Ab0CZThD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     blackfin: enable DEBUG_SECTION_MISMATCH
has been removed from the -mm tree.  Its filename was
     blackfin-enable-debug_section_mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin: enable DEBUG_SECTION_MISMATCH
From: Mike Frysinger <vapier@gentoo.org>

We see only one section mismatch now after thousands of randconfigs, and a
bug has been filed about that one.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~blackfin-enable-debug_section_mismatch lib/Kconfig.debug
--- a/lib/Kconfig.debug~blackfin-enable-debug_section_mismatch
+++ a/lib/Kconfig.debug
@@ -103,7 +103,8 @@ config HEADERS_CHECK
 
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
-	depends on UNDEFINED
+	depends on UNDEFINED || (BLACKFIN)
+	default y
 	# This option is on purpose disabled for now.
 	# It will be enabled when we are down to a reasonable number
 	# of section mismatch warnings (< 10 for an allyesconfig build)
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
nommu-allow-private-mappings-of-read-only-devices.patch
fbdev-bfin-lq035q1-fb-respect-new-ppi-mode-platform-field.patch


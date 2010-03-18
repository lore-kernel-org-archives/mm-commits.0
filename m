From: akpm@linux-foundation.org
Subject: + blackfin-enable-debug_section_mismatch.patch added to -mm tree
Date: Thu, 18 Mar 2010 14:45:14 -0700
Message-ID: <201003182145.o2ILjE1Z017421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704Ab0CRVpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 17:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     blackfin: enable DEBUG_SECTION_MISMATCH
has been added to the -mm tree.  Its filename is
     blackfin-enable-debug_section_mismatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
blackfin-enable-debug_section_mismatch.patch
linux-next.patch
nommu-allow-private-mappings-of-read-only-devices.patch
fbdev-bfin-lq035q1-fb-respect-new-ppi-mode-platform-field.patch


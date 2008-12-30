From: akpm@linux-foundation.org
Subject: + remove-obsolete-config_resources_64bit.patch added to -mm tree
Date: Tue, 30 Dec 2008 15:53:35 -0800
Message-ID: <200812302353.mBUNramP020257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbYL3XyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:54:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, jeremy@goop.org


The patch titled
     Remove obsolete CONFIG_RESOURCES_64BIT
has been added to the -mm tree.  Its filename is
     remove-obsolete-config_resources_64bit.patch

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
Subject: Remove obsolete CONFIG_RESOURCES_64BIT
From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 8308c54d7e312f7a03e2ce2057d0837e6fe3843f ("generic: redefine
resource_size_t as phys_addr_t") made CONFIG_RESOURCES_64BIT obsolete, but
didn't remove it. Remove it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/Kconfig~remove-obsolete-config_resources_64bit mm/Kconfig
--- a/mm/Kconfig~remove-obsolete-config_resources_64bit
+++ a/mm/Kconfig
@@ -181,12 +181,6 @@ config MIGRATION
 	  example on NUMA systems to put pages nearer to the processors accessing
 	  the page.
 
-config RESOURCES_64BIT
-	bool "64 bit Memory and IO resources (EXPERIMENTAL)" if (!64BIT && EXPERIMENTAL)
-	default 64BIT
-	help
-	  This option allows memory and IO resources to be 64 bit.

From: akpm@linux-foundation.org
Subject: - remove-obsolete-config_resources_64bit.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:16 -0800
Message-ID: <200901072216.n07MGGFH015958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760927AbZAGWQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     Remove obsolete CONFIG_RESOURCES_64BIT
has been removed from the -mm tree.  Its filename was
     remove-obsolete-config_resources_64bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

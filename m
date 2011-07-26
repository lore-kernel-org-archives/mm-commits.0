From: akpm@linux-foundation.org
Subject: [merged] geode-reflect-mfgpt-dependency-on-mfd.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:16 -0700
Message-ID: <201107260754.p6Q7sJYQ003341__28270.53277656$1311666963$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252Ab1GZHz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp@redfish-solutions.com, alex@ozo.com, dilinger@queued.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     geode: reflect mfgpt dependency on mfd
has been removed from the -mm tree.  Its filename was
     geode-reflect-mfgpt-dependency-on-mfd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: geode: reflect mfgpt dependency on mfd
From: Philip A. Prindeville <philipp@redfish-solutions.com>

As stated in drivers/mfd/cs5535-mfd.c, the mfd driver exposes the BARs
which then make the GPIO, MFGPT, ACPI, etc.  all visible to the system.

So the dependencies of the MFGPT stuff have changed, and most people
expect Kconfig to bring in the necessary dependencies.  Without them, the
module fails to load and most people don't understand why because the
details of the rewrite aren't captured anywhere most people who know to
look.

This dependency needs to be reflected in Kconfig.

Signed-off-by: Philip A. Prindeville <philipp@redfish-solutions.com>
Acked-by: Alexandros C. Couloumbis <alex@ozo.com>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/misc/Kconfig~geode-reflect-mfgpt-dependency-on-mfd drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~geode-reflect-mfgpt-dependency-on-mfd
+++ a/drivers/misc/Kconfig
@@ -245,8 +245,7 @@ config SGI_XP
 
 config CS5535_MFGPT
 	tristate "CS5535/CS5536 Geode Multi-Function General Purpose Timer (MFGPT) support"
-	depends on PCI
-	depends on X86
+	depends on PCI && X86 && MFD_CS5535
 	default n
 	help
 	  This driver provides access to MFGPT functionality for other
_

Patches currently in -mm which might be from philipp@redfish-solutions.com are

origin.patch


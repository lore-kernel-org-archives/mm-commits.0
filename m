From: akpm@linux-foundation.org
Subject: + geode-reflect-mfgpt-dependency-on-mfd.patch added to -mm tree
Date: Wed, 29 Jun 2011 12:43:21 -0700
Message-ID: <201106291943.p5TJhLoq007407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932098Ab1F2ToQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 15:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp@redfish-solutions.com, alex@ozo.com, dilinger@queued.net


The patch titled
     geode: reflect mfgpt dependency on mfd
has been added to the -mm tree.  Its filename is
     geode-reflect-mfgpt-dependency-on-mfd.patch

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
Subject: geode: reflect mfgpt dependency on mfd
From: Philip A. Prindeville <philipp@redfish-solutions.com>

As stated in drivers/mfd/cs5535-mfd.c, the mfd driver exposes the BARs
which then make the GPIO, MFGPT, ACPI, etc.  all visible to the system.

This dependency needs to be reflected in Kconfig.

Signed-off-by: Philip A. Prindeville <philipp@redfish-solutions.com>
Acked-by: Alexandros C. Couloumbis <alex@ozo.com>
Acked-by: Andres Salomon <dilinger@queued.net>
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

geode-reflect-mfgpt-dependency-on-mfd.patch


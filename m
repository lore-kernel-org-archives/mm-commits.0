From: akpm@linux-foundation.org
Subject: + booke_wdt-fix-build-unconstify-watchdog_info.patch added to -mm tree
Date: Mon, 26 Apr 2010 15:59:53 -0700
Message-ID: <201004262259.o3QMxrY1024704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471Ab0DZXAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 19:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, galak@kernel.crashing.org, wim@iguana.be


The patch titled
     booke_wdt: fix build - unconstify watchdog_info
has been added to the -mm tree.  Its filename is
     booke_wdt-fix-build-unconstify-watchdog_info.patch

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
Subject: booke_wdt: fix build - unconstify watchdog_info
From: Anton Vorontsov <avorontsov@mvista.com>

commit 42747d712de56cf2087b702d2ad90af114c53138 ("[WATCHDOG] watchdog_info
constify") introduced the following build failure:

   CC      booke_wdt.o
 booke_wdt.c: In function 'booke_wdt_init':
 booke_wdt.c:220: error: assignment of read-only variable 'ident'

Fix this by removing 'const' qualifier from watchdog_info struct.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/booke_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/watchdog/booke_wdt.c~booke_wdt-fix-build-unconstify-watchdog_info drivers/watchdog/booke_wdt.c
--- a/drivers/watchdog/booke_wdt.c~booke_wdt-fix-build-unconstify-watchdog_info
+++ a/drivers/watchdog/booke_wdt.c
@@ -121,7 +121,7 @@ static ssize_t booke_wdt_write(struct fi
 	return count;
 }
 
-static const struct watchdog_info ident = {
+static struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity = "PowerPC Book-E Watchdog",
 };
_

Patches currently in -mm which might be from avorontsov@mvista.com are

origin.patch
booke_wdt-fix-build-unconstify-watchdog_info.patch
sdhci-pltfm-implement-platform-data-passing-fix.patch


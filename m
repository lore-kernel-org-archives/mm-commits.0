From: akpm@linux-foundation.org
Subject: [merged] booke_wdt-fix-build-unconstify-watchdog_info.patch removed from -mm tree
Date: Thu, 29 Apr 2010 13:56:49 -0400
Message-ID: <201004292058.o3TKwMsW011784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757115Ab0D3RJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@mvista.com, galak@kernel.crashing.org, stable@kernel.org, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     booke_wdt: fix build - unconstify watchdog_info
has been removed from the -mm tree.  Its filename was
     booke_wdt-fix-build-unconstify-watchdog_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Cc: <stable@kernel.org>
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
linux-next.patch
sdhci-pltfm-implement-platform-data-passing-fix.patch


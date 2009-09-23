From: akpm@linux-foundation.org
Subject: [merged] mmc-power-off-once-at-removal.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:54:33 -0700
Message-ID: <200909231954.n8NJsXVU000963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbZIWUIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:08:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-denis.2.karpov@nokia.com, adrian.hunter@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, linux-mmc@vger.kernel.org, madhu.cr@ti.com, matt@console-pimps.org, philipl@overt.


The patch titled
     mmc: power off once at removal
has been removed from the -mm tree.  Its filename was
     mmc-power-off-once-at-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: power off once at removal
From: Denis Karpov <ext-denis.2.karpov@nokia.com>

Fix MMC host stop sequence: power off once.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philip Langdale <philipl@overt.org>
Cc: "Madhusudhan" <madhu.cr@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/mmc/core/core.c~mmc-power-off-once-at-removal drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-power-off-once-at-removal
+++ a/drivers/mmc/core/core.c
@@ -1143,6 +1143,8 @@ void mmc_stop_host(struct mmc_host *host
 		mmc_claim_host(host);
 		mmc_detach_bus(host);
 		mmc_release_host(host);
+		mmc_bus_put(host);
+		return;
 	}
 	mmc_bus_put(host);
 
_

Patches currently in -mm which might be from ext-denis.2.karpov@nokia.com are

origin.patch


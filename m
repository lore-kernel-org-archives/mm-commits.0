From: akpm@linux-foundation.org
Subject: - pnp-remove-redundant-pnp_can_configure-check.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:40 -0700
Message-ID: <200806232103.m5NL3e2G016208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758718AbYFWVEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:04:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commits@v


The patch titled
     pnp: remove redundant pnp_can_configure() check
has been removed from the -mm tree.  Its filename was
     pnp-remove-redundant-pnp_can_configure-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: remove redundant pnp_can_configure() check
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

pnp_assign_resources() is static and the only caller checks
pnp_can_configure() before calling it, so no need to do it again.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/manager.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/pnp/manager.c~pnp-remove-redundant-pnp_can_configure-check drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-remove-redundant-pnp_can_configure-check
+++ a/drivers/pnp/manager.c
@@ -231,9 +231,6 @@ static int pnp_assign_resources(struct p
 	struct pnp_dma *dma;
 	int nport = 0, nmem = 0, nirq = 0, ndma = 0;
 
-	if (!pnp_can_configure(dev))
-		return -ENODEV;

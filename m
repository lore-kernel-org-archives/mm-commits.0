From: akpm@linux-foundation.org
Subject: [merged] dca-remove-unneeded-null-check.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:04:13 -0800
Message-ID: <201101132006.p0DK6s1d029783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933614Ab1AMUHZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:07:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, davem@davemloft.net, maciej.sosnowski@intel.com, mm-commits@vger.kernel.org


The patch titled
     dca: remove unneeded NULL check
has been removed from the -mm tree.  Its filename was
     dca-remove-unneeded-null-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dca: remove unneeded NULL check
From: Dan Carpenter <error27@gmail.com>

The return here doesn't release the locks or re-enable IRQs.  But as
Andrew Morton points out, domain is never NULL.  list_first_entry()
essentially never returns NULL and also we already verified that the list
is not empty.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dca/dca-core.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/dca/dca-core.c~dca-remove-unneeded-null-check drivers/dca/dca-core.c
--- a/drivers/dca/dca-core.c~dca-remove-unneeded-null-check
+++ a/drivers/dca/dca-core.c
@@ -110,8 +110,6 @@ static void unregister_dca_providers(voi
 
 	/* at this point only one domain in the list is expected */
 	domain = list_first_entry(&dca_domains, struct dca_domain, node);
-	if (!domain)
-		return;
 
 	list_for_each_entry_safe(dca, _dca, &domain->dca_providers, node) {
 		list_del(&dca->node);
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch


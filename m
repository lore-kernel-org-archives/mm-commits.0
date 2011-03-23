From: akpm@linux-foundation.org
Subject: [merged] drivers-dca-dca-corec-use-list_move-instead-of-list_del-list_add-combination.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:17 -0700
Message-ID: <201103232042.p2NKgrb0028808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754277Ab1CWUzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, maciej.sosnowski@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/dca/dca-core.c: use list_move() instead of list_del()/list_add() combination
has been removed from the -mm tree.  Its filename was
     drivers-dca-dca-corec-use-list_move-instead-of-list_del-list_add-combination.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/dca/dca-core.c: use list_move() instead of list_del()/list_add() combination
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dca/dca-core.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/dca/dca-core.c~drivers-dca-dca-corec-use-list_move-instead-of-list_del-list_add-combination drivers/dca/dca-core.c
--- a/drivers/dca/dca-core.c~drivers-dca-dca-corec-use-list_move-instead-of-list_del-list_add-combination
+++ a/drivers/dca/dca-core.c
@@ -111,10 +111,8 @@ static void unregister_dca_providers(voi
 	/* at this point only one domain in the list is expected */
 	domain = list_first_entry(&dca_domains, struct dca_domain, node);
 
-	list_for_each_entry_safe(dca, _dca, &domain->dca_providers, node) {
-		list_del(&dca->node);
-		list_add(&dca->node, &unregistered_providers);
-	}
+	list_for_each_entry_safe(dca, _dca, &domain->dca_providers, node)
+		list_move(&dca->node, &unregistered_providers);
 
 	dca_free_domain(domain);
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch
linux-next.patch


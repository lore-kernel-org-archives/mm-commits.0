From: akpm@linux-foundation.org
Subject: + drivers-dca-dca-corec-use-list_move-instead-of-list_del-list_add-combination.patch added to -mm tree
Date: Tue, 15 Mar 2011 16:18:16 -0700
Message-ID: <201103152318.p2FNIGsh018377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540Ab1COXSp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Mar 2011 19:18:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, maciej.sosnowski@intel.com


The patch titled
     drivers/dca/dca-core.c: use list_move() instead of list_del()/list_add() combination
has been added to the -mm tree.  Its filename is
     drivers-dca-dca-corec-use-list_move-instead-of-list_del-list_add-combination.patch

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

cgroups-if-you-list_empty-a-head-then-dont-list_del-it.patch
mm-page_allocc-use-list_move-instead-of-list_del-list_add-combination.patch
drivers-dca-dca-corec-use-list_move-instead-of-list_del-list_add-combination.patch
listh-add-debug-version-of-list_empty.patch


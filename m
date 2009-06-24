From: akpm@linux-foundation.org
Subject: [merged] partitions-fix-broken-uevent_suppress-conversion.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:10:54 -0700
Message-ID: <200906241910.n5OJAsl1011139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758782AbZFXTLx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:11:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, greg@kroah.com, kay.sievers@vrfy.org, stable@kernel.org, tom.leiming@gmail.com, mm-commits@vger.kernel.org


The patch titled
     partitions: fix broken uevent_suppress conversion
has been removed from the -mm tree.  Its filename was
     partitions-fix-broken-uevent_suppress-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: partitions: fix broken uevent_suppress conversion
From: Heiko Carstens <heiko.carstens@de.ibm.com>

git commit f67f129e "Driver core: implement uevent suppress in kobject"
contains this chunk for fs/partitions/check.c:

 	/* suppress uevent if the disk supresses it */
-	if (!ddev->uevent_suppress)
+	if (!dev_get_uevent_suppress(pdev))
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);

However that should have been

-	if (!ddev->uevent_suppress)
+	if (!dev_get_uevent_suppress(ddev))

Acked-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/partitions/check.c~partitions-fix-broken-uevent_suppress-conversion fs/partitions/check.c
--- a/fs/partitions/check.c~partitions-fix-broken-uevent_suppress-conversion
+++ a/fs/partitions/check.c
@@ -436,7 +436,7 @@ struct hd_struct *add_partition(struct g
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
-	if (!dev_get_uevent_suppress(pdev))
+	if (!dev_get_uevent_suppress(ddev))
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);
 
 	return p;
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch


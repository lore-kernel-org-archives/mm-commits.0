From: akpm@linux-foundation.org
Subject: + partitions-fix-broken-uevent_suppress-conversion.patch added to -mm tree
Date: Thu, 11 Jun 2009 15:44:07 -0700
Message-ID: <200906112244.n5BMi79J020277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733AbZFKWpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 18:45:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, greg@kroah.com, kay.sievers@vrfy.org, stable@kernel.org, tom.leiming@gmail.com


The patch titled
     partitions: fix broken uevent_suppress conversion
has been added to the -mm tree.  Its filename is
     partitions-fix-broken-uevent_suppress-conversion.patch

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
partitions-fix-broken-uevent_suppress-conversion.patch
migration-only-migrate_prep-once-per-move_pages.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch


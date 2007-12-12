From: akpm@linux-foundation.org
Subject: + pktcdvd-add-kobject_put-when-kobject-register-fails.patch added to -mm tree
Date: Wed, 12 Dec 2007 02:13:32 -0800
Message-ID: <200712121013.lBCADWVE004663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758623AbXLLKPP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 05:15:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, greg@kroah.com, jens.axboe@oracle.com, penberg@cs.helsinki.fi, petero2@telia.com


The patch titled
     pktcdvd: add kobject_put when kobject register fails
has been added to the -mm tree.  Its filename is
     pktcdvd-add-kobject_put-when-kobject-register-fails.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pktcdvd: add kobject_put when kobject register fails
From: Dave Young <hidave.darkstar@gmail.com>

In kobject_register, the kobject reference is get in kobject_init, and then
kobject_add.  If kobject_add fail, it will only cleanup the reference got
by itself.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Greg KH <greg@kroah.com>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-add-kobject_put-when-kobject-register-fails drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-add-kobject_put-when-kobject-register-fails
+++ a/drivers/block/pktcdvd.c
@@ -117,8 +117,10 @@ static struct pktcdvd_kobj* pkt_kobj_cre
 	p->kobj.parent = parent;
 	p->kobj.ktype = ktype;
 	p->pd = pd;
-	if (kobject_register(&p->kobj) != 0)
+	if (kobject_register(&p->kobj) != 0) {
+		kobject_put(&p->kobj);
 		return NULL;
+	}
 	return p;
 }
 /*
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

git-cpufreq.patch
bluetooth-hidp_process_hid_control-remove-unnecessary-parameter-dealing.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
pktcdvd-add-kobject_put-when-kobject-register-fails.patch

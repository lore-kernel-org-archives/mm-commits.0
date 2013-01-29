From: akpm@linux-foundation.org
Subject: + atm-nicstar-dont-use-idr_remove_all.patch added to -mm tree
Date: Mon, 28 Jan 2013 16:07:00 -0800
Message-ID: <20130129000701.198E431C00F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:34666 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3A2AHC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 19:07:02 -0500
Received: by mail-ia0-f202.google.com with SMTP id p22so626684iad.3
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 16:07:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, chas@cmf.nrl.navy.mil


The patch titled
     Subject: atm/nicstar: don't use idr_remove_all()
has been added to the -mm tree.  Its filename is
     atm-nicstar-dont-use-idr_remove_all.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: atm/nicstar: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/nicstar.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/atm/nicstar.c~atm-nicstar-dont-use-idr_remove_all drivers/atm/nicstar.c
--- a/drivers/atm/nicstar.c~atm-nicstar-dont-use-idr_remove_all
+++ a/drivers/atm/nicstar.c
@@ -251,7 +251,6 @@ static void nicstar_remove_one(struct pc
 		if (card->scd2vc[j] != NULL)
 			free_scq(card, card->scd2vc[j]->scq, card->scd2vc[j]->tx_vcc);
 	}
-	idr_remove_all(&card->idr);
 	idr_destroy(&card->idr);
 	pci_free_consistent(card->pcidev, NS_RSQSIZE + NS_RSQ_ALIGNMENT,
 			    card->rsq.org, card->rsq.dma);
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
idr-make-idr_destroy-imply-idr_remove_all.patch
atm-nicstar-dont-use-idr_remove_all.patch
block-loop-dont-use-idr_remove_all.patch
firewire-dont-use-idr_remove_all.patch
drm-dont-use-idr_remove_all.patch
dm-dont-use-idr_remove_all.patch
remoteproc-dont-use-idr_remove_all.patch
rpmsg-dont-use-idr_remove_all.patch
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch


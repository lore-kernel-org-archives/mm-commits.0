From: akpm@linux-foundation.org
Subject: + idr-rename-max_level-to-max_idr_level-fix-fix-2-fix.patch added to -mm tree
Date: Mon, 24 Sep 2012 13:04:42 -0700
Message-ID: <20120924200442.94879100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:51788 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab2IXUEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 16:04:43 -0400
Received: by ghbz15 with SMTP id z15so804116ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 13:04:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, roland@purestorage.com


The patch titled
     Subject: idr-rename-max_level-to-max_idr_level-fix-fix-2-fix
has been added to the -mm tree.  Its filename is
     idr-rename-max_level-to-max_idr_level-fix-fix-2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: idr-rename-max_level-to-max_idr_level-fix-fix-2-fix

IB/mlx4: fix for MAX_ID_MASK to MAX_IDR_MASK name change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/mlx4/cm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/infiniband/hw/mlx4/cm.c~idr-rename-max_level-to-max_idr_level-fix-fix-2-fix drivers/infiniband/hw/mlx4/cm.c
--- a/drivers/infiniband/hw/mlx4/cm.c~idr-rename-max_level-to-max_idr_level-fix-fix-2-fix
+++ a/drivers/infiniband/hw/mlx4/cm.c
@@ -225,7 +225,7 @@ id_map_alloc(struct ib_device *ibdev, in
 		ret = idr_get_new_above(&sriov->pv_id_table, ent,
 					next_id, &id);
 		if (!ret) {
-			next_id = ((unsigned) id + 1) & MAX_ID_MASK;
+			next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
 			ent->pv_cm_id = (u32)id;
 			sl_id_map_add(ibdev, ent);
 		}
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

linux-next.patch
rbtree-empty-nodes-have-no-color-fix.patch
atomic-implement-generic-atomic_dec_if_positive.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2-fix.patch
rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix.patch
rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix.patch


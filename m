From: akpm@linux-foundation.org
Subject: [folded-dropped] idr-rename-max_level-to-max_idr_level-fix-fix-2-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:57:07 -0700
Message-ID: <20121004235707.E77B3100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42195 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2JDX5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:57:10 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so129579vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:57:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, roland@purestorage.com, mm-commits@vger.kernel.org


The patch titled
     Subject: idr-rename-max_level-to-max_idr_level-fix-fix-2-fix
has been removed from the -mm tree.  Its filename was
     idr-rename-max_level-to-max_idr_level-fix-fix-2-fix.patch

This patch was dropped because it was folded into idr-rename-max_level-to-max_idr_level.patch

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

origin.patch
idr-rename-max_level-to-max_idr_level.patch
rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix.patch
rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix.patch
coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr.patch
compat-move-compat_siginfo_t-definition-to-asm-compath.patch
coredump-add-a-new-elf-note-with-siginfo-of-the-signal.patch
coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files.patch


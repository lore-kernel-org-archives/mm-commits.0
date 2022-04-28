Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 020C3C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 22:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbiD1WD0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 18:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352714AbiD1WDZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 18:03:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9A6260B
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 15:00:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58445B83075
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 22:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06473C385AD;
        Thu, 28 Apr 2022 22:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651183206;
        bh=17Qo0HVWD58O2EV0XI9m51w6B+GNIfy3U3iqnPsCRTE=;
        h=Date:To:From:Subject:From;
        b=IlVUq0zY+nRaYmitoIeWiT06MUl894ISOF9eM75RBWlQqzfYpORAJx/ixMrUVD9uX
         JGogGnXDOwVQ0h90VyNT+X5V6oaKJ3CyZnlpO23mUQDPJ98TCbp6XkD4ZWyIIyDw/b
         rOtfdhG9QLDN0nRrm87bHW9tmbFm/kGXbgJFgGAI=
Date:   Thu, 28 Apr 2022 15:00:05 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, heming.zhao@suse.com, ghe@suse.com,
        gechangwei@live.cn, ocfs2-devel@oss.oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-change-return-type-of-ocfs2_resmap_init.patch added to -mm tree
Message-Id: <20220428220006.06473C385AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: change return type of ocfs2_resmap_init
has been added to the -mm tree.  Its filename is
     ocfs2-change-return-type-of-ocfs2_resmap_init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-change-return-type-of-ocfs2_resmap_init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-change-return-type-of-ocfs2_resmap_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: change return type of ocfs2_resmap_init

Since ocfs2_resmap_init() always return 0, change it to void.

Link: https://lkml.kernel.org/r/20220424130952.2436-3-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/reservations.c |    4 +---
 fs/ocfs2/reservations.h |    9 ++-------
 fs/ocfs2/super.c        |    6 +-----
 3 files changed, 4 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/reservations.c~ocfs2-change-return-type-of-ocfs2_resmap_init
+++ a/fs/ocfs2/reservations.c
@@ -198,7 +198,7 @@ void ocfs2_resv_set_type(struct ocfs2_al
 	resv->r_flags |= flags;
 }
 
-int ocfs2_resmap_init(struct ocfs2_super *osb,
+void ocfs2_resmap_init(struct ocfs2_super *osb,
 		      struct ocfs2_reservation_map *resmap)
 {
 	memset(resmap, 0, sizeof(*resmap));
@@ -207,8 +207,6 @@ int ocfs2_resmap_init(struct ocfs2_super
 	resmap->m_reservations = RB_ROOT;
 	/* m_bitmap_len is initialized to zero by the above memset. */
 	INIT_LIST_HEAD(&resmap->m_lru);
-
-	return 0;
 }
 
 static void ocfs2_resv_mark_lru(struct ocfs2_reservation_map *resmap,
--- a/fs/ocfs2/reservations.h~ocfs2-change-return-type-of-ocfs2_resmap_init
+++ a/fs/ocfs2/reservations.h
@@ -73,15 +73,10 @@ void ocfs2_resv_discard(struct ocfs2_res
 
 /**
  * ocfs2_resmap_init() - Initialize fields of a reservations bitmap
+ * @osb: struct ocfs2_super to be saved in resmap
  * @resmap: struct ocfs2_reservation_map to initialize
- * @obj: unused for now
- * @ops: unused for now
- * @max_bitmap_bytes: Maximum size of the bitmap (typically blocksize)
- *
- * Only possible return value other than '0' is -ENOMEM for failure to
- * allocation mirror bitmap.
  */
-int ocfs2_resmap_init(struct ocfs2_super *osb,
+void ocfs2_resmap_init(struct ocfs2_super *osb,
 		      struct ocfs2_reservation_map *resmap);
 
 /**
--- a/fs/ocfs2/super.c~ocfs2-change-return-type-of-ocfs2_resmap_init
+++ a/fs/ocfs2/super.c
@@ -2110,11 +2110,7 @@ static int ocfs2_initialize_super(struct
 
 	init_waitqueue_head(&osb->osb_mount_event);
 
-	status = ocfs2_resmap_init(osb, &osb->osb_la_resmap);
-	if (status) {
-		mlog_errno(status);
-		goto bail;
-	}
+	ocfs2_resmap_init(osb, &osb->osb_la_resmap);
 
 	osb->vol_label = kmalloc(OCFS2_MAX_VOL_LABEL_LEN, GFP_KERNEL);
 	if (!osb->vol_label) {
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-fix-mounting-crash-if-journal-is-not-alloced.patch
ocfs2-change-return-type-of-ocfs2_resmap_init.patch
ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch
ocfs2-ocfs2_mount_volume-does-cleanup-job-before-return-error.patch
ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch


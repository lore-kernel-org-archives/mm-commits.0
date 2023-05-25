Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0722C77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 17:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjEYRga (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 13:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjEYRg3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 13:36:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE0D194
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 10:36:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47B98647F2
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 17:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995FAC433EF;
        Thu, 25 May 2023 17:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685036187;
        bh=Ciy+i8AR+hv+8ukdIWKSA4eTFnIgWgXL740YGdCWqEw=;
        h=Date:To:From:Subject:From;
        b=FWp//XYNJION3VlXiPdr64FiBMvUI8rW1Eha+R9ncAUihu6K3vAR6/kH9HoXel6Ev
         KM2RkGfNR0iJGVSBTz0/ru1LVGOqABUwpWSwyo7kej85ZxrOqwzZ/jfNVZz63afAQd
         4ILkrKm054XdgrfD4FpY6yYOTpsGlWl3ErCtxV3g=
Date:   Thu, 25 May 2023 10:36:26 -0700
To:     mm-commits@vger.kernel.org, linkinjeon@kernel.org,
        brauner@kernel.org, bagasdotme@gmail.com, anton@tuxera.com,
        almaz.alexandrovich@paragon-software.com, listdansp@mail.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] ntfs-do-not-dereference-a-null-ctx-on-error.patch removed from -mm tree
Message-Id: <20230525173627.995FAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ntfs: do not dereference a null ctx on error
has been removed from the -mm tree.  Its filename was
     ntfs-do-not-dereference-a-null-ctx-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Danila Chernetsov <listdansp@mail.ru>
Subject: ntfs: do not dereference a null ctx on error
Date: Fri, 7 Apr 2023 19:44:33 +0000

In ntfs_mft_data_extend_allocation_nolock(), if an error condition occurs
prior to 'ctx' being set to a non-NULL value, avoid dereferencing the NULL
'ctx' pointer in error handling.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20230407194433.25659-1-listdansp@mail.ru
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/mft.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

--- a/fs/ntfs/mft.c~ntfs-do-not-dereference-a-null-ctx-on-error
+++ a/fs/ntfs/mft.c
@@ -1955,36 +1955,40 @@ undo_alloc:
 				"attribute.%s", es);
 		NVolSetErrors(vol);
 	}
-	a = ctx->attr;
+
 	if (ntfs_rl_truncate_nolock(vol, &mft_ni->runlist, old_last_vcn)) {
 		ntfs_error(vol->sb, "Failed to truncate mft data attribute "
 				"runlist.%s", es);
 		NVolSetErrors(vol);
 	}
-	if (mp_rebuilt && !IS_ERR(ctx->mrec)) {
-		if (ntfs_mapping_pairs_build(vol, (u8*)a + le16_to_cpu(
+	if (ctx) {
+		a = ctx->attr;
+		if (mp_rebuilt && !IS_ERR(ctx->mrec)) {
+			if (ntfs_mapping_pairs_build(vol, (u8*)a + le16_to_cpu(
 				a->data.non_resident.mapping_pairs_offset),
 				old_alen - le16_to_cpu(
-				a->data.non_resident.mapping_pairs_offset),
+					a->data.non_resident.mapping_pairs_offset),
 				rl2, ll, -1, NULL)) {
-			ntfs_error(vol->sb, "Failed to restore mapping pairs "
+				ntfs_error(vol->sb, "Failed to restore mapping pairs "
 					"array.%s", es);
-			NVolSetErrors(vol);
-		}
-		if (ntfs_attr_record_resize(ctx->mrec, a, old_alen)) {
-			ntfs_error(vol->sb, "Failed to restore attribute "
+				NVolSetErrors(vol);
+			}
+			if (ntfs_attr_record_resize(ctx->mrec, a, old_alen)) {
+				ntfs_error(vol->sb, "Failed to restore attribute "
 					"record.%s", es);
-			NVolSetErrors(vol);
+				NVolSetErrors(vol);
+			}
+			flush_dcache_mft_record_page(ctx->ntfs_ino);
+			mark_mft_record_dirty(ctx->ntfs_ino);
 		}
-		flush_dcache_mft_record_page(ctx->ntfs_ino);
-		mark_mft_record_dirty(ctx->ntfs_ino);
-	} else if (IS_ERR(ctx->mrec)) {
-		ntfs_error(vol->sb, "Failed to restore attribute search "
+		else if (IS_ERR(ctx->mrec)) {
+			ntfs_error(vol->sb, "Failed to restore attribute search "
 				"context.%s", es);
-		NVolSetErrors(vol);
+			NVolSetErrors(vol);
+		}
+		if (ctx)
+			ntfs_attr_put_search_ctx(ctx);
 	}
-	if (ctx)
-		ntfs_attr_put_search_ctx(ctx);
 	if (!IS_ERR(mrec))
 		unmap_mft_record(mft_ni);
 	up_write(&mft_ni->runlist.lock);
_

Patches currently in -mm which might be from listdansp@mail.ru are



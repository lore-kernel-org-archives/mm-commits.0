Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AAFC77B7F
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 21:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjECVII (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 May 2023 17:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjECVIH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2023 17:08:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C16F7D99
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 14:08:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD1EF627A5
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 21:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15242C433EF;
        Wed,  3 May 2023 21:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683148085;
        bh=fZZvmfDs3hYW3xm/gY5hoEodS0GguB4p7mweSkUTFCc=;
        h=Date:To:From:Subject:From;
        b=Qm4kYj6d/LJ5nW+fv/Bt7RA6hjZtEwGtpnvJqJ7zYULFwyi27bsMxeq0N9SnhsQqA
         A9JJ9bTjMtwz561GU7Ogho7kv2m2OrPFIEcBjeljf3WzhinN7qjI+2lE5XA9g6ePQF
         iepMs1IdQ/9ZA6qzfhxr1FSxNo008j3qbPCozLlc=
Date:   Wed, 03 May 2023 14:08:04 -0700
To:     mm-commits@vger.kernel.org, brauner@kernel.org,
        bagasdotme@gmail.com, anton@tuxera.com,
        almaz.alexandrovich@paragon-software.com, listdansp@mail.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs-do-not-dereference-a-null-ctx-on-error.patch added to mm-nonmm-unstable branch
Message-Id: <20230503210805.15242C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: do not dereference a null ctx on error
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ntfs-do-not-dereference-a-null-ctx-on-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs-do-not-dereference-a-null-ctx-on-error.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

ntfs-do-not-dereference-a-null-ctx-on-error.patch


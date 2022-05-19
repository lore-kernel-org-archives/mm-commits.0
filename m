Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67579C43217
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbiESW2l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245514AbiESW2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED12A7763
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70ABB61717
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C528EC385B8;
        Thu, 19 May 2022 22:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999255;
        bh=ie0S233fT7iDtvdznG3clvvd5yquGv+m6uF4IOj+UuA=;
        h=Date:To:From:Subject:From;
        b=k7Q5Tc2l/ID379mIG/krdK5CYLQfWIC9dFs9rdWqM/JGplKBm0Rb9z66NbV/vdteR
         T3DAs2XPVhQCB9rUUqm/NidpmIm0idRXHdnxF5RzwozgReMD3Gl2HAS2FyK9hOhMti
         5bvw7MYXWhtfLJqZoLizBQTuP14ldu52albvPKNo=
Date:   Thu, 19 May 2022 15:27:35 -0700
To:     mm-commits@vger.kernel.org, anton@tuxera.com,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-ntfs-remove-redundant-variable-idx.patch removed from -mm tree
Message-Id: <20220519222735.C528EC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/ntfs: remove redundant variable idx
has been removed from the -mm tree.  Its filename was
     fs-ntfs-remove-redundant-variable-idx.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: fs/ntfs: remove redundant variable idx
Date: Tue, 17 May 2022 10:36:46 +0100

The variable idx is assigned a value and is never read.  The variable is
not used and is redundant, remove it.

Cleans up clang scan build warning:
warning: Although the value stored to 'idx' is used in the enclosing
expression, the value is never actually read from 'idx'
[deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20220517093646.93628-2-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ntfs/file.c~fs-ntfs-remove-redundant-variable-idx
+++ a/fs/ntfs/file.c
@@ -1772,11 +1772,11 @@ static ssize_t ntfs_perform_write(struct
 	last_vcn = -1;
 	do {
 		VCN vcn;
-		pgoff_t idx, start_idx;
+		pgoff_t start_idx;
 		unsigned ofs, do_pages, u;
 		size_t copied;
 
-		start_idx = idx = pos >> PAGE_SHIFT;
+		start_idx = pos >> PAGE_SHIFT;
 		ofs = pos & ~PAGE_MASK;
 		bytes = PAGE_SIZE - ofs;
 		do_pages = 1;
_

Patches currently in -mm which might be from colin.i.king@gmail.com are



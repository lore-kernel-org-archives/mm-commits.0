Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7D4C388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 20:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09FFE2063A
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 20:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uubsoFoS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgKJUbp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 15:31:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgKJUbo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 15:31:44 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8F01205CA;
        Tue, 10 Nov 2020 20:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605040304;
        bh=U6zCPD4uZgr+C9wiwJLskb2sIgWroqD5VRo8gBoRCi0=;
        h=Date:From:To:Subject:From;
        b=uubsoFoSTd34lFTEzRnZozufwDO8qZ6itpTeWC8Cc/FD31RMYLobUUC1+DSC/PVBz
         4KYXO/0DDePU56QbUx9tWzFS+dQ+o5lGmkVVqg160VBjnfGCUfreEGmIZ3TfU+rpC6
         XpvnLezrVVh+MMhpPGwSXUQVZquGhMHXtwgZqhBc=
Date:   Tue, 10 Nov 2020 12:31:43 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, anton@tuxera.com,
        mm-commits@vger.kernel.org
Subject:  + fs-ntfs-remove-unused-varible-attr_len.patch added to
 -mm tree
Message-ID: <20201110203143.7qHHiJN2t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ntfs: remove unused varible attr_len
has been added to the -mm tree.  Its filename is
     fs-ntfs-remove-unused-varible-attr_len.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-ntfs-remove-unused-varible-attr_len.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-ntfs-remove-unused-varible-attr_len.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: fs/ntfs: remove unused varible attr_len

This varible isn't used anymore, remove it to skip W=1 warning:
fs/ntfs/inode.c:2350:6: warning: variable `attr_len' set but not used
[-Wunused-but-set-variable]

Link: https://lkml.kernel.org/r/4194376f-898b-b602-81c3-210567712092@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ntfs/inode.c~fs-ntfs-remove-unused-varible-attr_len
+++ a/fs/ntfs/inode.c
@@ -2347,7 +2347,6 @@ int ntfs_truncate(struct inode *vi)
 	ATTR_RECORD *a;
 	const char *te = "  Leaving file length out of sync with i_size.";
 	int err, mp_size, size_change, alloc_change;
-	u32 attr_len;
 
 	ntfs_debug("Entering for inode 0x%lx.", vi->i_ino);
 	BUG_ON(NInoAttr(ni));
@@ -2721,7 +2720,6 @@ do_non_resident_truncate:
 	 * this cannot fail since we are making the attribute smaller thus by
 	 * definition there is enough space to do so.
 	 */
-	attr_len = le32_to_cpu(a->length);
 	err = ntfs_attr_record_resize(m, a, mp_size +
 			le16_to_cpu(a->data.non_resident.mapping_pairs_offset));
 	BUG_ON(err);
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
fs-ntfs-remove-unused-varibles.patch
fs-ntfs-remove-unused-varible-attr_len.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcg-update-page-struct-member-in-comments.patch


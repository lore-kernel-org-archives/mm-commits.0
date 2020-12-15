Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B8AC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80F0D2246B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgLODEs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:04:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbgLODEm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:04:42 -0500
Date:   Mon, 14 Dec 2020 19:03:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001414;
        bh=/KtOPZQRh+M3gtQbQJLjfnWo9DShfPQW8lVfAKezejg=;
        h=From:To:Subject:In-Reply-To:From;
        b=g6KgIc3d/wGQ8mSJwrANRgGlvLmfmYFXrh+ltemxYTlQAlbIy76l+axFdG0dCtO2g
         HW9cCMVVn4QBc3U4zp8cNA7b67t0okcpH1It+1pt30L9yE+/dgFM1rVjQMBwcE37Kz
         uYpeM8ovJcp4+cb/tTQ7cqpUl74r7rLtlrBVSAsg=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        anton@tuxera.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 007/200] fs/ntfs: remove unused variable attr_len
Message-ID: <20201215030334.NAT1gN2Hf%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: fs/ntfs: remove unused variable attr_len

This variable isn't used anymore, remove it to skip W=1 warning:
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

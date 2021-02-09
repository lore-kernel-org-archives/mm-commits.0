Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED37C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 23:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A783F64E45
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 23:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbhBIXI4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Feb 2021 18:08:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234556AbhBIWb4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Feb 2021 17:31:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A19BB64E8A;
        Tue,  9 Feb 2021 21:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612906153;
        bh=X29Eo/MLaoU69les1XOxR3cg4TjFefbxSQ0TxuVo3d8=;
        h=Date:From:To:Subject:From;
        b=Hc+LHF1He5qskMuLzfeVnxZrVCmHIyYRRgjXvu+00k6XI5XeIA5D00VboS9+NmakJ
         SPiIJFYrDsWeh3/4I5GXeS+FMY7GtpBbRVl/PPbGVmH87RLtv/+27hFBT9yoHG53pJ
         +YEDcNeS5s1SaN7mIQkJQ6oG9uDzLBseAGEh/eSg=
Date:   Tue, 09 Feb 2021 13:29:12 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk
Subject:  [folded-merged]
 squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2.patch removed from
 -mm tree
Message-ID: <20210209212912.rGJaPGLtB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2
has been removed from the -mm tree.  Its filename was
     squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2.patch

This patch was dropped because it was folded into squashfs-add-more-sanity-checks-in-xattr-id-lookup.patch

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2

fix checkpatch issue

Link: https://lkml.kernel.org/r/270245655.754655.1612770082682@webmail.123-reg.co.uk
Reported-by: syzbot+2ccea6339d368360800d@syzkaller.appspotmail.com
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/xattr_id.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/xattr_id.c~squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2
+++ a/fs/squashfs/xattr_id.c
@@ -109,7 +109,7 @@ __le64 *squashfs_read_xattr_id_table(str
 		start = le64_to_cpu(table[n]);
 		end = le64_to_cpu(table[n + 1]);
 
-		if(start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
+		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
 			kfree(table);
 			return ERR_PTR(-EINVAL);
 		}
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-avoid-out-of-bounds-writes-in-decompressors.patch
squashfs-add-more-sanity-checks-in-id-lookup.patch
squashfs-add-more-sanity-checks-in-inode-lookup.patch
squashfs-add-more-sanity-checks-in-xattr-id-lookup.patch


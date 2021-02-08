Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78452C433E9
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 21:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BF8264E8F
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 21:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbhBHVud (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Feb 2021 16:50:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236954AbhBHVuD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Feb 2021 16:50:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBAD164E9C;
        Mon,  8 Feb 2021 21:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612820961;
        bh=UdancBrk2MRm7M6tE3i8KNEoLSadlDY8d2+CBNbdbRA=;
        h=Date:From:To:Subject:From;
        b=x3E1E/s9Nqi09haGnxSv1O0/FxupEbPNkXW3XUZFOdlejBX7RfGU0uuaOSMtN8t06
         eEJ9h1S/N0fyvG4PCpK7whvGinjOXDcTPQyXaO8qAjwbySs9NtM/B7Flc7x7kLw95Q
         tEjhaDd4TDDFP9RdH9UjgqADUo+8qioSLtXCl3PE=
Date:   Mon, 08 Feb 2021 13:49:20 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk
Subject:  +
 squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2.patch added to -mm
 tree
Message-ID: <20210208214920.ydg8Ch7IJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2
has been added to the -mm tree.  Its filename is
     squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
squashfs-add-more-sanity-checks-in-inode-lookup-v2.patch
squashfs-add-more-sanity-checks-in-xattr-id-lookup.patch
squashfs-add-more-sanity-checks-in-xattr-id-lookup-v2.patch


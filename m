Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A560DC38142
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 00:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjBAApT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjBAApL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 19:45:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D1151C41
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 16:45:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD8BFB81FBB
        for <mm-commits@vger.kernel.org>; Wed,  1 Feb 2023 00:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FC6C4339B;
        Wed,  1 Feb 2023 00:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212302;
        bh=wEeCIy0ZamP4ha9FYbNoX8FiW3n2BTiiPMrzEPBlYo0=;
        h=Date:To:From:Subject:From;
        b=oU2DCCtd5Vm7/2ssDvCVwEgeGP4JU8Ap5Cm7+44HXn4uxi+UJmHCg/ivtL8ZnmX+Y
         Qjc4WIb5IUkVq20PJwG4suKYzrdzJZdto7o8F0VZFf62a3RCpNWeNBh5DvehRZ1ktp
         XKop9icZ3JAJEu7tgbm8u5R0yVLEGoKFbSHdcXJU=
Date:   Tue, 31 Jan 2023 16:45:02 -0800
To:     mm-commits@vger.kernel.org,
        syzbot+082fa4af80a5bb1a9843@syzkaller.appspotmail.com,
        phillip@squashfs.org.uk, khoroshilov@ispras.ru, pchelkin@ispras.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch removed from -mm tree
Message-Id: <20230201004502.86FC6C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: harden sanity check in squashfs_read_xattr_id_table
has been removed from the -mm tree.  Its filename was
     squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fedor Pchelkin <pchelkin@ispras.ru>
Subject: squashfs: harden sanity check in squashfs_read_xattr_id_table
Date: Tue, 17 Jan 2023 13:52:26 +0300

While mounting a corrupted filesystem, a signed integer '*xattr_ids' can
become less than zero.  This leads to the incorrect computation of 'len'
and 'indexes' values which can cause null-ptr-deref in copy_bio_to_actor()
or out-of-bounds accesses in the next sanity checks inside
squashfs_read_xattr_id_table().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Link: https://lkml.kernel.org/r/20230117105226.329303-2-pchelkin@ispras.ru
Fixes: 506220d2ba21 ("squashfs: add more sanity checks in xattr id lookup")
Reported-by: <syzbot+082fa4af80a5bb1a9843@syzkaller.appspotmail.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/xattr_id.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/xattr_id.c~squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table
+++ a/fs/squashfs/xattr_id.c
@@ -76,7 +76,7 @@ __le64 *squashfs_read_xattr_id_table(str
 	/* Sanity check values */
 
 	/* there is always at least one xattr id */
-	if (*xattr_ids == 0)
+	if (*xattr_ids <= 0)
 		return ERR_PTR(-EINVAL);
 
 	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
_

Patches currently in -mm which might be from pchelkin@ispras.ru are



Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D4DC00A5A
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 00:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjARAgd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjARAfH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2023 19:35:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F30661D58
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 16:04:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BFCAB81A29
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 00:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98D5C433F0;
        Wed, 18 Jan 2023 00:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674000246;
        bh=0hT6SBzUhjO2ZtY67Z+haVDC7Eu7ELX1sXVc7jBjp20=;
        h=Date:To:From:Subject:From;
        b=iqCGF+KUDSu8igOi6TZ2WY7cZH7XPdKcBPjMxXW4gnuC2fRW8ZAiIP6s+UpnygriM
         tEqif0OYdqoRu1RZMqQQuCOgYmGdpc5mX1QNniS0dMiDy+AuNW5LJma2++2kmTMdL5
         h15/XAlFufCoViLcje01n8bbxiU50ySeqigL5oa8=
Date:   Tue, 17 Jan 2023 16:04:06 -0800
To:     mm-commits@vger.kernel.org,
        syzbot+082fa4af80a5bb1a9843@syzkaller.appspotmail.com,
        phillip@squashfs.org.uk, khoroshilov@ispras.ru, pchelkin@ispras.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch added to mm-hotfixes-unstable branch
Message-Id: <20230118000406.C98D5C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: harden sanity check in squashfs_read_xattr_id_table
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch


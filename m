Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B91C07E95
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 21:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06FCE6135E
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 21:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhGJVsG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Jul 2021 17:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhGJVsG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Jul 2021 17:48:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F15E461260;
        Sat, 10 Jul 2021 21:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625953520;
        bh=n04Bq51aFEAr8StsyEaZulycVQcqgIPA62gNIbZSvgw=;
        h=Date:From:To:Subject:From;
        b=d+DK+PsMyIdItVuBXV7Tjhnvwm+A6sxESN0QRSuWUo24K6FUzoj0gG+zGqDLmtoOz
         IT6sI92rffH6z4BEexo9PwBTq6324CbOxietAmUH8DaFi7w+7FMOYBMbDPYwZW16Lm
         +RKzJDuKUZ0xIFUd/ENROjYGn427HwzPRK6q880o=
Date:   Sat, 10 Jul 2021 14:45:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        slava@dubeyko.com, skhan@linuxfoundation.org,
        gustavoars@kernel.org, gregkh@linuxfoundation.org,
        desmondcheongzx@gmail.com
Subject:  + hfs-add-missing-clean-up-in-hfs_fill_super.patch added to
 -mm tree
Message-ID: <20210710214519.IlCwk%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: add missing clean-up in hfs_fill_super
has been added to the -mm tree.  Its filename is
     hfs-add-missing-clean-up-in-hfs_fill_super.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hfs-add-missing-clean-up-in-hfs_fill_super.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hfs-add-missing-clean-up-in-hfs_fill_super.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Subject: hfs: add missing clean-up in hfs_fill_super

Before exiting hfs_fill_super, the struct hfs_find_data used in
hfs_find_init should be passed to hfs_find_exit to be cleaned up, and to
release the lock held on the btree.

The call to hfs_find_exit is missing from an error path.  We add it back
in by consolidating calls to hfs_find_exit for error paths.

Link: https://lkml.kernel.org/r/20210701030756.58760-2-desmondcheongzx@gmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/super.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/hfs/super.c~hfs-add-missing-clean-up-in-hfs_fill_super
+++ a/fs/hfs/super.c
@@ -420,14 +420,12 @@ static int hfs_fill_super(struct super_b
 	if (!res) {
 		if (fd.entrylength > sizeof(rec) || fd.entrylength < 0) {
 			res =  -EIO;
-			goto bail;
+			goto bail_hfs_find;
 		}
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset, fd.entrylength);
 	}
-	if (res) {
-		hfs_find_exit(&fd);
-		goto bail_no_root;
-	}
+	if (res)
+		goto bail_hfs_find;
 	res = -EINVAL;
 	root_inode = hfs_iget(sb, &fd.search_key->cat, &rec);
 	hfs_find_exit(&fd);
@@ -443,6 +441,8 @@ static int hfs_fill_super(struct super_b
 	/* everything's okay */
 	return 0;
 
+bail_hfs_find:
+	hfs_find_exit(&fd);
 bail_no_root:
 	pr_err("get root inode failed\n");
 bail:
_

Patches currently in -mm which might be from desmondcheongzx@gmail.com are

hfs-add-missing-clean-up-in-hfs_fill_super.patch
hfs-fix-high-memory-mapping-in-hfs_bnode_read.patch
hfs-add-lock-nesting-notation-to-hfs_find_init.patch


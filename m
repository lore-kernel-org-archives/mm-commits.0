Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1036C64EC3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbjBCGwO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjBCGv3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D186F8D433
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A3F7B82986
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D75DC433D2;
        Fri,  3 Feb 2023 06:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407076;
        bh=DfTH/1V5MuQU9aEPhPsc/oV9p+dU9Pskjx1MOmefY1w=;
        h=Date:To:From:Subject:From;
        b=VPaS2keF78kIbaKJWVhECuP8ZJ2fVzRN5QCcHgl9Tjv+nTQa2xtlBI9izBavngKU2
         BKtRFyisxgfv5q6jHcvB6WvJH1/bRSLIRy1OwteBQqycTiz3ulJOB+dXEBHbMr/NH9
         9GbKTDQNh5JAYBeOOjMwPJC206J3G54i2A/1rjm0=
Date:   Thu, 02 Feb 2023 22:51:15 -0800
To:     mm-commits@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        ebiggers@kernel.org, chao@kernel.org, adilger.kernel@dilger.ca,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-hfs-initialize-fsdata-in-hfs_file_truncate.patch removed from -mm tree
Message-Id: <20230203065116.2D75DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: hfs: initialize fsdata in hfs_file_truncate()
has been removed from the -mm tree.  Its filename was
     fs-hfs-initialize-fsdata-in-hfs_file_truncate.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: fs: hfs: initialize fsdata in hfs_file_truncate()
Date: Mon, 21 Nov 2022 12:21:33 +0100

When aops->write_begin() does not initialize fsdata, KMSAN may report an
error passing the latter to aops->write_end().

Fix this by unconditionally initializing fsdata.

Link: https://lkml.kernel.org/r/20221121112134.407362-4-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Chao Yu <chao@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/hfs/extent.c~fs-hfs-initialize-fsdata-in-hfs_file_truncate
+++ a/fs/hfs/extent.c
@@ -486,7 +486,7 @@ void hfs_file_truncate(struct inode *ino
 		inode->i_size);
 	if (inode->i_size > HFS_I(inode)->phys_size) {
 		struct address_space *mapping = inode->i_mapping;
-		void *fsdata;
+		void *fsdata = NULL;
 		struct page *page;
 
 		/* XXX: Can use generic_cont_expand? */
_

Patches currently in -mm which might be from glider@google.com are



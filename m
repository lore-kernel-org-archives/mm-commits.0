Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF0AC63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjBCGwN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbjBCGv3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFB28CA8D
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 807EBB8298C
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2421AC4339B;
        Fri,  3 Feb 2023 06:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407077;
        bh=iFzq5gUCdLPNFfd+3NwVnlUBziXMCFvRSfypq3d6+EI=;
        h=Date:To:From:Subject:From;
        b=GoiH21/42+KLgJzls2hBxZoSa0sPr5JG75KbOyVirhM1UPAP2WMso5rvM+zstGU+4
         JC3nk94H9bQKNgvlb73g5pauF6Ikwlp9frLXXAQCBnkGsgHa9nLIGi1D6oSA6JFhYM
         bpfqcSAxUjNrQEIh+zBhbeOg+OuBbX1KHkUqrdwA=
Date:   Thu, 02 Feb 2023 22:51:16 -0800
To:     mm-commits@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        ebiggers@kernel.org, chao@kernel.org, adilger.kernel@dilger.ca,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-hfsplus-initialize-fsdata-in-hfsplus_file_truncate.patch removed from -mm tree
Message-Id: <20230203065117.2421AC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: hfsplus: initialize fsdata in hfsplus_file_truncate()
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-initialize-fsdata-in-hfsplus_file_truncate.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: fs: hfsplus: initialize fsdata in hfsplus_file_truncate()
Date: Mon, 21 Nov 2022 12:21:34 +0100

When aops->write_begin() does not initialize fsdata, KMSAN may report an
error passing the latter to aops->write_end().

Fix this by unconditionally initializing fsdata.

Link: https://lkml.kernel.org/r/20221121112134.407362-5-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Chao Yu <chao@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/hfsplus/extents.c~fs-hfsplus-initialize-fsdata-in-hfsplus_file_truncate
+++ a/fs/hfsplus/extents.c
@@ -554,7 +554,7 @@ void hfsplus_file_truncate(struct inode
 	if (inode->i_size > hip->phys_size) {
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		loff_t size = inode->i_size;
 
 		res = hfsplus_write_begin(NULL, mapping, size, 0,
_

Patches currently in -mm which might be from glider@google.com are



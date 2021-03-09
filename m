Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461C8C433E6
	for <mm-commits@archiver.kernel.org>; Tue,  9 Mar 2021 05:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12D86652AC
	for <mm-commits@archiver.kernel.org>; Tue,  9 Mar 2021 05:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhCIFwH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:52:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhCIFvx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Mar 2021 00:51:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A16B665252;
        Tue,  9 Mar 2021 05:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615269112;
        bh=yJ1Tj4baZikZVN1WR71Lhz155svlBVVrJSP2R5E9Uo0=;
        h=Date:From:To:Subject:From;
        b=t3z5DRNCqHzCGqDQLCLTWkGqhH4XMeSNcqBrUJirrcD+n+PreAfjnChajbqyEUNfh
         4BAA7Xg/7PkQ164SB5z5HWPQ5FmPZiVuM4oEUpMzPG8jRF38XzCJgbHICTsHKPCpW7
         tnhYcpf+jSA3AGFNKmEYXYn1L2w/q9NxIFs+DeJs=
Date:   Mon, 08 Mar 2021 21:51:52 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        stable@vger.kernel.org
Subject:  [to-be-updated]
 squashfs-fix-xattr-id-and-id-lookup-sanity-checks.patch removed from -mm
 tree
Message-ID: <20210309055152.6u-IEbSD5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: fix xattr id and id lookup sanity checks
has been removed from the -mm tree.  Its filename was
     squashfs-fix-xattr-id-and-id-lookup-sanity-checks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: fix xattr id and id lookup sanity checks

The checks for maximum metadata block size is missing
SQUASHFS_BLOCK_OFFSET (the two byte length count).  As a consequence
the user will be unable to mount the filesystem, because it will fail
the sanity check.

Link: https://lkml.kernel.org/r/2069685113.2081245.1614583677427@webmail.123-reg.co.uk
Fixes: f37aa4c7366e23f ("squashfs: add more sanity checks in id lookup")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/id.c       |    6 ++++--
 fs/squashfs/xattr_id.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/fs/squashfs/id.c~squashfs-fix-xattr-id-and-id-lookup-sanity-checks
+++ a/fs/squashfs/id.c
@@ -97,14 +97,16 @@ __le64 *squashfs_read_id_index_table(str
 		start = le64_to_cpu(table[n]);
 		end = le64_to_cpu(table[n + 1]);
 
-		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
+		if (start >= end || (end - start) >
+				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 			kfree(table);
 			return ERR_PTR(-EINVAL);
 		}
 	}
 
 	start = le64_to_cpu(table[indexes - 1]);
-	if (start >= id_table_start || (id_table_start - start) > SQUASHFS_METADATA_SIZE) {
+	if (start >= id_table_start || (id_table_start - start) >
+				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
--- a/fs/squashfs/xattr_id.c~squashfs-fix-xattr-id-and-id-lookup-sanity-checks
+++ a/fs/squashfs/xattr_id.c
@@ -109,14 +109,16 @@ __le64 *squashfs_read_xattr_id_table(str
 		start = le64_to_cpu(table[n]);
 		end = le64_to_cpu(table[n + 1]);
 
-		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
+		if (start >= end || (end - start) >
+				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 			kfree(table);
 			return ERR_PTR(-EINVAL);
 		}
 	}
 
 	start = le64_to_cpu(table[indexes - 1]);
-	if (start >= table_start || (table_start - start) > SQUASHFS_METADATA_SIZE) {
+	if (start >= table_start || (table_start - start) >
+				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are



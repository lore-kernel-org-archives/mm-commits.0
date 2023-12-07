Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D485CC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 21:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbjLGVoG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 16:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235646AbjLGVno (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 16:43:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D732D73
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 13:29:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E94EC433CB;
        Thu,  7 Dec 2023 21:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701984587;
        bh=7MIloRC8o5X9bvNT75CccGOLMj7qUhEX6ctgxckdeFQ=;
        h=Date:To:From:Subject:From;
        b=UJld/nD4uiGI7p8NH44KwMkm4hB7nMntHzV8Nf6S3nAuaiwCqIEIMXmueeayHnaUr
         H0ad61pqfm8t4YTMr/HWmb6VMHHJ0y2cGduD0+rWBdyi31sjKanEHI39OeX96ZjSdp
         gQ9S8wwv7cXRezTUcFCJFnbPnkGUFlm0uHGsa1w0=
Date:   Thu, 07 Dec 2023 13:29:45 -0800
To:     mm-commits@vger.kernel.org, hch@infradead.org,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + freevxfs-bmap-fix-kernel-doc-warnings.patch added to mm-nonmm-unstable branch
Message-Id: <20231207212947.1E94EC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: freevxfs: bmap: fix kernel-doc warnings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     freevxfs-bmap-fix-kernel-doc-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/freevxfs-bmap-fix-kernel-doc-warnings.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: freevxfs: bmap: fix kernel-doc warnings
Date: Thu, 7 Dec 2023 13:20:33 -0800

Fix -Wall kernel-doc warnings in vxfs_bmap.c:

vxfs_bmap.c:44: warning: Function parameter or member 'bn' not described in 'vxfs_bmap_ext4'
vxfs_bmap.c:44: warning: Excess function parameter 'iblock' description in 'vxfs_bmap_ext4'
vxfs_bmap.c:108: warning: No description found for return value of 'vxfs_bmap_indir'
vxfs_bmap.c:187: warning: No description found for return value of 'vxfs_bmap_typed'
vxfs_bmap.c:251: warning: No description found for return value of 'vxfs_bmap1'

Link: https://lkml.kernel.org/r/20231207212035.25345-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_bmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/freevxfs/vxfs_bmap.c~freevxfs-bmap-fix-kernel-doc-warnings
+++ a/fs/freevxfs/vxfs_bmap.c
@@ -29,7 +29,7 @@ vxfs_typdump(struct vxfs_typed *typ)
 /**
  * vxfs_bmap_ext4 - do bmap for ext4 extents
  * @ip:		pointer to the inode we do bmap for
- * @iblock:	logical block.
+ * @bn:		logical block.
  *
  * Description:
  *   vxfs_bmap_ext4 performs the bmap operation for inodes with
@@ -97,7 +97,7 @@ fail_buf:
  *   vxfs_bmap_indir reads a &struct vxfs_typed at @indir
  *   and performs the type-defined action.
  *
- * Return Value:
+ * Returns:
  *   The physical block number on success, else Zero.
  *
  * Note:
@@ -179,7 +179,7 @@ out:
  * Description:
  *   Performs the bmap operation for typed extents.
  *
- * Return Value:
+ * Returns:
  *   The physical block number on success, else Zero.
  */
 static daddr_t
@@ -243,7 +243,7 @@ vxfs_bmap_typed(struct inode *ip, long i
  *   vxfs_bmap1 perfoms a logical to physical block mapping
  *   for vxfs-internal purposes.
  *
- * Return Value:
+ * Returns:
  *   The physical block number on success, else Zero.
  */
 daddr_t
_

Patches currently in -mm which might be from rdunlap@infradead.org are

rapidio-tsi721-fix-kernel-doc-warnings.patch
freevxfs-bmap-fix-kernel-doc-warnings.patch
freevxfs-immed-fix-kernel-doc-param-name.patch
freevxfs-lookup-fix-function-params-kernel-doc.patch


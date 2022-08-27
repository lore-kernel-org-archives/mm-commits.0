Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E21ECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 01:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiH0Bvr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 21:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiH0Bvp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 21:51:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301BAEA312
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 18:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE507B8334C
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 01:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F37C433D7;
        Sat, 27 Aug 2022 01:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661565101;
        bh=80mXDjC3oEQkBjct3Gx99tKD6bsDQ6UmTIomN7JS0rg=;
        h=Date:To:From:Subject:From;
        b=un86WQ1AiV+rjfXlqzUiubcVm/pCDqQBeGxI36e7DGb0bG2MSmy+AMwusr5vILoV9
         3C5vqYC0MD2ZJDH4YkqiWKg6ToSOl3K/XOobK8ztKGZBj4Tv1HuWUw9fXruJ75Y9+8
         Xfr3oTcEhW3U2wFbIk25FQ+N8OH+3whVO0P+VqSw=
Date:   Fri, 26 Aug 2022 18:51:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, ruansy.fnst@fujitsu.com,
        riteshh@linux.ibm.com, rgoldwyn@suse.de, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, hch@lst.de,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + xfs-fix-sb_born-check-in-xfs_dax_notify_failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20220827015141.74F37C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xfs: fix SB_BORN check in xfs_dax_notify_failure()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     xfs-fix-sb_born-check-in-xfs_dax_notify_failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xfs-fix-sb_born-check-in-xfs_dax_notify_failure.patch

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
From: Dan Williams <dan.j.williams@intel.com>
Subject: xfs: fix SB_BORN check in xfs_dax_notify_failure()
Date: Fri, 26 Aug 2022 10:18:01 -0700

The SB_BORN flag is stored in the vfs superblock, not xfs_sb.

Link: https://lkml.kernel.org/r/166153428094.2758201.7936572520826540019.stgit@dwillia2-xfh.jf.intel.com
Fixes: 6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_notify_failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_notify_failure.c~xfs-fix-sb_born-check-in-xfs_dax_notify_failure
+++ a/fs/xfs/xfs_notify_failure.c
@@ -175,7 +175,7 @@ xfs_dax_notify_failure(
 	u64			ddev_start;
 	u64			ddev_end;
 
-	if (!(mp->m_sb.sb_flags & SB_BORN)) {
+	if (!(mp->m_super->s_flags & SB_BORN)) {
 		xfs_warn(mp, "filesystem is not ready for notify_failure()!");
 		return -EIO;
 	}
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

xfs-quiet-notify_failure-eopnotsupp-cases.patch
xfs-fix-sb_born-check-in-xfs_dax_notify_failure.patch
mm-memory-failure-fix-detection-of-memory_failure-handlers.patch
mm-memory-failure-fall-back-to-vma_address-when-notify_failure-fails.patch


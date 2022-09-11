Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F19C6FA83
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiIKXXN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiIKXXF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:23:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B819C24F24
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:23:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D93DB80B96
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EEEC433D7;
        Sun, 11 Sep 2022 23:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938582;
        bh=WhPf1C3ny5hNixbOrd3mMYF+quA5PLZZM2sh0fsQXko=;
        h=Date:To:From:Subject:From;
        b=RIrFpZzIqG4Wbcwp/PuaIRlxqnXGinp36NSYmkbn5hAcUvWvXBYtVBxSRFnHUjxIB
         0H3DLvKINQOiRkCxI+KErWsnLAhK8g2oaYzJ68ZCp/mwoKuXPpSxxAtWN01BdcblPZ
         URID37wNZd4W5Nlv/oEwx34NaPE3drb/JZNmENMM=
Date:   Sun, 11 Sep 2022 16:23:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, ruansy.fnst@fujitsu.com,
        riteshh@linux.ibm.com, rgoldwyn@suse.de, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, hch@lst.de,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] xfs-fix-sb_born-check-in-xfs_dax_notify_failure.patch removed from -mm tree
Message-Id: <20220911232301.E7EEEC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: xfs: fix SB_BORN check in xfs_dax_notify_failure()
has been removed from the -mm tree.  Its filename was
     xfs-fix-sb_born-check-in-xfs_dax_notify_failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: xfs: fix SB_BORN check in xfs_dax_notify_failure()
Date: Fri, 26 Aug 2022 10:18:01 -0700

The SB_BORN flag is stored in the vfs superblock, not xfs_sb.

Link: https://lkml.kernel.org/r/166153428094.2758201.7936572520826540019.stgit@dwillia2-xfh.jf.intel.com
Fixes: 6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
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



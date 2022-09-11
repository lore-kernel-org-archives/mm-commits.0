Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5D0C6FA8B
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiIKXXF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiIKXXE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:23:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D24824F29
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:23:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED89BB80B10
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E34C433D6;
        Sun, 11 Sep 2022 23:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938580;
        bh=yxIngLcDjI6lEYQ7VGwaS5iYokQVE2SXwzatkvynzEE=;
        h=Date:To:From:Subject:From;
        b=i2F2iw695zLTfCDR/aT5iKMTDT/Cv6V0QjlMK3NgL08bpOa4gsZ7UGgC6ZC2HlcH6
         1B8wnacP/kn8/eminZBQMV7dbd+RBg8Qm0/5N1rZbryak4TD8Scq9dCEpJinzSMLyi
         yQgeol9INVNe8PxlIpS9ZUEUxuIGj6EZmsKp/SEk=
Date:   Sun, 11 Sep 2022 16:22:59 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, ruansy.fnst@fujitsu.com,
        riteshh@linux.ibm.com, rgoldwyn@suse.de, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, hch@lst.de,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] xfs-quiet-notify_failure-eopnotsupp-cases.patch removed from -mm tree
Message-Id: <20220911232300.A3E34C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: xfs: quiet notify_failure EOPNOTSUPP cases
has been removed from the -mm tree.  Its filename was
     xfs-quiet-notify_failure-eopnotsupp-cases.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: xfs: quiet notify_failure EOPNOTSUPP cases
Date: Fri, 26 Aug 2022 10:17:54 -0700

Patch series "mm, xfs, dax: Fixes for memory_failure() handling".

I failed to run the memory error injection section of the ndctl test suite
on linux-next prior to the merge window and as a result some bugs were
missed.  While the new enabling targeted reflink enabled XFS filesystems
the bugs cropped up in the surrounding cases of DAX error injection on
ext4-fsdax and device-dax.

One new assumption / clarification in this set is the notion that if a
filesystem's ->notify_failure() handler returns -EOPNOTSUPP, then it must
be the case that the fsdax usage of page->index and page->mapping are
valid.  I am fairly certain this is true for xfs_dax_notify_failure(), but
would appreciate another set of eyes.


This patch (of 4):

XFS always registers dax_holder_operations regardless of whether the
filesystem is capable of handling the notifications.  The expectation is
that if the notify_failure handler cannot run then there are no scenarios
where it needs to run.  In other words the expected semantic is that
page->index and page->mapping are valid for memory_failure() when the
conditions that cause -EOPNOTSUPP in xfs_dax_notify_failure() are present.

A fallback to the generic memory_failure() path is expected so do not warn
when that happens.

Link: https://lkml.kernel.org/r/166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com
Link: https://lkml.kernel.org/r/166153427440.2758201.6709480562966161512.stgit@dwillia2-xfh.jf.intel.com
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

 fs/xfs/xfs_notify_failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_notify_failure.c~xfs-quiet-notify_failure-eopnotsupp-cases
+++ a/fs/xfs/xfs_notify_failure.c
@@ -181,7 +181,7 @@ xfs_dax_notify_failure(
 	}
 
 	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_daxdev == dax_dev) {
-		xfs_warn(mp,
+		xfs_debug(mp,
 			 "notify_failure() not supported on realtime device!");
 		return -EOPNOTSUPP;
 	}
@@ -194,7 +194,7 @@ xfs_dax_notify_failure(
 	}
 
 	if (!xfs_has_rmapbt(mp)) {
-		xfs_warn(mp, "notify_failure() needs rmapbt enabled!");
+		xfs_debug(mp, "notify_failure() needs rmapbt enabled!");
 		return -EOPNOTSUPP;
 	}
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are



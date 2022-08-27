Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E100AECAAD4
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 01:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243146AbiH0Bvq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 21:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiH0Bvo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 21:51:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575BBEA30D
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 18:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 964D7CE31E4
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 01:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4A3C433C1;
        Sat, 27 Aug 2022 01:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661565099;
        bh=dNoFQbeGeTvuv18cUbwWOUJ2U68JTbooDEWpazaaxqs=;
        h=Date:To:From:Subject:From;
        b=jWZrfLjY63WlgGpOU6jo4mL1UMiWzGGYNEptrvoS5sMSAZD5X8iHRn8e7tjaaIeTj
         WvQslS7+gVEwvorGbIROFKM3DNxPMfcz1jzkosLc5JoaFoxjNMpRagMeSblZj3F+6l
         qtiEsCz++uzMb2B9WrZlj9qUc6vtOA7BkhnvbQiU=
Date:   Fri, 26 Aug 2022 18:51:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, ruansy.fnst@fujitsu.com,
        riteshh@linux.ibm.com, rgoldwyn@suse.de, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, hch@lst.de,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + xfs-quiet-notify_failure-eopnotsupp-cases.patch added to mm-hotfixes-unstable branch
Message-Id: <20220827015139.5D4A3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xfs: quiet notify_failure EOPNOTSUPP cases
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     xfs-quiet-notify_failure-eopnotsupp-cases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xfs-quiet-notify_failure-eopnotsupp-cases.patch

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

xfs-quiet-notify_failure-eopnotsupp-cases.patch
xfs-fix-sb_born-check-in-xfs_dax_notify_failure.patch
mm-memory-failure-fix-detection-of-memory_failure-handlers.patch
mm-memory-failure-fall-back-to-vma_address-when-notify_failure-fails.patch


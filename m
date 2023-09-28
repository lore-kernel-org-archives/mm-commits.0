Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3750CE732E7
	for <mm-commits@archiver.kernel.org>; Thu, 28 Sep 2023 16:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjI1QKJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjI1QKI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2023 12:10:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8C2B7
        for <mm-commits@vger.kernel.org>; Thu, 28 Sep 2023 09:10:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83262C433C8;
        Thu, 28 Sep 2023 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695917406;
        bh=sKFJzowRxA1HxlfjnyYrJ9opdyaFulP6aEZKRrV3PZA=;
        h=Date:To:From:Subject:From;
        b=IAGcw1xPX6+kQEksPrdfEV8lr5qTMMB6ZbXOv5q5F1RvN5Xlu+rSoHYC4IcCpmDon
         mx4sIL+7XMkaF/vZsGxypiBzurJTwnR4K0V4BV62E0eWXsarCz3pmIzj2wwZJ6wfM1
         lBUFy4t7A8oxpeScQHbmwbeU9LE6cKkTlbbHxQ8Q=
Date:   Thu, 28 Sep 2023 09:10:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, mcgrof@kernel.org,
        jack@suse.cz, djwong@kernel.org, dan.j.williams@intel.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pmem-xfs-introduce-mf_mem_pre_remove-for-unbind-v15.patch added to mm-hotfixes-unstable branch
Message-Id: <20230928161006.83262C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-pmem-xfs-introduce-mf_mem_pre_remove-for-unbind-v15.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pmem-xfs-introduce-mf_mem_pre_remove-for-unbind-v15.patch

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
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
Date: Thu, 28 Sep 2023 18:32:27 +0800

add/fix code comments per Dan's comments

Link: https://lkml.kernel.org/r/20230928103227.250550-1-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_notify_failure.c |   21 +++++++++++++++------
 mm/memory-failure.c         |    4 ++++
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/fs/xfs/xfs_notify_failure.c~mm-pmem-xfs-introduce-mf_mem_pre_remove-for-unbind-v15
+++ a/fs/xfs/xfs_notify_failure.c
@@ -234,18 +234,21 @@ xfs_dax_notify_ddev_failure(
 	xfs_trans_cancel(tp);
 
 	/*
-	 * Determine how to shutdown the filesystem according to the
-	 * error code and flags.
+	 * Shutdown fs from a force umount in pre-remove case which won't fail,
+	 * so errors can be ignored.  Otherwise, shutdown the filesystem with
+	 * CORRUPT flag if error occured or notify.want_shutdown was set during
+	 * RMAP querying.
 	 */
-	if (error || notify.want_shutdown) {
+	if (mf_flags & MF_MEM_PRE_REMOVE)
+		xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
+	else if (error || notify.want_shutdown) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
 		if (!error)
 			error = -EFSCORRUPTED;
-	} else if (mf_flags & MF_MEM_PRE_REMOVE)
-		xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
+	}
 
 out:
-	/* Thaw the fs if it is frozen before. */
+	/* Thaw the fs if it has been frozen before. */
 	if (mf_flags & MF_MEM_PRE_REMOVE)
 		xfs_dax_notify_failure_thaw(mp, kernel_frozen);
 
@@ -276,6 +279,12 @@ xfs_dax_notify_failure(
 
 	if (mp->m_logdev_targp && mp->m_logdev_targp->bt_daxdev == dax_dev &&
 	    mp->m_logdev_targp != mp->m_ddev_targp) {
+		/*
+		 * In the pre-remove case the failure notification is attempting
+		 * to trigger a force unmount.  The expectation is that the
+		 * device is still present, but its removal is in progress and
+		 * can not be cancelled, proceed with accessing the log device.
+		 */
 		if (mf_flags & MF_MEM_PRE_REMOVE)
 			return 0;
 		xfs_err(mp, "ondisk log corrupt, shutting down fs!");
--- a/mm/memory-failure.c~mm-pmem-xfs-introduce-mf_mem_pre_remove-for-unbind-v15
+++ a/mm/memory-failure.c
@@ -1814,6 +1814,10 @@ int mf_dax_kill_procs(struct address_spa
 		if (!pre_remove)
 			SetPageHWPoison(page);
 
+		/*
+		 * The pre_remove case is revoking access, the memory is still
+		 * good and could theoretically be put back into service.
+		 */
 		collect_procs_fsdax(page, mapping, index, &to_kill, pre_remove);
 		unmap_and_kill(&to_kill, page_to_pfn(page), mapping,
 				index, mf_flags);
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

mm-pmem-xfs-introduce-mf_mem_pre_remove-for-unbind.patch
mm-pmem-xfs-introduce-mf_mem_pre_remove-for-unbind-v15.patch


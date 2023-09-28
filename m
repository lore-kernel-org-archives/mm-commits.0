Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC55E732FE
	for <mm-commits@archiver.kernel.org>; Thu, 28 Sep 2023 17:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjI1R2V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Sep 2023 13:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI1R2S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2023 13:28:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD21DD
        for <mm-commits@vger.kernel.org>; Thu, 28 Sep 2023 10:28:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6AFC433C8;
        Thu, 28 Sep 2023 17:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695922096;
        bh=Ccunrt+1TVAV5TtpdHYI72dItH62x6XYFv0g/SrlBQI=;
        h=Date:To:From:Subject:From;
        b=lQ3UfvaKZfiBOtITkPnagFjUTVxx5ivej496U/wb1CHNEjKKSOC8E3akoRlI6aI8e
         bkCYgp3UCK3MLdlL+C2UxGdN8uJwU+qxQG1XJ0Ms4Brn2eVXfgbN2n8w0p3qxCs4L/
         m3La5zL+ZFIUmmDtIVTDm0aYy4iudMZjD6Ga1olU=
Date:   Thu, 28 Sep 2023 10:28:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, mcgrof@kernel.org,
        jack@suse.cz, djwong@kernel.org, dan.j.williams@intel.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-pmem-xfs-introduce-mf_mem_pre_remove-for-unbind-v15.patch removed from -mm tree
Message-Id: <20230928172815.EE6AFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
has been removed from the -mm tree.  Its filename was
     mm-pmem-xfs-introduce-mf_mem_pre_remove-for-unbind-v15.patch

This patch was dropped because an updated version will be merged

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



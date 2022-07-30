Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2898C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbiG3BJP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239654AbiG3BIz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0848723D
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1554161BF4
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6778AC433D6;
        Sat, 30 Jul 2022 01:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143318;
        bh=81+vH6CRAwB9wSpQfMlWvnYSVCy27w1877PDeTe5o8c=;
        h=Date:To:From:Subject:From;
        b=U6fdsejBviLfrQmDAI3NLgl9wUz6EU3KDLybzkBtqjxiTX76p5kZqb7ZNoXGEhqQ9
         meiO45JdEBVeAXGlXHjPao05dvgXGsvem5dXqRaWY8KBNVQUAIyKNzI3aiCJO5Cg8E
         4TxgpBZzfqJmybKsgxuyDzbz5e24cwF6BMCRxc+I=
Date:   Fri, 29 Jul 2022 18:08:37 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, djwong@kernel.org,
        david@fromorbit.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xfs-fail-dax-mount-if-reflink-is-enabled-on-a-partition.patch removed from -mm tree
Message-Id: <20220730010838.6778AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: xfs: fail dax mount if reflink is enabled on a partition
has been removed from the -mm tree.  Its filename was
     xfs-fail-dax-mount-if-reflink-is-enabled-on-a-partition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: xfs: fail dax mount if reflink is enabled on a partition
Date: Thu, 9 Jun 2022 22:34:35 +0800

Failure notification is not supported on partitions.  So, when we mount a
reflink enabled xfs on a partition with dax option, let it fail with
-EINVAL code.

Link: https://lkml.kernel.org/r/20220609143435.393724-1-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_super.c~xfs-fail-dax-mount-if-reflink-is-enabled-on-a-partition
+++ a/fs/xfs/xfs_super.c
@@ -350,8 +350,10 @@ xfs_setup_dax_always(
 		goto disable_dax;
 	}
 
-	if (xfs_has_reflink(mp)) {
-		xfs_alert(mp, "DAX and reflink cannot be used together!");
+	if (xfs_has_reflink(mp) &&
+	    bdev_is_partition(mp->m_ddev_targp->bt_bdev)) {
+		xfs_alert(mp,
+			"DAX and reflink cannot work with multi-partitions!");
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are



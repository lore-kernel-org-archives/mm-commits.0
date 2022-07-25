Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E713C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 20:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbiGYUC1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 16:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236716AbiGYUC0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 16:02:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3479D20BE0
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 13:02:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C55816104F
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 20:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F7AC341C8;
        Mon, 25 Jul 2022 20:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658779345;
        bh=dJMisa/Gf+N6KcbQ3NIaGufVXB22CCC9Jo59HQFJCUE=;
        h=Date:To:From:Subject:From;
        b=XwM8S5aTrwf41rfWurgcJEso6RBMsrpT6H7X8m38ZHawXV6y0v61noPdjQbCpX6ZL
         38gNd7Wg0QhzLZFS2RT220WZL0aUHa+SWByfGHoOOEnU7nXL42r6aUET8W3S1pU+mo
         b8Hv6VHJOw1ageXUvRLk5QLjhZGW0N2CeNKHoc7c=
Date:   Mon, 25 Jul 2022 13:02:24 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, djwong@kernel.org,
        david@fromorbit.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + xfs-fail-dax-mount-if-reflink-is-enabled-on-a-partition.patch added to mm-unstable branch
Message-Id: <20220725200225.20F7AC341C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xfs: fail dax mount if reflink is enabled on a partition
has been added to the -mm mm-unstable branch.  Its filename is
     xfs-fail-dax-mount-if-reflink-is-enabled-on-a-partition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xfs-fail-dax-mount-if-reflink-is-enabled-on-a-partition.patch

This patch will later appear in the mm-unstable branch at
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

xfs-fail-dax-mount-if-reflink-is-enabled-on-a-partition.patch


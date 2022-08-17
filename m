Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0E8C3F6B0
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 20:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242156AbiHQU6O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 16:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242159AbiHQU50 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 16:57:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25705A927F
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 13:57:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1C5E615AE
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 20:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F21C433D7;
        Wed, 17 Aug 2022 20:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660769837;
        bh=qPquSYzKKLvYF1iBakLPalA0dYvZIVir1swSsL2n+wQ=;
        h=Date:To:From:Subject:From;
        b=Fw7akkyXcmbtmdvkhtJR4SQVGMgP1bsLnIjPWGOuq6W8gW+nLPlkPs5AQw93HIhgC
         L83YadovaQ3TT3HOBZTxDcJtDfbTc7I/1/Z8E5pX7wO9xJ+CETWJKyZ3orkJeMMM0K
         05cG9SEZ+Rmx6kDhiOQWBCJULx6Sj2L+1EqFWrVE=
Date:   Wed, 17 Aug 2022 13:57:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        rburny@google.com, djwong@kernel.org, brauner@kernel.org,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-tmpfs-fallocate-use-file_modified.patch removed from -mm tree
Message-Id: <20220817205717.38F21C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: tmpfs fallocate use file_modified()
has been removed from the -mm tree.  Its filename was
     mm-shmem-tmpfs-fallocate-use-file_modified.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: tmpfs fallocate use file_modified()
Date: Wed, 10 Aug 2022 21:55:36 -0700 (PDT)

5.18 fixed the btrfs and ext4 fallocates to use file_modified(), as xfs
was already doing, to drop privileges: and fstests generic/{683,684,688}
expect this.  There's no need to argue over keep-size allocation (which
could just update ctime): fix shmem_fallocate() to behave the same way.

Link: https://lkml.kernel.org/r/39c5e62-4896-7795-c0a0-f79c50d4909@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Radoslaw Burny <rburny@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-tmpfs-fallocate-use-file_modified
+++ a/mm/shmem.c
@@ -2839,12 +2839,13 @@ static long shmem_fallocate(struct file
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
 		i_size_write(inode, offset + len);
-	inode->i_ctime = current_time(inode);
 undone:
 	spin_lock(&inode->i_lock);
 	inode->i_private = NULL;
 	spin_unlock(&inode->i_lock);
 out:
+	if (!error)
+		file_modified(file);
 	inode_unlock(inode);
 	return error;
 }
_

Patches currently in -mm which might be from hughd@google.com are



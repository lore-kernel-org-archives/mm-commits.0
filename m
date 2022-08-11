Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF1CC19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 21:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbiHKVtl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiHKVtk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 17:49:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F28C9F76E
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 14:49:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EECF9614CC
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 21:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414DEC433D6;
        Thu, 11 Aug 2022 21:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660254579;
        bh=ofwF1IaS0oKFWQ6gQzfyyvO8ShorY+c13DeVRuUB1lM=;
        h=Date:To:From:Subject:From;
        b=LBchvRlfancuzdgLPSVmj7592lqtstxO6xfyZ8tOfjki5Gv0dIXzM32c1/nulkT2m
         lfbPpgSYX3DCHgn+MnF592l9EnZWQTH+i1jLGcJ7fvdGXohkzKsDN1QXNW8ATlsQMz
         OwFUdmW/rfrtxrk87IrfdiNG0HoEMsyf/seUET+Q=
Date:   Thu, 11 Aug 2022 14:49:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        rburny@google.com, djwong@kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-tmpfs-fallocate-use-file_modified.patch added to mm-hotfixes-unstable branch
Message-Id: <20220811214939.414DEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: tmpfs fallocate use file_modified()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-tmpfs-fallocate-use-file_modified.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-tmpfs-fallocate-use-file_modified.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: tmpfs fallocate use file_modified()
Date: Wed, 10 Aug 2022 21:55:36 -0700 (PDT)

5.18 fixed the btrfs and ext4 fallocates to use file_modified(), as xfs
was already doing, to drop privileges: and fstests generic/{683,684,688}
expect this.  There's no need to argue over keep-size allocation (which
could just update ctime): fix shmem_fallocate() to behave the same way.

Link: https://lkml.kernel.org/r/39c5e62-4896-7795-c0a0-f79c50d4909@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
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
@@ -2840,12 +2840,13 @@ static long shmem_fallocate(struct file
 
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

mm-shmem-fix-chattr-fsflags-support-in-tmpfs.patch
mm-shmem-tmpfs-fallocate-use-file_modified.patch
mm-shmem-shmem_replace_page-remember-nr_shmem.patch


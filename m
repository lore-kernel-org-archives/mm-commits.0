Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46480C43334
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 20:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbiFOUOy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 16:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiFOUOx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 16:14:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E044B40A
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 13:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 746F4614CF
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 20:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD57C3411A;
        Wed, 15 Jun 2022 20:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655324091;
        bh=a9m4I9uyWZasBeUTWQMvJpVWLOMFWS6F7Dhx2TrbiKs=;
        h=Date:To:From:Subject:From;
        b=McFARKpMLXMezEIAtzY0O67Bkkbohvsg3nI/gXNoGBT18cX7O2mdXTrh6OkF2zauh
         2w2tkXGyjdf/crhAahA7T95893Ez+sJxt9l7g/b0ZqHZMmynj/5d+wh0Rw38L0hRvm
         K9043cXg5MC8zgJvREj7AmtPqLghse+atA6K+2mM=
Date:   Wed, 15 Jun 2022 13:14:51 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-start-tracking-vmas-with-maple-tree-fix-3.patch added to mm-unstable branch
Message-Id: <20220615201451.CDD57C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/userfaultfd: fix vma iteration in mas_for_each() loop
has been added to the -mm mm-unstable branch.  Its filename is
     mm-start-tracking-vmas-with-maple-tree-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-start-tracking-vmas-with-maple-tree-fix-3.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: fs/userfaultfd: fix vma iteration in mas_for_each() loop
Date: Wed, 15 Jun 2022 16:42:17 +0000

The maple tree state becomes stale when the tree is altered and requires
the iteration to be paused with mas_pause().  This forces the next
iteration to start from the top of tree for the next entry.

Link: https://lkml.kernel.org/r/20220615164150.652376-1-Liam.Howlett@oracle.com
Fixes: d3ccd17e7c96 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+68771c0e74f7bb7804e5@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/userfaultfd.c~mm-start-tracking-vmas-with-maple-tree-fix-3
+++ a/fs/userfaultfd.c
@@ -885,10 +885,13 @@ static int userfaultfd_release(struct in
 				 vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
 				 NULL_VM_UFFD_CTX, anon_vma_name(vma));
-		if (prev)
+		if (prev) {
+			mas_pause(&mas);
 			vma = prev;
-		else
+		} else {
 			prev = vma;
+		}
+
 		vma->vm_flags = new_flags;
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 	}
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
maple-tree-add-new-data-structure-fix-7.patch
maple-tree-add-new-data-structure-fix-8.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-3.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch
mm-remove-the-vma-linked-list-fix.patch


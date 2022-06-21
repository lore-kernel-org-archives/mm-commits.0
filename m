Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664BCC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 19:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiFUTwU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 15:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiFUTwT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 15:52:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B3C27CE4
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 12:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42AF8617BB
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 19:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED52C3411C;
        Tue, 21 Jun 2022 19:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655841136;
        bh=/iPwAYtKk6XlH0yASD7zOfMFZt3BhMR1TOYxDjHYUp0=;
        h=Date:To:From:Subject:From;
        b=C0IsJZBblrW2f5Daze1/YtnKhH+q/kpSaJ2fDXQYy1n/XNcUkyXZymFQKdUPl/dXc
         Q8CZGEL7XHFkoMU9WKmkUOZiCThstXJHcvmukMW1QG8WSx0AoI4v02sujj+4zpuL2R
         URLfAFxVbj4fCRnnpJ1lUB2MHezAKdfASmD7YJmQ=
Date:   Tue, 21 Jun 2022 12:52:07 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-use-maple-tree-iterator-to-iterate-vmas-fix.patch added to mm-unstable branch
Message-Id: <20220621195215.5ED52C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/userfaultfd: fix vma iteration in mas_for_each() loop
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-use-maple-tree-iterator-to-iterate-vmas-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-use-maple-tree-iterator-to-iterate-vmas-fix.patch

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
Fixes: "userfaultfd-use-maple-tree-iterator-to-iterate-vmas.patch"
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+68771c0e74f7bb7804e5@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-use-maple-tree-iterator-to-iterate-vmas-fix
+++ a/fs/userfaultfd.c
@@ -890,10 +890,13 @@ static int userfaultfd_release(struct in
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
maple-tree-add-new-data-structure-fix-8-fix.patch
maple-tree-add-new-data-structure-fix-9.patch
maple-tree-add-new-data-structure-fix-10.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-3.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch
userfaultfd-use-maple-tree-iterator-to-iterate-vmas-fix.patch
mm-remove-the-vma-linked-list-fix.patch
mm-remove-the-vma-linked-list-fix-4.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch


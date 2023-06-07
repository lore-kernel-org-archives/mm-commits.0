Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12316C77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 20:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbjFGUAJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbjFGUAB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 16:00:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8401C19B6
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 13:00:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E53F63446
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 20:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62886C433EF;
        Wed,  7 Jun 2023 19:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686167999;
        bh=+8XiyN6piz6aRcgmf4XOsUXwESy3+/Y6NU/RI0LNVcY=;
        h=Date:To:From:Subject:From;
        b=vf00nAwIj6uJEydxANjp21ALGpWSWLwtjqTZ3JRi2U2kQbm0IPUfQC19tyYkOXrvi
         yo3TikR9M/By7reBJ4hvNS/EA2KMzUgvG1AKkPH3DtKM7RNYCMmgvMOTfrPkVGM7W4
         Nv/fdn1j8ESgZtKwfBwIOgLMTDaaZ4eS6RetRVnQ=
Date:   Wed, 07 Jun 2023 12:59:58 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-uffd-allow-vma-to-merge-as-much-as-possible.patch removed from -mm tree
Message-Id: <20230607195959.62886C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/uffd: allow vma to merge as much as possible
has been removed from the -mm tree.  Its filename was
     mm-uffd-allow-vma-to-merge-as-much-as-possible.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: allow vma to merge as much as possible
Date: Wed, 17 May 2023 15:09:16 -0400

We used to not pass in the pgoff correctly when register/unregister uffd
regions, it caused incorrect behavior on vma merging and can cause
mergeable vmas being separate after ioctls return.

For example, when we have:

  vma1(range 0-9, with uffd), vma2(range 10-19, no uffd)

Then someone unregisters uffd on range (5-9), it should logically become:

  vma1(range 0-4, with uffd), vma2(range 5-19, no uffd)

But with current code we'll have:

  vma1(range 0-4, with uffd), vma3(range 5-9, no uffd), vma2(range 10-19, no uffd)

This patch allows such merge to happen correctly before ioctl returns.

This behavior seems to have existed since the 1st day of uffd.  Since
pgoff for vma_merge() is only used to identify the possibility of vma
merging, meanwhile here what we did was always passing in a pgoff smaller
than what we should, so there should have no other side effect besides not
merging it.  Let's still tentatively copy stable for this, even though I
don't see anything will go wrong besides vma being split (which is mostly
not user visible).

Link: https://lkml.kernel.org/r/20230517190916.3429499-3-peterx@redhat.com
Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/userfaultfd.c~mm-uffd-allow-vma-to-merge-as-much-as-possible
+++ a/fs/userfaultfd.c
@@ -1332,6 +1332,7 @@ static int userfaultfd_register(struct u
 	bool basic_ioctls;
 	unsigned long start, end, vma_end;
 	struct vma_iterator vmi;
+	pgoff_t pgoff;
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
 
@@ -1484,8 +1485,9 @@ static int userfaultfd_register(struct u
 		vma_end = min(end, vma->vm_end);
 
 		new_flags = (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags;
+		pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 		prev = vma_merge(&vmi, mm, prev, start, vma_end, new_flags,
-				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
+				 vma->anon_vma, vma->vm_file, pgoff,
 				 vma_policy(vma),
 				 ((struct vm_userfaultfd_ctx){ ctx }),
 				 anon_vma_name(vma));
@@ -1565,6 +1567,7 @@ static int userfaultfd_unregister(struct
 	unsigned long start, end, vma_end;
 	const void __user *buf = (void __user *)arg;
 	struct vma_iterator vmi;
+	pgoff_t pgoff;
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
@@ -1667,8 +1670,9 @@ static int userfaultfd_unregister(struct
 			uffd_wp_range(vma, start, vma_end - start, false);
 
 		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
+		pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 		prev = vma_merge(&vmi, mm, prev, start, vma_end, new_flags,
-				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
+				 vma->anon_vma, vma->vm_file, pgoff,
 				 vma_policy(vma),
 				 NULL_VM_UFFD_CTX, anon_vma_name(vma));
 		if (prev) {
_

Patches currently in -mm which might be from peterx@redhat.com are



Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A45AC7EE22
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 20:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjEQUXk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 16:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjEQUXj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 16:23:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3007EE8
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 13:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9806864B09
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 20:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE10AC433EF;
        Wed, 17 May 2023 20:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684355016;
        bh=7TUbZupW76dVa1w8XsP/cQ54CLmFskHHhh2KNG3y2JU=;
        h=Date:To:From:Subject:From;
        b=Bx98vlXIA/aj9lUZ5HiJNKzXQAmOB2Rp97IT87yxScB+qHRVlCtwEeNJUNZLXaNFH
         gYYY2pqWT5tZdHAo1rf32EbjwYkxLV5rGqLwMJZqio2b4N+csPp0nCAqK4LK0qTkxS
         uv3Z5h8rnmpjGLWXDNQEndjSoPZHUNom5mwq3+oQ=
Date:   Wed, 17 May 2023 13:23:35 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-allow-vma-to-merge-as-much-as-possible.patch added to mm-hotfixes-unstable branch
Message-Id: <20230517202335.EE10AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/uffd: Allow vma to merge as much as possible
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-uffd-allow-vma-to-merge-as-much-as-possible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-uffd-allow-vma-to-merge-as-much-as-possible.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: Allow vma to merge as much as possible
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

mm-uffd-fix-vma-operation-where-start-addr-cuts-part-of-vma.patch
mm-uffd-allow-vma-to-merge-as-much-as-possible.patch


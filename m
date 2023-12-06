Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2D1C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 20:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379531AbjLFUSo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 15:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379461AbjLFUSm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 15:18:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E5BD1
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 12:18:48 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DAEC433C9;
        Wed,  6 Dec 2023 20:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701893927;
        bh=8oTcgVtZGEJ1Sacu6mC/UiRfIa1uu+tNYSUFl8f7MZM=;
        h=Date:To:From:Subject:From;
        b=FqHifRFe+rwJD1vJABVCU90RoW5LJDskNp5EEDDb1jc6R7ydYBlFlrnfK3UWS5VSD
         NfZkSL71JofF9rSfqOmVPwzsWgmkPID2Q2lTvX2MhFRNTVS/BuPkol2QCGMGkv+Cx6
         e8c4/Jube4pQ79Z3gE4eDot6Q6Neahj0fQFzdhoM=
Date:   Wed, 06 Dec 2023 12:18:47 -0800
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, viro@zeniv.linux.org.uk, surenb@google.com,
        shuah@kernel.org, ryan.roberts@arm.com, rppt@kernel.org,
        peterx@redhat.com, ngeoffray@google.com, mhocko@suse.com,
        lokeshgidra@google.com, Liam.Howlett@oracle.com,
        kaleshsingh@google.com, jannh@google.com, hughd@google.com,
        david@redhat.com, brauner@kernel.org, bgeffon@google.com,
        axelrasmussen@google.com, aarcange@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-uffdio_move-uabi.patch added to mm-unstable branch
Message-Id: <20231206201847.A5DAEC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: UFFDIO_MOVE uABI
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-uffdio_move-uabi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-uffdio_move-uabi.patch

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
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: UFFDIO_MOVE uABI
Date: Wed, 6 Dec 2023 02:36:56 -0800

Implement the uABI of UFFDIO_MOVE ioctl.
UFFDIO_COPY performs ~20% better than UFFDIO_MOVE when the application
needs pages to be allocated [1]. However, with UFFDIO_MOVE, if pages are
available (in userspace) for recycling, as is usually the case in heap
compaction algorithms, then we can avoid the page allocation and memcpy
(done by UFFDIO_COPY). Also, since the pages are recycled in the
userspace, we avoid the need to release (via madvise) the pages back to
the kernel [2].

We see over 40% reduction (on a Google pixel 6 device) in the compacting
thread's completion time by using UFFDIO_MOVE vs.  UFFDIO_COPY.  This was
measured using a benchmark that emulates a heap compaction implementation
using userfaultfd (to allow concurrent accesses by application threads). 
More details of the usecase are explained in [2].  Furthermore,
UFFDIO_MOVE enables moving swapped-out pages without touching them within
the same vma.  Today, it can only be done by mremap, however it forces
splitting the vma.

[1] https://lore.kernel.org/all/1425575884-2574-1-git-send-email-aarcange@redhat.com/
[2] https://lore.kernel.org/linux-mm/CA+EESO4uO84SSnBhArH4HvLNhaUQ5nZKNKXqxRCyjniNVjp0Aw@mail.gmail.com/

Update for the ioctl_userfaultfd(2)  manpage:

   UFFDIO_MOVE
       (Since Linux xxx)  Move a continuous memory chunk into the
       userfault registered range and optionally wake up the blocked
       thread. The source and destination addresses and the number of
       bytes to move are specified by the src, dst, and len fields of
       the uffdio_move structure pointed to by argp:

           struct uffdio_move {
               __u64 dst;    /* Destination of move */
               __u64 src;    /* Source of move */
               __u64 len;    /* Number of bytes to move */
               __u64 mode;   /* Flags controlling behavior of move */
               __s64 move;   /* Number of bytes moved, or negated error */
           };

       The following value may be bitwise ORed in mode to change the
       behavior of the UFFDIO_MOVE operation:

       UFFDIO_MOVE_MODE_DONTWAKE
              Do not wake up the thread that waits for page-fault
              resolution

       UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES
              Allow holes in the source virtual range that is being moved.
              When not specified, the holes will result in ENOENT error.
              When specified, the holes will be accounted as successfully
              moved memory. This is mostly useful to move hugepage aligned
              virtual regions without knowing if there are transparent
              hugepages in the regions or not, but preventing the risk of
              having to split the hugepage during the operation.

       The move field is used by the kernel to return the number of
       bytes that was actually moved, or an error (a negated errno-
       style value).  If the value returned in move doesn't match the
       value that was specified in len, the operation fails with the
       error EAGAIN.  The move field is output-only; it is not read by
       the UFFDIO_MOVE operation.

       The operation may fail for various reasons. Usually, remapping of
       pages that are not exclusive to the given process fail; once KSM
       might deduplicate pages or fork() COW-shares pages during fork()
       with child processes, they are no longer exclusive. Further, the
       kernel might only perform lightweight checks for detecting whether
       the pages are exclusive, and return -EBUSY in case that check fails.
       To make the operation more likely to succeed, KSM should be
       disabled, fork() should be avoided or MADV_DONTFORK should be
       configured for the source VMA before fork().

       This ioctl(2) operation returns 0 on success.  In this case, the
       entire area was moved.  On error, -1 is returned and errno is
       set to indicate the error.  Possible errors include:

       EAGAIN The number of bytes moved (i.e., the value returned in
              the move field) does not equal the value that was
              specified in the len field.

       EINVAL Either dst or len was not a multiple of the system page
              size, or the range specified by src and len or dst and len
              was invalid.

       EINVAL An invalid bit was specified in the mode field.

       ENOENT
              The source virtual memory range has unmapped holes and
              UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES is not set.

       EEXIST
              The destination virtual memory range is fully or partially
              mapped.

       EBUSY
              The pages in the source virtual memory range are either
              pinned or not exclusive to the process. The kernel might
              only perform lightweight checks for detecting whether the
              pages are exclusive. To make the operation more likely to
              succeed, KSM should be disabled, fork() should be avoided
              or MADV_DONTFORK should be configured for the source virtual
              memory area before fork().

       ENOMEM Allocating memory needed for the operation failed.

       ESRCH
              The target process has exited at the time of a UFFDIO_MOVE
              operation.

Link: https://lkml.kernel.org/r/20231206103702.3873743-3-surenb@google.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/mm/rmap.c~userfaultfd-uffdio_move-uabi
+++ a/mm/rmap.c
@@ -565,6 +565,17 @@ retry:
 		}
 
 		/*
+		 * folio_move_anon_rmap() might have changed the anon_vma as we
+		 * might not hold the folio lock here.
+		 */
+		if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
+			     anon_mapping)) {
+			up_read(&root_anon_vma->rwsem);
+			rcu_read_unlock();
+			goto retry;
+		}
+
+		/*
 		 * If the folio is still mapped, then this anon_vma is still
 		 * its anon_vma, and holding the mutex ensures that it will
 		 * not go away, see anon_vma_free().
@@ -600,6 +611,18 @@ retry:
 
 	/*
 	 * folio_move_anon_rmap() might have changed the anon_vma as we might
+	 * not hold the folio lock here.
+	 */
+	if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
+		     anon_mapping)) {
+		anon_vma_unlock_read(anon_vma);
+		put_anon_vma(anon_vma);
+		anon_vma = NULL;
+		goto retry;
+	}
+
+	/*
+	 * folio_move_anon_rmap() might have changed the anon_vma as we might
 	 * not hold the folio lock here.
 	 */
 	if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-rmap-support-move-to-different-root-anon_vma-in-folio_move_anon_rmap.patch
userfaultfd-uffdio_move-uabi.patch


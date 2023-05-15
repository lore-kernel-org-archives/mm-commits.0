Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDEEFC7EE24
	for <mm-commits@archiver.kernel.org>; Mon, 15 May 2023 19:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240321AbjEOT6v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 May 2023 15:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbjEOT6u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2023 15:58:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F15D7
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 12:58:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0683E631F6
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 19:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D9DC4339C;
        Mon, 15 May 2023 19:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684180728;
        bh=Fevo8v3dR2leTjBX7C5/DbGvGcQoZHLLeHbRPeMDycg=;
        h=Date:To:From:Subject:From;
        b=xpXem0Hn3XeSttyyRBhDDheoQ319iEAicDtowDbb14VvWwnWmCWNuppz8XcFJ8cnr
         Xzyw9+1D+ZvmGwBMc6wcPzfQCCjAXZ5kpNJy3R0WfUIb5gg7nukqAh4BL/TcXI1MbL
         e9FHrxibmSZWdWleq1VxmZP9jnuBqeuzbogWO8YU=
Date:   Mon, 15 May 2023 12:58:47 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        rppt@kernel.org, peterx@redhat.com, mark.rutland@arm.com,
        Liam.Howlett@oracle.com, brauner@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-avoid-passing-an-invalid-range-to-vma_merge.patch added to mm-hotfixes-unstable branch
Message-Id: <20230515195848.54D9DC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: userfaultfd: avoid passing an invalid range to vma_merge()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-avoid-passing-an-invalid-range-to-vma_merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-avoid-passing-an-invalid-range-to-vma_merge.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: userfaultfd: avoid passing an invalid range to vma_merge()
Date: Mon, 15 May 2023 20:32:32 +0100

The userfaultfd_[un]register() functions will knowingly pass an invalid
address range to vma_merge(), then rely on it failing to merge to indicate
that the VMA should be split into a valid one.

This is not something that should be relied upon, as vma_merge()
implicitly assumes in cases 5-8 that curr->vm_start == addr.  This is now
enforced since commit b0729ae0ae67 ("mm/mmap/vma_merge: explicitly assign
res, vma, extend invariants") with an explicit VM_WARN_ON() check.

Since commit 29417d292bd0 ("mm/mmap/vma_merge: always check invariants")
this check is performed unconditionally, which caused this assert to arise
in tests performed by Mark [1].

This patch fixes the issue by performing the split operations before
attempting to merge VMAs in both instances.  The problematic operation is
splitting the start of the VMA since we were clamping to the end of the
VMA in any case, however it is useful to group both of the split
operations together to avoid egregious goto's and to abstract the code
between the functions.

As well as fixing the repro described in [1] this also continues to pass
uffd unit tests.

[1]:https://lore.kernel.org/all/ZFunF7DmMdK05MoF@FVFF77S0Q05N.cambridge.arm.com

Link: https://lkml.kernel.org/r/20230515193232.67552-1-lstoakes@gmail.com
Fixes: 29417d292bd0 ("mm/mmap/vma_merge: always check invariants")
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reported-by: Mark Rutland <mark.rutland@arm.com>
Closes: https://lore.kernel.org/all/ZFunF7DmMdK05MoF@FVFF77S0Q05N.cambridge.arm.com/
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |  108 +++++++++++++++++++++++++--------------------
 1 file changed, 60 insertions(+), 48 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-avoid-passing-an-invalid-range-to-vma_merge
+++ a/fs/userfaultfd.c
@@ -1319,6 +1319,32 @@ static __always_inline int validate_rang
 	return 0;
 }
 
+static int clamp_range(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		       unsigned long start, unsigned long end, bool *can_merge)
+{
+	int ret;
+	bool merge = true;
+
+	/* The range must always be clamped to the start of a VMA. */
+	if (vma->vm_start < start) {
+		ret = split_vma(vmi, vma, start, 1);
+		if (ret)
+			return ret;
+
+		merge = false;
+	}
+
+	/* It must also be clamped to the end of a VMA. */
+	if (vma->vm_end > end) {
+		ret = split_vma(vmi, vma, end, 0);
+		if (ret)
+			return ret;
+	}
+
+	*can_merge = merge;
+	return 0;
+}
+
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 				unsigned long arg)
 {
@@ -1330,7 +1356,7 @@ static int userfaultfd_register(struct u
 	unsigned long vm_flags, new_flags;
 	bool found;
 	bool basic_ioctls;
-	unsigned long start, end, vma_end;
+	unsigned long start, end;
 	struct vma_iterator vmi;
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
@@ -1462,6 +1488,8 @@ static int userfaultfd_register(struct u
 
 	ret = 0;
 	for_each_vma_range(vmi, vma, end) {
+		bool can_merge;
+
 		cond_resched();
 
 		BUG_ON(!vma_can_userfault(vma, vm_flags));
@@ -1477,32 +1505,22 @@ static int userfaultfd_register(struct u
 		    (vma->vm_flags & vm_flags) == vm_flags)
 			goto skip;
 
-		if (vma->vm_start > start)
-			start = vma->vm_start;
-		vma_end = min(end, vma->vm_end);
+		ret = clamp_range(&vmi, vma, start, end, &can_merge);
+		if (ret)
+			break;
 
 		new_flags = (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags;
-		prev = vma_merge(&vmi, mm, prev, start, vma_end, new_flags,
-				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
-				 vma_policy(vma),
-				 ((struct vm_userfaultfd_ctx){ ctx }),
-				 anon_vma_name(vma));
-		if (prev) {
+		if (can_merge) {
+			prev = vma_merge(&vmi, mm, prev, vma->vm_start, vma->vm_end, new_flags,
+					 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
+					 vma_policy(vma),
+					 ((struct vm_userfaultfd_ctx){ ctx }),
+					 anon_vma_name(vma));
+
 			/* vma_merge() invalidated the mas */
-			vma = prev;
-			goto next;
-		}
-		if (vma->vm_start < start) {
-			ret = split_vma(&vmi, vma, start, 1);
-			if (ret)
-				break;
-		}
-		if (vma->vm_end > end) {
-			ret = split_vma(&vmi, vma, end, 0);
-			if (ret)
-				break;
+			if (prev)
+				vma = prev;
 		}
-	next:
 		/*
 		 * In the vma_merge() successful mprotect-like case 8:
 		 * the next vma was merged into the current one and
@@ -1560,7 +1578,7 @@ static int userfaultfd_unregister(struct
 	struct uffdio_range uffdio_unregister;
 	unsigned long new_flags;
 	bool found;
-	unsigned long start, end, vma_end;
+	unsigned long start, end;
 	const void __user *buf = (void __user *)arg;
 	struct vma_iterator vmi;
 
@@ -1627,6 +1645,8 @@ static int userfaultfd_unregister(struct
 	prev = vma_prev(&vmi);
 	ret = 0;
 	for_each_vma_range(vmi, vma, end) {
+		bool can_merge;
+
 		cond_resched();
 
 		BUG_ON(!vma_can_userfault(vma, vma->vm_flags));
@@ -1640,9 +1660,9 @@ static int userfaultfd_unregister(struct
 
 		WARN_ON(!(vma->vm_flags & VM_MAYWRITE));
 
-		if (vma->vm_start > start)
-			start = vma->vm_start;
-		vma_end = min(end, vma->vm_end);
+		ret = clamp_range(&vmi, vma, start, end, &can_merge);
+		if (ret)
+			break;
 
 		if (userfaultfd_missing(vma)) {
 			/*
@@ -1652,35 +1672,27 @@ static int userfaultfd_unregister(struct
 			 * UFFDIO_WAKE explicitly.
 			 */
 			struct userfaultfd_wake_range range;
-			range.start = start;
-			range.len = vma_end - start;
+			range.start = vma->vm_start;
+			range.len = vma->vm_end - vma->vm_start;
 			wake_userfault(vma->vm_userfaultfd_ctx.ctx, &range);
 		}
 
 		/* Reset ptes for the whole vma range if wr-protected */
 		if (userfaultfd_wp(vma))
-			uffd_wp_range(vma, start, vma_end - start, false);
+			uffd_wp_range(vma, vma->vm_start,
+				      vma->vm_end - vma->vm_start, false);
 
 		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
-		prev = vma_merge(&vmi, mm, prev, start, vma_end, new_flags,
-				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
-				 vma_policy(vma),
-				 NULL_VM_UFFD_CTX, anon_vma_name(vma));
-		if (prev) {
-			vma = prev;
-			goto next;
-		}
-		if (vma->vm_start < start) {
-			ret = split_vma(&vmi, vma, start, 1);
-			if (ret)
-				break;
-		}
-		if (vma->vm_end > end) {
-			ret = split_vma(&vmi, vma, end, 0);
-			if (ret)
-				break;
+		if (can_merge) {
+			prev = vma_merge(&vmi, mm, prev, vma->vm_start,
+					 vma->vm_end, new_flags, vma->anon_vma,
+					 vma->vm_file, vma->vm_pgoff,
+					 vma_policy(vma),
+					 NULL_VM_UFFD_CTX, anon_vma_name(vma));
+			/* vma_merge() invalidated the mas */
+			if (prev)
+				vma = prev;
 		}
-	next:
 		/*
 		 * In the vma_merge() successful mprotect-like case 8:
 		 * the next vma was merged into the current one and
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-userfaultfd-avoid-passing-an-invalid-range-to-vma_merge.patch
mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch
mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch
mm-gup-remove-unused-vmas-parameter-from-get_user_pages.patch
mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch
mm-gup-remove-vmas-parameter-from-get_user_pages_remote.patch
io_uring-rsrc-delegate-vma-file-backed-check-to-gup.patch
mm-gup-remove-vmas-parameter-from-pin_user_pages.patch
mm-gup-remove-vmas-array-from-internal-gup-functions.patch


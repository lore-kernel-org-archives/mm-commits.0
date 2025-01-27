Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A814E17799F
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738010527; cv=none; b=Yf0BQ1NNdTolM3VV3DIrz3ac4Mf345yzQFg3dDUyf8mqNrAXUgYPHfykMkdTPhhhlO2tbO4zzvCjHfF0LrRXJy44xqWB2486BrukA3Lw9SwOMgBkC1UxL6bo9FgleQSFl7hNz8eEd/Fhe3wBfwDcH+x4/sRqLlB4TqNUsZAO5dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738010527; c=relaxed/simple;
	bh=QtLXV5S1NN53bLM2Pj5rbHPq6kovJnwqD7wDrC9dleY=;
	h=Date:To:From:Subject:Message-Id; b=SUcL2isIsBTCprFBHxEj6jTPGUTzDf9NMAmR+OWS8/oT+uANr4B/8aE0XCUDuztFHA7mHLaVwBSVcVSabVubmIZGN2j3do9YhOAonpFMU2/GFIEaenNof5qPx2GHJRPkH63Z1AxC6ZF5fR5xn/OThxhhAH0rnNHpbdJIBJhiioQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qUjTEOpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qUjTEOpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF41C4CED2;
	Mon, 27 Jan 2025 20:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738010526;
	bh=QtLXV5S1NN53bLM2Pj5rbHPq6kovJnwqD7wDrC9dleY=;
	h=Date:To:From:Subject:From;
	b=qUjTEOpbicNhnLCURuN7ln3633yPckALdjPDhH7tJlv3ECu4iIvJKMDPBPRTVzXQR
	 rqFPnBiX06iVJvCYJZlZGJN2gIrffagYpAj/s6Mp0Y7cWO5rPC9qBd6di4fsyCUvTf
	 X6KP22YpnB54pOlc92V972/1KE+wEvJlHAEhG/Ew=
Date: Mon, 27 Jan 2025 12:42:05 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,willy@infradead.org,peterz@infradead.org,oleg@redhat.com,mhocko@suse.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-be-more-careful-about-dup_mmap-failures-and-uprobe-registering.patch added to mm-hotfixes-unstable branch
Message-Id: <20250127204206.0AF41C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel: be more careful about dup_mmap() failures and uprobe registering
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kernel-be-more-careful-about-dup_mmap-failures-and-uprobe-registering.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-be-more-careful-about-dup_mmap-failures-and-uprobe-registering.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: kernel: be more careful about dup_mmap() failures and uprobe registering
Date: Mon, 27 Jan 2025 12:02:21 -0500

If a memory allocation fails during dup_mmap(), the maple tree can be left
in an unsafe state for other iterators besides the exit path.  All the
locks are dropped before the exit_mmap() call (in mm/mmap.c), but the
incomplete mm_struct can be reached through (at least) the rmap finding
the vmas which have a pointer back to the mm_struct.

Up to this point, there have been no issues with being able to find an
mm_struct that was only partially initialised.  Syzbot was able to make
the incomplete mm_struct fail with recent forking changes, so it has been
proven unsafe to use the mm_struct that hasn't been initialised, as
referenced in the link below.

Although 8ac662f5da19f ("fork: avoid inappropriate uprobe access to
invalid mm") fixed the uprobe access, it does not completely remove the
race.

This patch sets the MMF_OOM_SKIP to avoid the iteration of the vmas on the
oom side (even though this is extremely unlikely to be selected as an oom
victim in the race window), and sets MMF_UNSTABLE to avoid other potential
users from using a partially initialised mm_struct.

When registering vmas for uprobe, skip the vmas in an mm that is marked
unstable.  Modifying a vma in an unstable mm may cause issues if the mm
isn't fully initialised.

Link: https://lore.kernel.org/all/6756d273.050a0220.2477f.003d.GAE@google.com/
Link: https://lkml.kernel.org/r/20250127170221.1761366-1-Liam.Howlett@oracle.com
Fixes: d240629148377 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    4 ++++
 kernel/fork.c           |   17 ++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

--- a/kernel/events/uprobes.c~kernel-be-more-careful-about-dup_mmap-failures-and-uprobe-registering
+++ a/kernel/events/uprobes.c
@@ -28,6 +28,7 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/workqueue.h>
 #include <linux/srcu.h>
+#include <linux/oom.h>          /* check_stable_address_space */
 
 #include <linux/uprobes.h>
 
@@ -1260,6 +1261,9 @@ register_for_each_vma(struct uprobe *upr
 		 * returns NULL in find_active_uprobe_rcu().
 		 */
 		mmap_write_lock(mm);
+		if (check_stable_address_space(mm))
+			goto unlock;
+
 		vma = find_vma(mm, info->vaddr);
 		if (!vma || !valid_vma(vma, is_register) ||
 		    file_inode(vma->vm_file) != uprobe->inode)
--- a/kernel/fork.c~kernel-be-more-careful-about-dup_mmap-failures-and-uprobe-registering
+++ a/kernel/fork.c
@@ -760,7 +760,8 @@ loop_out:
 		mt_set_in_rcu(vmi.mas.tree);
 		ksm_fork(mm, oldmm);
 		khugepaged_fork(mm, oldmm);
-	} else if (mpnt) {
+	} else {
+
 		/*
 		 * The entire maple tree has already been duplicated. If the
 		 * mmap duplication fails, mark the failure point with
@@ -768,8 +769,18 @@ loop_out:
 		 * stop releasing VMAs that have not been duplicated after this
 		 * point.
 		 */
-		mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
-		mas_store(&vmi.mas, XA_ZERO_ENTRY);
+		if (mpnt) {
+			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
+			mas_store(&vmi.mas, XA_ZERO_ENTRY);
+			/* Avoid OOM iterating a broken tree */
+			set_bit(MMF_OOM_SKIP, &mm->flags);
+		}
+		/*
+		 * The mm_struct is going to exit, but the locks will be dropped
+		 * first.  Set the mm_struct as unstable is advisable as it is
+		 * not fully initialised.
+		 */
+		set_bit(MMF_UNSTABLE, &mm->flags);
 	}
 out:
 	mmap_write_unlock(mm);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

kernel-be-more-careful-about-dup_mmap-failures-and-uprobe-registering.patch


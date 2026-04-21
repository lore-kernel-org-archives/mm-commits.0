Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A683F9FB;
	Tue, 21 Apr 2026 10:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776767770; cv=none; b=lGXZdhsdr/Bb1msrQbsY8uOsfu06k5XC5ttt/EeN6x0OM3qz6wmZVQEHHExzsb6JHbTuYJ0qyXhMJS60RbmxiDPU0tQTvdPsypki7R+rwz9GLdvFGP0ToWEjwn25U8YaMWVQEuh1ux2pKGBSBpcA/l4dlhkf52pPOuYt+z5hw+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776767770; c=relaxed/simple;
	bh=Thkm8FEgdmMQkcZIsHXL5Zt1EA1XVjNddKgCseGUmLM=;
	h=Date:To:From:Subject:Message-Id; b=F8bEwJ4HRUAtmF9ekyHFpaWe5qrf7DZktCTEGw3kYyfSJRP97zavaDARRLdzap0c7nA+9ZAz0vkC8lZUQ+veWbJL1ieOCrJ4z7RsfYbuFS2pNDkXblW/QHxBTRngDka1Us7OUMzxnnkZNK3Tnryo7UOcFCgcId5NWMgL9HeDHA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AtoDX2iu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AtoDX2iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A850EC2BCB0;
	Tue, 21 Apr 2026 10:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776767770;
	bh=Thkm8FEgdmMQkcZIsHXL5Zt1EA1XVjNddKgCseGUmLM=;
	h=Date:To:From:Subject:From;
	b=AtoDX2iuCvqINrTckoF1CBW+Ns8IaCUW8OiLVdZDW0wMbs4wYCPArrf+hMDWekskq
	 otA8O17j8XPMuMuSPX8wgAsJdQ6xxpOk+zBFQ9dZwd0S1J+BlV7e2Mi7yc4DGNUsSc
	 EuS1VVNoNjN2z6+GFc/9cfhFe13AfddAy7zy2+tM=
Date: Tue, 21 Apr 2026 03:36:06 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-do-not-try-to-unmap-a-vma-if-mmap_prepare-invoked-from-mmap.patch added to mm-hotfixes-unstable branch
Message-Id: <20260421103609.A850EC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: do not try to unmap a VMA if mmap_prepare() invoked from mmap()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-do-not-try-to-unmap-a-vma-if-mmap_prepare-invoked-from-mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-do-not-try-to-unmap-a-vma-if-mmap_prepare-invoked-from-mmap.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: do not try to unmap a VMA if mmap_prepare() invoked from mmap()
Date: Tue, 21 Apr 2026 11:21:50 +0100

The mmap_prepare hook functionality includes the ability to invoke
mmap_prepare() from the mmap() hook of existing 'stacked' drivers, that is
ones which are capable of calling the mmap hooks of other drivers/file
systems (e.g.  overlayfs, shm).

As part of the mmap_prepare action functionality, we deal with errors by
unmapping the VMA should one arise.  This works in the usual mmap_prepare
case, as we invoke this action at the last moment, when the VMA is
established in the maple tree.

However, the mmap() hook passes a not-fully-established VMA pointer to the
caller (which is the motivation behind the mmap_prepare() work), which is
detached.

So attempting to unmap a VMA in this state will be problematic, with the
most obvious symptom being a warning in vma_mark_detached(), because the
VMA is already detached.

It's also unncessary - the mmap() handler will clean up the VMA on error.

So to fix this issue, this patch propagates whether or not an mmap action
is being completed via the compatibility layer or directly.

If the former, then we do not attempt VMA cleanup, if the latter, then we
do.

This patch also updates the userland VMA tests to reflect the change.

Link: https://lore.kernel.org/20260421102150.189982-1-ljs@kernel.org
Fixes: ac0a3fc9c07d ("mm: add ability to take further action in vm_area_desc")
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reported-by: syzbot+db390288d141a1dccf96@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69e69734.050a0220.24bfd3.0027.GAE@google.com/
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h                |    2 +-
 mm/util.c                         |   26 +++++++++++++++++---------
 mm/vma.c                          |    3 ++-
 tools/testing/vma/include/dup.h   |    2 +-
 tools/testing/vma/include/stubs.h |    3 ++-
 5 files changed, 23 insertions(+), 13 deletions(-)

--- a/include/linux/mm.h~mm-vma-do-not-try-to-unmap-a-vma-if-mmap_prepare-invoked-from-mmap
+++ a/include/linux/mm.h
@@ -4391,7 +4391,7 @@ static inline void mmap_action_map_kerne
 
 int mmap_action_prepare(struct vm_area_desc *desc);
 int mmap_action_complete(struct vm_area_struct *vma,
-			 struct mmap_action *action);
+			 struct mmap_action *action, bool is_compat);
 
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
--- a/mm/util.c~mm-vma-do-not-try-to-unmap-a-vma-if-mmap_prepare-invoked-from-mmap
+++ a/mm/util.c
@@ -1232,7 +1232,7 @@ int __compat_vma_mmap(struct vm_area_des
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
-	return mmap_action_complete(vma, &desc->action);
+	return mmap_action_complete(vma, &desc->action, /*is_compat=*/true);
 }
 EXPORT_SYMBOL(__compat_vma_mmap);
 
@@ -1389,7 +1389,8 @@ static int call_vma_mapped(struct vm_are
 }
 
 static int mmap_action_finish(struct vm_area_struct *vma,
-			      struct mmap_action *action, int err)
+			      struct mmap_action *action, int err,
+			      bool is_compat)
 {
 	size_t len;
 
@@ -1400,8 +1401,12 @@ static int mmap_action_finish(struct vm_
 
 	/* do_munmap() might take rmap lock, so release if held. */
 	maybe_rmap_unlock_action(vma, action);
-	if (!err)
-		return 0;
+	/*
+	 * If this is invoked from the compatibility layer, post-mmap() hook
+	 * logic will handle cleanup for us.
+	 */
+	if (!err || is_compat)
+		return err;
 
 	/*
 	 * If an error occurs, unmap the VMA altogether and return an error. We
@@ -1451,13 +1456,15 @@ EXPORT_SYMBOL(mmap_action_prepare);
  * mmap_action_complete - Execute VMA descriptor action.
  * @vma: The VMA to perform the action upon.
  * @action: The action to perform.
+ * @is_compat: Is this being invoked from the compatibility layer?
  *
  * Similar to mmap_action_prepare().
  *
- * Return: 0 on success, or error, at which point the VMA will be unmapped.
+ * Return: 0 on success, or error, at which point the VMA will be unmapped if
+ * !@is_compat.
  */
 int mmap_action_complete(struct vm_area_struct *vma,
-			 struct mmap_action *action)
+			 struct mmap_action *action, bool is_compat)
 {
 	int err = 0;
 
@@ -1478,7 +1485,7 @@ int mmap_action_complete(struct vm_area_
 		break;
 	}
 
-	return mmap_action_finish(vma, action, err);
+	return mmap_action_finish(vma, action, err, is_compat);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #else
@@ -1500,7 +1507,8 @@ int mmap_action_prepare(struct vm_area_d
 EXPORT_SYMBOL(mmap_action_prepare);
 
 int mmap_action_complete(struct vm_area_struct *vma,
-			 struct mmap_action *action)
+			 struct mmap_action *action,
+			 bool is_compat)
 {
 	int err = 0;
 
@@ -1517,7 +1525,7 @@ int mmap_action_complete(struct vm_area_
 		break;
 	}
 
-	return mmap_action_finish(vma, action, err);
+	return mmap_action_finish(vma, action, err, is_compat);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #endif
--- a/mm/vma.c~mm-vma-do-not-try-to-unmap-a-vma-if-mmap_prepare-invoked-from-mmap
+++ a/mm/vma.c
@@ -2780,7 +2780,8 @@ static unsigned long __mmap_region(struc
 	__mmap_complete(&map, vma);
 
 	if (have_mmap_prepare && allocated_new) {
-		error = mmap_action_complete(vma, &desc.action);
+		error = mmap_action_complete(vma, &desc.action,
+					     /*is_compat=*/false);
 		if (error)
 			return error;
 	}
--- a/tools/testing/vma/include/dup.h~mm-vma-do-not-try-to-unmap-a-vma-if-mmap_prepare-invoked-from-mmap
+++ a/tools/testing/vma/include/dup.h
@@ -1330,7 +1330,7 @@ static inline int __compat_vma_mmap(stru
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
-	return mmap_action_complete(vma, &desc->action);
+	return mmap_action_complete(vma, &desc->action, /*is_compat=*/true);
 }
 
 static inline int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
--- a/tools/testing/vma/include/stubs.h~mm-vma-do-not-try-to-unmap-a-vma-if-mmap_prepare-invoked-from-mmap
+++ a/tools/testing/vma/include/stubs.h
@@ -87,7 +87,8 @@ static inline int mmap_action_prepare(st
 }
 
 static inline int mmap_action_complete(struct vm_area_struct *vma,
-				       struct mmap_action *action)
+				       struct mmap_action *action,
+				       bool is_compat)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-do-not-try-to-unmap-a-vma-if-mmap_prepare-invoked-from-mmap.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A1B4685;
	Thu, 29 May 2025 19:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748546807; cv=none; b=nvYK7oiUEZLng0hAYvWOFnNCUMI9Sicic+RqTUi+QBv5UXwEfEsQe3r8flNjGPo74a/o0zsyWrVfk4Rpjq5fayWULIuhE6HS1JqVvllBzx8KYjxFG6rH7fg4NKAvSCgsppfiXWc6H4bxqYbgHNA838uHvWnO9eprhKTmO34UN8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748546807; c=relaxed/simple;
	bh=YQpvX8b8VhdjOJaZkqSsskEzuhLf8gH+THmFjuwjHsw=;
	h=Date:To:From:Subject:Message-Id; b=FlI6bFFSYMBZMyepDvWhQE0afmhmc0kyNrpci3hWo9papo6MXvsTBLz/zI0P1j0UpZtwFWYknxpF/9huZLtMbgsjnkRpDrwj386eEFxSycLZBrrn1wXA1Hr4LK3rGugSy9Uw6jUY0lK0NNvRhhZAEzaJbYpxGKJv3z1UxZgDZcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cua9L4ts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cua9L4ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49340C4CEE7;
	Thu, 29 May 2025 19:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748546806;
	bh=YQpvX8b8VhdjOJaZkqSsskEzuhLf8gH+THmFjuwjHsw=;
	h=Date:To:From:Subject:From;
	b=Cua9L4tsfRyditBOasakusUxx5CGgCYK+0D5YSFD2oWYhujZM3EWA+p9xnF/SXSE0
	 oQ8cOAiIvdk0PkB4vYzSdV/2z0Tx3naTc850UsDIbPvII7PUwsGk0G3RZ2FjSxv/D3
	 3mJeTWf+pSAXlMLQO+4dOTAqb/MnIQfi3ACjPKcg=
Date: Thu, 29 May 2025 12:26:45 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,pulehui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-uprobe-pte-be-overwritten-when-expanding-vma.patch added to mm-unstable branch
Message-Id: <20250529192646.49340C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix uprobe pte be overwritten when expanding vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-uprobe-pte-be-overwritten-when-expanding-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-uprobe-pte-be-overwritten-when-expanding-vma.patch

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
From: Pu Lehui <pulehui@huawei.com>
Subject: mm: fix uprobe pte be overwritten when expanding vma
Date: Thu, 29 May 2025 15:56:47 +0000

Patch series "Fix uprobe pte be overwritten when expanding vma".


This patch (of 4):

We encountered a BUG alert triggered by Syzkaller as follows:
   BUG: Bad rss-counter state mm:00000000b4a60fca type:MM_ANONPAGES val:1

And we can reproduce it with the following steps:
1. register uprobe on file at zero offset
2. mmap the file at zero offset:
   addr1 = mmap(NULL, 2 * 4096, PROT_NONE, MAP_PRIVATE, fd, 0);
3. mremap part of vma1 to new vma2:
   addr2 = mremap(addr1, 4096, 2 * 4096, MREMAP_MAYMOVE);
4. mremap back to orig addr1:
   mremap(addr2, 4096, 4096, MREMAP_MAYMOVE | MREMAP_FIXED, addr1);

In step 3, the vma1 range [addr1, addr1 + 4096] will be remap to new vma2
with range [addr2, addr2 + 8192], and remap uprobe anon page from the vma1
to vma2, then unmap the vma1 range [addr1, addr1 + 4096].

In step 4, the vma2 range [addr2, addr2 + 4096] will be remap back to the
addr range [addr1, addr1 + 4096].  Since the addr range [addr1 + 4096,
addr1 + 8192] still maps the file, it will take vma_merge_new_range to
expand the range, and then do uprobe_mmap in vma_complete.  Since the
merged vma pgoff is also zero offset, it will install uprobe anon page to
the merged vma.  However, the upcomming move_page_tables step, which use
set_pte_at to remap the vma2 uprobe pte to the merged vma, will overwrite
the newly uprobe pte in the merged vma, and lead that pte to be orphan.

Since the uprobe pte will be remapped to the merged vma, we can remove the
unnecessary uprobe_mmap upon merged vma.

This problem was first found in linux-6.6.y and also exists in the
community syzkaller:
https://lore.kernel.org/all/000000000000ada39605a5e71711@google.com/T/

Link: https://lkml.kernel.org/r/20250529155650.4017699-1-pulehui@huaweicloud.com
Link: https://lkml.kernel.org/r/20250529155650.4017699-2-pulehui@huaweicloud.com
Fixes: 2b1444983508 ("uprobes, mm, x86: Add the ability to install and remove uprobes breakpoints")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   20 +++++++++++++++++---
 mm/vma.h |    7 +++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

--- a/mm/vma.c~mm-fix-uprobe-pte-be-overwritten-when-expanding-vma
+++ a/mm/vma.c
@@ -169,6 +169,9 @@ static void init_multi_vma_prep(struct v
 	vp->file = vma->vm_file;
 	if (vp->file)
 		vp->mapping = vma->vm_file->f_mapping;
+
+	if (vmg && vmg->skip_vma_uprobe)
+		vp->skip_vma_uprobe = true;
 }
 
 /*
@@ -358,10 +361,13 @@ static void vma_complete(struct vma_prep
 
 	if (vp->file) {
 		i_mmap_unlock_write(vp->mapping);
-		uprobe_mmap(vp->vma);
 
-		if (vp->adj_next)
-			uprobe_mmap(vp->adj_next);
+		if (!vp->skip_vma_uprobe) {
+			uprobe_mmap(vp->vma);
+
+			if (vp->adj_next)
+				uprobe_mmap(vp->adj_next);
+		}
 	}
 
 	if (vp->remove) {
@@ -1830,6 +1836,14 @@ struct vm_area_struct *copy_vma(struct v
 		faulted_in_anon_vma = false;
 	}
 
+	/*
+	 * If the VMA we are copying might contain a uprobe PTE, ensure
+	 * that we do not establish one upon merge. Otherwise, when mremap()
+	 * moves page tables, it will orphan the newly created PTE.
+	 */
+	if (vma->vm_file)
+		vmg.skip_vma_uprobe = true;
+
 	new_vma = find_vma_prev(mm, addr, &vmg.prev);
 	if (new_vma && new_vma->vm_start < addr + len)
 		return NULL;	/* should never get here */
--- a/mm/vma.h~mm-fix-uprobe-pte-be-overwritten-when-expanding-vma
+++ a/mm/vma.h
@@ -19,6 +19,8 @@ struct vma_prepare {
 	struct vm_area_struct *insert;
 	struct vm_area_struct *remove;
 	struct vm_area_struct *remove2;
+
+	bool skip_vma_uprobe :1;
 };
 
 struct unlink_vma_file_batch {
@@ -120,6 +122,11 @@ struct vma_merge_struct {
 	 */
 	bool give_up_on_oom :1;
 
+	/*
+	 * If set, skip uprobe_mmap upon merged vma.
+	 */
+	bool skip_vma_uprobe :1;
+
 	/* Internal flags set during merge process: */
 
 	/*
_

Patches currently in -mm which might be from pulehui@huawei.com are

mm-fix-uprobe-pte-be-overwritten-when-expanding-vma.patch
mm-expose-abnormal-new_pte-during-move_ptes.patch
selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util.patch
selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge.patch


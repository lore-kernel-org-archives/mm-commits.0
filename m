Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5690220F24
	for <mm-commits@vger.kernel.org>; Fri, 12 Sep 2025 23:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719001; cv=none; b=sxh+PHg80+u/zNuwokMwcMSHteevQZ49KZeHcd6uyMeVzeaWjCnAO2lU8EjF8JV/t8zKfyajd8pHq29PqODyvqef0cE3qTdxXGxm5wzQ4rZBu3iom6ziwQtf56oqlrIXKZR/r1Jiae276I11FYHTbAFnT+yaAbb3W1z39gLSOuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719001; c=relaxed/simple;
	bh=YaRNCPbLcdzBJYwI45/EmGgNXsz7YLmqv5YQbymWTLw=;
	h=Date:To:From:Subject:Message-Id; b=uD+dFkLOY2Snkqzlb/xPA5XlKzTap9WnjhpetDD5ot8V9ChA6Y/bF5Tkr+2/aRud3X/E08Na+G7EQ3C7M+vBCkPnrVaQVSB9hEUx6aDC4IcHnZgm+VGxu9CHrvWu2pe/z3tcCsTg5eKIdwxcNjUVrraQtLnAN3vRAqEzgilK8wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1LFjrmV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1LFjrmV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2229BC4CEF1;
	Fri, 12 Sep 2025 23:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757719001;
	bh=YaRNCPbLcdzBJYwI45/EmGgNXsz7YLmqv5YQbymWTLw=;
	h=Date:To:From:Subject:From;
	b=1LFjrmV4xHY2+muu4dOgolyXQLfWH/L+HJF7KiRONtYvJmQs6F+pQdo1yoGQcpu6j
	 y7+EfGHnSC4X31arURGFsd9PVaKAglxEE51FgLgDQ+kiTFrzv/gJgE91MsU8/334Fg
	 AmuwC9afi4Ruayy+wQxWfe5wVY+DlSGqPeVLnGeg=
Date: Fri, 12 Sep 2025 16:16:40 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-update-vmcore-to-use-proc_mmap_prepare-fix.patch added to mm-unstable branch
Message-Id: <20250912231641.2229BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmcore fix
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-update-vmcore-to-use-proc_mmap_prepare-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-update-vmcore-to-use-proc_mmap_prepare-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: vmcore fix
Date: Fri, 12 Sep 2025 11:12:10 +0100

Link: https://lkml.kernel.org/r/26d584a9-86da-4286-b980-d45ecf6321d4@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/proc/vmcore.c~fs-proc-update-vmcore-to-use-proc_mmap_prepare-fix
+++ a/fs/proc/vmcore.c
@@ -592,11 +592,10 @@ static int mmap_prepare_action_vmcore(st
 {
 	struct mmap_action action;
 	size_t size = vma->vm_end - vma->vm_start;
-	u64 start, end, len, tsz;
+	u64 start, len, tsz;
 	struct vmcore_range *m;
 
 	start = (u64)vma->vm_pgoff << PAGE_SHIFT;
-	end = start + size;
 	len = 0;
 
 	if (start < elfcorebuf_sz) {
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-jann-horn-as-rmap-reviewer.patch
mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch
mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch
mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch
mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-introduce-io_remap_pfn_range_.patch
mm-introduce-io_remap_pfn_range_-fix.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-update-cramfs-to-use-mmap_prepare.patch
fs-proc-add-the-proc_mmap_prepare-hook-for-procfs.patch
fs-proc-update-vmcore-to-use-proc_mmap_prepare.patch
fs-proc-update-vmcore-to-use-proc_mmap_prepare-fix.patch
kcov-update-kcov-to-use-mmap_prepare.patch


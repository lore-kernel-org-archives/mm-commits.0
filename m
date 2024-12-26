Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD6442AA1
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735247779; cv=none; b=pr+GNmsIcX30PBl+SyhHlZZYoR9V7gQf0RuwAHjJ1ILK6bABYrXfWIJ/ALT4CRg79bTG52Ow5kRw4dFiiWl4Q9OaziYDeR9BCubFbgZGowqLm3Ep+p9AObgzDTXSoJfuC/iBI6hETmQc94asvo3tqRoc+8wEXwnEE734fxfGr9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735247779; c=relaxed/simple;
	bh=gqqWX5KgsWaOl/c/43vSLJLz5ILx8RaGyMI0VRwz2Bc=;
	h=Date:To:From:Subject:Message-Id; b=loPpyn6fVTvOHCB7dQeGeDG7Xg61WFEknLX6yC+0YJ8bTzr/VyeEDmRy3CzVsk/1HoAcYu7mX60EgyzLDmrLR68Tj9yDnmb9VwQjTdKGPDTvA/Th1bXJG87kTc8D2W8fQiBvHq2R9mISAhIrSg8l50Yt3StqinFuHSpySVAgqsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ificsuu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ificsuu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21FFC4CED1;
	Thu, 26 Dec 2024 21:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735247779;
	bh=gqqWX5KgsWaOl/c/43vSLJLz5ILx8RaGyMI0VRwz2Bc=;
	h=Date:To:From:Subject:From;
	b=Ificsuu3Tzk/GOaBlzmtpdArYuf5EACiX4m/+uXScujNucNz8QBkBlnhDMr4ep4LC
	 ke7dLi+lqxxv7IAYjizHBNMVKPV9KQv7+yJsChbQ7t3S57VG4tcXVVJ/pwBQ6XRxQc
	 uWvUULOA1a3iwdm1FihI5Dhy1WQeKXGYKPung8+g=
Date: Thu, 26 Dec 2024 13:16:19 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix.patch added to mm-unstable branch
Message-Id: <20241226211619.A21FFC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix
Date: Thu, 26 Dec 2024 12:03:35 -0800

vma->vm_refcnt does not exist when CONFIG_PER_VMA_LOCK=n, therefore when
CONFIG_PER_VMA_LOCK=n and CONFIG_DEBUG_VM=y we need to avoid its usage in
dump_vma().

Link: https://lkml.kernel.org/r/20241226200335.1250078-1-surenb@google.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412270328.HiJX1mRt-lkp@intel.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/debug.c~mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix
+++ a/mm/debug.c
@@ -178,6 +178,7 @@ EXPORT_SYMBOL(dump_page);
 
 void dump_vma(const struct vm_area_struct *vma)
 {
+#ifdef CONFIG_PER_VMA_LOCK
 	pr_emerg("vma %px start %px end %px mm %px\n"
 		"prot %lx anon_vma %px vm_ops %px\n"
 		"pgoff %lx file %px private_data %px\n"
@@ -187,6 +188,17 @@ void dump_vma(const struct vm_area_struc
 		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
 		vma->vm_file, vma->vm_private_data,
 		vma->vm_flags, &vma->vm_flags, refcount_read(&vma->vm_refcnt));
+#else
+	pr_emerg("vma %px start %px end %px mm %px\n"
+		"prot %lx anon_vma %px vm_ops %px\n"
+		"pgoff %lx file %px private_data %px\n"
+		"flags: %#lx(%pGv)\n",
+		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_mm,
+		(unsigned long)pgprot_val(vma->vm_page_prot),
+		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
+		vma->vm_file, vma->vm_private_data,
+		vma->vm_flags, &vma->vm_flags);
+#endif
 }
 EXPORT_SYMBOL(dump_vma);
 
_

Patches currently in -mm which might be from surenb@google.com are

seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma.patch
mm-mark-vmas-detached-upon-exit.patch
mm-nommu-fix-the-last-places-where-vma-is-not-locked-before-being-attached.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch


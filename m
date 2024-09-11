Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A607A1B29BA
	for <mm-commits@vger.kernel.org>; Wed, 11 Sep 2024 18:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726080767; cv=none; b=NqQMeYiNuCr41rx4Xu3aunLO8lbEMRFblQCKQYBqsGpPkQf0QKjuiFo5YBygqdzuvL2/MdFxkq1EMEafRipf5Tjzqbphds5KBBkoXSQmxEjj6NungNSY4LwStm1UKPaOLTwi7DFXSr6O4RFDiaPTlVNK8C5GfqnWrlDxNJcnaUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726080767; c=relaxed/simple;
	bh=sfclNxLN0sPH/hSjCechnuLBijuw5vp61D4YycMwzeA=;
	h=Date:To:From:Subject:Message-Id; b=ayUOPqxidQiDfirTRR6jPlZF2GT2BWSZvcXgEdbmSWyUX6bJ/57y2CeQjS8XOOLKRxdcud9jy0H3lZRvyOvxMfegJ1QpXP4sWd61qjjXPx2KzJzk4dSzYT1CHWWywTU7LwvCQ4KQjnI0dRY6jtLzgbWlFQZ2AF0c7FkuMX7/5JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k5NYLKh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k5NYLKh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B34C4CEC0;
	Wed, 11 Sep 2024 18:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726080766;
	bh=sfclNxLN0sPH/hSjCechnuLBijuw5vp61D4YycMwzeA=;
	h=Date:To:From:Subject:From;
	b=k5NYLKh+0DG/oUazXzVT9FE295xEqJ7hFlU/hRofKp5NeDtXiXZam8NK2f9/oXp8R
	 hYfYA6as9T8Juib5yxbab975LmM8y7lu1iv2sEKf3vFYkbXGZ4Q2k+2zQt6ZbjwFmA
	 8+CUza58yaUiz09QgT1Xfp8HzSUJypCR8F/MrAYM=
Date: Wed, 11 Sep 2024 11:52:39 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,svens@linux.ibm.com,peterz@infradead.org,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhiramat@kernel.org,mark.rutland@arm.com,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,andrii@kernel.org,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + uprobes-introduce-the-global-struct-vm_special_mapping-xol_mapping.patch added to mm-unstable branch
Message-Id: <20240911185245.43B34C4CEC0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: uprobes: introduce the global struct vm_special_mapping xol_mapping
has been added to the -mm mm-unstable branch.  Its filename is
     uprobes-introduce-the-global-struct-vm_special_mapping-xol_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uprobes-introduce-the-global-struct-vm_special_mapping-xol_mapping.patch

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
From: Oleg Nesterov <oleg@redhat.com>
Subject: uprobes: introduce the global struct vm_special_mapping xol_mapping
Date: Wed, 11 Sep 2024 15:14:07 +0200

Currently each xol_area has its own instance of vm_special_mapping, this
is suboptimal and ugly.  Kill xol_area->xol_mapping and add a single
global instance of vm_special_mapping, the ->fault() method can use
area->pages rather than xol_mapping->pages.

As a side effect this fixes the problem introduced by the recent commit
223febc6e557 ("mm: add optional close() to struct vm_special_mapping"), if
special_mapping_close() is called from the __mmput() paths, it will use
vma->vm_private_data = &area->xol_mapping freed by uprobe_clear_state().

Link: https://lkml.kernel.org/r/20240911131407.GB3448@redhat.com
Fixes: 223febc6e557 ("mm: add optional close() to struct vm_special_mapping")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Sven Schnelle <svens@linux.ibm.com>
Closes: https://lore.kernel.org/all/yt9dy149vprr.fsf@linux.ibm.com/
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/kernel/events/uprobes.c~uprobes-introduce-the-global-struct-vm_special_mapping-xol_mapping
+++ a/kernel/events/uprobes.c
@@ -99,7 +99,6 @@ struct xol_area {
 	atomic_t 			slot_count;	/* number of in-use slots */
 	unsigned long 			*bitmap;	/* 0 = free slot */
 
-	struct vm_special_mapping	xol_mapping;
 	struct page 			*pages[2];
 	/*
 	 * We keep the vma's vm_start rather than a pointer to the vma
@@ -1433,6 +1432,21 @@ void uprobe_munmap(struct vm_area_struct
 		set_bit(MMF_RECALC_UPROBES, &vma->vm_mm->flags);
 }
 
+static vm_fault_t xol_fault(const struct vm_special_mapping *sm,
+			    struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct xol_area *area = vma->vm_mm->uprobes_state.xol_area;
+
+	vmf->page = area->pages[0];
+	get_page(vmf->page);
+	return 0;
+}
+
+static const struct vm_special_mapping xol_mapping = {
+	.name = "[uprobes]",
+	.fault = xol_fault,
+};
+
 /* Slot allocation for XOL */
 static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
 {
@@ -1459,7 +1473,7 @@ static int xol_add_vma(struct mm_struct
 
 	vma = _install_special_mapping(mm, area->vaddr, PAGE_SIZE,
 				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|VM_IO,
-				&area->xol_mapping);
+				&xol_mapping);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		goto fail;
@@ -1498,9 +1512,6 @@ static struct xol_area *__create_xol_are
 	if (!area->bitmap)
 		goto free_area;
 
-	area->xol_mapping.name = "[uprobes]";
-	area->xol_mapping.fault = NULL;
-	area->xol_mapping.pages = area->pages;
 	area->pages[0] = alloc_page(GFP_HIGHUSER);
 	if (!area->pages[0])
 		goto free_bitmap;
_

Patches currently in -mm which might be from oleg@redhat.com are

revert-uprobes-use-vm_special_mapping-close-functionality.patch
uprobes-introduce-the-global-struct-vm_special_mapping-xol_mapping.patch
uprobes-turn-xol_area-pages-into-xol_area-page.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E993185B7B
	for <mm-commits@vger.kernel.org>; Wed, 11 Sep 2024 18:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726080758; cv=none; b=QXZZRrL1fExd7AKuR6emMXVVBq3Yb4bzTKwq4NMk2mHoRKrqB9QvliOVYlRJNMvlzQ8Z4KCBOTT5y8GoltpSNEUEdfks4j83vND1fuqAgZrjhpcOulXh6n4rujOhppICJdRnuWlMzxkzT/goyxMPMk2kV0Wd6HrdGHHwIGMMS4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726080758; c=relaxed/simple;
	bh=rxirT+dgBYzP68ya8n/FyCnXjP8fciWYrBlUPTxkc54=;
	h=Date:To:From:Subject:Message-Id; b=AYXvHARwEd4lYzMWrLnC3C8UOLc0rDsmbFmfz6kr1qSohkNWdvPKKoyaeh0Qv//DFPRDh4PiTuyWxh68xy5qHydAusOC86Y8qDuPONBpf4G+BfMMb+r7XYf2/083pYiXdmlXUuj/ouTw5MQsCsp4Gn7Po+XZAgCJOwd1Mxhlq1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T0FSCCUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T0FSCCUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25888C4CEC0;
	Wed, 11 Sep 2024 18:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726080758;
	bh=rxirT+dgBYzP68ya8n/FyCnXjP8fciWYrBlUPTxkc54=;
	h=Date:To:From:Subject:From;
	b=T0FSCCUrOw+3XPkWEja88HOc9SjfNivMMxHPR0VeGR/MO7mGf3s2Osf4fLeeZfdFr
	 ppHiOZJsChqwpTH2bRcrYyabJkC4mNxYyEczsYIgeembzWQX6VQRoyIdeN9lyBSQSZ
	 OLAIBDWcIkQM2iluNb4BowdmIaCuG+RMIYXsq44c=
Date: Wed, 11 Sep 2024 11:52:30 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,svens@linux.ibm.com,peterz@infradead.org,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhiramat@kernel.org,mark.rutland@arm.com,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,andrii@kernel.org,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-uprobes-use-vm_special_mapping-close-functionality.patch added to mm-unstable branch
Message-Id: <20240911185237.25888C4CEC0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "uprobes: use vm_special_mapping close() functionality"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-uprobes-use-vm_special_mapping-close-functionality.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-uprobes-use-vm_special_mapping-close-functionality.patch

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
Subject: Revert "uprobes: use vm_special_mapping close() functionality"
Date: Wed, 11 Sep 2024 15:13:20 +0200

This reverts commit 08e28de1160a712724268fd33d77b32f1bc84d1c.

A malicious application can munmap() its "[uprobes]" vma and in this case
xol_mapping.close == uprobe_clear_state() will free the memory which can
be used by another thread, or the same thread when it hits the uprobe bp
afterwards.

Link: https://lkml.kernel.org/r/20240911131320.GA3448@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uprobes.h |    1 +
 kernel/events/uprobes.c |   36 +++++++++++++++++++-----------------
 kernel/fork.c           |    1 +
 3 files changed, 21 insertions(+), 17 deletions(-)

--- a/include/linux/uprobes.h~revert-uprobes-use-vm_special_mapping-close-functionality
+++ a/include/linux/uprobes.h
@@ -126,6 +126,7 @@ extern int uprobe_pre_sstep_notifier(str
 extern void uprobe_notify_resume(struct pt_regs *regs);
 extern bool uprobe_deny_signal(void);
 extern bool arch_uprobe_skip_sstep(struct arch_uprobe *aup, struct pt_regs *regs);
+extern void uprobe_clear_state(struct mm_struct *mm);
 extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
 extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
--- a/kernel/events/uprobes.c~revert-uprobes-use-vm_special_mapping-close-functionality
+++ a/kernel/events/uprobes.c
@@ -1482,22 +1482,6 @@ void * __weak arch_uprobe_trampoline(uns
 	return &insn;
 }
 
-/*
- * uprobe_clear_state - Free the area allocated for slots.
- */
-static void uprobe_clear_state(const struct vm_special_mapping *sm, struct vm_area_struct *vma)
-{
-	struct xol_area *area = container_of(vma->vm_private_data, struct xol_area, xol_mapping);
-
-	mutex_lock(&delayed_uprobe_lock);
-	delayed_uprobe_remove(NULL, vma->vm_mm);
-	mutex_unlock(&delayed_uprobe_lock);
-
-	put_page(area->pages[0]);
-	kfree(area->bitmap);
-	kfree(area);
-}
-
 static struct xol_area *__create_xol_area(unsigned long vaddr)
 {
 	struct mm_struct *mm = current->mm;
@@ -1516,7 +1500,6 @@ static struct xol_area *__create_xol_are
 
 	area->xol_mapping.name = "[uprobes]";
 	area->xol_mapping.fault = NULL;
-	area->xol_mapping.close = uprobe_clear_state;
 	area->xol_mapping.pages = area->pages;
 	area->pages[0] = alloc_page(GFP_HIGHUSER);
 	if (!area->pages[0])
@@ -1562,6 +1545,25 @@ static struct xol_area *get_xol_area(voi
 	return area;
 }
 
+/*
+ * uprobe_clear_state - Free the area allocated for slots.
+ */
+void uprobe_clear_state(struct mm_struct *mm)
+{
+	struct xol_area *area = mm->uprobes_state.xol_area;
+
+	mutex_lock(&delayed_uprobe_lock);
+	delayed_uprobe_remove(NULL, mm);
+	mutex_unlock(&delayed_uprobe_lock);
+
+	if (!area)
+		return;
+
+	put_page(area->pages[0]);
+	kfree(area->bitmap);
+	kfree(area);
+}
+
 void uprobe_start_dup_mmap(void)
 {
 	percpu_down_read(&dup_mmap_sem);
--- a/kernel/fork.c~revert-uprobes-use-vm_special_mapping-close-functionality
+++ a/kernel/fork.c
@@ -1338,6 +1338,7 @@ static inline void __mmput(struct mm_str
 {
 	VM_BUG_ON(atomic_read(&mm->mm_users));
 
+	uprobe_clear_state(mm);
 	exit_aio(mm);
 	ksm_exit(mm);
 	khugepaged_exit(mm); /* must run before exit_mmap */
_

Patches currently in -mm which might be from oleg@redhat.com are

revert-uprobes-use-vm_special_mapping-close-functionality.patch
uprobes-introduce-the-global-struct-vm_special_mapping-xol_mapping.patch
uprobes-turn-xol_area-pages-into-xol_area-page.patch


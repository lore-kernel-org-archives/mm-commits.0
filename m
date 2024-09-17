Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8151531ED
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560573; cv=none; b=H/xPESITdJc7NTtAoBe+QVmI3Vw66lR7zZDBlUgjIeTHbxeYF3ZUCFgUEQ8122aPfK2KWZwEucCpT3Sa5W1gSs0vsK5sJkmT4vsXgpjueoPTJdRPpHy6/KhKgD+V7jFWO6Mzy3YI+JtYEzxrKgLQK0mTjueUt729mIYAqsPRPek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560573; c=relaxed/simple;
	bh=BpYzPyQYVLKoO/8F30e+QU93V8z979s01TAeo/t0Dnk=;
	h=Date:To:From:Subject:Message-Id; b=hpoIpTQnOQdxwTd4uORsm6Tg6+SU1gdCHiH2bvrXTg1HLiWMiKdEuR6Re+xlzJP7AuSU7UKLHqjMj8U4wATA4dyblWsp1tiXO69pc28gGnapWKX65oTBdwFc2LkR2Pr0gMpXWCiedT7kX4d0Awhe912UtcQWpTxZHasb1KduxlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lYNxGfis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lYNxGfis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BFAC4CEC7;
	Tue, 17 Sep 2024 08:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560573;
	bh=BpYzPyQYVLKoO/8F30e+QU93V8z979s01TAeo/t0Dnk=;
	h=Date:To:From:Subject:From;
	b=lYNxGfisDNPrnMclTyVbFS7BpVC4ZUj6LW0dVWli+AyHnDak9c6yx7R4nc4J9ccQc
	 TctW3anwkYHPmfa/tEVaJIhzOcL57SYUxl+ksOUIM+O7VRaA/jbNowIluuPyTyfPSn
	 y1bMkFy28c6yIPRXboAJA20a4quibllcrDuwb5Fg=
Date: Tue, 17 Sep 2024 01:09:30 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,svens@linux.ibm.com,peterz@infradead.org,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhiramat@kernel.org,mark.rutland@arm.com,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,andrii@kernel.org,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-uprobes-use-vm_special_mapping-close-functionality.patch removed from -mm tree
Message-Id: <20240917080933.25BFAC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "uprobes: use vm_special_mapping close() functionality"
has been removed from the -mm tree.  Its filename was
     revert-uprobes-use-vm_special_mapping-close-functionality.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D09414D2BB
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 02:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742266494; cv=none; b=d2Ky6vfzXFk/sP6wU/r1fOjZnZnOo8l288dPby1B2Va/8gcNzVoh+UXz7ttmM+mNDKSTXNXH2IUcyHTdNHA/lCaLt+LoUI89VQCC4RwxRrqJmyyKn/Tk9cuB/XSak+b067Us4Plg55/tJN/zMU7bmTg2I0IiVZ9Z9fNQMV0vgTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742266494; c=relaxed/simple;
	bh=9oRigDb5RmCRh33cYpbZbYJtrRhtVsFuNJx02N4MrVQ=;
	h=Date:To:From:Subject:Message-Id; b=HWV9/4y64MnAFjaN09gyzg4RjG4OeOPv7UZVVnrpCcdySs9RGF6YF3zZaNwcBky7WnOj/7sCXwaycw7/I/t5I867v4fVqisq5G0bkkTzrw5Zweuq21xGmEybhF63xpLB6d32o9S0OV2ivh32oGsTkZWEDASBl7/CMkA93CjvzKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T0ISgMeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T0ISgMeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C43C4CEE3;
	Tue, 18 Mar 2025 02:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742266492;
	bh=9oRigDb5RmCRh33cYpbZbYJtrRhtVsFuNJx02N4MrVQ=;
	h=Date:To:From:Subject:From;
	b=T0ISgMeDZ7o30cIL7uq5nnSfsIsLZUqBSivj4k646pVGXdMC/eUvW6SBVXWIBNK4i
	 4Z7Pr0hds774UIx4g8nRLZjmcVN8w4a2HvlnUyzOd6T8owsh5rmhDmmKRU3Fftn90Q
	 c2cqEd8Ga5MGXzHnHSGsGiATco6xoqKoduyfX7Ns=
Date: Mon, 17 Mar 2025 19:54:51 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-add-hung_task-detector-mutex-blocking-sample-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250318025452.85C43C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples-add-hung_task-detector-mutex-blocking-sample-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     samples-add-hung_task-detector-mutex-blocking-sample-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-add-hung_task-detector-mutex-blocking-sample-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: samples-add-hung_task-detector-mutex-blocking-sample-fix
Date: Mon Mar 17 07:53:34 PM PDT 2025

make `hung_task_dir' static

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503180827.4StpuFrD-lkp@intel.com/
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/hung_task/Makefile          |    2 +-
 samples/hung_task/hung_task_mutex.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/samples/hung_task/hung_task_mutex.c~samples-add-hung_task-detector-mutex-blocking-sample-fix
+++ a/samples/hung_task/hung_task_mutex.c
@@ -22,7 +22,7 @@
 
 static const char dummy_string[] = "This is a dummy string.";
 static DEFINE_MUTEX(dummy_mutex);
-struct dentry *hung_task_dir;
+static struct dentry *hung_task_dir;
 
 static ssize_t read_dummy(struct file *file, char __user *user_buf,
 			  size_t count, loff_t *ppos)
--- a/samples/hung_task/Makefile~samples-add-hung_task-detector-mutex-blocking-sample-fix
+++ a/samples/hung_task/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_SAMPLE_HUNG_TASK) += hung_task_mutex.o
\ No newline at end of file
+obj-$(CONFIG_SAMPLE_HUNG_TASK) += hung_task_mutex.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch
samples-add-hung_task-detector-mutex-blocking-sample-fix.patch


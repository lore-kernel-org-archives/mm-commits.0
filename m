Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA37137925
	for <mm-commits@vger.kernel.org>; Thu, 28 Mar 2024 18:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711652166; cv=none; b=Vae+Fu7dR7vyIQhD3n7QqW2hBncQSk+uuOagnRgemU5sVy08LYLOSQOPKambaHXL5ESrk8lTssfcQmQ2Kpkkomz4JGA9cK+nSkOfnG5d7HlXNAoEegGFs7YPqbHHRIGb7TGzwqvfK4JE7IeH9SV6KQiC2wE8P1wSAiKJAG4uY7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711652166; c=relaxed/simple;
	bh=avTKuoN+F48Z+JYrKcSVfhHElxxMM8UnKHKZGGS63N8=;
	h=Date:To:From:Subject:Message-Id; b=aIaoJKFgRMiM8gXyPMHz+BDa+6FuNGI0WrNSje4huhufwaaQrpJz8gjTZn+IGBEQN9BAc8Hbi8Ofby0bo7RkaGQFougfla+oMJ1gcPvMIpNyoojqmAD+iHcQVi7qVXBg8mVs3/G1Oi7OMSIQcZL7wQwsdYvh2cmT6yovkiLQZII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CB64urI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CB64urI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89902C43390;
	Thu, 28 Mar 2024 18:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711652165;
	bh=avTKuoN+F48Z+JYrKcSVfhHElxxMM8UnKHKZGGS63N8=;
	h=Date:To:From:Subject:From;
	b=CB64urI3DI3XrSQ5MYxUrz2NIx74PIV9FkDMUZ9FQB596B5v/wEWQT//0z5qDX7KH
	 7ph7LzbL3cRY5vJaQOFTFLL3ZdenYqtVt/vOEVC+1q7eroL0G+4GzsMWIVjJZU1MKe
	 8bQ4JNexXP89hzEDhFpxo+fJAm+XCceGN2azwzfU=
Date: Thu, 28 Mar 2024 11:56:04 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,shr@devkernel.io,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-ksm-exec-support-for-prctl.patch added to mm-unstable branch
Message-Id: <20240328185605.89902C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: fix ksm exec support for prctl
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-fix-ksm-exec-support-for-prctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-ksm-exec-support-for-prctl.patch

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/ksm: fix ksm exec support for prctl
Date: Thu, 28 Mar 2024 19:10:08 +0800

Patch series "mm/ksm: fix ksm exec support for prctl", v4.

commit 3c6f33b7273a ("mm/ksm: support fork/exec for prctl") inherits
MMF_VM_MERGE_ANY flag when a task calls execve().  However, it doesn't
create the mm_slot, so ksmd will not try to scan this task.  The first
patch fixes the issue.

The second patch refactors to prepare for the third patch.  The third
patch extends the selftests of ksm to verfity the deduplication really
happens after fork/exec inherits ths KSM setting.


This patch (of 3):

commit 3c6f33b7273a ("mm/ksm: support fork/exec for prctl") inherits
MMF_VM_MERGE_ANY flag when a task calls execve().  Howerver, it doesn't
create the mm_slot, so ksmd will not try to scan this task.

To fix it, allocate and add the mm_slot to ksm_mm_head in __bprm_mm_init()
when the mm has MMF_VM_MERGE_ANY flag.

Link: https://lkml.kernel.org/r/20240328111010.1502191-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20240328111010.1502191-2-tujinjiang@huawei.com
Fixes: 3c6f33b7273a ("mm/ksm: support fork/exec for prctl")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c           |   11 +++++++++++
 include/linux/ksm.h |   13 +++++++++++++
 2 files changed, 24 insertions(+)

--- a/fs/exec.c~mm-ksm-fix-ksm-exec-support-for-prctl
+++ a/fs/exec.c
@@ -67,6 +67,7 @@
 #include <linux/time_namespace.h>
 #include <linux/user_events.h>
 #include <linux/rseq.h>
+#include <linux/ksm.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -268,6 +269,14 @@ static int __bprm_mm_init(struct linux_b
 	}
 
 	/*
+	 * Need to be called with mmap write lock
+	 * held, to avoid race with ksmd.
+	 */
+	err = ksm_execve(mm);
+	if (err)
+		goto err_ksm;
+
+	/*
 	 * Place the stack at the largest stack address the architecture
 	 * supports. Later, we'll move this to an appropriate place. We don't
 	 * use STACK_TOP because that can depend on attributes which aren't
@@ -288,6 +297,8 @@ static int __bprm_mm_init(struct linux_b
 	bprm->p = vma->vm_end - sizeof(void *);
 	return 0;
 err:
+	ksm_exit(mm);
+err_ksm:
 	mmap_write_unlock(mm);
 err_free:
 	bprm->vma = NULL;
--- a/include/linux/ksm.h~mm-ksm-fix-ksm-exec-support-for-prctl
+++ a/include/linux/ksm.h
@@ -59,6 +59,14 @@ static inline int ksm_fork(struct mm_str
 	return 0;
 }
 
+static inline int ksm_execve(struct mm_struct *mm)
+{
+	if (test_bit(MMF_VM_MERGE_ANY, &mm->flags))
+		return __ksm_enter(mm);
+
+	return 0;
+}
+
 static inline void ksm_exit(struct mm_struct *mm)
 {
 	if (test_bit(MMF_VM_MERGEABLE, &mm->flags))
@@ -106,6 +114,11 @@ static inline int ksm_fork(struct mm_str
 {
 	return 0;
 }
+
+static inline int ksm_execve(struct mm_struct *mm)
+{
+	return 0;
+}
 
 static inline void ksm_exit(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-ksm-fix-ksm-exec-support-for-prctl.patch
selftest-mm-ksm_functional_tests-refactor-mmap_and_merge_range.patch
selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec.patch


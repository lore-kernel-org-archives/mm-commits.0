Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789367F7C1
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104098; cv=none; b=Sqam2vAVSMSkqLUxSammSynRuJOwWWsVKW7KKsm5T4k/gzdSjfYSw/I5k7U5+7Bh/pUZODdZCkRwL8B5cg5vv6HObikfmlV7OhZ5BqLHwrFvKhd5R6x6XCe2AGaQfF7H0hxATYWpUMQVfylKbA9DNoAGTsVAMtQoBu4oSO/RppY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104098; c=relaxed/simple;
	bh=BALGHje9H7mPkPjlkzjAtcWtqVAg2j3mOwgbSOqnBM0=;
	h=Date:To:From:Subject:Message-Id; b=saihJhwabl5OfoNXeiGLgn5dky1pDJw6aPBf/D1LtxnoQTJQd1PMA+CeSSz/Qnba8T/NXG0YXMW3P4MXuxZSlIDIZ+MoA72fVdwUfL53rDFGPhmBCMK3yLhHUqKYN52QATFZO8NFHvs/fF4ciZH7qZME/fs5yhKb6gMSe3h/af8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wXlmKOtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wXlmKOtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B76C113CD;
	Fri, 26 Apr 2024 04:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104098;
	bh=BALGHje9H7mPkPjlkzjAtcWtqVAg2j3mOwgbSOqnBM0=;
	h=Date:To:From:Subject:From;
	b=wXlmKOtb7lnR8kq+Y/UFZWPd0+qA8gUw06TawMiYnIRDOY/WFBD+evGafV7Fqt0W2
	 10T1rosKJt/TK9GKSiXPNh2c2rXoqUzx/y9cLT89oqc7tZZLnguBQZgWugPM6TSPRM
	 ZGksBcxc3ZEk96MFOkQ3V4PasVqDEnj/FcotK588=
Date: Thu, 25 Apr 2024 21:01:37 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,shr@devkernel.io,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-fix-ksm-exec-support-for-prctl.patch removed from -mm tree
Message-Id: <20240426040138.50B76C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: fix ksm exec support for prctl
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-ksm-exec-support-for-prctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE631B3922
	for <mm-commits@vger.kernel.org>; Thu, 14 Nov 2024 23:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731628631; cv=none; b=JcHwqZ6HInhqgzcyed3mv4DJk4tpa6S2EKut5dhL/xpbzzg3zwOWwdSlM+Qcu0kcFq+D96mtcsOQEmX1FKL7S0DQlE+JAKVU33VK1HwHMgbCoOAThH2flCXM/W0fU8pOk1b8vzKatUYe8WVjZsdmpmJ1UbnKCi1Bse2fAwVZpgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731628631; c=relaxed/simple;
	bh=XlJu/xecgto2WYYCMEwVPmfaTwaXTgVIKmtlo5DRZgU=;
	h=Date:To:From:Subject:Message-Id; b=JpJmBHymA57FuS/KnXtGcvDzXZGmk/qXMZIwL4KwJKGnLbORVYvQx2a8S618nOM5b4LZkTWsirOwZt/s56ZQwFRy1uNiNAPnVDGEGIHr68qPJ8qqEc5QrtiRppR933+okjwjwnGSqtG/Pg5KMMyCyPR1LluwN1XLcNRvoB4unwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UoCyj238; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UoCyj238"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12E5C4CECD;
	Thu, 14 Nov 2024 23:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731628630;
	bh=XlJu/xecgto2WYYCMEwVPmfaTwaXTgVIKmtlo5DRZgU=;
	h=Date:To:From:Subject:From;
	b=UoCyj2388MOZxVdibBGNT8TWkXzBtK7x9qnA9tMw7k3KI61u5WfYe48sVWJpEln7u
	 YCZDfqenY+YjDZ9HmMWbXwBgU/mJGQeGYr7UgaBgGi9JyNhnkOjSLbL5H/OHAOp+wD
	 KBq1FYVHf6gMWLwzDOaOcaYgOzguEpzV6IAfnfuk=
Date: Thu, 14 Nov 2024 15:57:06 -0800
To: mm-commits@vger.kernel.org,xiqi2@huawei.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch added to mm-hotfixes-unstable branch
Message-Id: <20241114235709.C12E5C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/vmcore.c: fix warning when CONFIG_MMU=n
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: fs/proc/vmcore.c: fix warning when CONFIG_MMU=n
Date: Thu Nov 14 03:44:21 PM PST 2024

>> fs/proc/vmcore.c:424:19: warning: 'mmap_vmcore_fault' defined but not used [-Wunused-function]
     424 | static vm_fault_t mmap_vmcore_fault(struct vm_fault *vmf)

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411140156.2o0nS4fl-lkp@intel.com/
Cc: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   56 ++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

--- a/fs/proc/vmcore.c~fs-proc-vmcorec-fix-warning-when-config_mmu=n
+++ a/fs/proc/vmcore.c
@@ -414,6 +414,34 @@ static ssize_t read_vmcore(struct kiocb
 	return __read_vmcore(iter, &iocb->ki_pos);
 }
 
+/**
+ * vmcore_alloc_buf - allocate buffer in vmalloc memory
+ * @size: size of buffer
+ *
+ * If CONFIG_MMU is defined, use vmalloc_user() to allow users to mmap
+ * the buffer to user-space by means of remap_vmalloc_range().
+ *
+ * If CONFIG_MMU is not defined, use vzalloc() since mmap_vmcore() is
+ * disabled and there's no need to allow users to mmap the buffer.
+ */
+static inline char *vmcore_alloc_buf(size_t size)
+{
+#ifdef CONFIG_MMU
+	return vmalloc_user(size);
+#else
+	return vzalloc(size);
+#endif
+}
+
+/*
+ * Disable mmap_vmcore() if CONFIG_MMU is not defined. MMU is
+ * essential for mmap_vmcore() in order to map physically
+ * non-contiguous objects (ELF header, ELF note segment and memory
+ * regions in the 1st kernel pointed to by PT_LOAD entries) into
+ * virtually contiguous user-space in ELF layout.
+ */
+#ifdef CONFIG_MMU
+
 /*
  * The vmcore fault handler uses the page cache and fills data using the
  * standard __read_vmcore() function.
@@ -457,34 +485,6 @@ static vm_fault_t mmap_vmcore_fault(stru
 #endif
 }
 
-/**
- * vmcore_alloc_buf - allocate buffer in vmalloc memory
- * @size: size of buffer
- *
- * If CONFIG_MMU is defined, use vmalloc_user() to allow users to mmap
- * the buffer to user-space by means of remap_vmalloc_range().
- *
- * If CONFIG_MMU is not defined, use vzalloc() since mmap_vmcore() is
- * disabled and there's no need to allow users to mmap the buffer.
- */
-static inline char *vmcore_alloc_buf(size_t size)
-{
-#ifdef CONFIG_MMU
-	return vmalloc_user(size);
-#else
-	return vzalloc(size);
-#endif
-}
-
-/*
- * Disable mmap_vmcore() if CONFIG_MMU is not defined. MMU is
- * essential for mmap_vmcore() in order to map physically
- * non-contiguous objects (ELF header, ELF note segment and memory
- * regions in the 1st kernel pointed to by PT_LOAD entries) into
- * virtually contiguous user-space in ELF layout.
- */
-#ifdef CONFIG_MMU
-
 static const struct vm_operations_struct vmcore_mmap_ops = {
 	.fault = mmap_vmcore_fault,
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3020B6FBF
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 03:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457311; cv=none; b=AnBrRbATDst7QYzu5Z3+4H8OfNKVv+O6PFWQcRvtE2qaq6YusqZDTgO3+YTHitzTIAanzGrpBG6GkF9ZKhHg6cbNcUQ/gy2FNVcyT0OO7gmyXWzMwm9VfqY2eSuYwanJ6PTPtr9OUCZrYsJf+6tAfKlPHXMCUurlhW+MF8BCKSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457311; c=relaxed/simple;
	bh=bJ1uBgBk+n0387UajQuw0Ec5bQHpjagFUP8HAi214PI=;
	h=Date:To:From:Subject:Message-Id; b=lUpkX9iJHNUhJmSSmoDVruhu9ffwiELnXVv5XZjU6zuPdUZ4iNaDjiR3fIPOpDetFiulIjISbWTCWmrLgrLsx8H/24N9QRQ2P8JdorJ/DOA0m5IrKb8kzfTp9jo4OzbFfIUKTIMVZz7iiqkGi/dCXO9OaUCM3Ri9fw3JG4JKNHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UQNWTGAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UQNWTGAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C2BC4CED1;
	Fri,  6 Dec 2024 03:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457310;
	bh=bJ1uBgBk+n0387UajQuw0Ec5bQHpjagFUP8HAi214PI=;
	h=Date:To:From:Subject:From;
	b=UQNWTGAhpBbLsOfT/kDZFD7pK9q5GEgKy3E/xoArBwurA2YgdcSiVQljm5qFi0urw
	 3TQlw2KDuszYEQLFBH5NUbANDz3ARhttqOFB6qXXbSPopkhjvZ17+Npj3UbOgV+brS
	 iohaQ+A5KLkzuZusUUzS0P9cp76PDdz+DItngmCY=
Date: Thu, 05 Dec 2024 19:55:09 -0800
To: mm-commits@vger.kernel.org,xiqi2@huawei.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch removed from -mm tree
Message-Id: <20241206035510.95C2BC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/vmcore.c: fix warning when CONFIG_MMU=n
has been removed from the -mm tree.  Its filename was
     fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch


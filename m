Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41A7155C9E
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 20:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730492682; cv=none; b=q708VYB7pb2KMhsyisV57hPsrt8eqYXWWVbVA7JVGtA5f4yoU0JoWW7/8l139hyLlLaRXrNvjuja8xDv/Moykdva9fx5tHX02JoeyIebJmlGmhwJ3zsdl2Zr6r2UUE6EVvKSgu8jWaUaD8oU0YUjIdf9cOhiZ9dpX1BnDmDCzD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730492682; c=relaxed/simple;
	bh=RSCuB5uE04bAy7z/ISo/ZsVvkReguHKJZeWf5SmIMXs=;
	h=Date:To:From:Subject:Message-Id; b=mvxLz6dttIyk+nfuJd4O3EIzh2QQmhf125dsgUEpyT8+nfHdOsHkc/NEvUfG2Ioa3li5ec5KqYNS+vl9tExV7aSblRMVXUIDQ+LIz0cywl4CwazTLCuWwrW9MvEapSDxsL3AXP2aPvRQSrdacD4fRBAQhCDc6ncwMx/5djZ/BM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fneVsjT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fneVsjT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D173C4CECD;
	Fri,  1 Nov 2024 20:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730492681;
	bh=RSCuB5uE04bAy7z/ISo/ZsVvkReguHKJZeWf5SmIMXs=;
	h=Date:To:From:Subject:From;
	b=fneVsjT8QUSo1cxtfCBLAwvQdDwaJmMrH1OMbnCdz9hfZ3RzPPqy+LBuCisRdG3T+
	 0ausgHR/jp9o3IxPjtQQJlbASFACzSrqRHvD6+URUTv6F6vxdoDO6Wsl5m/SZUVF6a
	 6mEu55bBCBrQ5MTE8PakohuJlfwSpg7fuK9+9dtI=
Date: Fri, 01 Nov 2024 13:24:40 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,lkp@intel.com,holzheu@linux.vnet.ibm.com,dyoung@redhat.com,bobo.shaobowang@huawei.com,bhe@redhat.com,xiqi2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-fix-compile-warning-about-variable-vmcore_mmap_ops.patch added to mm-hotfixes-unstable branch
Message-Id: <20241101202441.8D173C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc: fix compile warning about variable 'vmcore_mmap_ops'
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-fix-compile-warning-about-variable-vmcore_mmap_ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-fix-compile-warning-about-variable-vmcore_mmap_ops.patch

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
From: Qi Xi <xiqi2@huawei.com>
Subject: fs/proc: fix compile warning about variable 'vmcore_mmap_ops'
Date: Fri, 1 Nov 2024 11:48:03 +0800

When build with !CONFIG_MMU, the variable 'vmcore_mmap_ops'
is defined but not used:

>> fs/proc/vmcore.c:458:42: warning: unused variable 'vmcore_mmap_ops'
     458 | static const struct vm_operations_struct vmcore_mmap_ops = {

Fix this by only defining it when CONFIG_MMU is enabled.

Link: https://lkml.kernel.org/r/20241101034803.9298-1-xiqi2@huawei.com
Fixes: 9cb218131de1 ("vmcore: introduce remap_oldmem_pfn_range()")
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/lkml/202410301936.GcE8yUos-lkp@intel.com/
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/proc/vmcore.c~fs-proc-fix-compile-warning-about-variable-vmcore_mmap_ops
+++ a/fs/proc/vmcore.c
@@ -457,10 +457,6 @@ static vm_fault_t mmap_vmcore_fault(stru
 #endif
 }
 
-static const struct vm_operations_struct vmcore_mmap_ops = {
-	.fault = mmap_vmcore_fault,
-};
-
 /**
  * vmcore_alloc_buf - allocate buffer in vmalloc memory
  * @size: size of buffer
@@ -488,6 +484,11 @@ static inline char *vmcore_alloc_buf(siz
  * virtually contiguous user-space in ELF layout.
  */
 #ifdef CONFIG_MMU
+
+static const struct vm_operations_struct vmcore_mmap_ops = {
+	.fault = mmap_vmcore_fault,
+};
+
 /*
  * remap_oldmem_pfn_checked - do remap_oldmem_pfn_range replacing all pages
  * reported as not being ram with the zero page.
_

Patches currently in -mm which might be from xiqi2@huawei.com are

fs-proc-fix-compile-warning-about-variable-vmcore_mmap_ops.patch


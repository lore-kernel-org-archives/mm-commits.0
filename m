Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A5F218D9F
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017734; cv=none; b=ENhyShmLwFvyWDvpNZJG3vD+Adz3/r9UXrv5VPO81t1zFnraWOJMecfcHUMF8TDj7G3hYKb08Nfmv6jyrLwMsnxuXHHtYOZZm0B60cJGgkl+ze50bnEsHBAxNsDx7Z7x7EuJFKIy21B46NjeqydcTUkst47SqzjJfz8g5D5WRjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017734; c=relaxed/simple;
	bh=/+7dsQgZNNA7lVvrMpgoOwoJnm6ROYUgYgCxuoegyxQ=;
	h=Date:To:From:Subject:Message-Id; b=MFsGrETeFHa8YSyZleIvI5pMpLDivtXetzFHzeUlrIhjcyjSg7OQJv+BhJqp9pOq64sZvN7Nqv7Y7Yt95kc9oPDsNkR/klmb2TNXr8WQjpUbhbqy8EDPjNTDFb8kfhfTPwoyZEFFYMmyJham8n/Rpuk3t8MQl+r1HYibv+5u/Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=izGMmlEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="izGMmlEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A3DC4CECC;
	Thu,  7 Nov 2024 22:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017733;
	bh=/+7dsQgZNNA7lVvrMpgoOwoJnm6ROYUgYgCxuoegyxQ=;
	h=Date:To:From:Subject:From;
	b=izGMmlEarsrOiJ05qvqJu/OOUp7Ktfg5myTRCp7k7Rx9aGoDZTX9sUIKhoDC2Lcyb
	 WmYDRv7cGhM1ePK8c3OMduEHWnMPAVUE8iyseCINdH2TvkLPmHImzcmcQL8xfD7Ebt
	 7wk9RI6QiDc7jBvMtF6WjXtKvEKL+Thnn6glsNc8=
Date: Thu, 07 Nov 2024 14:15:33 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,lkp@intel.com,holzheu@linux.vnet.ibm.com,dyoung@redhat.com,bobo.shaobowang@huawei.com,bhe@redhat.com,xiqi2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-fix-compile-warning-about-variable-vmcore_mmap_ops.patch removed from -mm tree
Message-Id: <20241107221533.C5A3DC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: fix compile warning about variable 'vmcore_mmap_ops'
has been removed from the -mm tree.  Its filename was
     fs-proc-fix-compile-warning-about-variable-vmcore_mmap_ops.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



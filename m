Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF0C1F92E
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 02:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754447928; cv=none; b=JX93MbqvfIVpj2skiJhMH2CKkyYtDZoNEihrU5CIkzLMZkE+WaomrK89zXLVaU2wnVffaqbv4p7YADiwF5hlsQ19dLCHcq5+fJeaZS5rAy/YOa5SYn20BGx3hblENauBdEHKI2X+1X4hoPp1lPV2oeTGIN2rZwp+fqB7b0vn8sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754447928; c=relaxed/simple;
	bh=5n5BvK+2i7Sx3I8hz/vHlJdC5X/qI1u2dxAe01xCJ8g=;
	h=Date:To:From:Subject:Message-Id; b=e9qiu5TDGx0zewrcC68s+riAvWe5V1IyXfhCMm+4fkUmvVmreGjAsHMssNOAM4rcOrvmZp5Bg6vCOLS7waSy/+bzdnOL3e2V/YJf3yKWOJgJobdndnwIKzBk7jnpEmip/z9mYghs2DLEeNcGYe0+gjCu4Ep6GRPW47FPFN7Bxhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m556rS9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m556rS9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421DAC4CEF0;
	Wed,  6 Aug 2025 02:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754447928;
	bh=5n5BvK+2i7Sx3I8hz/vHlJdC5X/qI1u2dxAe01xCJ8g=;
	h=Date:To:From:Subject:From;
	b=m556rS9trd68+THFzQ9AEXOQlHwTlp6Qkt4wJtqAST/ligUVGMANke8POw7oYDnAZ
	 TGgnfcKmUbxjQ2AR5xHJJAdAFRV2xt8uu0NeTf3tMfTx3rp+PxRO+tseNIJIZKbBog
	 Zy+lFe21cZ5+g3SdkGebyYhV1lgM6LYwZeU/+OOI=
Date: Tue, 05 Aug 2025 19:38:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xueshuai@linux.alibaba.com,wangkefeng.wang@huawei.com,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-infinite-uce-for-vm_pfnmap-pfn.patch added to mm-hotfixes-unstable branch
Message-Id: <20250806023848.421DAC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: fix infinite uncorrected error exception for VM_PFNMAP pfn
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-fix-infinite-uce-for-vm_pfnmap-pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-infinite-uce-for-vm_pfnmap-pfn.patch

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/memory-failure: fix infinite uncorrected error exception for VM_PFNMAP pfn
Date: Wed, 6 Aug 2025 10:05:20 +0800

When memory_failure() is called for a already hwpoisoned pfn,
kill_accessing_process() will be called to kill current task.  However, if
the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will skip
the vma in walk_page_test() and return 0.

Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
with recovered clean pages"), kill_accessing_process() will return EFAULT.
For x86, the current task will be killed in kill_me_maybe().

However, after this commit, kill_accessing_process() simplies return 0,
that means the UCE is handled properly, but it actually wasn't.  In such
case, the user task will trigger the UCE infinitely.

To fix it, add .test_walk callback for hwpoison_walk_ops to scan all vmas.

Link: https://lkml.kernel.org/r/20250806020520.631203-1-tujinjiang@huawei.com
Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes with recovered clean pages")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-fix-infinite-uce-for-vm_pfnmap-pfn
+++ a/mm/memory-failure.c
@@ -853,9 +853,16 @@ static int hwpoison_hugetlb_range(pte_t
 #define hwpoison_hugetlb_range	NULL
 #endif
 
+static int hwpoison_test_walk(unsigned long start, unsigned long end,
+			     struct mm_walk *walk)
+{
+	return 0;
+}
+
 static const struct mm_walk_ops hwpoison_walk_ops = {
 	.pmd_entry = hwpoison_pte_range,
 	.hugetlb_entry = hwpoison_hugetlb_range,
+	.test_walk = hwpoison_test_walk,
 	.walk_lock = PGWALK_RDLOCK,
 };
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-memory-failure-fix-infinite-uce-for-vm_pfnmap-pfn.patch
mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch


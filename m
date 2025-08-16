Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE0317A2F6;
	Sat, 16 Aug 2025 07:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755328281; cv=none; b=prRlzcMC8FzdeZRmY6xdBWVVCBlgFMhnIekKrl+LgnRtX/n+x0QFu4jSj2MWqXHpsysbOtFP78k4S4tC6isUxrDJNp7OvKtCfeIpO1P8m9Mt3dcmToRhH+pzCGm5TAi/aTgmDdpci2bvk9wOwEpV4iJHjEr7uWAxhkX4FRftK+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755328281; c=relaxed/simple;
	bh=joH5WcPpBYq0YJbRXBZDgQVkMXMhmM92NLN3cOHS2OI=;
	h=Date:To:From:Subject:Message-Id; b=YxNONVvZIom3dfvLZ6oMXI6dTiziwV/mN2mnefGXNGsu1q+SOLKtKu4kjP8CtLbqO1ha1gU1yoBqe3doM1nGYDuS0VcI23dOkUJw8RGa5CJtADnhgugUMAwl9b6oF6XojU1tH4W8N78Zdt5NOx+gKL/NtYz9ylICbYx7qZhF84I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p3L9k4t7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p3L9k4t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471F6C4CEEF;
	Sat, 16 Aug 2025 07:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755328280;
	bh=joH5WcPpBYq0YJbRXBZDgQVkMXMhmM92NLN3cOHS2OI=;
	h=Date:To:From:Subject:From;
	b=p3L9k4t7aWYlL4ZBChcin5LuAcltHvj7wZurTxhNVaYZBHJlwefu58hTTK68ula0y
	 lSl00n9L4b1Cy4abkAPIr02qOc+tktrAShw5ThJYgN4jK4aJGEMJgTOc1qUdjacUHm
	 67DEQ7L8UKHsYLoo+M31Hj5aHyi16FR4c2cHn9mQ=
Date: Sat, 16 Aug 2025 00:11:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xueshuai@linux.alibaba.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-infinite-uce-for-vm_pfnmap-pfn.patch added to mm-hotfixes-unstable branch
Message-Id: <20250816071120.471F6C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
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
Subject: mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
Date: Fri, 15 Aug 2025 15:32:09 +0800

When memory_failure() is called for a already hwpoisoned pfn,
kill_accessing_process() will be called to kill current task.  However, if
the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will skip
the vma in walk_page_test() and return 0.

Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
with recovered clean pages"), kill_accessing_process() will return EFAULT.
For x86, the current task will be killed in kill_me_maybe().

However, after this commit, kill_accessing_process() simplies return 0,
that means UCE is handled properly, but it doesn't actually.  In such
case, the user task will trigger UCE infinitely.

To fix it, add .test_walk callback for hwpoison_walk_ops to scan all vmas.

Link: https://lkml.kernel.org/r/20250815073209.1984582-1-tujinjiang@huawei.com
Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes with recovered clean pages")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-fix-infinite-uce-for-vm_pfnmap-pfn
+++ a/mm/memory-failure.c
@@ -853,9 +853,17 @@ static int hwpoison_hugetlb_range(pte_t
 #define hwpoison_hugetlb_range	NULL
 #endif
 
+static int hwpoison_test_walk(unsigned long start, unsigned long end,
+			     struct mm_walk *walk)
+{
+	/* We also want to consider pages mapped into VM_PFNMAP. */
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


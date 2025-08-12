Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF477F9EC
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 01:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754961598; cv=none; b=aaTElk7y8qMD2DkTZDlicnS8p2fTbHZVySZp0bnu+rfQVXnPaWxemzDTYsZYUHDp3wI5dXzytqVDIRd53VSSBT/9v19aTNfikxlXvoQdrWclPuaTUs3D4nw3gV6SIlRJWjX1pPsxeceNSFXeBPTNPZmPN6bUuvdsTjY8pN3Dp/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754961598; c=relaxed/simple;
	bh=L6C/j7RZqf8ha1WLTU8r/rqWk5XTzYqU1twRma1uHPc=;
	h=Date:To:From:Subject:Message-Id; b=YVRn3k48mv9WBMwXelcJjnol0wc74yz4ooTzVF1RVSZrr74ZwN/v3TjBvxtwXd7k0ot8Z3pyNzjeSd8DzxyrRLrWotaQCoACzKNowPUlk8nr+gIZStiokTrKPj9LNDPz1RciGFJuSISx6t3nVMCCMvT0njOWMPYRwRCM2fe0Ky8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oc9QDAN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oc9QDAN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D86EC4CEED;
	Tue, 12 Aug 2025 01:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754961597;
	bh=L6C/j7RZqf8ha1WLTU8r/rqWk5XTzYqU1twRma1uHPc=;
	h=Date:To:From:Subject:From;
	b=oc9QDAN5W58E29U+Ovvm2iwkgyO5CwqqJyffETTV5DjQD6NbPRTPkyNVA74N7lxK2
	 UzwNTpX0DRcUolobW06LfBm9eaUK3xBFRkBgspB6KexQjckqbJYauudDr7740esJLO
	 xOT+gtdhDUhoMvWhAvj+i94Wa2J/lCr5+wEOfL4U=
Date: Mon, 11 Aug 2025 18:19:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xueshuai@linux.alibaba.com,wangkefeng.wang@huawei.com,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-infinite-uce-for-vm_pfnmaped-page.patch added to mm-hotfixes-unstable branch
Message-Id: <20250812011957.5D86EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: fix infinite UCE for VM_PFNMAP'ed page
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-fix-infinite-uce-for-vm_pfnmaped-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-infinite-uce-for-vm_pfnmaped-page.patch

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
Subject: mm/memory-failure: fix infinite UCE for VM_PFNMAP'ed page
Date: Mon, 11 Aug 2025 12:33:23 +0800

When memory_failure() is called for a already hwpoisoned pfn backed with
struct page, kill_accessing_process() will conditionally send a SIGBUS to
the current (triggering) process if it maps the page.

However, in case the page is not ordinarily mapped, but was mapped through
remap_pfn_range(), kill_accessing_process() wouldn't identify it as mapped
even though hwpoison_pte_range() would be prepared to handle it, because
walk_page_range() will skip VM_PFNMAP as default in walk_page_test().  As
a result, walk_page_range() will return 0, assuming "not mapped" and
SIGBUS will be skipped.  The user task will trigger UCE infinitely because
it will not receive a SIGBUS on access and simply retry.

Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
with recovered clean pages"), kill_accessing_process() will return EFAULT.
For x86, the current task will be killed in kill_me_maybe().

To fix it, add .test_walk callback for hwpoison_walk_ops to process
VM_PFNMAP VMAs too.

Link: https://lkml.kernel.org/r/20250811043323.899130-1-tujinjiang@huawei.com
Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes with recovered clean pages")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
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

--- a/mm/memory-failure.c~mm-memory-failure-fix-infinite-uce-for-vm_pfnmaped-page
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

mm-memory-failure-fix-infinite-uce-for-vm_pfnmaped-page.patch
mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch


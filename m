Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A706D8289A
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218906; cv=none; b=MIKxZpv7NWnsinmGlaWlhh1v0Vv8E+tibs21RO9Bcwd+XQrjEUTalABhAlOB0lsU5CXPnOmsv8ccDyXUkssy77V2gJPfXzXJcntLw6RWVmQoE5v5ur5PeZtoks1GwcZ/NgXKhPzLd2fehYcAu1WqbPpF7Y5NVsor/ndJfCBwrM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218906; c=relaxed/simple;
	bh=gCwQiQ5bn3NFQhPZ+H/cANpUg3HpGMSSz55Lr/OTFBI=;
	h=Date:To:From:Subject:Message-Id; b=qAw2sfcXVvyLDFLx+dUFNBEnTq5tDvDFWe76D4aLtacvLW3R7tWiynBOlNMwNfrsq6ir5xtNN2HjF2W1lXFgmkl7znPrf+zuDNFL/2zGsKxhWCoTmbuZQ2VJp9TslxBSJjXtvWAts6rajiOr2U6HrWfxFCzFJu/xlsKfPxZ5gzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LKwemF4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LKwemF4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D72C116B1;
	Wed, 12 Jun 2024 19:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218906;
	bh=gCwQiQ5bn3NFQhPZ+H/cANpUg3HpGMSSz55Lr/OTFBI=;
	h=Date:To:From:Subject:From;
	b=LKwemF4bj5qRU4Djh2zJrXxvpi0crSBfBzSnZqs8Y4RUDppSapEpgOzUQvC27VnV/
	 dkfNdjp96nuPys3p/6JqmaXdgtkhK76TTdKOhOelmfkBPbtN6TVOkCZFHIr1yCfKRR
	 GFC8/cSONS8bcze/CBX0CAO91laM1tpBS9anMdGI=
Date: Wed, 12 Jun 2024 12:01:45 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-comment-of-get_hwpoison_page.patch added to mm-unstable branch
Message-Id: <20240612190146.75D72C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: fix comment of get_hwpoison_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-fix-comment-of-get_hwpoison_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-comment-of-get_hwpoison_page.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: fix comment of get_hwpoison_page()
Date: Wed, 12 Jun 2024 15:18:33 +0800

When return value is 0, it could also means the page is free hugetlb page
or free buddy page.  Fix the corresponding comment.

Link: https://lkml.kernel.org/r/20240612071835.157004-12-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-comment-of-get_hwpoison_page
+++ a/mm/memory-failure.c
@@ -1525,7 +1525,7 @@ static int __get_unpoison_page(struct pa
  * the given page has PG_hwpoison. So it's never reused for other page
  * allocations, and __get_unpoison_page() never races with them.
  *
- * Return: 0 on failure,
+ * Return: 0 on failure or free buddy (hugetlb) page,
  *         1 on success for in-use pages in a well-defined state,
  *         -EIO for pages on which we can not handle memory errors,
  *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-simplify-put_ref_page.patch
mm-memory-failure-remove-mf_msg_slab.patch
mm-memory-failure-add-macro-get_page_max_retry_num.patch
mm-memory-failure-save-some-page_folio-calls.patch
mm-memory-failure-remove-unneeded-empty-string.patch
mm-memory-failure-remove-confusing-initialization-to-count.patch
mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch
mm-memory-failure-use-helper-macro-task_pid_nr.patch
mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch
mm-memory-failure-move-some-function-declarations-into-internalh.patch
mm-memory-failure-fix-comment-of-get_hwpoison_page.patch
mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch
mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch


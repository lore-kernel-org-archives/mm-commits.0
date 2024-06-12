Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EB91C14
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218910; cv=none; b=lygWgUwy7CUl5letJ0W2k8X6so8pYUPXQkI/t/55QmaQEDkPrJL+dC7NWIMyjgFpvwct5ms0UOjo8WK6+txiVeBnL0G96XBjv6t1npe/w3bnYQHTem9lTNB+vzdboGW/LAdgQL8TQyyS9yOObiP9IAoNmR42yx4xVSG534iG5wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218910; c=relaxed/simple;
	bh=/2zc8gaEXUV9VaRDJLiZjvE5SqgZWkUHFw+S0h7OPRc=;
	h=Date:To:From:Subject:Message-Id; b=PbmjfLHdOLHnMueCqUgKXEKUDSnZJFpB4BBttzEren7ZyV1CNtmA/ZSOTUX4584RQCCKde55r+oQ7vT1gep5S+j9UfbVsg4L9AqSmn3s+/52THyrOSev3tCPslSHq2izSMEcRoTlMS4bc3W33ETP9AFT7ayUD88maI64ZaIXze4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dY5Gs4bq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dY5Gs4bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8600C116B1;
	Wed, 12 Jun 2024 19:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218909;
	bh=/2zc8gaEXUV9VaRDJLiZjvE5SqgZWkUHFw+S0h7OPRc=;
	h=Date:To:From:Subject:From;
	b=dY5Gs4bq/1ECTnQeXCzw8Ch08NmeNRwDdxMYsgVsGWe9IklFGRUw6S21Ak4lUdUgI
	 sFuVMem7B/2NsWr851gqO6KvgT3J7PWfTGBLs1ZdPdNCWA14/Y/dEMLesj94Yn/4Yc
	 Hc0z1IaW7wRXGDB14bAQ+goTytBlNfWgnpRB4UmM=
Date: Wed, 12 Jun 2024 12:01:49 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch added to mm-unstable branch
Message-Id: <20240612190149.D8600C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: correct comment in me_swapcache_dirty
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch

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
Subject: mm/memory-failure: correct comment in me_swapcache_dirty
Date: Wed, 12 Jun 2024 15:18:35 +0800

Dirty swap cache page could live both in page table (not page cache) and
swap cache when freshly swapped in.  Correct comment.

Link: https://lkml.kernel.org/r/20240612071835.157004-14-linmiaohe@huawei.com
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

--- a/mm/memory-failure.c~mm-memory-failure-correct-comment-in-me_swapcache_dirty
+++ a/mm/memory-failure.c
@@ -1126,7 +1126,7 @@ static int me_pagecache_dirty(struct pag
  * Clean and dirty swap cache.
  *
  * Dirty swap cache page is tricky to handle. The page could live both in page
- * cache and swap cache(ie. page is freshly swapped in). So it could be
+ * table and swap cache(ie. page is freshly swapped in). So it could be
  * referenced concurrently by 2 types of PTEs:
  * normal PTEs and swap PTEs. We try to handle them consistently by calling
  * try_to_unmap(!TTU_HWPOISON) to convert the normal PTEs to swap PTEs,
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2098287E
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218899; cv=none; b=EA/Hdod7k4dN1twINkWL2WByIH84m1Ncnyd0A2nanTq9hVZ5tpxbtHmjSAN3yzNV7dNyRicpwvu/gqlW43aSrneUiW5mHtkvMYpj/3tPHTRWvqDxenf7RYUaQicARwSGKWiq1lvHg6KJ9QCTtP7Kj/Kmq1cUqwUvSQjpGONyizc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218899; c=relaxed/simple;
	bh=ySpGcarPRJt7SMSeNSvrN0C90itTKJjuESZVUwx4PLY=;
	h=Date:To:From:Subject:Message-Id; b=l+Ru7BXUCOLsDLdgpbh0AysP6+YUHbdZU2oCBw0MuCTqqruU6vwTpPd5qh8R5DriGFiqqBt/i+yLsGOQYfZftteOr36OtClGR9nbmwHVbPkojF9UUjU/iTg/q+a/EZ5HEgTYqhOADB4R3HjX92NLyemhm6jPqvx4lyXKBzUY9aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q3oRCY+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q3oRCY+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36690C116B1;
	Wed, 12 Jun 2024 19:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218899;
	bh=ySpGcarPRJt7SMSeNSvrN0C90itTKJjuESZVUwx4PLY=;
	h=Date:To:From:Subject:From;
	b=Q3oRCY+LRgdgR+2vrdsPISxACZNH0NdgXFfRCs8wq/59PcN7mDDf5f+34iOarggAt
	 Ed1GPKgmBmwPCaC4xfRIVzWq3wUOu+CXRaeke9XeAleB+eYpD86KIU/tKy0E0QMVNS
	 lgKj1LoRvtLBq33aJSbTu7OTLRno2UHtZ3mVW6w8=
Date: Wed, 12 Jun 2024 12:01:38 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch added to mm-unstable branch
Message-Id: <20240612190139.36690C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: don't export hwpoison_filter() when !CONFIG_HWPOISON_INJECT
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch

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
Subject: mm/memory-failure: don't export hwpoison_filter() when !CONFIG_HWPOISON_INJECT
Date: Wed, 12 Jun 2024 15:18:29 +0800

When CONFIG_HWPOISON_INJECT is not enabled, there is no user of the
hwpoison_filter() outside memory-failure.  So there is no need to export
it in that case.

Link: https://lkml.kernel.org/r/20240612071835.157004-8-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406070136.hGQwVbsv-lkp@intel.com/
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject
+++ a/mm/memory-failure.c
@@ -294,6 +294,7 @@ int hwpoison_filter(struct page *p)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(hwpoison_filter);
 #else
 int hwpoison_filter(struct page *p)
 {
@@ -301,8 +302,6 @@ int hwpoison_filter(struct page *p)
 }
 #endif
 
-EXPORT_SYMBOL_GPL(hwpoison_filter);
-
 /*
  * Kill all processes that have a poisoned page mapped and then isolate
  * the page.
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


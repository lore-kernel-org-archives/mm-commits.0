Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D0082863
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218894; cv=none; b=nS0mTPCPuBfgl8mels/XuwbjVWOK3VRrqokafs/Rw6qP/sVOI2luG0kplswJ13n1p3+zkOc0/fJYglAVc8j2iEDElJNHHYme9DDEtoyT5AgjW5JaaIdcooLEA4RLlx8vUU5sxSwqe2x3mxGb5uYDiM9g5N3HPcE4e9rn8Vf5kV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218894; c=relaxed/simple;
	bh=JCZUaNyzpV1PRyybEvJg3o01qfeUaYiilrBx284qyq0=;
	h=Date:To:From:Subject:Message-Id; b=oq2GwLnze16t6GdKDyIUNS1CVaIfY2EAGeXLWy0yDJ6bDjIjO/5erwAaVN4qN6GVHDaowQjWrZlsaddWgNQ1dTxKrCqEPgQCo3krV4xSsGrs0Fnfhc8ZRnAWkB5wpNgGTGNKlkcCC0+5ZYvWifiES9bTwGX/+T9imd89ykLsoDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0wiG5fxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0wiG5fxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F83C116B1;
	Wed, 12 Jun 2024 19:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218894;
	bh=JCZUaNyzpV1PRyybEvJg3o01qfeUaYiilrBx284qyq0=;
	h=Date:To:From:Subject:From;
	b=0wiG5fxKAiwZDvbLZDDxvfqeEtJlz+vc7VackPIRMEiVTncOmTKT5WHJyNF+9+9Wa
	 SV3iFnrou8i18b0uavOth97CxoUu5eOoXEJUSEcoxuVN8pqvU+DvjDwkiIHBXPT1Nv
	 BVKSKHbr2rHMa1xtqcZbv2CJNC9TTYGVxl/mHoKQ=
Date: Wed, 12 Jun 2024 12:01:33 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-save-some-page_folio-calls.patch added to mm-unstable branch
Message-Id: <20240612190134.71F83C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: save some page_folio() calls
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-save-some-page_folio-calls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-save-some-page_folio-calls.patch

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
Subject: mm/memory-failure: save some page_folio() calls
Date: Wed, 12 Jun 2024 15:18:26 +0800

Use local variable folio directly to save a page_folio() call.  Also use
folio_mapped() to save more page_folio() calls.  No functional change
intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-save-some-page_folio-calls
+++ a/mm/memory-failure.c
@@ -1575,7 +1575,7 @@ static bool hwpoison_user_mappings(struc
 	 * This check implies we don't kill processes if their pages
 	 * are in the swap cache early. Those are always late kills.
 	 */
-	if (!page_mapped(p))
+	if (!folio_mapped(folio))
 		return true;
 
 	if (folio_test_swapcache(folio)) {
@@ -1626,10 +1626,10 @@ static bool hwpoison_user_mappings(struc
 		try_to_unmap(folio, ttu);
 	}
 
-	unmap_success = !page_mapped(p);
+	unmap_success = !folio_mapped(folio);
 	if (!unmap_success)
 		pr_err("%#lx: failed to unmap page (folio mapcount=%d)\n",
-		       pfn, folio_mapcount(page_folio(p)));
+		       pfn, folio_mapcount(folio));
 
 	/*
 	 * try_to_unmap() might put mlocked page in lru cache, so call
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


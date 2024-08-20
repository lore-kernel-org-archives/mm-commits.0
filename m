Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD402BAEB
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 05:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724132329; cv=none; b=OVKXPdpGf98llDyTL+LvkRgBvea/w2GD2wsCPQ/wXfYjXv/PCuPen9U0cF5ynYWxjelWPQOCfK9c0J6h3tm7EJcL6xKSOvq1t+Qlv/OsLMfgF3Kn6rSZiOmkYwv7CjYpArqTUfa0eezefDm3DYOlqn/Eeki6fLCx7dqFuE0ie4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724132329; c=relaxed/simple;
	bh=r1y2Nolgp5zppVXnsNaX0rvdW1xAwI8X1tNKKYemwZA=;
	h=Date:To:From:Subject:Message-Id; b=krFft+jh+pl9CxEWMkclwlN0tNkUMgUpTxYe0svBWXpsxidgGyoatXaIE0YFoKw9+o9xGkHAi0mOEoL7thzlK49r9rhWjrLO7uOiBvsXyQFmfCLruCEKotK/H+gVxM+DY3BmVgz22IKHmurSnIMGgDVTs5h/EHuqhfN/O7917ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QZALRh0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QZALRh0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB13C4AF09;
	Tue, 20 Aug 2024 05:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724132328;
	bh=r1y2Nolgp5zppVXnsNaX0rvdW1xAwI8X1tNKKYemwZA=;
	h=Date:To:From:Subject:From;
	b=QZALRh0u7d6/1546TnCk/vLN7LP4OAirtxhKNXV7ZKcT5gfSdUClgKgfy6SBKF4v6
	 2SYJ2bb+xTdFvqL1jDqVVfNtSKC/53T+VrQ4JqPk5Fdr2rYifmd0nmoHkktdRk5J5k
	 XQtFqATLGLkFEE6+k/wdGjOKO2HM9ti0bvV5uO1M=
Date: Mon, 19 Aug 2024 22:38:47 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@Huawei.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix.patch added to mm-unstable branch
Message-Id: <20240820053848.5BB13C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix
Date: Mon Aug 19 10:36:53 PM PDT 2024

revise comment, per Jonathan

Cc: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix
+++ a/mm/memory_hotplug.c
@@ -1788,10 +1788,10 @@ static void do_migrate_range(unsigned lo
 		folio = page_folio(page);
 
 		/*
-		 * The folio hold no reference or lock, it might be changed
-		 * concurrently(eg, split), folio_nr_pages() may read garbage,
-		 * but out loop could handle that as it revisits the split
-		 * folio later.
+		 * No reference or lock is held on the folio, so it might
+		 * be modified concurrently (e.g. split).  As such,
+		 * folio_nr_pages() may read garbage.  This is fine as the outer
+		 * loop will revisit the split folio later.
 		 */
 		if (folio_test_large(folio)) {
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch


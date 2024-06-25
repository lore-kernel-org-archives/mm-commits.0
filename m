Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51195143C56
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291705; cv=none; b=tGR/aY84t3j/lqKYYCq8OiVnK1bsxAKel/lerleDct+0w9p7EgzfGA4wsVRI5eLQP+qh6tbgAvsUL33TnNqo4RC4aTt3u1rWvgbcrycGBuKYVXb4QzWqzFVBamZlsTSh1BqxCUT8gxTnNq/3+BA+jLCRjfK/OlaU90mZA9U09wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291705; c=relaxed/simple;
	bh=NgEuyXvg0yOhcBafRrwOudhVjiZn3WRBUKXdqFvy7uc=;
	h=Date:To:From:Subject:Message-Id; b=VZsOyZQWhreZRyFkYH6V0lAcMV+LR1k0bpBQCU6EOdKHcIK0H+LwNJe8P05mtwZffLr0soBaj8QgYdRRm9pDE9UjLjMbgrYzulhwlhKTEwaME+z0yg+7wR7mczptvTA2WBrWtUYajyEgivv4FPVJ3TKvm8EE+cfZAckepy2CjWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O3O3CbS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O3O3CbS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7C3C32782;
	Tue, 25 Jun 2024 05:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291705;
	bh=NgEuyXvg0yOhcBafRrwOudhVjiZn3WRBUKXdqFvy7uc=;
	h=Date:To:From:Subject:From;
	b=O3O3CbS1TtKXkZqHXi/Iq/zSPRcHf55x5G5OXKHDrzCzOo+QHC0hLNrDM6lr57U3C
	 IWAJMntCecMV0D2XY/yAEjxvCrZoirFLNE88XQst1aCdxVKEbOKrG8dYQ4JJEnzi5N
	 zohxXgcYgljJPZBFiqkN/PcYcECNxwqkPsqnu1dg=
Date: Mon, 24 Jun 2024 22:01:44 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-simplify-put_ref_page.patch removed from -mm tree
Message-Id: <20240625050145.1C7C3C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: simplify put_ref_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-simplify-put_ref_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: simplify put_ref_page()
Date: Wed, 12 Jun 2024 15:18:23 +0800

Patch series "Some cleanups for memory-failure", v3.

This series contains a few cleanup patches to avoid exporting unused
function, add helper macro, fix some obsolete comments and so on.  More
details can be found in the respective changelogs.  


This patch (of 13):

Remove unneeded page != NULL check.  pfn_to_page() won't return NULL.  No
functional change intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20240612071835.157004-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-simplify-put_ref_page
+++ a/mm/memory-failure.c
@@ -2120,14 +2120,10 @@ static inline unsigned long folio_free_r
 /* Drop the extra refcount in case we come from madvise() */
 static void put_ref_page(unsigned long pfn, int flags)
 {
-	struct page *page;
-
 	if (!(flags & MF_COUNT_INCREASED))
 		return;
 
-	page = pfn_to_page(pfn);
-	if (page)
-		put_page(page);
+	put_page(pfn_to_page(pfn));
 }
 
 static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are



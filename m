Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9174BA88
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zFcM7WNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845F7C433C7;
	Wed, 10 Jan 2024 16:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704902493;
	bh=WJLSQtKadyBRbrVqQebskD7nUMcb6i4/UquQh5dJcmM=;
	h=Date:To:From:Subject:From;
	b=zFcM7WNlFHxGsr03xSigRNcCtQL/EHY77BO0qo2RpCYf69h2mFEoSUnfFXVFYnB7W
	 UCzBru9IMnlWHwCK/qNogP/Yqpw7TSNCQUZpxSiHt69lZStowDb5QZT4Pi7J335goU
	 XwWRdZT2IgydB3y1nJ9xpTYc1DbjJyBwr9eyUzpY=
Date: Wed, 10 Jan 2024 08:01:32 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-use-nth_page-in-clear-copy_subpage.patch added to mm-unstable branch
Message-Id: <20240110160133.845F7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory: use nth_page() in clear/copy_subpage()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-use-nth_page-in-clear-copy_subpage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-use-nth_page-in-clear-copy_subpage.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use nth_page() in clear/copy_subpage()
Date: Fri, 29 Dec 2023 16:22:07 +0800

The clear and copy of huge gigantic page has converted to use nth_page()
to handle the possible discontinuous struct page(SPARSEMEM without
VMEMMAP), but not change for the non-gigantic part, fix it too.

Link: https://lkml.kernel.org/r/20231229082207.60235-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-use-nth_page-in-clear-copy_subpage
+++ a/mm/memory.c
@@ -6143,7 +6143,7 @@ static int clear_subpage(unsigned long a
 {
 	struct page *page = arg;
 
-	clear_user_highpage(page + idx, addr);
+	clear_user_highpage(nth_page(page, idx), addr);
 	return 0;
 }
 
@@ -6193,10 +6193,11 @@ struct copy_subpage_arg {
 static int copy_subpage(unsigned long addr, int idx, void *arg)
 {
 	struct copy_subpage_arg *copy_arg = arg;
+	struct page *dst = nth_page(copy_arg->dst, idx);
+	struct page *src = nth_page(copy_arg->src, idx);
 
-	if (copy_mc_user_highpage(copy_arg->dst + idx, copy_arg->src + idx,
-				  addr, copy_arg->vma)) {
-		memory_failure_queue(page_to_pfn(copy_arg->src + idx), 0);
+	if (copy_mc_user_highpage(dst, src, addr, copy_arg->vma)) {
+		memory_failure_queue(page_to_pfn(src), 0);
 		return -EHWPOISON;
 	}
 	return 0;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-use-nth_page-in-clear-copy_subpage.patch


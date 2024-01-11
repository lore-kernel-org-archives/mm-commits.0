Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D4614F7A;
	Thu, 11 Jan 2024 19:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fsuIuCwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F2FC433F1;
	Thu, 11 Jan 2024 19:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705002876;
	bh=z4/HwMdBiPc1YGqeHo3mx2i3czMutlf2Lv2YvjH+mUM=;
	h=Date:To:From:Subject:From;
	b=fsuIuCwS8pA9wuQEDGoh610RwC/WlEkCj5WcjLVks8NOOJg/lP6WQQ3mnL/7VkNrM
	 ZDqdaHLj1pmYCCnQ90PG/Fi/r/moPxeFRxeDT8F0fK/+E/cjBaAQ1Cc0WOmCbQeUq6
	 WZcqbn4kJJoQUcJPPZuQeQEB3VhxXM2f/q66QCXc=
Date: Thu, 11 Jan 2024 11:54:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,usama.anjum@collabora.com,stable@vger.kernel.org,shy828301@gmail.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,linmiaohe@huawei.com,jthoughton@google.com,jiaqiyan@google.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-hugetlbfs-hwpoison-handling.patch added to mm-hotfixes-unstable branch
Message-Id: <20240111195436.79F2FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/hugetlbfs/inode.c: mm/memory-failure.c
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fix-hugetlbfs-hwpoison-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-hugetlbfs-hwpoison-handling.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: fs/hugetlbfs/inode.c: mm/memory-failure.c
fix hugetlbfs hwpoison handling
Date: Thu, 11 Jan 2024 11:16:55 -0800

has_extra_refcount() makes the assumption that a ref count of 1 means the
page is not referenced by other users.  Commit a08c7193e4f1 (mm/filemap:
remove hugetlb special casing in filemap.c) modifies __filemap_add_folio()
by calling folio_ref_add(folio, nr); for all cases (including hugtetlb)
where nr is the number of pages in the folio.  We should check if the page
is not referenced by other users by checking the page count against the
number of pages rather than 1.

In hugetlbfs_read_iter(), folio_test_has_hwpoisoned() is testing the wrong
flag as, in the hugetlb case, memory-failure code calls
folio_test_set_hwpoison() to indicate poison.  folio_test_hwpoison() is
the correct function to test for that flag.

After these fixes, the hugetlb hwpoison read selftest passes all cases.

Link: https://lkml.kernel.org/r/20240111191655.295530-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Closes: https://lore.kernel.org/linux-mm/20230713001833.3778937-1-jiaqiyan@google.com/T/#m8e1469119e5b831bbd05d495f96b842e4a1c5519
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>	[6.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 mm/memory-failure.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~fix-hugetlbfs-hwpoison-handling
+++ a/fs/hugetlbfs/inode.c
@@ -340,7 +340,7 @@ static ssize_t hugetlbfs_read_iter(struc
 		} else {
 			folio_unlock(folio);
 
-			if (!folio_test_has_hwpoisoned(folio))
+			if (!folio_test_hwpoison(folio))
 				want = nr;
 			else {
 				/*
--- a/mm/memory-failure.c~fix-hugetlbfs-hwpoison-handling
+++ a/mm/memory-failure.c
@@ -979,7 +979,7 @@ struct page_state {
 static bool has_extra_refcount(struct page_state *ps, struct page *p,
 			       bool extra_pins)
 {
-	int count = page_count(p) - 1;
+	int count = page_count(p) - folio_nr_pages(page_folio(p));
 
 	if (extra_pins)
 		count -= 1;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

fix-hugetlbfs-hwpoison-handling.patch
maple_tree-fix-comment-describing-mas_node_count_gfp.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CA61E4110
	for <mm-commits@vger.kernel.org>; Mon, 21 Apr 2025 19:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745262166; cv=none; b=WAMkoCkG3kFwH78FI81/l18cznh9nmrkM8/C4AVu16w5F1hqiqR0QhHJq1QRSqOF0H6U2y4J9Ek9KfZgOqji+50WyNMnD/OQuw8f0PHlXPimzbsvY2lA7/Ym8GcqdCZve6JTj1uSVFAKeFt1bj8QR9M5i7aY89APZLPA+zwe4V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745262166; c=relaxed/simple;
	bh=PuqpD0ghUW8S2JsguD6d0u1Mn5Zn/BDMhrB6LV3opWY=;
	h=Date:To:From:Subject:Message-Id; b=mcs5qLoNuUsvv/BFCdxmJswHKqkncG/2DgZjtj113hEQrKQZGGm8SH7Ok1dvC9bh+5+hZ11IN4SwgbDELxo/6nejNluaBbyVdJdzrn6CdjR5ZrdL3HQoFkzuda7bii04e5fOQ79YSCPQfpLg2ROVCdW5oWDsMRhgZ/leZk/recE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=icHK++Yh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="icHK++Yh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1D1C4CEE4;
	Mon, 21 Apr 2025 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745262165;
	bh=PuqpD0ghUW8S2JsguD6d0u1Mn5Zn/BDMhrB6LV3opWY=;
	h=Date:To:From:Subject:From;
	b=icHK++Yhm/VYGBYK0lXdApWAfaTC1Bk3O3mdmBpgRskkoxsWwUsO2hjQJFhNvCC9k
	 hAfJRrF3cKRxI+bNenbdHBDPjuiDtlfS3kDwLE6obJK1Xu/8ddiVwOY3Z1LE7HX0En
	 T5nWvv5gszVM7NzrlctaEy2JjscOLyFzgRrEqskk=
Date: Mon, 21 Apr 2025 12:02:45 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,harry.yoo@oracle.com,david@redhat.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch added to mm-new branch
Message-Id: <20250421190245.8F1D1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: fix typo in comment in page_address_in_vma
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/rmap: fix typo in comment in page_address_in_vma
Date: Mon, 21 Apr 2025 16:57:29 +0800

Fix a minor typo in the comment above page_address_in_vma():
"responsibililty" → "responsibility"

Link: https://lkml.kernel.org/r/20250421085729.127845-3-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-fix-typo-in-comment-in-page_address_in_vma
+++ a/mm/rmap.c
@@ -774,7 +774,7 @@ static bool should_defer_flush(struct mm
  * @vma: The VMA we need to know the address in.
  *
  * Calculates the user virtual address of this page in the specified VMA.
- * It is the caller's responsibililty to check the page is actually
+ * It is the caller's responsibility to check the page is actually
  * within the VMA.  There may not currently be a PTE pointing at this
  * page, but if a page fault occurs at this address, this is the page
  * which will be accessed.
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch
mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch
fs-proc-page-refactoring-to-reduce-code-duplication.patch
mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch
mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch


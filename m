Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4EC2848B2
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 19:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770407828; cv=none; b=FunbqwJN4nvWkARy6eboZRruKOjTxNaZeIbnrPmT4rWRoxfkWPcSP+MLdZTo3b0amABAyUDC4fE3Il6Un/BOrmSd6oOoA8APS9k7L8DwFoOt3beBDk8LIDs6aXXjzMgwzjIhYdhEpYKHYKpl0rdIBQ6dCdF0krua0HFV4dyCpXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770407828; c=relaxed/simple;
	bh=u2CMs+caRwDMaaAuJjpExUUjcFnSWszFYZ4NUOta2QY=;
	h=Date:To:From:Subject:Message-Id; b=KWMTUlzCKOJe1QjWpfHu6t9oe49kNldXwAh8C9wBk4WMEBs8Y1Oal61KWiG0CAHOtktnKFFwpi881+SVg27e/CwHdQy3/ryZyPQgOSEyRCLg2nxAHmYPRyE2Sw1JLtf3avvWsDp/UCeyOCDdoF56S6kdfyKulRbyonGgm2CQmEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OJLYgb4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OJLYgb4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205F7C116C6;
	Fri,  6 Feb 2026 19:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770407828;
	bh=u2CMs+caRwDMaaAuJjpExUUjcFnSWszFYZ4NUOta2QY=;
	h=Date:To:From:Subject:From;
	b=OJLYgb4pYJoXEoOEWkMLk2icpfU/mU4kZ8ixehv+YxWDllX1vwfQrd2yTcl9kGnFX
	 HLEXPa/BR5uaGB2bR0czvjIR7hOTOgwPobO+32718i9ysDI/PM1/amFLdd1UFlnwGf
	 nYCi02xBNDq1cjfr8BrErJp2uDkWw0gLj9iE194E=
Date: Fri, 06 Feb 2026 11:57:07 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,willy@infradead.org,wang.yaxin@zte.com.cn,hughd@google.com,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-initialize-rmap-values-directly-and-make-them-const-fix.patch added to mm-new branch
Message-Id: <20260206195708.205F7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: initialize rmap values directly and make them const
has been added to the -mm mm-new branch.  Its filename is
     ksm-initialize-rmap-values-directly-and-make-them-const-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-initialize-rmap-values-directly-and-make-them-const-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: initialize rmap values directly and make them const
Date: Fri, 6 Feb 2026 15:22:54 +0800 (CST)

Considering that commit 06fbd555dea8 ("ksm: optimize rmap_walk_ksm by
passing a suitable addressrange") seems to have already been merged, this
new patch is proposed to address the issue raised by David at:

https://lore.kernel.org/all/ba03780a-fd65-4a03-97de-bc0905106260@kernel.org/

This initialize rmap values (addr, pgoff_start, pgoff_end) directly and
make them const to make code more robust.  Besides, since KSM folios are
always order-0, so folio_nr_pages(KSM folio) is always 1, so the line:

	"pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;"

becomes directly:

	"pgoff_end = pgoff_start;"

The test reproducer of rmap_walk_ksm can be found at:
https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/

Link: https://lkml.kernel.org/r/202602061522548871ohgXN8z0qq87sTSX-yZc@zte.com.cn
Fixes: 06fbd555dea8 ("ksm: optimize rmap_walk_ksm by passing a suitable addressrange")
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/ksm.c~ksm-initialize-rmap-values-directly-and-make-them-const-fix
+++ a/mm/ksm.c
@@ -3171,8 +3171,11 @@ again:
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
-		unsigned long addr;
-		pgoff_t pgoff_start, pgoff_end;
+		/* Ignore the stable/unstable/sqnr flags */
+		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		const pgoff_t pgoff_start = rmap_item->address >> PAGE_SHIFT;
+		/* KSM folios are always order-0 normal pages */
+		const pgoff_t pgoff_end = pgoff_start;
 
 		cond_resched();
 		if (!anon_vma_trylock_read(anon_vma)) {
@@ -3183,12 +3186,6 @@ again:
 			anon_vma_lock_read(anon_vma);
 		}
 
-		/* Ignore the stable/unstable/sqnr flags */
-		addr = rmap_item->address & PAGE_MASK;
-
-		pgoff_start = rmap_item->address >> PAGE_SHIFT;
-		pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
-
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
 					       pgoff_start, pgoff_end) {
 
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-initialize-the-addr-only-once-in-rmap_walk_ksm.patch
ksm-optimize-rmap_walk_ksm-by-passing-a-suitable-addressrange.patch
ksm-initialize-rmap-values-directly-and-make-them-const-fix.patch


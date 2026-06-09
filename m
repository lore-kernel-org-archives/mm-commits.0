Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF152F0C62
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968152; cv=none; b=Wy4O1ZgW6TdIPbPtiz9Ts7XnUTEXeY53fMMITTeZtLbx2rpHxIUpuCmPw3TOAI45p1VDsrvPlGeQXXrWrIRzpif8mr+yzPbMXc08IwD+S7ZSyMxrd9ovmoHeEaD2dIZkoYti09SmbaabO3DZcuBt8D8N+4Yv25frbN0Qk/bl1Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968152; c=relaxed/simple;
	bh=mfGaour8YMY/0GbrILgJzQF5LlggLcb4q54OtmWIMVc=;
	h=Date:To:From:Subject:Message-Id; b=iZuSZ77Qpld9TmSENUGBnMs28/a6Z4CvDJ4khdOfmK8ds2U82e2rr3P65z+c9naz1qN8K7mkODg1PozDKZ9cyx5s1jfHCPnoZpOZl5BY4aghFFCdSurQlOAHOwceR3aRaBwXlGEKgqfD+DJeYzWF0Tv6haM5saVfZgNMmMdL33M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Karr+a3y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Karr+a3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F5E1F00898;
	Tue,  9 Jun 2026 01:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968151;
	bh=IsgYn0XDZuChT792adUAHJNlWu3PoK09ICuj1q1fJ/w=;
	h=Date:To:From:Subject;
	b=Karr+a3y6V0/Fz+cJLWPTESNthVsI9+Jp8YdnEtL+ovcm9P98lfpQmoqB5/TOpPV3
	 FXnNkUvIQQh1OlS+t5UWSDWrZRQY5ry9t7Il/pSoCsrsupLk+vUuVojlukyB9NP8qd
	 YkLjlU+EflhKHTHrRcog7xms1yyp1oKV2/nn3tz8=
Date: Mon, 08 Jun 2026 18:22:31 -0700
To: mm-commits@vger.kernel.org,sashiko-bot@kernel.org,leon@kernel.org,jgg@ziepe.ca,balbirs@nvidia.com,apopple@nvidia.com,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system.patch removed from -mm tree
Message-Id: <20260609012231.64F5E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_hmm: fix memory leak in dmirror_migrate_to_system()
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: lib/test_hmm: fix memory leak in dmirror_migrate_to_system()
Date: Thu, 28 May 2026 09:13:36 +0800

Move the kvcalloc() calls after the early return checks to avoid leaking
src_pfns and dst_pfns when end < start or mmget_not_zero() fails.

Link: https://lore.kernel.org/20260528011336.20797-1-hao.ge@linux.dev
Fixes: 775465fd26a3 ("lib/test_hmm: add zone device private THP test infrastructure")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system
+++ a/lib/test_hmm.c
@@ -1111,9 +1111,6 @@ static int dmirror_migrate_to_system(str
 	unsigned long *src_pfns;
 	unsigned long *dst_pfns;
 
-	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
-	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
-
 	start = cmd->addr;
 	end = start + size;
 	if (end < start)
@@ -1123,6 +1120,9 @@ static int dmirror_migrate_to_system(str
 	if (!mmget_not_zero(mm))
 		return -EINVAL;
 
+	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
+
 	cmd->cpages = 0;
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
_

Patches currently in -mm which might be from hao.ge@linux.dev are

mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch
alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch
maintainers-add-hao-ge-as-reviewer-for-codetag-and-alloc_tag.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0941652F88
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006270; cv=none; b=RQtiaGysQexy5zZUOCMdftL1j2wR49WMd8PBiJzG88LdaOP9lX2L2xoXurhs06FAjNV0E6MtfTZQ1UbU2F8p6sjvfySQxTLuwKlUhq+mAElNQaGMZtuuuEt6+gffm40yc65yShgVdnnaAC3BY/aSJbE2Kv+L6CUyGw2rUhpn4SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006270; c=relaxed/simple;
	bh=mqnKT1bJJ+MXmWxMnkafIuaPDKd+Te8d5bdojvX+AUw=;
	h=Date:To:From:Subject:Message-Id; b=TZXiAEJe9jWCaaR7gxDo16BEGq00DIYa4ari3ME22FLpI4x3cUIcWMyECRCq6R62mMXcMf+/1VA6Zk4k1Ghv30VErpoJoaeUUvPXXSJnhGVWPBAwJPC8qthAChIsTJUXlNM5zj9iSgfslfd66gWpfeYKHd/0SxkbaczAbRaW71o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oCNIYmB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oCNIYmB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA14EC4CEF5;
	Wed, 17 Dec 2025 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766006269;
	bh=mqnKT1bJJ+MXmWxMnkafIuaPDKd+Te8d5bdojvX+AUw=;
	h=Date:To:From:Subject:From;
	b=oCNIYmB9HI94iNN7BXkGKsej1If3VwXaC3Czta7mXKh7W3jhxzgHqCUSJ3CTjSnzO
	 r5BSnalBTeDBMT83YiZ1jgQXExUKE4Buy7x3uWsfOdaPtR+Q8dS+lrsflA27UqcGIa
	 Du8rcGadH2TUAwyRYdW+tI5y1AfvSbwNUujMGbhc=
Date: Wed, 17 Dec 2025 13:17:49 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry.ahmed@linux.dev,willy@infradead.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david.laight.linux@gmail.com,david@kernel.org,chengming.zhou@linux.dev,axelrasmussen@google.com,chandna.sahil@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-simplify-hugepage-boundary-calculation.patch added to mm-new branch
Message-Id: <20251217211749.BA14EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pagewalk: simplify hugepage boundary calculation
has been added to the -mm mm-new branch.  Its filename is
     mm-pagewalk-simplify-hugepage-boundary-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-simplify-hugepage-boundary-calculation.patch

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
From: Sahil Chandna <chandna.sahil@gmail.com>
Subject: mm: pagewalk: simplify hugepage boundary calculation
Date: Fri, 28 Nov 2025 12:31:42 +0530

Patch series "mm: Coccinelle-driven cleanups across memory management
code", v4.

This patch series contains three minor cleanups identified by Coccinelle
scripts under scripts/coccinelle/misc/:

  * Use ALIGN() to compute the next hugepage boundary instead of the
    open-coded expression and use min() macro to improve readability.
  * Use the %pe printk format specifier for PTR_ERR() reporting
    in vmscan.c and zswap.c
Found using:
  make coccicheck MODE=report M=mm/


This patch (of 3):

Replace hugepage boundary computation with ALIGN() helper instead of an
open coded expression.  This helps to improves code readability.

This was flagged by Coccinelle (misc/minmax.cocci) as an opportunity to
use min(), after which the boundary computation was updated following
review suggestions.

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Link: https://lkml.kernel.org/r/cover.1764312627.git.chandna.sahil@gmail.com
Link: https://lkml.kernel.org/r/35ab82f052d248c0047c10bf01853e37e4f9b4e4.1764312627.git.chandna.sahil@gmail.com
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: David Laight <david.laight.linux@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/pagewalk.c~mm-pagewalk-simplify-hugepage-boundary-calculation
+++ a/mm/pagewalk.c
@@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long
 static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
 				       unsigned long end)
 {
-	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
-	return boundary < end ? boundary : end;
+	return min(ALIGN(addr, huge_page_size(h)), end);
 }
 
 static int walk_hugetlb_range(unsigned long addr, unsigned long end,
_

Patches currently in -mm which might be from chandna.sahil@gmail.com are

mm-pagewalk-simplify-hugepage-boundary-calculation.patch
mm-vmscan-use-%pe-to-print-error-pointers.patch
mm-zswap-use-%pe-to-print-error-pointers.patch


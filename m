Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9851FC0B
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 01:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610392; cv=none; b=ifnauXTx6R1cC4RgCNJZFJsyFrM5quSftkRcc5DQmWBUFXN+STjzRNpWnfmqaQGCwyKFYvwZPfs988EGaKV+44052/QwuJhosVNFPfWr44MAqeIZ98fXPXqmVC/vnmzQTXTNPLyObUihqhuvq5QPJoTSE631HRIOj4OerUJkMvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610392; c=relaxed/simple;
	bh=B9NAqgbXNOoD++ULVHAHKVPQICRTsiqVIF/vHw43BwQ=;
	h=Date:To:From:Subject:Message-Id; b=lIiWjZTW2Y6Gg8yZ/WTJ6Mji/Yso5DVr8tGAl+5FYZqE6MdOzHnIzsfeIyBH9FUo7QVuApvZnzBhthO+zRZz7/lufpxZ/pCtrIZbj56SYG0TEkiGS5XmGQ6c+uUp3lVRWe33H1zq4pF+S0GdRwNct+GVU0W6DArrOd+PxYe4gdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JGmAq7ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JGmAq7ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F45C4CED0;
	Tue, 31 Dec 2024 01:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610391;
	bh=B9NAqgbXNOoD++ULVHAHKVPQICRTsiqVIF/vHw43BwQ=;
	h=Date:To:From:Subject:From;
	b=JGmAq7ZKH+Jn9Hi58PvzoXZ3eGAVkCJwaBe/yGKhGotAGeXTyA8v5nGL8sBgN7rT3
	 S+N3EZyTt/q2LyWBRZLmi1km/ewBVS+/wv0gvjia+KfjF05+zsL6R8wqA4FAdeoyJf
	 LghAWMEi255kIebbT9mScGHs1z5HRRrIjbsc32Xg=
Date: Mon, 30 Dec 2024 17:59:50 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rick.p.edgecombe@intel.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,david@redhat.com,christophe.leroy@csgroup.eu,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-dont-try-thp-align-for-fs-without-get_unmapped_area.patch removed from -mm tree
Message-Id: <20241231015951.60F45C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: don't try THP alignment for FS without get_unmapped_area
has been removed from the -mm tree.  Its filename was
     mm-dont-try-thp-align-for-fs-without-get_unmapped_area.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: don't try THP alignment for FS without get_unmapped_area
Date: Fri, 6 Dec 2024 15:03:45 +0800

Commit ed48e87c7df3 ("thp: add thp_get_unmapped_area_vmflags()") changes
thp_get_unmapped_area() to thp_get_unmapped_area_vmflags() in
__get_unmapped_area(), which doesn't initialize local get_area for
anonymous mappings.  This leads to us always trying THP alignment even for
file_operations which have a NULL ->get_unmapped_area() callback.

Since commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries") we only want to enable THP alignment for anonymous mappings,
so add a !file check to avoid attempting THP alignment for file mappings.

Found issue by code inspection.  THP alignment is used for easy or more
pmd mappings, from vma side.  This may cause unnecessary VMA fragmentation
and potentially worse performance on filesystems that do not actually
support THPs and thus cannot benefit from the alignment.

Link: https://lkml.kernel.org/r/20241206070345.2526501-1-wangkefeng.wang@huawei.com
Fixes: ed48e87c7df3 ("thp: add thp_get_unmapped_area_vmflags()")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-dont-try-thp-align-for-fs-without-get_unmapped_area
+++ a/mm/mmap.c
@@ -892,7 +892,7 @@ __get_unmapped_area(struct file *file, u
 
 	if (get_area) {
 		addr = get_area(file, addr, len, pgoff, flags);
-	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !file
 		   && !addr /* no hint */
 		   && IS_ALIGNED(len, PMD_SIZE)) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are



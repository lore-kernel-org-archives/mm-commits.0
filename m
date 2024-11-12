Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540CD215021
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 18:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731435270; cv=none; b=i3+6A7xuf77eM7LCE9GWU6b9zfocdwCynCozk+3XKvMAIV3QkiZcrPhI5wx0w3oGAYAx4YKki4MDlqkBuNC3lUn76tpegbVBsUFXUEB2hjIt8tGdGV33jlM7eM56O8HW1hLe4chdiX8aV/ivo55zybhWpZ+L+g5j6JwBHVm3P1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731435270; c=relaxed/simple;
	bh=MWYdNJCISbq0JcpaVYUFrF6ronl+Ofl6j27EnSM1I2A=;
	h=Date:To:From:Subject:Message-Id; b=Ch92zucLw2MvB6BB6bmxu8x2N1Tbm6VlE0BwGLLCB0uX1SK9VmAwJ+b0iD9inbHT6s/FxLtgarmJ6n6mvyLgS++XIibrw0VmPLFEyss9AZ0HdcCCDCJpuJVTNM/JnUFTYsHQqLTjDAJJiN8oiiFphujNRi7/VsAekwC8trsKEyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hc6zIiiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hc6zIiiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A0FC4CED9;
	Tue, 12 Nov 2024 18:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731435269;
	bh=MWYdNJCISbq0JcpaVYUFrF6ronl+Ofl6j27EnSM1I2A=;
	h=Date:To:From:Subject:From;
	b=Hc6zIiiL38TibFnGgspadLeaehknjgoazmBZcLUosZfA2bruQny7ZUh5Wbg1BZg5x
	 02RX9ST1/B4uF1COtIAcEkY01c5rvAvih1eJ1PqkT9xyXufex2K1SnhCRWCAD/wETZ
	 m4AZnjVB29I0dBEd4+9N7niVcJzw1xf7owxiElwU=
Date: Tue, 12 Nov 2024 10:14:29 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,usamaarif642@gmail.com,shy828301@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,richard.weiyang@gmail.com,nphamcs@gmail.com,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-thp-fix-deferred-split-queue-not-partially_mapped-fix.patch removed from -mm tree
Message-Id: <20241112181429.D7A0FC4CED9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/thp: fix deferred split queue not partially_mapped: fix
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-deferred-split-queue-not-partially_mapped-fix.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: fix deferred split queue not partially_mapped: fix
Date: Sun, 10 Nov 2024 13:11:21 -0800 (PST)

Though even more elusive than before, list_del corruption has still been
seen on THP's deferred split queue.

The idea in commit e66f3185fa04 was right, but its implementation wrong. 
The context omitted an important comment just before the critical test:
"split_folio() removes folio from list on success." In ignoring that
comment, when a THP split succeeded, the code went on to release the
preceding safe folio, preserving instead an irrelevant (formerly head)
folio: which gives no safety because it's not on the list.  Fix the logic.

Link: https://lkml.kernel.org/r/3c995a30-31ce-0998-1b9f-3a2cb9354c91@google.com
Fixes: e66f3185fa04 ("mm/thp: fix deferred split queue not partially_mapped")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-fix-deferred-split-queue-not-partially_mapped-fix
+++ a/mm/huge_memory.c
@@ -3790,7 +3790,9 @@ next:
 		 * in the case it was underused, then consider it used and
 		 * don't add it back to split_queue.
 		 */
-		if (!did_split && !folio_test_partially_mapped(folio)) {
+		if (did_split) {
+			; /* folio already removed from list */
+		} else if (!folio_test_partially_mapped(folio)) {
 			list_del_init(&folio->_deferred_list);
 			removed++;
 		} else {
_

Patches currently in -mm which might be from hughd@google.com are



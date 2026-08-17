Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491CF235045;
	Mon, 17 Aug 2026 21:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787002908; cv=none; b=lDHBlvonPRchqEogrzjvNT86VmxiHw57GVRsbmHKQTyCoi6ZE3ZRWLL2XvwdELmmu+oQhe0usXqAwYKEURzoGa4kWm95pYtMtYwgnqANjr3HilWWQM31HXp2Y2As/5gYZeXiXkkj9rG6ZvRsJhZwT14tlIKNpwo5tcYaw2XH3Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787002908; c=relaxed/simple;
	bh=4WmHemqiGzwEr1P1GxIM9j8ebaIyfeQllPWsWFoDuzM=;
	h=Date:To:From:Subject:Message-Id; b=j5JKBQmLhwxAJqJelDH7SpPa0W/vgpf31hcSzVhTj5HHvEigfui0eMRfpbvY4wAMcHvZ4uaASTfYF7skfqLx5vvloP11pxgXEgzQojSPnaEnco/SzzJL78PeMzICOV0FnU7LVXbnMkjJxePiK752aei8i7M9WB9sQoyDHT597YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wOXU9p2K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wOXU9p2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20191F000E9;
	Mon, 17 Aug 2026 21:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787002906;
	bh=ilJFcXuONEQu0+B/j2F5OhA+v+1LDqzZjl8KkJQ9AWo=;
	h=Date:To:From:Subject;
	b=wOXU9p2KWkYpMm+KoAe0RN/bztE6aqx9KSEkNl1kK4aL/UXJbErrM0Ol5UXb/I/lT
	 MukG8KRB34zYwzMRZYKehyAvmYraXW2ddcy0R1odzkHLpBvc7an8AoRhljHu9o4dV+
	 eSwuDsJmO7Ld7uv/E0B8jZOv3IplWdkeVCeDjjKM=
Date: Mon, 17 Aug 2026 14:41:46 -0700
To: mm-commits@vger.kernel.org,tujinjiang@huawei.com,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-keep-max_huge_pages-when-dissolving-surplus-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20260817214146.C20191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: keep max_huge_pages when dissolving surplus folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-keep-max_huge_pages-when-dissolving-surplus-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-keep-max_huge_pages-when-dissolving-surplus-folios.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/hugetlb: keep max_huge_pages when dissolving surplus folios
Date: Fri, 14 Aug 2026 16:30:27 +0800

dissolve_free_hugetlb_folio() can remove a free folio as surplus when its
node has surplus pages.  In that case remove_hugetlb_folio() decrements
both nr_huge_pages and surplus_huge_pages, leaving the persistent pool
size unchanged.

Updating max_huge_pages as if a persistent folio had been removed can
therefore corrupt the persistent pool target and underflow it when
max_huge_pages is zero.  Keep max_huge_pages unchanged for surplus folios,
including the vmemmap restoration rollback path.

Link: https://lore.kernel.org/20260814083027.1419487-1-xialonglong2025@163.com
Fixes: cb402bbdabca ("mm/hugetlb: fix surplus pages in dissolve_free_huge_page()")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Longlong Xia <xialonglong@kylinos.cn>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-keep-max_huge_pages-when-dissolving-surplus-folios
+++ a/mm/hugetlb.c
@@ -2002,7 +2002,8 @@ retry:
 		if (h->surplus_huge_pages_node[folio_nid(folio)])
 			adjust_surplus = true;
 		remove_hugetlb_folio(h, folio, adjust_surplus);
-		h->max_huge_pages--;
+		if (!adjust_surplus)
+			h->max_huge_pages--;
 		spin_unlock_irq(&hugetlb_lock);
 
 		/*
@@ -2022,7 +2023,8 @@ retry:
 			if (rc) {
 				spin_lock_irq(&hugetlb_lock);
 				add_hugetlb_folio(h, folio, adjust_surplus);
-				h->max_huge_pages++;
+				if (!adjust_surplus)
+					h->max_huge_pages++;
 				goto out;
 			}
 		} else {
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-hugetlb-keep-max_huge_pages-when-dissolving-surplus-folios.patch
mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch
zram-fix-out-of-bounds-access-in-writeback_store.patch
zram-fix-out-of-bounds-access-in-read_block_state.patch
zsmalloc-account-for-handle-size-in-class-lookup.patch


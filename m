Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331A9156864
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560541; cv=none; b=OoLL/mcFyskuy92/wSupzDWkZZJIeMiH47Li/TgfughNVh+JWqg4Xx1+usrTQnxIy6NPJ2vbDuaGJnRpIX0OWqSFcMjgZP4fblrs9acl6LuoUxarvJH6hiw9hyFO+IAbt27fSnrXPSHNLnXv1awfkqM1Senlc3kivQ9gx//P68E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560541; c=relaxed/simple;
	bh=IrOiPID3s4kbEdg+MMNqCeaBQTZms0biYw19jCLUhVA=;
	h=Date:To:From:Subject:Message-Id; b=VQ9ZW1bNcyOaKa1a3cWL0Zoq9gPAw/WS/URLLmPxequ3KKlcF40W3FqmYQ4EiipJdME5LvHRySe6EbWktwUoQ98pZ/ly+G/Amv9xWa2FpwnO5yCznJGRzocYO0LhzdIdkLHli0SowUVpE+hs5i86RmXMAh1V4kk/m/2TmG0hcjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mVYHvUyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mVYHvUyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB67C4CECE;
	Tue, 17 Sep 2024 08:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560541;
	bh=IrOiPID3s4kbEdg+MMNqCeaBQTZms0biYw19jCLUhVA=;
	h=Date:To:From:Subject:From;
	b=mVYHvUyxjgiUs9rMr36oBDe0GCSTWRuqKPBuTd8RZtxXuDV+vJU7TSAGc49/wSSmI
	 8aEKRv8HWeh6PENH8ENv58M/qexn1Lg3I43/R0sv2BXNDV+tCUZH9sdEoWrMGWuODq
	 nF6Kf53Zmp/7XGU20KnFZ+N7loG1y9BzIWtihT+4=
Date: Tue, 17 Sep 2024 01:08:57 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jiaqiyan@google.com,jane.chu@oracle.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-support-poison-recovery-from-copy_present_page.patch removed from -mm tree
Message-Id: <20240917080900.9BB67C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: support poison recovery from copy_present_page()
has been removed from the -mm tree.  Its filename was
     mm-support-poison-recovery-from-copy_present_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: support poison recovery from copy_present_page()
Date: Fri, 6 Sep 2024 10:42:01 +0800

Similar to other poison recovery, use copy_mc_user_highpage() to avoid
potentially kernel panic during copy page in copy_present_page() from
fork, once copy failed due to hwpoison in source page, we need to break
out of copy in copy_pte_range() and release prealloc folio, so
copy_mc_user_highpage() is moved ahead before set *prealloc to NULL.

Link: https://lkml.kernel.org/r/20240906024201.1214712-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-support-poison-recovery-from-copy_present_page
+++ a/mm/memory.c
@@ -926,8 +926,11 @@ copy_present_page(struct vm_area_struct
 	 * We have a prealloc page, all good!  Take it
 	 * over and copy the page & arm it.
 	 */
+
+	if (copy_mc_user_highpage(&new_folio->page, page, addr, src_vma))
+		return -EHWPOISON;
+
 	*prealloc = NULL;
-	copy_user_highpage(&new_folio->page, page, addr, src_vma);
 	__folio_mark_uptodate(new_folio);
 	folio_add_new_anon_rmap(new_folio, dst_vma, addr, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(new_folio, dst_vma);
@@ -1166,8 +1169,9 @@ again:
 		/*
 		 * If we need a pre-allocated page for this pte, drop the
 		 * locks, allocate, and try again.
+		 * If copy failed due to hwpoison in source page, break out.
 		 */
-		if (unlikely(ret == -EAGAIN))
+		if (unlikely(ret == -EAGAIN || ret == -EHWPOISON))
 			break;
 		if (unlikely(prealloc)) {
 			/*
@@ -1197,7 +1201,7 @@ again:
 			goto out;
 		}
 		entry.val = 0;
-	} else if (ret == -EBUSY) {
+	} else if (ret == -EBUSY || unlikely(ret == -EHWPOISON)) {
 		goto out;
 	} else if (ret ==  -EAGAIN) {
 		prealloc = folio_prealloc(src_mm, src_vma, addr, false);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are



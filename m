Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDC0279DCC
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517850; cv=none; b=OGO6WyUM/ug0XqaBag+BGbBnQNTOMpvYsEd3LoeiiaQibfq7Tc1mc8WlfkGREBqXamPZzX7Jp2scsWN28GbPkkK5tw4dmjiCnhjjZ5MSGa9m56jaXv/LxBnfqKFKxkjRwEdLZowRjiJtxbzNp/ry3/Q4QPYIW+mrHFx0UW90J/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517850; c=relaxed/simple;
	bh=mzvg1F6CZuRgxg8Cl2GPnYP/gsO5ZPG3jHGqytisElI=;
	h=Date:To:From:Subject:Message-Id; b=bGe9VTBI4C2ugwPL3yK9yIrUNGH7CZvMWmk4iG1Q12/3bmigoVEvTvbpb46i0141fEjtZcyhHDicKe8ITsI0I2Klk/CNLIKZQmu6QwRod2hkmgwo1AhfHHfIfy8/dF3P2xYDj0IOEX4zukvjfJdRJaKaPURygu2bRe4xzG6N+kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EwQmhAbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EwQmhAbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C7CC113D0;
	Tue, 23 Dec 2025 19:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517850;
	bh=mzvg1F6CZuRgxg8Cl2GPnYP/gsO5ZPG3jHGqytisElI=;
	h=Date:To:From:Subject:From;
	b=EwQmhAbVOfwNdI9ep/iO1vWctOkJNAJSbKGNZNFr6oFBFK4c3jFCj9uA43SsbpoZU
	 jrxrZm6ObXsIg7zagqqLMuUOdSY1V7geCqkXwO+Fgt8s3/yd1aVJbxnyT0XGm2qmhK
	 6Fezbbj2/BJAFxKWMnFVBL5BtEBrbaSThQDi/WFQ=
Date: Tue, 23 Dec 2025 11:24:09 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-vaddr-fix-missing-pte_unmap_unlock-in-damos_va_migrate_pmd_entry.patch removed from -mm tree
Message-Id: <20251223192410.34C7CC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: fix missing pte_unmap_unlock in damos_va_migrate_pmd_entry()
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-fix-missing-pte_unmap_unlock-in-damos_va_migrate_pmd_entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm/damon/vaddr: fix missing pte_unmap_unlock in damos_va_migrate_pmd_entry()
Date: Wed, 10 Dec 2025 00:10:34 +0900

If the PTE page table lock is acquired by pte_offset_map_lock(), the lock
must be released via pte_unmap_unlock().

However, in damos_va_migrate_pmd_entry(), if damos_va_filter_out() returns
true, it immediately returns without releasing the lock.

This fixes the issue by not stopping page table traversal when
damos_va_filter_out() returns true and ensuring that the lock is released.

Link: https://lkml.kernel.org/r/20251209151034.77221-1-akinobu.mita@gmail.com
Fixes: 09efc56a3b1c ("mm/damon/vaddr: consistently use only pmd_entry for damos_migrate")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-fix-missing-pte_unmap_unlock-in-damos_va_migrate_pmd_entry
+++ a/mm/damon/vaddr.c
@@ -743,7 +743,7 @@ huge_out:
 		if (!folio)
 			continue;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
-			return 0;
+			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
 		nr = folio_nr_pages(folio);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes.patch
mm-numa_emu-add-document-for-numa-emulation.patch
mm-vmscan-dont-demote-if-there-is-not-enough-free-memory-in-the-lower-memory-tier.patch


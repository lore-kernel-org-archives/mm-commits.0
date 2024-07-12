Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E9C12DD8E
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824910; cv=none; b=AzrB1V6sKIvqdKcUI5YNKmRf3MxhzzD60idXj+wCMPtJKRat9nIn9hieoW/eD8jnDSJ1rqMxfQ6AIsz9US7mFv60vciwjEekp7/I3aEOH5ngS8Yq9+qpCLU+TNoc3BrFzJZKxTWpeVDx4hrL40OEzaDGlD90k/Z8sWbIfO2Fo7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824910; c=relaxed/simple;
	bh=HSs1ttwdVtaVh+kNBZCxeeo4VVxTxEVJVOHLGMtp1Mk=;
	h=Date:To:From:Subject:Message-Id; b=XkX5etxAI2jNlOjnCx/bliRVm2yIGfIabE5xYAEchmVjp9y714GxtCYDLmBVWvRrApRbpyx7wZ+fQ7z4OO2VnoJKjJaZjWT/9WnafriaXD/3enUDqMtJQLoM+9DiNWrcRvVEEZaK/sgEHf+kbIdH6vOCzq2w7aquYh4UL+CQaVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G3dAg0qN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G3dAg0qN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1B7C32782;
	Fri, 12 Jul 2024 22:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824910;
	bh=HSs1ttwdVtaVh+kNBZCxeeo4VVxTxEVJVOHLGMtp1Mk=;
	h=Date:To:From:Subject:From;
	b=G3dAg0qN5busRo4hiAU8bRMYI8tPUTF4tzME+7sFjJDe9yasrhzII01SmlUVigEB7
	 nGDnfZrEulxdY+fHvuEgsu7za2mXLhHtnyGAZ8m09jOP+CXe/MCKNioCMbldaLcqvP
	 LcMiv2vnHMQc2zvJVeLA5mHsuAWTkXLFseVLaXyw=
Date: Fri, 12 Jul 2024 15:55:09 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,dan.j.williams@intel.com,peili.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ignore-data-race-in-__swap_writepage.patch removed from -mm tree
Message-Id: <20240712225510.1E1B7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: ignore data-race in __swap_writepage
has been removed from the -mm tree.  Its filename was
     mm-ignore-data-race-in-__swap_writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pei Li <peili.dev@gmail.com>
Subject: mm: ignore data-race in __swap_writepage
Date: Thu, 11 Jul 2024 09:32:30 -0700

Syzbot reported a possible data race:

BUG: KCSAN: data-race in __swap_writepage / scan_swap_map_slots

read-write to 0xffff888102fca610 of 8 bytes by task 7106 on cpu 1.
read to 0xffff888102fca610 of 8 bytes by task 7080 on cpu 0.

While we are in __swap_writepage to read sis->flags, scan_swap_map_slots
is trying to update it with SWP_SCANNING.

value changed: 0x0000000000008083 -> 0x0000000000004083.

While this can be updated non-atomicially, this won't affect
SWP_SYNCHRONOUS_IO, so we consider this data-race safe.

This is possibly introduced by commit 3222d8c2a7f8 ("block: remove
->rw_page"), where this if branch is introduced.

Link: https://lkml.kernel.org/r/20240711-bug13-v1-1-cea2b8ae8d76@gmail.com
Fixes: 3222d8c2a7f8 ("block: remove ->rw_page")
Signed-off-by: Pei Li <peili.dev@gmail.com>
Reported-by: syzbot+da25887cc13da6bf3b8c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=da25887cc13da6bf3b8c
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/page_io.c~mm-ignore-data-race-in-__swap_writepage
+++ a/mm/page_io.c
@@ -382,7 +382,12 @@ void __swap_writepage(struct folio *foli
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
 		swap_writepage_fs(folio, wbc);
-	else if (sis->flags & SWP_SYNCHRONOUS_IO)
+	/*
+	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
+	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
+	 * is safe.
+	 */
+	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
 		swap_writepage_bdev_sync(folio, wbc, sis);
 	else
 		swap_writepage_bdev_async(folio, wbc, sis);
_

Patches currently in -mm which might be from peili.dev@gmail.com are



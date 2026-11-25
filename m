Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795573169;
	b=nRNUwWkNWd0xGDHVERcOLCLZA964Xg4Q4eU55Kv5//N2P8mqBAZdIAi2uW7Hpwan2q5w
	 Tfu9sFAJQlQ7E8Kp3GA8NtAkXjPM66d5gHlfx5Bkk/45C99vk3VqyWc5rrx5GQ6YvDHPn
	 ZDdeYKzvJjD3ir/i2gmH/9jLyzftH0t+NlVTiubF5SmwiCyHH8bsKWNmsy30lGz4RDs+9
	 X2CMhd7gKRplzpZxEMrsmtq7QkGy71O5VQI7DkackhU8o1Q6XYBFnTmTMhuEBio+AwrlA
	 MgMiSRXYdtf+KdYv89GFv3GcdTlabRlxwdqdNd4TYs1zxwAsmHI4PZ8+y+K9oI5y6eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795573169;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=NEW3V2K4gglBHL10ZuxqZ8uPBtKNlyzaDB+42s1d9oM=;
	b=cn8ZMgNB/izXJB6PDxTK9ympaArUPgLvjijMGXhsIz2UYzgp8Z31exdeEHCSkzIvVt1d
	 s/DxXoBU7auilSHEiCmITxK1Coq83Ghw6a1VClRtqTU2nQ9N9Z7zLHTIHzDH5/S9l3Vha
	 tQFkrrDlg2fj66jmx/JMU5+IiaFrTZw9qm4E1yXC8E+QeuoTmrAc2Cf1yuUejLSAZsMTf
	 +JajTCiFnoWAYtsSIF/8sc8MtjsvLSzQO0Nmp4oX8fukj1CzrLXWgv7axLsWLSAlNCRcl
	 0A99P0iZHiPW+a57tsPeR9zU1fBS6WZlHnrqCHukMDkbILnDHRufa36CGeoc9qQci8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ox5pl1tm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8D0606A323;
	Wed, 25 Nov 2026 02:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ox5pl1tm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202EA1F000C0;
	Wed, 25 Nov 2026 02:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795573169;
	bh=NEW3V2K4gglBHL10ZuxqZ8uPBtKNlyzaDB+42s1d9oM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Ox5pl1tmsBopOUhN6i+KE2ja6SIrtq3ChiqfuIOlWdANvlNBtifka1WQ9bwRop0p9
	 h6swJcSVlIVkAom6CZ1JOXCaiABXCkGmWaU9Ny3WG71ml5dHZ/HH7u24F1PJ+VU/rj
	 Fk+SPEnbswml3z+9ANO+LrwBj6wwFVm8AaQtYIws=
Date: Tue, 24 Nov 2026 18:19:28 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,
	stable@vger.kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,
	jannh@google.com,chris@chrisdown.name,matthewsalsamendi@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261118-pagemap-walk-end-v2-1-94cd92d838b3@gmail.com>
References: <20261118-pagemap-walk-end-v2-1-94cd92d838b3@gmail.com>
Subject: + fs-proc-task_mmu-reset-walk_end-before-each-pagemap-walk.patch added to mm-new branch
Message-Id: <20261125021929.202EA1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fs/proc/task_mmu: reset walk_end before each pagemap walk
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-task_mmu-reset-walk_end-before-each-pagemap-walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-reset-walk_end-before-each-pagemap-walk.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Matthew Salsamendi <matthewsalsamendi@gmail.com>
Subject: fs/proc/task_mmu: reset walk_end before each pagemap walk
Date: Tue, 17 Nov 2026 16:26:17 -0800

Patch series "fs/proc: fix PAGEMAP_SCAN walk_end after a buffer refill",
v2.


This patch (of 2):

When PAGEMAP_SCAN resumes after filling its buffer, it can return ranges
beyond a stale walk_end. This aborts a production game server during
dirty-page tracking.

Reset walk_end before each walk so a completed scan reports the end and
a partial HugeTLB write-protect request keeps its retry address.

Codex assisted with diagnosis, validation and this message.

Link: https://lore.kernel.org/20261118-pagemap-walk-end-v2-0-94cd92d838b3@gmail.com
Link: https://patch.msgid.link/20261118-pagemap-walk-end-v2-1-94cd92d838b3@gmail.com
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Matthew Salsamendi <matthewsalsamendi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Chris Down <chris@chrisdown.name>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org> # 6.7+

 fs/proc/task_mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-reset-walk_end-before-each-pagemap-walk
+++ a/fs/proc/task_mmu.c
@@ -3199,6 +3199,7 @@ static long do_pagemap_scan(struct mm_st
 			mmu_notifier_invalidate_range_start(&range);
 		}
 
+		p.arg.walk_end = 0; /* Reset partial walks. */
 		ret = walk_page_range(mm, walk_start, p.arg.end,
 				      &pagemap_scan_ops, &p);
 
_

Patches currently in -mm which might be from matthewsalsamendi@gmail.com are

fs-proc-task_mmu-reset-walk_end-before-each-pagemap-walk.patch
selftests-mm-cover-pagemap_scan-refill-and-hugetlb-retry.patch


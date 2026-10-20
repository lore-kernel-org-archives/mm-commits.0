Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792458306;
	b=r2oTQHRUsICoOswWdjfFtNtd7F1l+UyhCu/uzZ9GZzcKfzIbKIiXOO0AzYQwycDuOWV+
	 4L4f62HD1WdN+HVXZ4tRxjuLA9o5mvKdfX8txEZx/cLGfMzCMsmjSGO7/Ay9KPnl6TgFe
	 yAAOzR80d6bMvzo4dlgmECYh370AYigV1nDRhbRBnKaZ1F2KOM/S3Q69zL2yWavdg5jHF
	 pNf4/mGlfDZOQlRrfrZh4JJQvoLkelFKiHG8jOdlZLD9I8LlnWLZVhhwZBdq1gxdXRWGt
	 b4dZJdbC2h6KuWalz4QXujuGmeDuPBYOOFVOpD/7LJBor/jgaI9FiaOvFu/pJphPD3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792458306;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qz/REZQcau3HLxA1z4gxI8jW645xfcr06F21XNGw7GE=;
	b=3xJLPkcN/EO1qOFQFnqm06Hp377PCqMX5UDMx7TRtKvNkcf5bcrnMoGQjP6npv5JX69u
	 x5nXrdnmrEggjUsI56sOqfyA+kqG68j8t4wzHDonYISuupVauN4csHg7uNCqnF6AjcYjQ
	 krl/Hww0zeFaXJhxJjg818VYBL8PpWBboQb6MzPibAB89IU69NjuJtb8uGFhpPIxjNqhX
	 x4lG9Hb6XH5PSVMrxPj36QRITUNVUJzgcj13683ZRuIX/7wluDZsHrFOpw06krVyVs2DB
	 1LnAKbt0foiwQXaofVnDjqQVNhro04O96Q+JhVy7ZFy8510O7gH8GHGCv8Tcb0BtVXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OGT+dFpQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6D1606A323
	for <mm-commits@vger.kernel.org>; Tue, 20 Oct 2026 01:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OGT+dFpQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073ED1F000C8;
	Tue, 20 Oct 2026 01:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792458306;
	bh=qz/REZQcau3HLxA1z4gxI8jW645xfcr06F21XNGw7GE=;
	h=Date:To:From:Subject;
	b=OGT+dFpQiKfWSM4UXU2X7SFDxy3cvSsA4eE03MiOdx+y0Zr/u9paviZgXU1EbTLov
	 vs3m7CpeblOMgsIbbXgiWcLlVaPb8QWe+byUidgs7Ck03ffIiV4UWs2AHFo3/2uMvF
	 7UhRwdMEiRWC8XpZjpYN838u0pqIYv+hXW3klhyU=
Date: Mon, 19 Oct 2026 18:05:05 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,pfalcato@suse.de,ngocquy0700@gmail.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix.patch added to mm-unstable branch
Message-Id: <20261020010506.073ED1F000C8@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix
Date: Mon Oct 19 06:04:17 PM PDT 2026

remove unneeded & undesirable test for !mm

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Ngoc Quy <ngocquy0700@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix
+++ a/fs/proc/task_mmu.c
@@ -3125,7 +3125,7 @@ static long do_pagemap_scan(struct mm_st
 	size_t n_ranges_out = 0;
 	int ret;
 
-	if (!mm || !mmget_not_zero(mm))
+	if (!mmget_not_zero(mm))
 		return -ESRCH;
 
 	ret = pagemap_scan_get_args(&p.arg, uarg);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bio-iov-iter-rollback.patch
mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix.patch


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792829072;
	b=Y4AL3/vlFd7ShgJ8ek8pz+Yl7W2LolEShUyKmGctwUNykkXpZ8jr76PsEA9Q3Th5CKTp
	 HPNhQSq6GH3ZUTNlC3iNJqZ80gmPlO12+mm7DTCkXStpYGl1kCucYPrrk4ujSB0dHDcrd
	 gmeaEKDHGn/9ckh332yk7jtSiP/YVdlu/roinzFJT7Am9J4aMk3NQLb/yhJIhNQyNlQ87
	 qn4Rbmz60D0YmKRqKcfyIL5vVUDeTfNQ4/mgwcSSHyfD4G2wj4lTG/P3fHhYkzHh/vzT/
	 F6B0hIjQ/KOQFFAckvX/XCByR7ZxPXBih2Gt9cln9dPYrN0xcOCCAzxpNdcg0unKT/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792829072;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=lx2yJr/GhAwIc6Sl+KPWoW3v8JaOsu2JOs/ThgKaIpg=;
	b=feSvoPjICABmAssT2Dymv5H3Kd+hw89aoJvV2fRMKJI2oDO3bFWkYWDnHCyE7gy6pi4v
	 SZpjCZc8mp9boBsJvggs74aVgFuLoq1v7hdz6u0Xvgf1USyctqdRSy25fkLPe4GeOt8oP
	 aLj4uRlWv51924DzAHylAPqWMw+vjejDgw4EzETI34D2q7KxchPMAMRY/PNwlLZjxHopK
	 kC0DFwjeaTRqqpcqnGuA3CgSy4PFTY3ytb+7nfWj931dfWIx3L4/KkpKVDR0r6rksCr7e
	 efTbaQdSSebs1wDfqeuqgyK7d+dbBG2TtnLC62TNdGwIpNCoUsneY66xc2ltdnMllPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y0wJH1gw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0640B606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y0wJH1gw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2C81F01825;
	Sat, 24 Oct 2026 08:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792829071;
	bh=lx2yJr/GhAwIc6Sl+KPWoW3v8JaOsu2JOs/ThgKaIpg=;
	h=Date:To:From:Subject;
	b=y0wJH1gwbI2u/IWOoPb/dhLEbMy2IhY8UfS63BikaEFIgYhQ9RGX+mM9o/7h2J9W5
	 k5G/Gc+Ijgp3LBxrxT1ko1JAXgU2X08JFODS8CmznYsx25eHVJevBflfed+eRkWHS/
	 6dTv0ObsGoIsh1C2UjtNLY84lcNquCRJUVYQzEb4=
Date: Sat, 24 Oct 2026 01:04:30 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,pfalcato@suse.de,ngocquy0700@gmail.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix.patch removed from -mm tree
Message-Id: <20261024080431.5F2C81F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix.patch

This patch was dropped because it was folded into fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan.patch

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
@@ -3120,7 +3120,7 @@ static long do_pagemap_scan(struct mm_st
 	size_t n_ranges_out = 0;
 	int ret;
 
-	if (!mm || !mmget_not_zero(mm))
+	if (!mmget_not_zero(mm))
 		return -ESRCH;
 
 	ret = pagemap_scan_get_args(&p.arg, uarg);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE83B24501D
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138200; cv=none; b=ZuUlf1N56wbyj5OkiShm2mxqqo2QamnEAlav3tgspYlGsbkVakBn6A3T7ASqGj6P7nOJ9p+nzDeaFedOsvqo6jZQfFu+H3HMq7RQfGta0ymFL0Zi4/BCa081T+HTU4Uy4zNZyGhMudgXFH1G27wtoD20V4vW+yf4YX6I2h3xhLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138200; c=relaxed/simple;
	bh=HTcYymu1PCQe10Vd0qBz/kAOsz8JAflpn3ARzpCmPgQ=;
	h=Date:To:From:Subject:Message-Id; b=PSBKzo5PwGMzjvDZta8EsnOTbJV1qJCLiKBveqUb+g2aGWUZzAWfJ0DIHtt4FtMctjd1Wr8aRdOYK28GhdtXkIk5psxp0PYkLk3Jl8TvVwY5Cd/6Y8eUWIA8pAUYT2QHu5GUIwc5uoaOyraBdq8e56ylbI7Y5uSIveZ4SHJRz+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pPtt1dxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pPtt1dxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D2BC2BCB7;
	Mon, 18 May 2026 21:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779138199;
	bh=HTcYymu1PCQe10Vd0qBz/kAOsz8JAflpn3ARzpCmPgQ=;
	h=Date:To:From:Subject:From;
	b=pPtt1dxKQio899zv/UTfyQ7qwGwOJW0ezZig9rzddJCa5HMoPRipd8NFvZxxhWKhY
	 fWpJGzwPYSE9Rc5PAh6wF6X9dfihNPJIRycRv8Gz2qq2Rl/KWO8zNN4cj20e5XwxMx
	 36HOrDHQSN3IYx5bXbyAstui3lVzT7rMyhjAU0+Y=
Date: Mon, 18 May 2026 14:03:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,akpm@linux-foundation.org,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-slabinfo-remove-dead-assignment-in-get_obj_and_str.patch added to mm-new branch
Message-Id: <20260518210319.95D2BC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/slabinfo: remove dead assignment in get_obj_and_str()
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-slabinfo-remove-dead-assignment-in-get_obj_and_str.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-slabinfo-remove-dead-assignment-in-get_obj_and_str.patch

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
From: Xuewen Wang <wangxuewen@kylinos.cn>
Subject: tools/mm/slabinfo: remove dead assignment in get_obj_and_str()
Date: Mon, 18 May 2026 14:21:58 +0800

The assignment `x = NULL` sets the local parameter variable instead of
`*x`, which is a no-op since `*x` was already set to NULL on the line
above.  Remove the dead assignment.

Link: https://lore.kernel.org/20260518062159.80664-3-wangxuewen@kylinos.cn
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/slabinfo.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/tools/mm/slabinfo.c~tools-mm-slabinfo-remove-dead-assignment-in-get_obj_and_str
+++ a/tools/mm/slabinfo.c
@@ -193,10 +193,9 @@ static unsigned long get_obj_and_str(con
 
 	*x = NULL;
 
-	if (!read_obj(name)) {
-		x = NULL;
+	if (!read_obj(name))
 		return 0;
-	}
+
 	result = strtoul(buffer, &p, 10);
 	while (*p == ' ')
 		p++;
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are

mm-memory-failure-replace-magic-number-3-with-get_page_max_retry_num.patch
tools-mm-slabinfo-fix-trace-disable-logic-inversion.patch
tools-mm-slabinfo-remove-dead-assignment-in-get_obj_and_str.patch
tools-mm-slabinfo-remove-redundant-slab-partial-assignment.patch


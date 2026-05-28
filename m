Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC7A3FE348
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 19:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779995756; cv=none; b=C9DIDEFmedpft9zkihMbfzk/lJaNvGLAhnICuXp7BMZZM1oQEjzNcpL2FFcpLjrZd83rYM3AoclHYOwWqRZbsiMTRDp95G79eYjgvavPDYRBooAlCdrVdx56Djg/nQPFw68bhpplioFggOxBa9ZqAieKp9Nr8S8ecICayqsbiKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779995756; c=relaxed/simple;
	bh=XBrK96i6Oo9kSs8UR+w/9XlrRvd6zxAZPzlHtI32D3g=;
	h=Date:To:From:Subject:Message-Id; b=DL2vbLqrg6A0VnZCOH00Zu6/lkvYo7bokP4TW5RSMW6Bp2vkpKAq/Jvrn5WvhxtHHz9tK84v8VhL1UYj88XzbeBDbCBe0zEpSYXEo1tlsnvwj3GDRRHdRb1daeKP/F/cNtSzOQl3kk2enulM4vvTWW20Pqnb14WPHX9IuCSz8Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JqUzpk7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JqUzpk7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA941F000E9;
	Thu, 28 May 2026 19:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779995755;
	bh=iz6za9ImHgp3oPYNW0UrM4r0T87R5Va6spKeftziJ/c=;
	h=Date:To:From:Subject;
	b=JqUzpk7vZB6+Ja57m3HDCAjvMznhBwwz+kkV80evnzwc/xmDGS2oQQxbXOqQOBsvA
	 tw6W3vDEuJnwqn+RVGy7h8tQ6KqMlCHO8OU2hwVUvPhusHUGPg8cchd1IAiYVI81gX
	 DQG266g826n0JmcDv2TTvKaqsWNegcNvFFZVSgvE=
Date: Thu, 28 May 2026 12:15:54 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,akpm@linux-foundation.org,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-mm-slabinfo-remove-dead-assignment-in-get_obj_and_str.patch removed from -mm tree
Message-Id: <20260528191554.ECA941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/slabinfo: remove dead assignment in get_obj_and_str()
has been removed from the -mm tree.  Its filename was
     tools-mm-slabinfo-remove-dead-assignment-in-get_obj_and_str.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
tools-mm-slabinfo-remove-redundant-slab-partial-assignment.patch


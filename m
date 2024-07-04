Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2448C143C5B
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 23:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720135562; cv=none; b=Xr7G5HPsP0A1BVByQA+lFcZvbKjwsbb6BPX5b2uYklNrWZEewR6E1f5jVNTy7VqCsOOt8PMDQj8QnciHqsVrE0wtSgkZQXOk8Dab9vd8sOUljvp1Ie0FkI0RazzU3QisyQUIuZWIW7qgiSCnXlA9pNvKlZOmDJXX6NSdKrEXy+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720135562; c=relaxed/simple;
	bh=vMUhes+yqmo8V8421IgcR+CBLdljLQum7Glr63Xflz0=;
	h=Date:To:From:Subject:Message-Id; b=oDdHshDHX3w4haS0pnTKYMnnjleHzk0eXntsnhGGh+EOtnxCP5+cIt0ugQsUzIVt0bX1yUSWQFkU5mQp0/RZmxXD5fUMQhBbE4+9/pbz1lI/49UMs55JiVdeDzI/1s2H0Tz4RGZjFgZs3gytlUyS6aqEkj+wepjjwBwemtORmKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sSuR1sAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sSuR1sAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A719C4AF0C;
	Thu,  4 Jul 2024 23:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720135561;
	bh=vMUhes+yqmo8V8421IgcR+CBLdljLQum7Glr63Xflz0=;
	h=Date:To:From:Subject:From;
	b=sSuR1sAKFj5KJPcNaxs5g0TUo+i+thl5UVA4mBXx/PcscU0E0qwK2ZLGRKDaPUcms
	 lruC2AL0IQSBK/Au7cmzfDSry7ti/nW4sUZhIPmW757KZNlQlUVCzTgAGLP1OgRyvP
	 XWhJef6jXyNNomJrpU16g2SAp9ql/sjattqztYEk=
Date: Thu, 04 Jul 2024 16:26:00 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,qirui.001@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-allow-memory-allocation-from-emergency-reserves.patch removed from -mm tree
Message-Id: <20240704232601.9A719C4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: allow memory allocation from emergency reserves
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-allow-memory-allocation-from-emergency-reserves.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rui Qi <qirui.001@bytedance.com>
Subject: mm/memory-failure: allow memory allocation from emergency reserves
Date: Tue, 25 Jun 2024 10:23:42 +0800

We hope that memory errors can be successfully handled quickly, using
__GFP_MEMALLOC can help us improve the success rate of processing under
memory pressure, because to_kill struct is freed very quickly, so using
__GFP_MEMALLOC will not exacerbate memory pressure for a long time, and
more memory will be freed after killed task exiting, which will also
reduce memory pressure.

Link: https://lkml.kernel.org/r/20240625022342.6158-1-qirui.001@bytedance.com
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-allow-memory-allocation-from-emergency-reserves
+++ a/mm/memory-failure.c
@@ -440,7 +440,7 @@ static void __add_to_kill(struct task_st
 {
 	struct to_kill *tk;
 
-	tk = kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
+	tk = kmalloc(sizeof(struct to_kill), GFP_ATOMIC | __GFP_MEMALLOC);
 	if (!tk) {
 		pr_err("Out of memory while machine check handling\n");
 		return;
@@ -1920,7 +1920,7 @@ static int folio_set_hugetlb_hwpoison(st
 			return -EHWPOISON;
 	}
 
-	raw_hwp = kmalloc(sizeof(struct raw_hwp_page), GFP_ATOMIC);
+	raw_hwp = kmalloc(sizeof(struct raw_hwp_page), GFP_ATOMIC | __GFP_MEMALLOC);
 	if (raw_hwp) {
 		raw_hwp->page = page;
 		llist_add(&raw_hwp->node, head);
_

Patches currently in -mm which might be from qirui.001@bytedance.com are



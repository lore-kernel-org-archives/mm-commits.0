Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F2220FAA9
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188523; cv=none; b=D+bQ9zb4VBQxFnTbNP7OK0nzFosXc0VQR06vyrzUtCS8776CBugXPP+5vQsyg9UndV8S/wCR0R4lX2pzSjrf0TijPJTaM8DcU1Dp9SUPDl6bosQv3V+5CCQvw4kyaXID0ywIIPEu47MUx+uNXp/0lmOdxbpm5XodySpC3dLhEPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188523; c=relaxed/simple;
	bh=mMR3uuhyMzhz7eB7LOql58yWhIX5Z7INrh8oA1p8dYQ=;
	h=Date:To:From:Subject:Message-Id; b=DEHmostXHhiQFsVFLMQmLppjcft6zcW9MrLufTbkiwv6imjTTZ+e7iwDJRWOn9xKqmDWz/i6hgx12i4uJj1UpyPyQM9DSrqogzcWb30AiABxsKsLphdXWW9tpEFTgpOESgTfY1Qe1c44ZkHspvke2rp1ZMkbzYf0TnpJmjBIjAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WsXd7i2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WsXd7i2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB6AC4CEEC;
	Mon, 17 Mar 2025 05:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188523;
	bh=mMR3uuhyMzhz7eB7LOql58yWhIX5Z7INrh8oA1p8dYQ=;
	h=Date:To:From:Subject:From;
	b=WsXd7i2tHMvVzv9FOBa/9wf3zt+BT3PTBTlzHHkzrOfHiwas2RO/fEJ3is4Q/yQ+n
	 GxNcHIyRaQM88xARwa7sohAFgbykR4vjUJD8NGYgi4UOiKW/FJxMCBvYn1hK2w70ZY
	 +skX62Ru4ha+mGnv3RAC15RiDtc/bpxhsval0szU=
Date: Sun, 16 Mar 2025 22:15:22 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] page_counter-reduce-struct-page_counter-size.patch removed from -mm tree
Message-Id: <20250317051523.5BB6AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: page_counter: reduce struct page_counter size
has been removed from the -mm tree.  Its filename was
     page_counter-reduce-struct-page_counter-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: page_counter: reduce struct page_counter size
Date: Thu, 27 Feb 2025 23:58:08 -0800

The struct page_counter has explicit padding for better cache alignment. 
The commit c6f53ed8f213a ("mm, memcg: cg2 memory{.swap,}.peak write
handlers") added a field to the struct page_counter and accidently
increased its size.  Let's move the failcnt field which is v1-only field
to the same cacheline of usage to reduce the size of struct page_counter.

Link: https://lkml.kernel.org/r/20250228075808.207484-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/page_counter.h~page_counter-reduce-struct-page_counter-size
+++ a/include/linux/page_counter.h
@@ -9,10 +9,12 @@
 
 struct page_counter {
 	/*
-	 * Make sure 'usage' does not share cacheline with any other field. The
-	 * memcg->memory.usage is a hot member of struct mem_cgroup.
+	 * Make sure 'usage' does not share cacheline with any other field in
+	 * v2. The memcg->memory.usage is a hot member of struct mem_cgroup.
 	 */
 	atomic_long_t usage;
+	unsigned long failcnt; /* v1-only field */
+
 	CACHELINE_PADDING(_pad1_);
 
 	/* effective memory.min and memory.min usage tracking */
@@ -28,7 +30,6 @@ struct page_counter {
 	unsigned long watermark;
 	/* Latest cg2 reset watermark */
 	unsigned long local_watermark;
-	unsigned long failcnt; /* v1-only field */
 
 	/* Keep all the read most fields in a separete cacheline. */
 	CACHELINE_PADDING(_pad2_);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-add-hierarchical-effective-limits-for-v2.patch
memcg-avoid-refill_stock-for-root-memcg.patch
memcg-move-do_memsw_account-to-config_memcg_v1.patch


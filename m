Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794938125;
	b=XnJ5SnGyL0KXs6Hx7Vng+E+UK/qMOM6A9CbNCgFre028QOKGEI1qGwXkztPTgpZp2MBR
	 afIZZkK0NsY5iIqAXt0EoaMZQXIIBry9m8A/eWuFDDatgbrnadBdPhiJAvFFZLbvQs2QG
	 37YQaq02jqWsuIb2wSHnb9xB/RPx94JTgDn3KG5mPwVxiWPg4e1ZHATWUEgI+aZdoTiLX
	 jx3cVjZtBnmF7yyO8WsbSu/dQmz+fgRPVxx7kh0WKw8OLQEv7w4zEq/ovRqe4TrLU3YcO
	 Y4QXfAggDz2awtMK5udjQx0SZOEeD2eBuCpXqRkb354o6bVNNSKl16O3RRSimkqPw7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794938125;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=TTGTC9cNmr7BCuf/GNDrKLlhGp4KyLO16hKeIxdYkd0=;
	b=YXdcCNdbLcppNwBp63x5BuV3MbSiLtMKDCmgGNK2fww59RyEEDvbw87xdHfHN+r9yWJd
	 CJE5Lc3FEkbLikyOksuWnvz9Kd7DU+t8YVOUWc6YdHoOE+KxgaETo7XFs2EPJFLFoqdC5
	 XLJ/r6ELE5M8+96HmJ6APPM7O2H2qNF4vb3ncpxa0nb7NvRouYUZsLzjyy2C2kMG1dZTJ
	 JXEoF3c/EZYUMxQXL3h978Q95p+/QJMahXMGqGerZ6UvGsYZkdFl5oLv33iPY9Z7OgpWf
	 SOx1UWsPeNko48iopW4tENU0eBTAdp6GCk3rR7Bb7Y9hb0wqo6n8xzh+/TX2oZTT7YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OOmIY3B+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F12606A31C
	for <mm-commits@vger.kernel.org>; Tue, 17 Nov 2026 17:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OOmIY3B+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00141F000C4;
	Tue, 17 Nov 2026 17:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794938125;
	bh=TTGTC9cNmr7BCuf/GNDrKLlhGp4KyLO16hKeIxdYkd0=;
	h=Date:To:From:Subject;
	b=OOmIY3B+B6HlO9d1LCQc1y+RfY6nA08XXjzRPHyAdPID6ujfS8FRQilGYF/luR8dr
	 IxmROKTXxYENYJSoOpPycufsfN7fMOO1FTnOYewc+JLFNuQ0wV1MZK8CVRSYagqXPO
	 8JQpC5Xox9ss3hr65di6kQFfViJiRlkBPTSBBgU8=
Date: Tue, 17 Nov 2026 09:55:24 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,
	ahuang12@lenovo.com,adrianhuang0701@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fs-proc-task_mmu-advance-seq_file-position-on-interrupted-vma-lookup.patch removed from -mm tree
Message-Id: <20261117175524.E00141F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fs/proc/task_mmu: advance seq_file position on interrupted VMA lookup
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-advance-seq_file-position-on-interrupted-vma-lookup.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: fs/proc/task_mmu: advance seq_file position on interrupted VMA lookup
Date: Thu, 12 Nov 2026 22:01:01 +0800

Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma
lock") introduced the possibility of returning -EINTR from proc_get_vma()
when the VMA lookup is interrupted.

When this happens in m_next(), proc_get_vma() returns an error pointer
without updating the position index.  Consequently, seq_read_iter()
reports:

  seq_file: buggy .next function m_next did not update position index

The above buggy message is reproduced by the following command:

  # stress-ng --vma 0 -t 60

Update the position index when VMA lookup fails, as required by the
seq_file interface.  Also save the original position in priv->last_pos so
that subsequent iteration can restart from the correct address without
skipping or repeating a VMA.

Link: https://lore.kernel.org/20261112140101.647-1-adrianhuang0701@gmail.com
Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Adrian Huang <ahuang12@lenovo.com>

 fs/proc/task_mmu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-advance-seq_file-position-on-interrupted-vma-lookup
+++ a/fs/proc/task_mmu.c
@@ -221,6 +221,16 @@ retry:
 		if (PTR_ERR(vma) == -EAGAIN && fallback_to_mmap_lock(priv, *ppos))
 			goto retry;
 
+		/*
+		 * seq_file checks that the position advanced before it looks at
+		 * the returned pointer, so an error return that leaves *ppos
+		 * alone is reported as a buggy ->next. Advance it, and keep
+		 * last_pos at the pending position so m_start() would resume
+		 * the lookup from there.
+		 */
+		priv->last_pos = *ppos;
+		(*ppos)++;
+
 		return vma;
 	}
 
_

Patches currently in -mm which might be from adrianhuang0701@gmail.com are

mm-damon-core-remove-unnecessary-zero-initialization-in-damon_new_ctx.patch
docs-admin-guide-mm-damon-fix-various-typos.patch
docs-admin-guide-mm-damon-lru_sort-fix-copy-paste-mistakes.patch
docs-admin-guide-mm-damon-usage-fix-incorrect-option-syntax-in-perf-example.patch


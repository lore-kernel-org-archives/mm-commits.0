Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3B7230BE9
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 19:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783454019; cv=none; b=cydlZbDuQNttuHK+h2WG80hlnOF1sP5miL/PeTMzdyY7mYYkzXrEdhNhSJmzHLokwviDCU2+k94E85ZRb8xT2ygg6XhCtUMmumC+Vax9XOIrRmFUjkyRHHvHLWoX9sFjjd7BObJQJPxpQM+IZxcpZ4ImZOuR9nr9MMD9rQcHS9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783454019; c=relaxed/simple;
	bh=dCrH16ouTobB3ID8aj9IfetXcQZKs8TrvEkcfZmjGDw=;
	h=Date:To:From:Subject:Message-Id; b=R9oHXkhhh0a9gB9dS/BaOpRWe6b8yUBAAn02eYqm6O2Rw/+cnwaJhgTt7ni6sVm2KWGFkv4LjTLLUMNyn2me4mvxV0tchavky/ZfqfRkwZtvP51WBcApJMYMP/5iJz2DdERu+2KSramOmMq9pCcdRnyVyWBqyw9OoyXYx/Ui1Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ok7VcvB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ok7VcvB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DE41F000E9;
	Tue,  7 Jul 2026 19:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783454018;
	bh=wt1//u5i4o5mUj4Y1OPz0ppw3mNtRm6ippTr515JGhk=;
	h=Date:To:From:Subject;
	b=ok7VcvB3b68/oqUUtxSniNeJyX+LPTPaUY5jVXJ6vq+BjwIlYPgyf4Vhai/DmdKoa
	 A66ivNU2XCpScjS9yaCk/TI1Ip21xeb4HoyA/xhs/bFpqdi4a+i00+qhdRBXWlVS2b
	 wCullPXjb3Y7/ISX8S/kt9Lqlt22wKq9k8QxTfBY=
Date: Tue, 07 Jul 2026 12:53:37 -0700
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch removed from -mm tree
Message-Id: <20260707195337.E7DE41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix
Date: Tue Jun 30 10:52:22 PM PDT 2026

fix page_owner.c

Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix
+++ a/mm/page_owner.c
@@ -819,7 +819,7 @@ read_page_owner(struct file *file, char
 				spin_unlock_irqrestore(&state->lock, flags);
 				goto ext_put_continue;
 			}
-			nid = memdesc_nid(page_flags);
+			nid = memdesc_nid(&page_flags);
 			if (!node_isset(nid, state->nid_filter)) {
 				spin_unlock_irqrestore(&state->lock, flags);
 				goto ext_put_continue;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch


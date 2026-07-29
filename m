Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850F8280331
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297396; cv=none; b=aa+Gcc5q9ydKkXMKN2ui9cxmvmKHi+yVb+DeJhB8ga51abJVpEgqn5imafjWUgH6Wv/y7laePAjRCwjZCbxmYxs0/b3BSiuvT9QdsHBfZuEkAPMvJoUhYQTgKJNhjqov27P10CPyPEdqlyZy002hmSiH+negI+yTOlC+ZmRBaWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297396; c=relaxed/simple;
	bh=aG+IWt1yywbao7LD+3KxvS48S3TvK8zNSjAPoAw3aB0=;
	h=Date:To:From:Subject:Message-Id; b=dyjL2HmFb6CZXrhEX7ova3QVtu8JMi4Rle6syTXLBwRecU/YJXu2FiEQg+ZjcBktL43HU/ypfVEvXEj3NeToswb9POGU0NjDuaHigZ3/unpabugQZhzNX3NV89aCGEkxGkCOGdvy4JgGqkJ/ptspo6vnFd7am2YGSFp02bnl+94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p/+DjxO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p/+DjxO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A7A1F000E9;
	Wed, 29 Jul 2026 03:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297395;
	bh=5xZ6C1FLEYo9ZDO//mg4rM5BJlRR2yRMt5+OoeJLXJ8=;
	h=Date:To:From:Subject;
	b=p/+DjxO5QY2H1ErreBWUT1B7S+riKiBgNgWLKeQzfZYJIfF2palTQPXvTlYoLAj7R
	 hJc1yzy1n+qFIJ/kcejyJ3driwg6bVhh7eigbgx9GDnnSIDaBv0SDedtvMxw+5i3WI
	 VgtgA/aTCgNZkL2vbLqLKLErflTaqKKxohfLv8KQ=
Date: Tue, 28 Jul 2026 20:56:34 -0700
To: mm-commits@vger.kernel.org,zhen.ni@easystack.cn,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix-2.patch removed from -mm tree
Message-Id: <20260729035635.11A7A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_owner-add-numa-node-filter-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix-2.patch

This patch was dropped because it was folded into mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer.patch

------------------------------------------------------
From: "Zi Yan" <ziy@nvidia.com>
Subject: mm-page_owner-add-numa-node-filter-fix
Date: Tue, 07 Jul 2026 11:54:37 -0400

build fix

Link: https://lore.kernel.org/DJSGLP9VFLRI.355AAWR2VHIEL@nvidia.com
Signed-off-by: "Zi Yan" <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix-2
+++ a/mm/page_owner.c
@@ -815,7 +815,7 @@ read_page_owner(struct file *file, char
 			 */
 			if (page_flags.f == PAGE_POISON_PATTERN)
 				goto ext_put_continue;
-			nid = memdesc_nid(page_flags);
+			nid = memdesc_nid(&page_flags);
 			if (!node_isset(nid, state->nid_filter))
 				goto ext_put_continue;
 		}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer.patch
mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch


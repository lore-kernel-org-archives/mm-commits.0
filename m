Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D2013D52B
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854767; cv=none; b=SgbincpaB61e8k3MfZgjzSxaYFGof0F+KX7WfBPxBx3RvmvPNQYdUKJgGCH8SP3bZsQb6srg31AlUOpR9OrSq+A+yBhqXGC0YCPXpu+5BgwDgEpf2AH0nHQ7vznKXTieerwtt4ZVSZmmLQDF5n72pvljrQtbZzh2qMB8npzqs2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854767; c=relaxed/simple;
	bh=QWIIX3LxKcjcnxDRmdIKj75HhwsA1lE7RwNi2tevTYQ=;
	h=Date:To:From:Subject:Message-Id; b=bvvQhQKePURXQNWOro7JMWW8vHb98a3bCrHH0wVRmjh14LfiJqX9lcQeZkKytsjez9W83f8NU0hXR9wFIAkN01lwbCaRwkULgG09C373lOaAJqvk8Eup6eugh2tiEasZk4D9qXwh51Pa0nNROq0MNFQxHIwjKhjmzHGs1ckK6k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RYqLLQd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RYqLLQd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0CAC4CECF;
	Wed,  6 Nov 2024 00:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854766;
	bh=QWIIX3LxKcjcnxDRmdIKj75HhwsA1lE7RwNi2tevTYQ=;
	h=Date:To:From:Subject:From;
	b=RYqLLQd/r9hULme/Pd6P+d0G9bpAp8uNALHhysFiDVp4Qi5SFfO8C9Q2lIvrcfOw8
	 XaPbP5d9ze+wZwolX0KpX9uQfw7rl/V3FNH374s454a2rVrhqJuUE9nCNNgJtNah60
	 JANJ4L7REB7cHVgrenmxO9Gw9ucdh2W+0JRnq9GY=
Date: Tue, 05 Nov 2024 16:59:26 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch removed from -mm tree
Message-Id: <20241106005926.BE0CAC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/truncate: reset xa_has_values flag on each iteration
has been removed from the -mm tree.  Its filename was
     mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm/truncate: reset xa_has_values flag on each iteration
Date: Wed, 2 Oct 2024 15:51:50 -0700

Currently mapping_try_invalidate() and invalidate_inode_pages2_range()
traverses the xarray in batches and then for each batch, maintains and
sets the flag named xa_has_values if the batch has a shadow entry to clear
the entries at the end of the iteration.

However they forgot to reset the flag at the end of the iteration which
causes them to always try to clear the shadow entries in the subsequent
iterations where there might not be any shadow entries.

Fix this inefficiency.

Link: https://lkml.kernel.org/r/20241002225150.2334504-1-shakeel.butt@linux.dev
Fixes: 61c663e020d2 ("mm/truncate: batch-clear shadow entries")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/truncate.c~mm-truncate-reset-xa_has_values-flag-on-each-iteration
+++ a/mm/truncate.c
@@ -463,10 +463,10 @@ unsigned long mapping_try_invalidate(str
 	unsigned long ret;
 	unsigned long count = 0;
 	int i;
-	bool xa_has_values = false;
 
 	folio_batch_init(&fbatch);
 	while (find_lock_entries(mapping, &index, end, &fbatch, indices)) {
+		bool xa_has_values = false;
 		int nr = folio_batch_count(&fbatch);
 
 		for (i = 0; i < nr; i++) {
@@ -592,7 +592,6 @@ int invalidate_inode_pages2_range(struct
 	int ret = 0;
 	int ret2 = 0;
 	int did_range_unmap = 0;
-	bool xa_has_values = false;
 
 	if (mapping_empty(mapping))
 		return 0;
@@ -600,6 +599,7 @@ int invalidate_inode_pages2_range(struct
 	folio_batch_init(&fbatch);
 	index = start;
 	while (find_get_entries(mapping, &index, end, &fbatch, indices)) {
+		bool xa_has_values = false;
 		int nr = folio_batch_count(&fbatch);
 
 		for (i = 0; i < nr; i++) {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are



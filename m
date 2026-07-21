Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DD93EDE63;
	Tue, 21 Jul 2026 00:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784594620; cv=none; b=eERbqkPlc/6p4GPDUKJDtK5rXhI2h6X4GzLzMgSHA9u1Bht38TM0jopTgaiR//Q/9nN/VQqA7T90nkeSuZFpB1ZHDi+i7yUYFYa+nE3kCqJBtij5/p7Yf50XLlSWXSKAzwYJ/nDHCmPIz3Qb6Lqdxhyy2HKYVCoLYOEVywqU0ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784594620; c=relaxed/simple;
	bh=lp9zYcv7UmilwVsv0YRgUU2ZWIEHOwk0J+tVtw3CjUE=;
	h=Date:To:From:Subject:Message-Id; b=bHXvylvh5lfiEHKZjn/cpDJamiBygoBgG+YYnyUE/CsvZrpP1gEZCdvPdpC+2wsqjM7DSpu5BxWtbcvx+q45ClGdDMFhi5uIvmmfFAX02PYH36qNVcl47QSFXY6jvKP69Kb97G2YBaYl1Gxu0fYOKz3YeuVvfUfSQFkgiOdUA3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nkjAYht2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nkjAYht2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70D51F00A3A;
	Tue, 21 Jul 2026 00:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784594618;
	bh=0WA1uKHUtGYOvw6AG7WjUactfBNlQFWL89JV3czgDrg=;
	h=Date:To:From:Subject;
	b=nkjAYht2BJVTlxqMUwL2w7fEIlvJvPZ9zIl5kBOe3SaA/89zHlcXH67Q8e3c26//v
	 LK0wDnv1fNf65l9D4SToZcuTUNwB9DUQE6wq6JGX7b/HhGjD+3M3045Z2eDJXX/vfC
	 b9xuWR82LdzwLL7+7++faF2291IQjWz82QQlargI=
Date: Mon, 20 Jul 2026 17:43:38 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,dennis@kernel.org,cl@linux.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-percpu-km-fix-bitmap-overflow-and-accounting-in-pcpu_create_chunk.patch removed from -mm tree
Message-Id: <20260721004338.B70D51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()
has been removed from the -mm tree.  Its filename was
     mm-percpu-km-fix-bitmap-overflow-and-accounting-in-pcpu_create_chunk.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()
Date: Thu, 09 Jul 2026 15:12:01 -0400

In pcpu_create_chunk(), nr_pages is the total contiguous backing
allocation, i.e., nr_units * pcpu_unit_pages, but pcpu_chunk_populated()
uses it to set chunk->populated, whose size is pcpu_unit_pages, bitmap. 
Since bit N in chunk->populated means page offset N inside every unit is
backed.  When nr_units > 1, the function writes beyond chunk->populated. 
Fix it by using chunk->nr_pages.

It also fixes the global pcpu_nr_empty_pop_pages accounting, since
pcpu_balance_free() only iterates up to chunk->nr_pages.

Commit a63d4ac4ab609 ("percpu: make percpu-km set chunk->populated bitmap
properly") introduced the bitmap overflow issue.  Later, commit
b539b87fed37f ("percpu: implmeent pcpu_nr_empty_pop_pages and
chunk->nr_populated") added pcpu_nr_empty_pop_pages and caused the
accounting issue.

Link: https://lore.kernel.org/20260709-fix-pcpu_create_chunk-in-percpu-km-v1-1-1f64745a84cc@nvidia.com
Fixes: a63d4ac4ab609 ("percpu: make percpu-km set chunk->populated bitmap properly")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6%40nvidia.com?part=1
Assisted-by: Codex:GPT-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-km.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu-km.c~mm-percpu-km-fix-bitmap-overflow-and-accounting-in-pcpu_create_chunk
+++ a/mm/percpu-km.c
@@ -75,7 +75,7 @@ static struct pcpu_chunk *pcpu_create_ch
 	chunk->base_addr = page_address(pages);
 
 	spin_lock_irqsave(&pcpu_lock, flags);
-	pcpu_chunk_populated(chunk, 0, nr_pages);
+	pcpu_chunk_populated(chunk, 0, chunk->nr_pages);
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
 	pcpu_stats_chunk_alloc();
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_owner-add-numa-node-filter-fix.patch
mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch


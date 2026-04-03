Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD3E34D91F
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198541; cv=none; b=izTrjo9JSf/91nlVQFagOiXR/iqfQvl4m/D0vw6rHBLnLquY+XJtedhmMqrZRtC6iCuKss4USUOm9i5rInX3XypXuDR0DJFZVZHzi8lXpjilN3hc0wa5jxhg8pZtVkgMqx4f87yXMsOaimrIUcYP6IUWuAROr6dq7i0bS/b1RO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198541; c=relaxed/simple;
	bh=5JUZKmNPazI+KS3JSZlU4F/kXinzDmeGb5/Z8S3lqIY=;
	h=Date:To:From:Subject:Message-Id; b=OHoUFA7STQTpOQm/0ODjJDrHfSD94iA5LJ0MqGTtwTxrBsuoEMB6U7QBjPo9xfJNIXdEGzT7emGUlepmkKaXtzo8CJ4vdSD3wq2GbFJCZF7LWnDDX4SoA4vXmLAX1mZtd4pT5w3OuSFAcBD5y7kO3uY2BgOcmTwTiR+DjSSflsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ViUsg10W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ViUsg10W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD73C4CEF7;
	Fri,  3 Apr 2026 06:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198541;
	bh=5JUZKmNPazI+KS3JSZlU4F/kXinzDmeGb5/Z8S3lqIY=;
	h=Date:To:From:Subject:From;
	b=ViUsg10WjGjTzwAZD7AaD4gXrTkiu9+3tJQrM55Y9LxN8TnH8JiGwpdOi7DxvDZZK
	 OVotxwiDJ2SBBHJoRnjpNNbZYiq+FYObT6XZiyE3h0++8OKbzboLY6rnPSRf8VTHEf
	 6ARXDCCGKb9Nlw7LS5BqMB0L5MoOcCjITyot0eHU=
Date: Thu, 02 Apr 2026 23:42:20 -0700
To: mm-commits@vger.kernel.org,richard@nod.at,marscheng@google.com,jserv@ccns.ncku.edu.tw,hch@infradead.org,eleanor15x@gmail.com,chengzhihao1@huawei.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ubifs-remove-unnecessary-cond_resched-from-list_sort-compare.patch removed from -mm tree
Message-Id: <20260403064221.0AD73C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ubifs: remove unnecessary cond_resched() from list_sort() compare
has been removed from the -mm tree.  Its filename was
     ubifs-remove-unnecessary-cond_resched-from-list_sort-compare.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: ubifs: remove unnecessary cond_resched() from list_sort() compare
Date: Fri, 20 Mar 2026 18:09:37 +0000

Patch series "lib/list_sort: Clean up list_sort() scheduling workarounds",
v3.

Historically, list_sort() included a hack in merge_final() that
periodically invoked dummy cmp(priv, b, b) calls when merging highly
unbalanced lists.  This allowed the caller to invoke cond_resched() within
their comparison callbacks to avoid soft lockups.  

However, an audit of the kernel tree shows that fs/ubifs/ has been the
sole user of this mechanism.  For all other generic list_sort() users,
this results in wasted function calls and unnecessary overhead in a tight
loop.

Recent discussions and code inspection confirmed that the lists being
sorted in UBIFS are bounded in size (a few thousand elements at most), and
the comparison functions are extremely lightweight.  Therefore, UBIFS does
not actually need to rely on this mechanism.


This patch (of 2):

Historically, UBIFS embedded cond_resched() calls inside its list_sort()
comparison callbacks (data_nodes_cmp, nondata_nodes_cmp, and
replay_entries_cmp) to prevent soft lockups when sorting long lists.

However, further inspection by Richard Weinberger reveals that these
compare functions are extremely lightweight and do not perform any
blocking MTD I/O. Furthermore, the lists being sorted are strictly
bounded in size:
- In the GC case, the list contains at most the number of nodes that
  fit into a single LEB.
- In the replay case, the list spans across a few LEBs from the UBIFS
  journal, amounting to at most a few thousand elements.

Since the compare functions are called a few thousand times at most, the
overhead of frequent scheduling points is unjustified.  Removing the
cond_resched() calls simplifies the comparison logic and reduces
unnecessary context switch checks during the sort.

Link: https://lkml.kernel.org/r/20260320180938.1827148-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20260320180938.1827148-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Acked-by: Richard Weinberger <richard@nod.at>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mars Cheng <marscheng@google.com>
Cc: Yu-Chun Lin <eleanor15x@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/gc.c     |    2 --
 fs/ubifs/replay.c |    1 -
 2 files changed, 3 deletions(-)

--- a/fs/ubifs/gc.c~ubifs-remove-unnecessary-cond_resched-from-list_sort-compare
+++ a/fs/ubifs/gc.c
@@ -109,7 +109,6 @@ static int data_nodes_cmp(void *priv, co
 	struct ubifs_info *c = priv;
 	struct ubifs_scan_node *sa, *sb;
 
-	cond_resched();
 	if (a == b)
 		return 0;
 
@@ -153,7 +152,6 @@ static int nondata_nodes_cmp(void *priv,
 	struct ubifs_info *c = priv;
 	struct ubifs_scan_node *sa, *sb;
 
-	cond_resched();
 	if (a == b)
 		return 0;
 
--- a/fs/ubifs/replay.c~ubifs-remove-unnecessary-cond_resched-from-list_sort-compare
+++ a/fs/ubifs/replay.c
@@ -305,7 +305,6 @@ static int replay_entries_cmp(void *priv
 	struct ubifs_info *c = priv;
 	struct replay_entry *ra, *rb;
 
-	cond_resched();
 	if (a == b)
 		return 0;
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are



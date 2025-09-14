Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A9C39FD9
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810096; cv=none; b=VTu1IgczYQYKCN5sBemewvehb9WNLFi7wO8KqznBzsMGVfMCp5zi+IV4UvfcGETrgaGz7w2M+g6itCPA5kyB/pVoO+CZxtqcve5pdMQEzjRQ97Fp3iOhEoK0EfHpWchGvPDyZaj+5ltOzHYbSltXWHKw3DzqhOt+BWWR5/Qa2xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810096; c=relaxed/simple;
	bh=vfXmge4Y98zLst3NQdfnhAb2/S2/PhfCewczoXSDGvQ=;
	h=Date:To:From:Subject:Message-Id; b=mbdybSoef4a0tZj24Hbfp+eLkYJ58dWx+PF4hfrDaeGos06Vn/dhVZ3cUmhifohhsBArbVb5DYOWUOg/fWsD/OFzQgN52jZNO+hz49YH4s+FP6ySyZotwexciLwftZLlO+VLfJMzvTtRg+yvMRGRy5oioFjjtlcnlvkCSFmW6R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bou72ylE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bou72ylE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55099C4CEEB;
	Sun, 14 Sep 2025 00:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810095;
	bh=vfXmge4Y98zLst3NQdfnhAb2/S2/PhfCewczoXSDGvQ=;
	h=Date:To:From:Subject:From;
	b=Bou72ylEt19wOtI8t0xg39qES7rB34HtAiT+MibMM0ZdIyAGMp1A4VrjAs1fqN3Vt
	 hAUSPbEldJU6AMJlqE2LbtgvYlOszv/Pv8stU/33RN+LX0X5q3m4LNj/Ku7AlIjfBU
	 /UFlw8+/fW55twazsT6+LLf+S5OKQ/9P8io1153A=
Date: Sat, 13 Sep 2025 17:34:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,rongqianfeng@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ref_tracker-remove-redundant-__gfp_nowarn.patch removed from -mm tree
Message-Id: <20250914003455.55099C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ref_tracker: remove redundant __GFP_NOWARN
has been removed from the -mm tree.  Its filename was
     ref_tracker-remove-redundant-__gfp_nowarn.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: ref_tracker: remove redundant __GFP_NOWARN
Date: Tue, 5 Aug 2025 10:30:31 +0800

Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
GFP_NOWAIT implicitly include __GFP_NOWARN.

Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
`GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
redundant flags across subsystems.

No functional changes.

Link: https://lkml.kernel.org/r/20250805023031.331718-1-rongqianfeng@vivo.com
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ref_tracker.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/ref_tracker.c~ref_tracker-remove-redundant-__gfp_nowarn
+++ a/lib/ref_tracker.c
@@ -75,7 +75,7 @@ ref_tracker_get_stats(struct ref_tracker
 	struct ref_tracker *tracker;
 
 	stats = kmalloc(struct_size(stats, stacks, limit),
-			GFP_NOWAIT | __GFP_NOWARN);
+			GFP_NOWAIT);
 	if (!stats)
 		return ERR_PTR(-ENOMEM);
 	stats->total = 0;
@@ -159,7 +159,7 @@ __ref_tracker_dir_pr_ostream(struct ref_
 		return;
 	}
 
-	sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT | __GFP_NOWARN);
+	sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT);
 
 	for (i = 0, skipped = stats->total; i < stats->count; ++i) {
 		stack = stats->stacks[i].stack_handle;
@@ -306,7 +306,7 @@ int ref_tracker_free(struct ref_tracker_
 	}
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
 	stack_handle = stack_depot_save(entries, nr_entries,
-					GFP_NOWAIT | __GFP_NOWARN);
+					GFP_NOWAIT);
 
 	spin_lock_irqsave(&dir->lock, flags);
 	if (tracker->dead) {
_

Patches currently in -mm which might be from rongqianfeng@vivo.com are



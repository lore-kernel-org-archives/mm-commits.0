Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4218E19F420
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 02:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754447636; cv=none; b=C9SY++VbB3GxqgfW9E/g0SrgHhjkY4ycxc+QiWTPy/ApOT4/LNhRuGLLCa9qGBTG5SBCgiz//B4auOcpx5q76VJs9qncw3V1hn99TG8goTIUhZY1Q21TM+El7TF5JKVzMEeEcVtWxZR5whTP9GJQEdXGuHzR5LyqrnbQsIQP3gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754447636; c=relaxed/simple;
	bh=Ul/ga3/j0Ay01fK3Y089AF55+FHUZUBrquSL75DDSvw=;
	h=Date:To:From:Subject:Message-Id; b=FRqDACBsaWSgDbwQbsjGJ/UgEjLdlPWGG7IZpqVSzREHmuhL+PtBOYAvhFUdW6tvUE1PsQ/xT0iAqrPxjUBUVSeIeyHWTCpHPvW3e40yiUawW236dsoLrqUmeJPUOGVWHYlVQWFDrFCUODK9yHj2bB8aLzUvXUKgaKqlzG6qKRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NeoPMblt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NeoPMblt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C561BC4CEF0;
	Wed,  6 Aug 2025 02:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754447635;
	bh=Ul/ga3/j0Ay01fK3Y089AF55+FHUZUBrquSL75DDSvw=;
	h=Date:To:From:Subject:From;
	b=NeoPMbltLDhV0AjHIqHFkQ/CoIdBP0TDx/7XO4fUBWlw88X/fAtn97SVuV7a2/V7M
	 Um2Dp3HwVrGwKB4h7mUCs+ByTTgeTt++XDW0++vnwSKTkUrxcOPqylZ2/w6bUzQdYC
	 rBNZhBe5Y6rh8pfcRVON6pMsvS/RHgkhbWUw0h0c=
Date: Tue, 05 Aug 2025 19:33:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,rongqianfeng@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ref_tracker-remove-redundant-__gfp_nowarn.patch added to mm-nonmm-unstable branch
Message-Id: <20250806023355.C561BC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ref_tracker: remove redundant __GFP_NOWARN
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ref_tracker-remove-redundant-__gfp_nowarn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ref_tracker-remove-redundant-__gfp_nowarn.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

ref_tracker-remove-redundant-__gfp_nowarn.patch


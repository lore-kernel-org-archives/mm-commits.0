Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E1126E70E
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 01:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779153409; cv=none; b=VHpZKMtGGDFKJk+F66+cWIWFO0PFCrldJS4ccRbbu6j6iFYsRjfdp5VI08P6h/BBrOVef4pbUxrJFPOJEsRP6/HZvHiP4Omo4osvIu6KHzwC/pduXuUlFxb6v8lxZO56lOKs/P5hrksFpXr13lyhRAur30CkMQNKE0K9d+ar7Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779153409; c=relaxed/simple;
	bh=Z7ZdULv6k2v90ssIByLYa9UxHC4AMBpfesoW5hy02jw=;
	h=Date:To:From:Subject:Message-Id; b=DVhILN6K4fgLXgZNRxHQrC4vlaskw8GwRNKcD651HvivbgFmDSrLbXcww/1G9zGM2R90GvolDJJBGGLuqYhEWtDvIzlPZu36Al7ipOwWxxxIEeRNg78QRR3zOlhABn5V2M9MVtUnF7T8+i7b+QWX8v+GfGh4NoNdS1f3YW7QMII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RjAiCFd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RjAiCFd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0EDC2BCB7;
	Tue, 19 May 2026 01:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779153408;
	bh=Z7ZdULv6k2v90ssIByLYa9UxHC4AMBpfesoW5hy02jw=;
	h=Date:To:From:Subject:From;
	b=RjAiCFd3QtuUPmCyTAyBonSoJ3U5MLxabFBp1UmBgUC7naX+cO70lvOohPjCmfTz7
	 xT7tUQRn413GBHjhE/MfYLxSReWD5z9qzZnxsDNSa5nafz7QEYX5OsuOQyh9IeI3/T
	 cNEK7cvddAxLUGH61DRo0lfq0HJBuYz5sTpCpFjg=
Date: Mon, 18 May 2026 18:16:47 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-merge-zeromap-into-swap-table-fix.patch added to mm-new branch
Message-Id: <20260519011648.2B0EDC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-merge-zeromap-into-swap-table-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-merge-zeromap-into-swap-table-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-merge-zeromap-into-swap-table-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-merge-zeromap-into-swap-table-fix
Date: Mon May 18 06:15:39 PM PDT 2026

swap_cluster_alloc_table(): remove unused local `ret'

Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-merge-zeromap-into-swap-table-fix
+++ a/mm/swapfile.c
@@ -450,7 +450,6 @@ static int swap_cluster_alloc_table(stru
 {
 	struct swap_table *table = NULL;
 	struct folio *folio;
-	int ret = 0;
 
 	/* The cluster must be empty and not on any list during allocation. */
 	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch


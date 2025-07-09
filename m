Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48608188A0C
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 03:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752030264; cv=none; b=BCm/kr54CfDXebRr0xhVbHbk3dRLhR2g3diEINuqKKs7VQkCMSK00D9ptJ6VbDSNlkvxPUuUHUqKSc4VXAPkx1uVs1/uE5bQmTM7ipmvqDEq2OIVoZSXLqcGmCTrBXAvolNCPOLQfFoDwbmZVPuYk0mvLab6QAevo0LI5+5pjec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752030264; c=relaxed/simple;
	bh=JX7518cvWcGzxp+ckJcuCZFXNUlIGpdXCwiIl6iUboA=;
	h=Date:To:From:Subject:Message-Id; b=Ji5siDb+7Ycbnh6S/X7s6q/vYzCpnMDYMHgCKxo2DXvRqPnEnFrLWxhWi7/FMGIYTrMvPI/G/4WwCjsSmw7UISG6PgjKgZS/jWRMCOIa4mCcOYNPcXlmCoxeNbN3VnTkdUyu38r+WawmLOBaG5iafAbNkrDvtWoPvirzbJbdnSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g4yGQq2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g4yGQq2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA11EC4CEED;
	Wed,  9 Jul 2025 03:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752030263;
	bh=JX7518cvWcGzxp+ckJcuCZFXNUlIGpdXCwiIl6iUboA=;
	h=Date:To:From:Subject:From;
	b=g4yGQq2gF/gUclQpDhq+wYacIwzUgXkeOrxVOMEfiEvGoJM0/C0wj0K4WS7yWx/6M
	 Gl4fqdc3T2csfEueIwqCDiSIpZreC/DCKTnNpTfQ01+2p8pOX4oVWbCTiUg1ZdKzXc
	 QUYad1AeCHebP7DJ2PWpUOd9aCU8Y6AsCCfRhw/M=
Date: Tue, 08 Jul 2025 20:04:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,shivankg@amd.com,osalvador@suse.de,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-util-introduce-snapshot_page-fix.patch added to mm-new branch
Message-Id: <20250709030423.AA11EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-util-introduce-snapshot_page-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-util-introduce-snapshot_page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-util-introduce-snapshot_page-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm-util-introduce-snapshot_page-fix
Date: Tue, 8 Jul 2025 12:59:07 -0400

use clear_compound_head(), per Shivank

Link: https://lkml.kernel.org/r/60a1a526-52dd-478a-9ed4-79e6428743ac@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c~mm-util-introduce-snapshot_page-fix
+++ a/mm/util.c
@@ -1239,7 +1239,7 @@ again:
 	if (ps->idx > nr_pages) {
 		if (loops-- > 0)
 			goto again;
-		ps->page_snapshot.compound_head &= ~1UL;
+		clear_compound_head(&ps->page_snapshot);
 		foliop = (struct folio *)&ps->page_snapshot;
 		ps->flags = 0;
 		ps->idx = 0;
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-util-introduce-snapshot_page.patch
mm-util-introduce-snapshot_page-fix.patch
proc-kpagecount-use-snapshot_page.patch
fs-stable_page_flags-use-snapshot_page.patch


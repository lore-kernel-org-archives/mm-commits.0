Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA30442048
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 23:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775085438; cv=none; b=n23NI0jMqdNBj7584DBNlHgj+YyZBXf9lJ3GPyTLPZrN4pn7pXf1jTBKQkoBwEVKywxWADOMSHNzNGlnMdlRX2a3rklq3NKUNt/lsJrtTz6LQuo25XoVAz2SV5fU1ik6zrOBtXs8kn5tSDsaTDcR+bgH3lDIFN1qFSB/6NsP7eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775085438; c=relaxed/simple;
	bh=pD0ffHets/5WKMPJ0GLYJpgJIiTRJfp6BS9xWThQ/o4=;
	h=Date:To:From:Subject:Message-Id; b=In0h89lwrQkatHiUkDpFdRgTuhbdieMLRt93AtjiF7ljlJxBYMW7qAAN3/uFPVgpivnEs8qzkF50D03p2i6Dok2cicaha95QYxYyAhHytoMStBlI+ZyTRS8Ckx/RnzNCzW9YwgjlIduD13zy69gcRFbQ08CF2dsJuV5o3xou7TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SjUUh7y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SjUUh7y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B19C4CEF7;
	Wed,  1 Apr 2026 23:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775085437;
	bh=pD0ffHets/5WKMPJ0GLYJpgJIiTRJfp6BS9xWThQ/o4=;
	h=Date:To:From:Subject:From;
	b=SjUUh7y0FRgclJVJ8SYO8zHBGt88qZeMrFDXs2YIDgfTL6udHbaSHYcUgI75CCG1H
	 qHk0QWTUCiZd6FN3v0poQfEq9fmAvVti2z0P8ckQigaHf9le9IkhtODAYIKeSXZDKP
	 BwbnhciMvliYArsaOaKBKQLI+xdnqO7ja4s2SXj4=
Date: Wed, 01 Apr 2026 16:17:16 -0700
To: mm-commits@vger.kernel.org,lance.yang@linux.dev,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-deferred-split-queue-races-during-migration-fix.patch added to mm-unstable branch
Message-Id: <20260401231717.79B19C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-fix-deferred-split-queue-races-during-migration-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-deferred-split-queue-races-during-migration-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-deferred-split-queue-races-during-migration-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm-fix-deferred-split-queue-races-during-migration-fix
Date: Wed, 1 Apr 2026 18:52:43 -0400

move the comment

Link: https://lkml.kernel.org/r/FB71A764-0F10-4E5A-B4A0-BA4C7F138408@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-fix-deferred-split-queue-races-during-migration-fix
+++ a/mm/huge_memory.c
@@ -4551,15 +4551,18 @@ retry:
 		}
 		folio_unlock(folio);
 next:
+		/*
+		 * If thp_underused() returns false, or if split_folio()
+		 * succeeds, or if split_folio() fails in the case it was
+		 * underused, then consider it used and don't add it back to
+		 * split_queue.
+		 */
 		if (did_split || !folio_test_partially_mapped(folio))
 			continue;
 requeue:
 		/*
-		 * Add back partially mapped folios, or underused folios
-		 * that we could not lock this round.  If thp_underused()
-		 * returns false, or if split_folio() succeeds, or if
-		 * split_folio() fails in the case it was underused, then
-		 * consider it used and don't add it back to split_queue.
+		 * Add back partially mapped folios, or underused folios that
+		 * we could not lock this round.
 		 */
 		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
 		if (list_empty(&folio->_deferred_list)) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-fix-deferred-split-queue-races-during-migration-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736B51ABEDF
	for <mm-commits@vger.kernel.org>; Thu,  3 Oct 2024 20:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727985607; cv=none; b=nJlJogpayvZv544poJsvw1bNDmarvDzn0U8Ayg1cI75wluvtT1EDU+nuCxDO96kNOZtFt20sPzDTelSx9RXmEzaWo0JzSgiSzwLPhNlO/wCJ0pi2Ea9k4B6XLoR7SkR7h0cBBNB0KstjzZx9cwNh/ldix0CAQ/5cEIhUHodT+2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727985607; c=relaxed/simple;
	bh=WEYY3WspARQ0G/D9Wi2nURLA7GZGGKBGMaoo5f735cg=;
	h=Date:To:From:Subject:Message-Id; b=UgrcNp54xFptj8fgdqS62AJHpOYsTm/Pp2At/2hyiHjuH4ACwoKTvTT75mkREIjrDuY9qCqF4ChWXUSAPsM8/WP6ALqQbwue7Gq2Ic8kSET7EZiSFZ8PjRUsUxc1nHqcmXXSaqxGcq3ENx9V/YPRmLvYRDh5E/7OritB4MGLyOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=avEhaX09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="avEhaX09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4A1C4CEC5;
	Thu,  3 Oct 2024 20:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727985606;
	bh=WEYY3WspARQ0G/D9Wi2nURLA7GZGGKBGMaoo5f735cg=;
	h=Date:To:From:Subject:From;
	b=avEhaX09zGAvr5PYIMB9gZisxMgWcdv8TR/1JxXE/C6/uu1YD1TBgMtv3ibY2x8j2
	 14P8mFqDHOebNXyLZ+iRrxwRhNm4hFzbyZLxDuc8Sd60zy74+j48DloIjSn/ohqkH3
	 vbmhMN9tK1CoiYR9m/47u7al3CcnQUDQj2jijczM=
Date: Thu, 03 Oct 2024 13:00:06 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch added to mm-unstable branch
Message-Id: <20241003200006.BC4A1C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/truncate: reset xa_has_values flag on each iteration
has been added to the -mm mm-unstable branch.  Its filename is
     mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch

This patch will later appear in the mm-unstable branch at
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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
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

mm-optimize-truncation-of-shadow-entries.patch
mm-optimize-invalidation-of-shadow-entries.patch
mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218D61DD525
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 23:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746745515; cv=none; b=ZsfjpdHprhSsqRI4X68w+dDE8G+/0iBqrE6qSgrmI25b6DExUzqKetanyD9PXePcENslpQPSelCljcQE7ih4pLW3fgHfjOrOv+zZUuJ65JrCyGK8RJYJYr+MROo8/5r58bV3SY88iEpxAMBtw/Ev5JVyJ0z0/qiXYUZfdb0VXN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746745515; c=relaxed/simple;
	bh=fChxYEb7vGiGs5Dkxk/GE2rZuQaT+Ki1i2+SmeLMj00=;
	h=Date:To:From:Subject:Message-Id; b=BpkZ8LNwKgdvz2pr/QqgqJ+Lzum3K07A/wlUxUaD46fd8so6hFkqL/hvOSs4wOhXcNlTOnK2Wj350g7ACoCNe8orCCNvu4mJ6Cyf1L8P1dSkpNnSfySa3HlFJ1pdVrJy8JIjnaQ4liy222OtZJN+OG8lCFzT5n829IeUjcZnx3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yzb2c4yt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yzb2c4yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772EEC4CEE7;
	Thu,  8 May 2025 23:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746745514;
	bh=fChxYEb7vGiGs5Dkxk/GE2rZuQaT+Ki1i2+SmeLMj00=;
	h=Date:To:From:Subject:From;
	b=yzb2c4ytnqEa2JupCK6cGL5CYuoG8lm9x/WhwGg8METTKCwHuPQGdtUizkXPLSxj8
	 GIKqPH579Xp9wJX4pWIrDBUuZ6/YIb7y+jZLfrpOcEOPMEtr1WKCYYlzQqU4nsInPA
	 D1Pz6I7N+VZPOZHDIhRcl12XrqMRygp4GnGy223Q=
Date: Thu, 08 May 2025 16:05:13 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix.patch added to mm-new branch
Message-Id: <20250508230514.772EEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix
Date: Thu, 8 May 2025 15:23:42 -0400

Here is the fixup 2/3 to address Johannes' comments.

1. replace get_pageblock_isolate() with
   get_pageblock_migratetype() == MIGRATE_ISOLATE, a
   get_pageblock_isolate() becomes private in mm/page_isolation.c

Link: https://lkml.kernel.org/r/F05CF961-6104-4C46-94C2-8966F580D8AC@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix
+++ a/mm/page_alloc.c
@@ -1980,7 +1980,7 @@ static bool __move_freepages_block_isola
 	int from_mt;
 	int to_mt;
 
-	if (isolate == get_pageblock_isolate(page))
+	if (isolate == (get_pageblock_migratetype(page) == MIGRATE_ISOLATE))
 		return false;
 
 	if (!prep_move_freepages_block(zone, page, &start_pfn, NULL, NULL))
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix.patch


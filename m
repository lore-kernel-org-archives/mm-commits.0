Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5D62D46B3
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 11:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777290399; cv=none; b=rj420P0ySkhwVU5KNK2wX8LKOL/Zc270Z9cYe1XjUP4lSHSBgEOYzjfVhz+Bo1GdvfXHx8hFLpJV4JhfxM5GLaSF7O9phBvFzFLXtkbVCZ5cNuIoCQWHnwIVGj3jyvKUjdZ63ZoaV+NXIbJXxmKFpjW5ipHAyW2qY6LqHkIc3rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777290399; c=relaxed/simple;
	bh=0ZCCx7T34YqUOMBXY1rB6n6tIYQbQw5g+6DTsIKgNjw=;
	h=Date:To:From:Subject:Message-Id; b=mCwlJ1agLqKuBDnNgs5asQtMJlaEIj67U0onaDBRJiXsgJKUp9neRv0YEyZWoRsmfU7Gb6psdlQc4pdwxYNaVHGk2AEfcHsT7i7kSHDHFtehB49I5XsAOYP17hFEDIrf9JJq5fnd/nvnNaODV4340qbXp922I7nTQ6dTTRPjq6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yyVlgTXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yyVlgTXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E359DC2BCC4;
	Mon, 27 Apr 2026 11:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777290397;
	bh=0ZCCx7T34YqUOMBXY1rB6n6tIYQbQw5g+6DTsIKgNjw=;
	h=Date:To:From:Subject:From;
	b=yyVlgTXoQZY4msDgutgP6ZFid+sMlX8VZ2vuixiS0koA9yvOwhEN9/ZN75d5SX8sw
	 ErAOGJTIJk/e2lvBcXf/ydX3mu5l1WliHumG3e3NQ/tnlDv7FIuAS2scbUA7LbiDn/
	 5gIezlnE9qvLzQrnV4XcDVKQUWHXT/kKpCobcr2U=
Date: Mon, 27 Apr 2026 04:46:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,hank20010209@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-fix-parametrs-typo.patch added to mm-new branch
Message-Id: <20260427114636.E359DC2BCC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon: fix 'parametrs' typo
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-fix-parametrs-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-fix-parametrs-typo.patch

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
From: Cheng-Han Wu <hank20010209@gmail.com>
Subject: Docs/admin-guide/mm/damon: fix 'parametrs' typo
Date: Sun, 26 Apr 2026 16:16:15 -0700

Fix the misspelling of "parametrs" as "parameters" in reclaim.rst and
lru_sort.rst.

Link: https://lore.kernel.org/20260426231619.107231-3-sj@kernel.org
Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |    2 +-
 Documentation/admin-guide/mm/damon/reclaim.rst  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-admin-guide-mm-damon-fix-parametrs-typo
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -75,7 +75,7 @@ Make DAMON_LRU_SORT reads the input para
 
 Input parameters that updated while DAMON_LRU_SORT is running are not applied
 by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT reads values
-of parametrs except ``enabled`` again.  Once the re-reading is done, this
+of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-mm-damon-fix-parametrs-typo
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -67,7 +67,7 @@ Make DAMON_RECLAIM reads the input param
 
 Input parameters that updated while DAMON_RECLAIM is running are not applied
 by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
-of parametrs except ``enabled`` again.  Once the re-reading is done, this
+of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
_

Patches currently in -mm which might be from hank20010209@gmail.com are

docs-admin-guide-mm-damon-fix-parametrs-typo.patch


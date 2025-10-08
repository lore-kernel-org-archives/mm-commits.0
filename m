Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C185F1DE4FB
	for <mm-commits@vger.kernel.org>; Wed,  8 Oct 2025 00:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759882933; cv=none; b=r8wscArkPSuIPxzih45NT0Boxi6zFBKusW9t6K4u2R+hNS9m856pZm2jKKSa8TsYXJArHmIHIs90TpzOuRJ3Wf4lBWGPRtiGJBIMWNiMzRRJ2Y6tCcOeFWLrViO+1W9jW6VpdppG5Y67dC40nh3k/LFLVfpjXtg/Fjv9C3X5MwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759882933; c=relaxed/simple;
	bh=JhMBvF5yTCf3UrudWOtxfH3I5ru6DSdeSvcxUqQ7RtA=;
	h=Date:To:From:Subject:Message-Id; b=h3OwFtjs93kxi9iVi7bxoy++DzUfaSg6oYOdXxFdGeQv1rOcueKatDWtW1XPH8N6YcEDX+cjxpxv8BNzvKFKlzs/7/E97Zja9RttKA9g0awKXhTtFkFOh0ZkVck/cLztzlqvKStXkVKJ52Tix2InrWTLN3E/4CtQgaX185mRvRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TKfwH64c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TKfwH64c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40537C4CEF1;
	Wed,  8 Oct 2025 00:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759882931;
	bh=JhMBvF5yTCf3UrudWOtxfH3I5ru6DSdeSvcxUqQ7RtA=;
	h=Date:To:From:Subject:From;
	b=TKfwH64cMmb68bSsiBvUg/w6jfKW6TRdgffoRBKY4XZKYbTlq8cINFtdD17VnENX3
	 pwtTqfEJU8/1yhL39fbg0PBDkMu6RE/fFRzNL4JoRcnNpYG5tyqGAUvBST26Nm3Hns
	 sTa+kHoT9Tu1d4kqxusADrS1cQm9/83fdqUJb/Nk=
Date: Tue, 07 Oct 2025 17:22:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,chengming.zhou@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch added to mm-new branch
Message-Id: <20251008002211.40537C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: remove unnecessary dlen writes for incompressible pages
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/zswap: remove unnecessary dlen writes for incompressible pages
Date: Fri, 3 Oct 2025 13:38:48 -0700

Patch series "mm/zswap: misc cleanup of code and documentations".

Clean up an unnecessary local variable write in incompressible pages
handling, typos (s/zwap/zswap/) and outdated comments/documentations about
the zswap's red-black tree, which is replaced by xarray.


This patch (of 4):

Incompressible pages handling logic in zswap_compress() is setting 'dlen'
as PAGE_SIZE twice.  Once before deciding whether to save the content as
is, and once again after it is decided to save it as is.  But the value of
'dlen' is used only if it is decided to save the content as is, so the
first write is unnecessary.  It is not causing real user issues, but
making code confusing to read.  Remove the unnecessary write operation.

Link: https://lkml.kernel.org/r/20251003203851.43128-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251003203851.43128-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Chris Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages
+++ a/mm/zswap.c
@@ -894,7 +894,6 @@ static bool zswap_compress(struct page *
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
-		dlen = PAGE_SIZE;
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch


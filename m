Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168D84BE451
	for <mm-commits@vger.kernel.org>; Thu, 24 Sep 2026 20:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790280454; cv=none; b=Jl+8g9+mDkaNEUa/A42xdVG2wiKqZIB7c1t9T4fqOQINtTMD8Njxb6Gt3GPLifrh/Qp5tBD22Rj/uWP0PxO58KavgDXgP4LVj+hKMQgSh9R5d1MchdyoB4KP6u+tYmGCOw1cB7Q5dBlq9qBa9ZqypwtCIGkQO+mUs2EMQFU4Ci4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790280454; c=relaxed/simple;
	bh=KW4FJ8qj0T6EcA6zKbRkJj+ELS/t2r/5AvypmYs0uqA=;
	h=Date:To:From:Subject:Message-Id; b=SZV9ZwPtJqyYZKEQEq1s+fgLFOLEAm3pGF5HDFyzq+RZIHODYJLPvix88RrqLknj1SeoQd3b++9STf/DJFwZVXv0dBjNfl/M5fpBAh8bhFurfA6aZyF+5bo3BkbqAGZifLiXQYhSBtL7Q2rjHsxS3y7urSErpE5DvPxLi6ZJi9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HM671Bhy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HM671Bhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EF11F000FF;
	Thu, 24 Sep 2026 20:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790280449;
	bh=wALTZBwaCFxUFQZuQsBTZTt5uCDA0QBBt9RWnxi9iRY=;
	h=Date:To:From:Subject;
	b=HM671Bhy1d2KKjw7wi83VXgU73lHnHfQvWAcjCU+eUJT2RKh6pb+j5EHNKW0CnYEA
	 BSL48bxnXvKARiMLhpDqXti8btODzsSRW3QZ0j0jxYOmA1MM1esqIEZHGY+e6zSpjm
	 pHTIxsS9MOK0YeYCzlyy07SwTd3miLOoRfsQ+vhk=
Date: Thu, 24 Sep 2026 13:07:28 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,qi.zheng@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-unused-zone-unaccepted_cleanup.patch added to mm-new branch
Message-Id: <20260924200729.52EF11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove the unused zone->unaccepted_cleanup
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-the-unused-zone-unaccepted_cleanup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-unused-zone-unaccepted_cleanup.patch

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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: remove the unused zone->unaccepted_cleanup
Date: Thu, 24 Sep 2026 12:11:03 -0700

Commit fefc07518227 ("mm/page_alloc: fix race condition in unaccepted
memory handling") removed the zones_with_unaccepted_pages static key and
the work that decremented it, but left the work_struct behind in struct
zone.  Nothing uses it anymore, so let's remove it.

Link: https://lore.kernel.org/20260924191103.3475117-1-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---

 include/linux/mmzone.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/mmzone.h~mm-remove-the-unused-zone-unaccepted_cleanup
+++ a/include/linux/mmzone.h
@@ -1100,9 +1100,6 @@ struct zone {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	/* Pages to be accepted. All pages on the list are MAX_PAGE_ORDER */
 	struct list_head	unaccepted_pages;
-
-	/* To be called once the last page in the zone is accepted */
-	struct work_struct	unaccepted_cleanup;
 #endif
 
 	/* zone flags, see below */
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-zswap-dont-fail-a-large-folio-swapin-whose-range-is-not-in-zswap.patch
mm-filemap-move-lruvec-accounting-outside-the-xarray-lock.patch
mm-remove-the-unused-zone-unaccepted_cleanup.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086CA24EA90
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 22:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788646726; cv=none; b=EakiqvjMg2X4XoN9/G3HlyOcDcWlJTvY06PEtR930DeOaug5G+Lyj/SKmBf3u9BBwxGs7DdA9sz9PQs/0Qia5U5Oj+9RdbRMFk5mD6ZL04H7MgEUhFi61SWsNWJMiYASWgQjcHmvfHE5xR+0fuJjkWRSTktkqVGuJM+hv0ejFm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788646726; c=relaxed/simple;
	bh=jrHY3qG560TkXbDTj9haa/TtCNmmzZvzuO8QkgkLFl0=;
	h=Date:To:From:Subject:Message-Id; b=bQST2yDf2A9MKkANYp6cJWoZfza8Lw38Ei8d2RUUqvtkVWNL56ni0vDodAjH0+27h/pwTVNTEMeblZ0wLw1I7ELReNb74ETwbiE3pHOBc25nHn5Rqc0NjKkhB6SLl30qBHnSZQoV1sw3nYj592sqvFoJqzISZ3tl1NSZ7hD3d9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jA6OMSHn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jA6OMSHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F92A1F00A3A;
	Sat,  5 Sep 2026 22:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788646724;
	bh=QW4h4GQ2y/6fWCkBACk0ZB+QtnOh6hmZXPUtL3vCAUs=;
	h=Date:To:From:Subject;
	b=jA6OMSHnNVWRsK+bg4ApG1+s76FBLhLsK7DE5FaxSE/Mhu6buuZXzaMSeG1eth9KH
	 JA7uI1FsB0JOvwOXBjjdY34bAjfHOkrX7HrZn5PDrIi2J8NRM/nAVU5K76P95S7JJM
	 AxYXkGoMzL2WPpzAI7Vi6qGbcba0AWKKbMzRGTM0=
Date: Sat, 05 Sep 2026 15:18:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pagewriteback.patch added to mm-new branch
Message-Id: <20260905221844.8F92A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageWriteback
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-pagewriteback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pagewriteback.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove PageWriteback
Date: Sat, 05 Sep 2026 15:08:30 -0400

The last caller of PageWriteback() was removed in commit f75987e543c2
("libceph: remove pinning assertion in ceph_msg_data_iter_next()").  This
flag is now only used on folios, so we can remove all the page accessors. 
folio_test_clear_writeback() is not used, so don't add
FOLIO_TEST_CLEAR_FLAG() for it.

Link: https://lore.kernel.org/20260905-remove-pagewriteback-v1-1-06f41c00db03@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagewriteback
+++ a/include/linux/page-flags.h
@@ -588,8 +588,8 @@ FOLIO_FLAG(owner_2, FOLIO_HEAD_PAGE)
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
  * risky: they bypass page accounting.
  */
-TESTPAGEFLAG(Writeback, writeback, PF_NO_TAIL)
-	TESTSCFLAG(Writeback, writeback, PF_NO_TAIL)
+FOLIO_TEST_FLAG(writeback, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_SET_FLAG(writeback, FOLIO_HEAD_PAGE)
 FOLIO_FLAG(mappedtodisk, FOLIO_HEAD_PAGE)
 
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch
mm-remove-unused-mark_page_reserved.patch
mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch
mm-remove-pagewriteback.patch


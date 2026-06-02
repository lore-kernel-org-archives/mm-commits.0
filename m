Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BA1356768;
	Tue,  2 Jun 2026 04:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780373129; cv=none; b=K2s56+rTuQ7LlZlVAUR9LDOK2hUkyzfdlxESFSNKDtrqhVFbkimr+9vyYAa7K/D/xppATizhTXeCzxCt4NHmq5tzixFCDsazoBqUpQYkGV2pCZ/T25pjXT0K/9lB25nLg5jkzro3pF+yRtIfSMAhiB23LvYzXxY0cn6aETle4aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780373129; c=relaxed/simple;
	bh=gOVGQfIKdS+LO0hCSP48ZXNs3CjHLgvqZx8wCE6Zf4Q=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=DLCk+qmPg+ok6b05kw6ANXgDbGL7z3IHkr71GRoJ7k8GzuhOczpvY+StnGuqTRCaj53xRpTGSzf17UV9rGfCdIQzqk9BI+fEniYjOr0jjDgjq0QzkTxEYrbGtgZJqdsNgG5f05fjErsgu2vqxSqd/050IJn1S3DkTeZ/F/LMR1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sI5CfDVm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sI5CfDVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56551F00893;
	Tue,  2 Jun 2026 04:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780373128;
	bh=LORZAgAR/uBAOert55Zjf1s2Z74JOa5LkLhOA3aVAQ4=;
	h=Date:From:To:Cc:Subject;
	b=sI5CfDVmV5CplfMAZAMZNdCrISuAnlpP8tkRa+TzlMDymEo5vIGfjTXSmzrHAwRyG
	 CxYGf6MgL750yONZoAUfDO+ElIkvjV7i3hDUCH4iBMf6iK/i8/ztkzJqsrDv9+FyII
	 hAyDW1R3aK2h1fIgbQFi5bO0IGZjd4ONRziprSmM=
Date: Mon, 1 Jun 2026 21:05:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.1-rc7
Message-Id: <20260601210527.ad1549849df4d9d58b12cffe@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of hotfixes, thanks.

The following changes since commit d60ec36cab338dfe2ae40d73e9c8d6c4af70d2b8:

  Merge tag 'mm-hotfixes-stable-2026-05-25-16-22' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2026-05-26 08:23:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-06-01-20-58

for you to fetch changes up to 9d7bea186ba5a002456471edf36cc9b69f809397:

  userfaultfd: remove redundant check in vm_uffd_ops() (2026-05-31 21:50:26 -0700)

----------------------------------------------------------------
13 hotfixes.  All are for MM.  10 are cc:stable and the remaining 3
address post-7.1 issues or aren't considered suitable for backporting.

There's a 3 patch series "userfaultfd: verify VMA state across UFFDIO_COPY
retry" from Mike Rapoport which fixes a few uffd things.  The rest are
singletons - please see the individual changelogs for details.

----------------------------------------------------------------
David Carlier (1):
      mm/hugetlb: restore reservation on error in hugetlb folio copy paths

Lorenzo Stoakes (1):
      mm/hugetlb: avoid false positive lockdep assertion

Mike Rapoport (Microsoft) (3):
      userfaultfd: verify VMA state across UFFDIO_COPY retry
      userfaultfd: refuse to __mfill_atomic_pte() for unsupported VMAs
      userfaultfd: remove redundant check in vm_uffd_ops()

Muchun Song (3):
      mm/cma_debug: fix invalid accesses for inactive CMA areas
      mm/cma: fix reserved page leak on activation failure
      mm/hugetlb_vmemmap: fix incorrect vmemmap restore in rollback

SeongJae Park (1):
      mm/damon/ops-common: call folio_test_lru() after folio_get()

Shakeel Butt (1):
      memcg: use round-robin victim selection in refill_stock

Wupeng Ma (1):
      mm/memory-failure: fix hugetlb_lock AA deadlock in get_huge_page_for_hwpoison

Yin Tirui (2):
      mm/huge_memory: update file PUD counter before folio_put()
      mm/huge_memory: update file PMD counter before folio_put()

 include/linux/hugetlb.h |  8 -----
 include/linux/mm.h      |  8 -----
 mm/cma.c                |  7 ++--
 mm/cma_debug.c          |  3 +-
 mm/damon/ops-common.c   |  4 +--
 mm/huge_memory.c        |  4 ++-
 mm/hugetlb.c            | 69 +++++++++++++++++++++----------------
 mm/hugetlb_vmemmap.c    | 36 +++++++++----------
 mm/memcontrol.c         |  5 ++-
 mm/memory-failure.c     | 19 +++++-----
 mm/userfaultfd.c        | 92 ++++++++++++++++++++++++++++++++++++++++++-------
 11 files changed, 162 insertions(+), 93 deletions(-)


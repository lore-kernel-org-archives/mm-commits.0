Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB13D27462;
	Wed, 22 Oct 2025 19:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761162350; cv=none; b=jkNqvzt+28JCaTz2jC5QizIHkrwpdWjF5NVLMsYNJzkqmH4GsoL/H4hfPyN8OabMcgi4QWlsuC+VJC728P3DfaaVQLA+eHagStypw6ei8GNXLtg2X25WySMk3fvvb1/DQVcGRA/V6wwDoYB1wQimY5ud3/2iW8AR5ji3yE1ceF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761162350; c=relaxed/simple;
	bh=BhrdWlrWjrxxxCFVIJZR3Y5rtQjATk4Iozogb7pSrYU=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=VAAx9G/njuba0vgsnHiLnRYXvQhOPsMAcuNVU4VXp9+8nwGLXjBopWlZvubGSaqRWdP2s4+9lvDPidFiXgnNYN9q0rkVdlI27c4afdnmvhQw9vELzX9Eu1jCBs8oUd+auhcV86gTPniPeB+erItuxtYBuKcQBpIcjgwQyPlvP1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tmDh3B5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tmDh3B5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F574C4CEE7;
	Wed, 22 Oct 2025 19:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761162349;
	bh=BhrdWlrWjrxxxCFVIJZR3Y5rtQjATk4Iozogb7pSrYU=;
	h=Date:From:To:Cc:Subject:From;
	b=tmDh3B5QWQdj9aWhhJA+vZ20tQwAVdcPPo6xtHJ6xsW7/J04SUP3vLa3DKNptpTki
	 Gvf9v0TkTvCQ9G8TkWH2ooOqhtCLRMOzqPZvGidP+Tdc6Wj7tw9EN9zN4bf7X9dno1
	 +sRvxc9OFqpko3NnQa4mATd6SMmXdwimegArOGok=
Date: Wed, 22 Oct 2025 12:45:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL]  hotfixes for 6.18-rc3
Message-Id: <20251022124548.a2bd1335de33d5d2b7b2fcb2@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge this batch of hotfixes for the current -rc cycle,
thanks.

The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2025-10-22-12-43

for you to fetch changes up to 9aa12167ef1149d9980713b120ddcb31cf17222d:

  csky: abiv2: adapt to new folio flags field (2025-10-21 15:46:18 -0700)

----------------------------------------------------------------
17 hotfixes.  12 are cc:stable and 14 are for MM.

There's a two-patch DAMON series from SeongJae Park which addresses a
missed check and possible memory leak.  Apart from that it's all
singletons - please see the changelogs for details.

----------------------------------------------------------------
Alexei Starovoitov (1):
      mm: don't spin in add_stack_record when gfp flags don't allow

David Hildenbrand (1):
      vmw_balloon: indicate success when effectively deflating during migra=
tion

Deepanshu Kartikey (2):
      ocfs2: clear extent cache after moving/defragmenting extents
      hugetlbfs: move lock assertions after early returns in huge_pmd_unsha=
re()

Enze Li (1):
      mm/damon/core: fix potential memory leak by cleaning ops_filter in da=
mon_destroy_scheme

Lance Yang (1):
      hung_task: fix warnings caused by unaligned lock pointers

Lorenzo Stoakes (1):
      mm/mremap: correctly account old mapping after MREMAP_DONTUNMAP remap

Marek Szyprowski (1):
      dma-debug: don't report false positives with DMA_BOUNCE_UNALIGNED_KMA=
LLOC

Qiuxu Zhuo (1):
      mm: prevent poison consumption when splitting THP

SeongJae Park (4):
      mm/damon/sysfs: catch commit test ctx alloc failure
      mm/damon/sysfs: dealloc commit test ctx always
      mm/damon/core: fix list_add_tail() call on damon_call()
      mm/damon/core: use damos_commit_quota_goal() for new goal commit

Thomas Wei=DFschuh (1):
      csky: abiv2: adapt to new folio flags field

 arch/csky/abiv2/cacheflush.c         |  2 +-
 arch/csky/abiv2/inc/abi/cacheflush.h |  4 ++--
 drivers/misc/vmw_balloon.c           |  8 +++-----
 fs/hugetlbfs/inode.c                 |  9 ---------
 fs/ocfs2/move_extents.c              |  5 +++++
 include/linux/hung_task.h            |  8 +++++---
 kernel/dma/debug.c                   |  5 ++++-
 mm/damon/core.c                      |  7 +++++--
 mm/damon/sysfs.c                     |  7 ++++---
 mm/huge_memory.c                     |  3 +++
 mm/hugetlb.c                         |  5 ++---
 mm/migrate.c                         |  3 ++-
 mm/mremap.c                          | 15 ++++++---------
 mm/page_owner.c                      |  3 +++
 14 files changed, 45 insertions(+), 39 deletions(-)


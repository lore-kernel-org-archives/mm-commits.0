Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19EB19C56C;
	Tue, 18 Mar 2025 03:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742267527; cv=none; b=rIY5C1a4UlGLpz+0VisRr98MDkd58MEoE6OoDDMkpig7J6c21eQ5zzThUXv8BND+taBm9eKeRpZNsrdxQ8f6BPEIaKhNtp9SoXlDHL/ZzqJOMm/n08f075GkOZ3hczQaSthkN08HQ5onM2hQKVU7PMtiE6wTniZC0MXaGhzzIBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742267527; c=relaxed/simple;
	bh=FOzdTj+RgVpefQ/QXmvMORIw8lgZ29rTBpBKUfuC72E=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=ZDAdut2tB+af8wImG/qFxoCICy17cvcqGRmkgem4YMIf1vWLyQQNsB2r3VhaxMIQX3vOsW7sfDAzIAslV5uwyLU6qvCpI1ruEF86GrkS0GaPhEH3YDIHuG4siC/weNvuBNwTlA7kiiHqMZX9An4Pt185IudfDvzCavPXlxD9b/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=spDGdY+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="spDGdY+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2615C4CEEF;
	Tue, 18 Mar 2025 03:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742267527;
	bh=FOzdTj+RgVpefQ/QXmvMORIw8lgZ29rTBpBKUfuC72E=;
	h=Date:From:To:Cc:Subject:From;
	b=spDGdY+VA9KOBxO0Twx5afFB5rusaXHnv8mXmwgmmMZaGpgXkMiuqReEZbSq5DO2s
	 k6SltBxPpTWcHrgvhpKJxyRi6ajP4SuVZJcjQM8ahdMS/jxd9kKlxBKMIQd6db48pR
	 1RT5s1AtEOiQfYlVU2JeTU3ERk+Xcg9puzSmwXsQ=
Date: Mon, 17 Mar 2025 20:12:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes against 6.14-rc7
Message-Id: <20250317201206.7800aeeb5dad94c230fe1456@linux-foundation.org>
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

The following changes since commit 80e54e84911a923c40d7bee33a34c1b4be148d7a:

  Linux 6.14-rc6 (2025-03-09 13:45:25 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-03-17-20-09

for you to fetch changes up to 800f1059c99e2b39899bdc67a7593a7bea6375d8:

  mm/page_alloc: fix memory accept before watermarks gets initialized (2025-03-16 17:40:26 -0700)

----------------------------------------------------------------
15 hotfixes.  7 are cc:stable and the remainder address post-6.13 issues
or aren't considered necessary for -stable kernels.

13 are for MM and the other two are for squashfs and procfs.

All are singletons.  Please see the individual changelogs for details.

----------------------------------------------------------------
Dave Hansen (1):
      filemap: move prefaulting out of hot write path

Dev Jain (1):
      mm/vma: do not register private-anon mappings with khugepaged during mmap

Jinjiang Tu (1):
      mm/hugetlb: fix surplus pages in dissolve_free_huge_page()

Kirill A. Shutemov (1):
      mm/page_alloc: fix memory accept before watermarks gets initialized

Matthew Wilcox (Oracle) (1):
      mm: decline to manipulate the refcount on a slab page

Muchun Song (1):
      mm: memcontrol: fix swap counter leak from offline cgroup

Rafael Aquini (1):
      selftests/mm: run_vmtests.sh: fix half_ufd_size_MB calculation

Raphael S. Carvalho (1):
      mm: fix error handling in __filemap_get_folio() with FGP_NOWAIT

SeongJae Park (2):
      mm/damon: respect core layer filters' allowance decision on ops layer
      mm/damon/core: initialize damos->walk_completed in damon_new_scheme()

Shakeel Butt (1):
      memcg: drain obj stock on cpu hotplug teardown

Ye Bin (1):
      proc: fix UAF in proc_get_inode()

Zhiyu Zhang (1):
      squashfs: fix invalid pointer dereference in squashfs_cache_delete

Zi Yan (2):
      mm/migrate: fix shmem xarray update during migration
      mm/huge_memory: drop beyond-EOF folios with the right number of refs

 fs/proc/generic.c                         | 10 +++++++-
 fs/proc/inode.c                           |  6 ++---
 fs/proc/internal.h                        | 14 +++++++++++
 fs/squashfs/cache.c                       |  2 +-
 include/linux/damon.h                     |  5 ++++
 include/linux/mm.h                        |  8 ++++++-
 include/linux/proc_fs.h                   |  7 ++++--
 include/linux/swap_cgroup.h               |  4 ++--
 lib/iov_iter.c                            |  8 +++++--
 mm/damon/core.c                           |  7 +++++-
 mm/damon/paddr.c                          |  3 +++
 mm/filemap.c                              | 40 +++++++++++++++++++++----------
 mm/huge_memory.c                          |  2 +-
 mm/hugetlb.c                              |  8 +++++--
 mm/memcontrol.c                           | 13 ++++++++--
 mm/migrate.c                              | 10 ++++----
 mm/page_alloc.c                           | 14 +++++++++--
 mm/swap_cgroup.c                          |  7 +++---
 mm/vma.c                                  |  3 ++-
 tools/testing/selftests/mm/run_vmtests.sh |  4 +++-
 20 files changed, 132 insertions(+), 43 deletions(-)


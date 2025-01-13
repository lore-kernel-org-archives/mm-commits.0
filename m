Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2FC232386;
	Mon, 13 Jan 2025 08:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736755544; cv=none; b=kShMdE9iaQc1Mj6WkHl2FtuWhwwYMqCzkyApDGjTulgZqZtB4omKQ5/8cOAPaYRpmcaDaVdDdjNp4qnRkVDp3tM7lYkDntO3DsrluyFhs6iPReEAg9AQw+6Dy4ExOqLvE90c0OgkSkCiRhl7ZZb5Dopkg8HffIujdhXxO9molc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736755544; c=relaxed/simple;
	bh=xETqIZBGkh5MbzxGhLb+dwF2wrygfnXSiZpBTWUi0sw=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Xj8+Mp/c417McPvifHVfYT/LInwjF4Zz2wh4bTPU/bSKEN4ly2Tij5gFONeSiDi6/zHJH9J+xlHimEC7E67GKTVStlBNYYhh0SPpLuPSY44PM5VAg95gtlcuFWVG8npYkjGSxetNZ+0BUHnGja1yoOfwkDf2oXOqYO6ayIdSOgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NzNnGiOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NzNnGiOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EECC4CEE2;
	Mon, 13 Jan 2025 08:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736755544;
	bh=xETqIZBGkh5MbzxGhLb+dwF2wrygfnXSiZpBTWUi0sw=;
	h=Date:From:To:Cc:Subject:From;
	b=NzNnGiOFqUnOib7y/MVHQmCAq+qAMAAm+GTPOvG6eaROnaPj1LjKpech7g/PnZlKw
	 asLosvC7yzAcO/EWeVVHnepR5PvciB8jCPDuDEwORZklIBpfd4VyNK5yjDA3EN72i4
	 uPs6ftqCnqRDXEz0ff8mf1Y0HX2xvr+iEsjnaaTo=
Date: Mon, 13 Jan 2025 00:05:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes against 6.13-rc7
Message-Id: <20250113000543.862792e948c2646032a477e0@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of hotfixes, thanks.



The following changes since commit cd6313beaeaea0b2e6d428afef7a86a986b50abe:

  Revert "vmstat: disable vmstat_work on vmstat_cpu_down_prep()" (2025-01-06 06:10:24 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-01-13-00-03

for you to fetch changes up to cbc5dde0a461240046e8a41c43d7c3b76d5db952:

  fs/proc: fix softlockup in __read_vmcore (part 2) (2025-01-12 19:03:38 -0800)

----------------------------------------------------------------
18 hotfixes.  11 are cc:stable.  13 are MM and 5 are non-MM.

All patches are singletons - please see the relevant changelogs for
details.

----------------------------------------------------------------
Donet Tom (1):
      mm: vmscan : pgdemote vmstat is not getting updated when MGLRU is enabled.

Guo Weikang (1):
      mm/kmemleak: fix percpu memory leak detection failure

Honggyu Kim (1):
      mm/mempolicy: count MPOL_WEIGHTED_INTERLEAVE to "interleave_hit"

Juergen Gross (1):
      x86/execmem: fix ROX cache usage in Xen PV guests

Kairui Song (1):
      zram: fix potential UAF of zram table

Koichiro Den (1):
      vmstat: disable vmstat_work on vmstat_cpu_down_prep()

Luca Ceresoli (1):
      scripts/decode_stacktrace.sh: fix decoding of lines with an additional info

Marco Nelissen (1):
      filemap: avoid truncating 64-bit offset to 32 bits

Matthew Wilcox (Oracle) (1):
      mm: fix assertion in folio_end_read()

Muchun Song (1):
      hugetlb: fix NULL pointer dereference in trace_hugetlbfs_alloc_inode

Petr Pavlu (1):
      module: fix writing of livepatch relocations in ROX text

Rik van Riel (1):
      fs/proc: fix softlockup in __read_vmcore (part 2)

Ryan Roberts (2):
      mm: clear uffd-wp PTE/PMD state on mremap()
      selftests/mm: set allocated memory to non-zero content in cow test

Stefan Roesch (1):
      mm: fix div by zero in bdi_ratio_from_pages

Suren Baghdasaryan (1):
      tools: fix atomic_set() definition to set the value correctly

Yosry Ahmed (2):
      Revert "mm: zswap: fix race between [de]compression and CPU hotunplug"
      mm: zswap: properly synchronize freeing resources during CPU hotunplug

 arch/x86/mm/init.c                      |  3 +-
 drivers/block/zram/zram_drv.c           |  1 +
 fs/proc/vmcore.c                        |  2 ++
 include/linux/module.h                  |  3 +-
 include/linux/userfaultfd_k.h           | 12 +++++++
 include/trace/events/hugetlbfs.h        |  2 +-
 mm/filemap.c                            |  4 +--
 mm/huge_memory.c                        | 12 +++++++
 mm/hugetlb.c                            | 14 +++++++-
 mm/kmemleak.c                           |  2 +-
 mm/mempolicy.c                          |  3 +-
 mm/mremap.c                             | 32 +++++++++++++++++-
 mm/page-writeback.c                     | 10 ++++--
 mm/vmscan.c                             |  3 ++
 mm/vmstat.c                             | 15 +++++++--
 mm/zswap.c                              | 59 +++++++++++++++++++++------------
 scripts/decode_stacktrace.sh            | 16 +++++++--
 tools/testing/selftests/mm/cow.c        |  8 ++---
 tools/testing/shared/linux/maple_tree.h |  2 +-
 tools/testing/vma/linux/atomic.h        |  2 +-
 20 files changed, 163 insertions(+), 42 deletions(-)


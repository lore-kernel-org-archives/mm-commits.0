Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA89029A0;
	Sun,  5 Jan 2025 02:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736042713; cv=none; b=Gq+eiMXbQxDoIt6NT9ocaM6JeLDeomGLPFxLMqgbXVf0ZN/fUD4Ul0OseGhG+v+ovphA+wNCo5oqTKBpjr+Ek1LjZ7CdBgUe3jsCNnCH6PS36cWw1NHjUgZqke6hSHQpj+i/5wqxUPujhpZYw+uETtRdGx9E1rVqnZgbQIb485g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736042713; c=relaxed/simple;
	bh=pIyK5UNLmHV0OJMrjV03EMKF/xqRBQVt2/V7W4H6rrU=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=QDxXZwLI5Lgr4WAOSf8yyia/RNp4XfA31KfPuEkBHHIqrvYdFATyfBnjSZvpt7XwC7TWwXobltxy1/8SCehU/ZBOHfGcLjdKquPHIypiBRdtEP1sxa3xOemJqYd/46acWcncnDji0wI+7dIVE2ms8F2FQ2Z41infu33JhPZ4jY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r3B4tdXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r3B4tdXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B0DC4CED1;
	Sun,  5 Jan 2025 02:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736042712;
	bh=pIyK5UNLmHV0OJMrjV03EMKF/xqRBQVt2/V7W4H6rrU=;
	h=Date:From:To:Cc:Subject:From;
	b=r3B4tdXgPyUjKd84HMpg8z05zjLAo5dJ/FBTS0f2YFLySgUno36JMVzip1ZNpDBTm
	 b+nUZOTUM3Lmgkiji+ek6gjhKPbiVeUUnXAvNtkqT/Mp2Z2iVAEtrNoZ9y8vw013zX
	 o9HAbbfoxwtj8qVVSYqrOLd6zsTMEb6yQUxSyq2M=
Date: Sat, 4 Jan 2025 18:05:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.13-rc6
Message-Id: <20250104180511.ec607c34f312c8cc759cffc2@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 4bbf9020becbfd8fc2c3da790855b7042fad455b:

  Linux 6.13-rc4 (2024-12-22 13:22:21 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-01-04-18-02

for you to fetch changes up to e7404921818d676da4d7143ce78659456b05e2af:

  MAINTAINERS: change Arınç _NAL's name and email address (2024-12-30 17:59:12 -0800)

----------------------------------------------------------------
25 hotfixes.  16 are cc:stable.  18 are MM and 7 are non-MM.

The usual bunch of singletons and two doubletons - please see the relevant
changelogs for details.

----------------------------------------------------------------
Alessandro Carminati (1):
      mm/kmemleak: fix sleeping function called from invalid context at print message

Arnd Bergmann (1):
      kcov: mark in_softirq_really() as __always_inline

Baolin Wang (3):
      docs: mm: fix the incorrect 'FileHugeMapped' field
      mm: shmem: fix incorrect index alignment for within_size policy
      mm: shmem: fix the update of 'shmem_falloc->nr_unswapped'

Chester A. Unal (1):
      MAINTAINERS: change Arınç _NAL's name and email address

David Hildenbrand (1):
      fs/proc/task_mmu: fix pagemap flags with PMD THP entries on 32bit

Dennis Lam (1):
      ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv

Gal Pressman (1):
      percpu: remove intermediate variable in PERCPU_PTR()

Kairui Song (2):
      mm/list_lru: fix false warning of negative counter
      mm, madvise: fix potential workingset node list_lru leaks

Kefeng Wang (1):
      mm: don't try THP alignment for FS without get_unmapped_area

Koichiro Den (1):
      vmstat: disable vmstat_work on vmstat_cpu_down_prep()

Kuan-Wei Chiu (1):
      scripts/sorttable: fix orc_sort_cmp() to maintain symmetry and transitivity

Liu Shixin (1):
      mm: hugetlb: independent PMD page table shared count

Lorenzo Stoakes (2):
      mm: reinstate ability to map write-sealed memfd mappings read-only
      selftests/memfd: add test for mapping write-sealed memfd read-only

Mathieu Othacehe (1):
      mailmap: modify the entry for Mathieu Othacehe

Seiji Nishikawa (1):
      mm: vmscan: account for free pages to prevent infinite Loop in throttle_direct_reclaim()

SeongJae Park (2):
      mm/damon/core: fix new damon_target objects leaks on damon_commit_targets()
      mm/damon/core: fix ignored quota goals and filters of newly committed schemes

Tetsuo Handa (1):
      mm/util: make memdup_user_nul() similar to memdup_user()

Yafang Shao (1):
      mm/readahead: fix large folio support in async readahead

Yang Erkun (1):
      maple_tree: reload mas before the second call for mas_empty_area

Yosry Ahmed (1):
      mm: zswap: fix race between [de]compression and CPU hotunplug

 .mailmap                                   |  2 +-
 Documentation/admin-guide/mm/transhuge.rst |  2 +-
 MAINTAINERS                                |  6 +--
 fs/ocfs2/quota_global.c                    |  2 +-
 fs/ocfs2/quota_local.c                     |  1 +
 fs/proc/task_mmu.c                         |  2 +-
 include/linux/memfd.h                      | 14 +++++++
 include/linux/mm.h                         | 59 +++++++++++++++++++++---------
 include/linux/mm_types.h                   | 30 +++++++++++++++
 include/linux/percpu-defs.h                |  5 +--
 kernel/kcov.c                              |  2 +-
 lib/maple_tree.c                           |  1 +
 mm/damon/core.c                            | 10 ++++-
 mm/filemap.c                               |  9 -----
 mm/hugetlb.c                               | 16 ++++----
 mm/internal.h                              |  6 +++
 mm/khugepaged.c                            |  3 ++
 mm/kmemleak.c                              |  2 +-
 mm/list_lru.c                              |  2 +-
 mm/memfd.c                                 |  2 +-
 mm/mmap.c                                  |  6 ++-
 mm/readahead.c                             |  6 ++-
 mm/shmem.c                                 |  7 ++--
 mm/util.c                                  |  7 +---
 mm/vmscan.c                                |  9 ++++-
 mm/vmstat.c                                |  3 +-
 mm/zswap.c                                 | 19 ++++++++--
 scripts/sorttable.h                        |  5 ++-
 tools/testing/selftests/memfd/memfd_test.c | 43 ++++++++++++++++++++++
 29 files changed, 212 insertions(+), 69 deletions(-)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4956719E7F9;
	Fri, 11 Jul 2025 23:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752275932; cv=none; b=E0OOMRoesahZqey9YOququxDVkgcBA8gxxulx9zkgIUFrZPek0Vi2Yg9jlxO7rmb5Dr3gS6YzWwfQbaEHiSwkikxuVtw5PvqATQeGK8LRjf65utGODSH4RS/qb9Q1IzROF1jEh+/g9VtGHO79ySHMHrlkiEdAnuSu2Y8a1kc/h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752275932; c=relaxed/simple;
	bh=8/sM6gFYX94+sHDfgekSw0dkB7hQT1Gs8PFRkrIVh+8=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=jzFnD760I1cOeHw0jXowALykBbrlbsKXdXGfhz4/jNB2wAR2tRd8LpPwe8z+T4HQ/A55n32jbIGiZ6NhtE+p9zE0+qgVr20EMHlWq0Ap4BAWnPStV2/loPHvKm93jzIWSPTiZMoL/TPlXOCF6jMif4ii02XwlaGMeCPEeNlu968=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FJe31KoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FJe31KoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCFBC4CEED;
	Fri, 11 Jul 2025 23:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752275931;
	bh=8/sM6gFYX94+sHDfgekSw0dkB7hQT1Gs8PFRkrIVh+8=;
	h=Date:From:To:Cc:Subject:From;
	b=FJe31KoQ0AgHiPvAYOTdxjiwY0Kdk4QjsVj63KaUJBH07LjrPGMZ+dRjmxP7iaHK1
	 CqkzjDWZLcqSiF2ISQ9esGrHUMheB4d5OcLVS6YvlksHfjuCv/ZPJzUII7LscxaHUV
	 ZOdtS3pDHoxJKMFaKr+0XvO2gQPOgE4OmqfLwuwY=
Date: Fri, 11 Jul 2025 16:18:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.16-rc6
Message-Id: <20250711161851.7b0e9d2d962b79f38c2f67d1@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please pull this batch of hotfixes for the next -rc release,
thanks.


The following changes since commit d7b8f8e20813f0179d8ef519541a3527e7661d3a:

  Linux 6.16-rc5 (2025-07-06 14:10:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-07-11-16-16

for you to fetch changes up to db6cc3f4ac2e6cdc898fc9cbc8b32ae1bf56bdad:

  Revert "sched/numa: add statistics of numa balance task" (2025-07-09 21:07:56 -0700)

----------------------------------------------------------------
19 hotfixes.  A whopping 16 are cc:stable and the remainder address
post-6.15 issues or aren't considered necessary for -stable kernels.

14 are for MM.  Three gdb-script fixes and a kallsyms build fix.

----------------------------------------------------------------
Achill Gilgenast (1):
      kallsyms: fix build without execinfo

Alexander Gordeev (1):
      mm/vmalloc: leave lazy MMU mode on PTE mapping error

Baolin Wang (1):
      mm: fix the inaccurate memory statistics issue for users

Chen Yu (1):
      Revert "sched/numa: add statistics of numa balance task"

Christoph Berg (1):
      mm/migrate: fix do_pages_stat in compat mode

Florian Fainelli (3):
      scripts/gdb: fix interrupts display after MCP on x86
      scripts/gdb: fix interrupts.py after maple tree conversion
      scripts/gdb: de-reference per-CPU MCE interrupts

Harry Yoo (1):
      lib/alloc_tag: do not acquire non-existent lock in alloc_tag_top_users()

Honggyu Kim (4):
      samples/damon: fix damon sample prcl for start failure
      samples/damon: fix damon sample wsse for start failure
      samples/damon: fix damon sample mtier for start failure
      mm/damon: fix divide by zero in damon_get_intervals_score()

Illia Ostapyshyn (1):
      scripts: gdb: vfs: support external dentry names

Lance Yang (1):
      mm/rmap: fix potential out-of-bounds page table access during batched unmap

SeongJae Park (1):
      mm/damon/core: handle damon_call_control as normal under kdmond deactivation

Vivek Kasireddy (1):
      mm/hugetlb: don't crash when allocating a folio if there are no resv

Wei Yang (1):
      maple_tree: fix mt_destroy_walk() on root leaf node

Yeoreum Yun (1):
      kasan: remove kasan_find_vm_area() to prevent possible deadlock

 Documentation/admin-guide/cgroup-v2.rst |   6 -
 fs/proc/task_mmu.c                      |  14 +-
 include/linux/mm.h                      |   5 +
 include/linux/sched.h                   |   4 -
 include/linux/vm_event_item.h           |   2 -
 kernel/sched/core.c                     |   9 +-
 kernel/sched/debug.c                    |   4 -
 lib/alloc_tag.c                         |   3 +
 lib/maple_tree.c                        |   1 +
 mm/damon/core.c                         |   8 +-
 mm/hugetlb.c                            |   9 +-
 mm/kasan/report.c                       |  45 +-----
 mm/memcontrol.c                         |   2 -
 mm/migrate.c                            |  14 +-
 mm/rmap.c                               |  46 +++---
 mm/vmalloc.c                            |  22 ++-
 mm/vmstat.c                             |   2 -
 samples/damon/mtier.c                   |   8 +-
 samples/damon/prcl.c                    |   8 +-
 samples/damon/wsse.c                    |   8 +-
 scripts/gdb/linux/constants.py.in       |   7 +
 scripts/gdb/linux/interrupts.py         |  16 +-
 scripts/gdb/linux/mapletree.py          | 252 ++++++++++++++++++++++++++++++++
 scripts/gdb/linux/vfs.py                |   2 +-
 scripts/gdb/linux/xarray.py             |  28 ++++
 tools/include/linux/kallsyms.h          |   4 +
 26 files changed, 399 insertions(+), 130 deletions(-)
 create mode 100644 scripts/gdb/linux/mapletree.py
 create mode 100644 scripts/gdb/linux/xarray.py


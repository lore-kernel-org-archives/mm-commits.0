Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CDF3542FC;
	Thu, 29 Jan 2026 17:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708714; cv=none; b=CHF4EvZl7imJ8311C2oiIF5RNqP7KlXRW0cnRvczJZg7laS/T1a81+5L2c8v+FsDNIda0tyqgY401pWi3q1pZCBKvCkZixMMKNT5Jp8RJJwMohJZOUhFkgKviQ6jZfiRN7tSJYFaVyYdvZZw/b7yQQJl4YIc7NvwL+qRNWVa8w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708714; c=relaxed/simple;
	bh=/6Bij3SsXTuU2/orANe8p9+tCAYwwRciCDxFl8HVqdk=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=khFau7KFjrq5IkcmuVOSblDjthBYTWL7i0HmlbAmYNmpfSAFSzhwfKxsEFiSJ5hZ4rQ5Atzijai3izrhOKv+Bb2VwDjVYIA6F6WkbF6pKBfk6yspyBAcjsrEa0rmCRk6fVcewOeqfnZPPduwLd7cDQei/Zf5VI9ej7cm6j+/7Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0akjmG9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0akjmG9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A625AC4CEF7;
	Thu, 29 Jan 2026 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769708713;
	bh=/6Bij3SsXTuU2/orANe8p9+tCAYwwRciCDxFl8HVqdk=;
	h=Date:From:To:Cc:Subject:From;
	b=0akjmG9rb9fhX7DXzSBU9V/DaI4hjKXoHmSjI3SM1rSTiRMEyX5S4IKy9Fhffeds+
	 IVWBA8nGrlSXZeN1bv4HsvZzaPpGnfzRaod8fMPivarkUNE0RIoahDVpo37Gg9KL/f
	 6K0+FwY4CYKBLQj+w0UG/bWaqtSiasUp/ye751YM=
Date: Thu, 29 Jan 2026 09:45:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.19-rc8
Message-Id: <20260129094513.621310717801e65dce692162@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please pull this batch of MM and non-MM hotfixes, thanks.


The following changes since commit 6c790212c588fddeb0d852f2790840753bb604b1:

  Merge tag 'devicetree-fixes-for-6.19-3' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux (2026-01-20 15:01:15 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-29-09-41

for you to fetch changes up to bd58782995a2e6a07fd07255f3cc319f40b131c9:

  vmcoreinfo: make hwerr_data visible for debugging (2026-01-26 19:03:49 -0800)

----------------------------------------------------------------
16 hotfixes.  9 are cc:stable, 12 are for MM.

- There's a 3 patch series from Pratyush Yadav which fixes a few things
  in the new-in-6.19 LUO memfd code.

- Plus the usual shower of singletons - please see the changelogs for
  details.

----------------------------------------------------------------
Andrew Morton (1):
      kho: kho_preserve_vmalloc(): don't return 0 when ENOMEM

Andrey Ryabinin (1):
      mm/kasan: fix KASAN poisoning in vrealloc()

Breno Leitao (1):
      vmcoreinfo: make hwerr_data visible for debugging

Jan Kara (1):
      flex_proportions: make fprop_new_period() hardirq safe

Jane Chu (2):
      mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
      mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn

Kairui Song (1):
      mm/shmem, swap: fix race of truncate and swap entry split

Matthew Brost (1):
      mm/zone_device: reinitialize large zone device private folios

Pimyn Girgis (1):
      mm/kfence: randomize the freelist on initialization

Pratyush Yadav (Google) (3):
      memfd: export alloc_file()
      mm: memfd_luo: use memfd_alloc_file() instead of shmem_file_setup()
      mm: memfd_luo: restore and free memfd_luo_ser on failure

Ran Xiaokai (1):
      kho: init alloc tags when restoring pages from reserved memory

Viacheslav Bocharov (1):
      mailmap: add entry for Viacheslav Bocharov

Waiman Long (1):
      mm/mm_init: don't cond_resched() in deferred_init_memmap_chunk() if called from deferred_grow_zone()

robin.kuo (1):
      mm, swap: restore swap_space attr aviod kernel panic

 .mailmap                                 |  1 +
 arch/powerpc/kvm/book3s_hv_uvmem.c       |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  2 +-
 drivers/gpu/drm/drm_pagemap.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  2 +-
 include/linux/kasan.h                    | 14 +++++
 include/linux/memfd.h                    |  6 ++
 include/linux/memremap.h                 |  9 ++-
 kernel/liveupdate/kexec_handover.c       | 12 +++-
 kernel/vmcore_info.c                     |  6 +-
 lib/flex_proportions.c                   |  5 +-
 lib/test_hmm.c                           |  4 +-
 mm/kasan/common.c                        | 21 +++++++
 mm/kfence/core.c                         | 23 ++++++--
 mm/memfd.c                               |  4 +-
 mm/memfd_luo.c                           | 10 ++--
 mm/memory-failure.c                      | 99 +++++++++++++++++++-------------
 mm/memremap.c                            | 35 ++++++++++-
 mm/mm_init.c                             | 12 ++--
 mm/shmem.c                               | 45 +++++++++++----
 mm/swap.h                                |  2 +-
 mm/swap_state.c                          |  3 +-
 mm/vmalloc.c                             |  7 +--
 23 files changed, 239 insertions(+), 87 deletions(-)


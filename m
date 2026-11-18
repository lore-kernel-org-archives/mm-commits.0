Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794974377;
	b=fEpCwSr4ujpZ2vdwylb8zoYLTPr9Vaes23XvMHtrz2IB/gwBwBjzH3zw0cHer0fMuMms
	 LHUzPBRtWJ/obJnVLvfkVKZ1AHToNIb8QB31vMYcNbq9rWRXq2AkJLKdHAoGNt0Ix2g0G
	 GNP1Pa1dJsv2T3HUyDEQpQss5B6RNM9EnAEA1oXCeUq0VqO+fTJscaOlSak7tUVw6hzC+
	 RwG0p1NNvItbaipjoImZ7kIWHBGFg1DLEEiG58/dHEtmoC/QDe/403te80LUahvghTZLK
	 MxzC8ReoVQjerH9/LfusvjDO5b3kLbuaXkOJXIs3r/ThkBq3xHQk2fdzbG+26BA9ogg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794974377;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:X-Mailer:
	 Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=XyHm8E6N2BxawANh+DTFxuHa3dV/Ky8ta/U+foCe5G0=;
	b=TajaARElO38uiCp8CucSOgFCJAsFTq6GSZkNOaXaSlApU5sEnX7/Nu8iRGpQhlSTWOMt
	 w+E/vrO74gLF/Hd/oAbT8JbIGJq5c0okXv2h3U77q98B77TGHpCbeduck9FcBVbMP8ZCA
	 FheoyyLi4aYsPxpXO4526G1b/FW1aMOugDdVxSZK7Kca5GldcrGzVArkx00jdGZwyVZzz
	 0+K7tdxm3xPB3KfK9bKyGQOA3LUPXnx9zSWoLjBFDjtUF1vsbUXJ04R0G+Hz9mM9oXdc7
	 8N3XIZUrbeGRr91RsSTEUu50hm9MIASxwRQtco7d0kUHM0XO+39sTlbVFkhp/t9+wRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FGGzPP+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9E4606A325;
	Wed, 18 Nov 2026 03:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FGGzPP+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD361F000C9;
	Wed, 18 Nov 2026 03:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794974376;
	bh=XyHm8E6N2BxawANh+DTFxuHa3dV/Ky8ta/U+foCe5G0=;
	h=Date:From:To:Cc:Subject;
	b=FGGzPP+SEtRVhRTpBqGTZyW/9L7mrJiWNJ7j1osbATyqNtc/Z3sMU7PGu47jqM4NB
	 lA8uYRC31QY9Skm9aV4rS0caF32Q2NgVnHwij9RHIAWFM2GzHG+Nk78snqHZYfM6Dt
	 8UjvKLlWVrEK4Da8ZqaT5jjgIjb429jIwpaj3+qY=
Date: Tue, 17 Nov 2026 19:59:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>
Subject: [GIT PULL] MM hotfixes for 7.4-rc4
Message-Id: <20261117195935.25bd098c3a99c1331c6ffc01@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of MM hotfixes, thanks.


The following changes since commit fa4ad798f6f681031775266044ba1b0cf3c670bd:

  Merge tag 'for-7.4-rc1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux (2026-11-07 13:52:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-17-19-55

for you to fetch changes up to a4e667346a8d91e629a2ca9affc70dc28978f4a1:

  xarray: fix index jumping backwards in xas_find() (2026-11-09 22:44:31 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-hotfixes-stable

Everything:

Total patches:       27
Fixes: tags:         26
cc:stable patches:   23
Reviews/patch:       1.63
Reviewed rate:       81%

Summary of patch series in this merge:

- "maple_tree fixes for 7.3" (Liam R. Howlett):

  Fix an RCU reader NULL dereference when the tree is emptied during
  a walk, including /proc/PID/maps racing with munmap(). Add tests
  and make debug WARN and BUG checks report failures properly.

- "mm/kasan: Detect double-free involving kfree_rcu_sheaf()."
  (Kuniyuki Iwashima):

  Detect double-free when an object enters an RCU sheaf. KASAN could
  previously miss it until the object was reused, leading to a later
  free of a live object. Add KUnit tests for the different free orders.

- "mm: Fix page-table teardown during memory hot-remove"
  (Muchun Song):

  Balance page-table constructors and destructors when hot-remove
  frees tables on x86-64, RISC-V and arm64. This fixes NR_PAGETABLE
  accounting for tables with and without constructors.

- "mm/damon: fix watermark state, kunit pid leak and selftest fake pass"
  (SJ Park):

  Recompute watermark wait state when DAMON schemes are removed, so
  kdamond resumes monitoring. Fix a pid reference leak in KUnit and
  a selftest that reports a skipped run as a pass.

Summary of the 15 singletons in this merge:

An XArray iterator could step backwards when a large page-cache entry
was split, sending filemap_map_pages() outside the PTE page it locked.
The XArray correction and a filemap bound check prevent out-of-bounds
accesses and use-after-free. Another XArray fix prevents lockless
walkers from following a parent pointer into a freed node.

Userfaultfd now validates the whole write-protection range before
changing any VMA, avoiding partial unprotect without waking blocked
faults. Failed unmaps now abort queued UFFD_EVENT_UNMAPs; previously
they could report a nonexistent unmap, leak the userfaultfd context
and leave later operations returning -EAGAIN. A fork fix clears stale
uffd PTE bits if the new context is released before its event is read.

Moving the hugetlbfs inode trace event before RCU freeing avoids a
use-after-free of its superblock. Shmem swapin no longer retries
forever on reused swap slots containing a mismatched large swap-cache
folio. Swapoff also avoids a cluster-list loop that can soft-lock
reclaim and leave swapoff hung.

Weighted interleave recalculation now uses one node set throughout,
avoiding a divide-by-zero during memory hotplug. Hwpoison holds the
folio lock when inspecting its mapping and no longer leaks a folio
reference; it also updates poison statistics before notifying
rasdaemon through a trace event.

Cross-node migration now moves NR_FILE_THPS and NR_KERNEL_FILE_PAGES
with page-cache folios, preventing per-node and memcg-node accounting
from retaining stale counts or underflowing after the folios are freed.

----------------------------------------------------------------
Andrew Morton (1):
      mm/mempolicy: use one node set for interleave weights

Aveline Noir (1):
      mm/damon/core: reset watermark wait state on each iteration

David Hildenbrand (Arm) (1):
      mm/memory-failure: fix folio refcount leak and min_order_for_split() locking

Joas Antonio dos Santos (1):
      hugetlbfs: move hugetlbfs_free_inode tracepoint to ->destroy_inode()

Jose Fernandez (Anthropic) (1):
      mm/filemap: stop fault-around when the walk steps back

Krystian Kaniewski (1):
      xarray: fix index jumping backwards in xas_find()

Kuniyuki Iwashima (2):
      mm/kasan: detect double-free involving kfree_rcu_sheaf()
      mm/kasan/kunit: add double-free tests involving kfree_rcu_sheaf()

Liam R. Howlett (Google) (3):
      maple_tree: fix rcu reader NULL dereference after the tree is emptied
      maple_tree: test emptying tree while RCU reading
      maple_tree: update internal warning and bug_on code

Lorenzo Stoakes (ARM) (1):
      mm/vma: read anon_vma carefully in validate_mm()

Mani Tofigh (2):
      mm, swap: stop cluster list scans once swapoff clears SWP_WRITEOK
      mm/shmem: fix swapin livelock on a mismatched large swap cache folio

Mauro Carvalho Chehab (1):
      mm: memory-failure: update statistics before emitting the trace event

Mike Rapoport (Microsoft) (2):
      userfaultfd: clear uffd state in child PTEs if uffd is released during fork
      mm/vma: undo userfaultfd unmap preparation when unmapping fails

Muchun Song (4):
      mm: fix missing page-table destructor in pagetable_free()
      riscv/mm: fix hotplug page-table destructor handling
      riscv/mm: fix missing destructor for hotplug PUD tables
      arm64/mm: fix destructor for unconstructed hotplug page tables

Nickolai Zeldovich (1):
      xarray: clear the new head's parent before freeing the old head

Ridong Chen (2):
      mm/migrate: move NR_FILE_THPS on cross-node migration
      mm/migrate: move NR_KERNEL_FILE_PAGES on cross-node migration

SJ Park (1):
      selftests/damon/sysfs_memcg_path_leak: define ksft_skip

Umang Pokhriyal (1):
      userfaultfd: validate the whole range before changing write protection

Wang Xiaolei (1):
      mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets test

 arch/arm64/mm/mmu.c                                |   3 +-
 arch/riscv/mm/init.c                               |  32 ++--
 fs/hugetlbfs/inode.c                               |   2 +-
 include/linux/kasan.h                              |  15 +-
 include/linux/maple_tree.h                         |  48 +++---
 include/linux/mm.h                                 |  39 ++---
 include/linux/userfaultfd_k.h                      |   5 +
 include/trace/events/hugetlbfs.h                   |   2 +-
 lib/maple_tree.c                                   | 120 +++++++++++----
 lib/test_maple_tree.c                              | 165 +++++++++++++++++++++
 lib/test_xarray.c                                  |  70 +++++++++
 lib/xarray.c                                       |  11 +-
 mm/damon/core.c                                    |   5 +-
 mm/damon/tests/sysfs-kunit.h                       |   9 ++
 mm/filemap.c                                       |   7 +
 mm/huge_memory.c                                   |   4 +
 mm/kasan/common.c                                  |  13 +-
 mm/kasan/generic.c                                 |  17 ++-
 mm/kasan/kasan.h                                   |  34 ++++-
 mm/kasan/kasan_test_c.c                            | 139 +++++++++++++++++
 mm/memory-failure.c                                |  67 +++------
 mm/mempolicy.c                                     |  13 +-
 mm/migrate.c                                       |  10 ++
 mm/shmem.c                                         |  16 +-
 mm/slub.c                                          |  13 +-
 mm/swapfile.c                                      |   5 +
 mm/userfaultfd.c                                   |  87 +++++++----
 mm/vma.c                                           |  62 +++++---
 tools/testing/radix-tree/maple.c                   |  13 +-
 .../selftests/damon/sysfs_memcg_path_leak.sh       |   3 +
 tools/testing/shared/maple-shared.h                |  33 +++++
 tools/testing/vma/include/stubs.h                  |   4 +
 32 files changed, 858 insertions(+), 208 deletions(-)


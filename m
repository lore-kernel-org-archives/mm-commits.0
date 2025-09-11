Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F4586329;
	Thu, 11 Sep 2025 03:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757559772; cv=none; b=Le9ZW6SEngmqi5t9pq0c+VqHXAX9hpEiGT2x9X5j6iFPCkiCo0Xd2ndnm0/S18XzK4p4EzzZh1Fjfa1e5HIZkLlIOA1LLCqd/vK1qkZz3bvjuEUARfNp3jEFenJXzTLx1ZS7+kcKlyBOyOCZp3hU6VxSxWjeHEImsOQgy6pC0F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757559772; c=relaxed/simple;
	bh=LaA/VWmGiLwdH1UFM3vge6MrAkXvw9+Tei3RlIykXfY=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=XQ4qJW9euO4osI8+Jls1zCh5WSP64xbzEhs+pCCTQNCbCbtJsfFMpCFLT867Lz4QWSS8I4YYg9DpFAkBzrB/O3dcOrIuc9tDmZhsyKK4qZBuQQdp9lLiyaxnbMo7n/yTF3mTfmI18dyrWzDP3l0cBes8f0G6695uF7GA6ZnLHVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NBM/i83s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NBM/i83s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43332C4CEEB;
	Thu, 11 Sep 2025 03:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757559771;
	bh=LaA/VWmGiLwdH1UFM3vge6MrAkXvw9+Tei3RlIykXfY=;
	h=Date:From:To:Cc:Subject:From;
	b=NBM/i83sCLCRdTKnOz7AOrvq1vtPk5ndjiixThdhabcRdtLf4QwKK+7OgeZLFF0oF
	 c3sJncrmw60CBlvngEowyiRC1G0LCAUOFGwoWk31rby6GKm82KhKRw1qjzw9DXFpb1
	 1uurkySbAvpOs5GDsV7D0gOUNaYAVATofdnsGCQ0=
Date: Wed, 10 Sep 2025 20:02:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.17-rc6
Message-Id: <20250910200250.b110da062c9561aa092c479f@linux-foundation.org>
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


The following changes since commit e6b9dce0aeeb91dfc0974ab87f02454e24566182:

  Merge tag 'sound-6.17-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2025-09-02 13:38:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-10-20-00

for you to fetch changes up to a68172d95c2845d2b5455b072b4ff51ba32650e9:

  MAINTAINERS: add tree entry to numa memblocks and emulation block (2025-09-08 23:45:12 -0700)

----------------------------------------------------------------
20 hotfixes.  15 are cc:stable and the remainder address post-6.16 issues
or aren't considered necessary for -stable kernels.  14 of these fixes are
for MM.

This includes

- a 3-patch kexec series from Breno that fixes a recently introduced
  use-uninitialized bug,

- e 2-patch DAMON series from Quanmin Yan that avoids div-by-zero
  crashes which can occur if the operator uses poorly-chosen insmod
  parameters.

----------------------------------------------------------------
Breno Leitao (3):
      arm64: kexec: initialize kexec_buf struct in load_other_segments()
      riscv: kexec: initialize kexec_buf struct
      s390: kexec: initialize kexec_buf struct

Carlos Llamas (1):
      mm/mremap: fix regression in vrm->new_addr check

Jeongjun Park (1):
      mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()

Jinjiang Tu (1):
      mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range()

Kyle Meyer (1):
      mm/memory-failure: fix redundant updates for already poisoned pages

Mark Tinguely (1):
      ocfs2: fix recursive semaphore deadlock in fiemap call

Miaohe Lin (1):
      mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory

Mike Rapoport (Microsoft) (2):
      init/main.c: fix boot time tracing crash
      MAINTAINERS: add tree entry to numa memblocks and emulation block

Nathan Chancellor (1):
      compiler-clang.h: define __SANITIZE_*__ macros only when undefined

Quanmin Yan (2):
      mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()
      mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()

Sang-Heon Jeon (1):
      mm/damon/core: set quota->charged_from to jiffies at first charge window

Stanislav Fort (1):
      mm/damon/sysfs: fix use-after-free in state_show()

Uladzislau Rezki (Sony) (1):
      mm/vmalloc, mm/kasan: respect gfp mask in kasan_populate_vmalloc()

Vlad Dumitrescu (1):
      percpu: fix race on alloc failed warning limit

Wei Yang (1):
      mm/khugepaged: fix the address passed to notifier on testing young

wangzijie (1):
      proc: fix type confusion in pde_set_flags()

 MAINTAINERS                            |  1 +
 arch/arm64/kernel/machine_kexec_file.c |  2 +-
 arch/riscv/kernel/kexec_elf.c          |  4 ++--
 arch/riscv/kernel/kexec_image.c        |  2 +-
 arch/riscv/kernel/machine_kexec_file.c |  2 +-
 arch/s390/kernel/kexec_elf.c           |  2 +-
 arch/s390/kernel/kexec_image.c         |  2 +-
 arch/s390/kernel/machine_kexec_file.c  |  6 +++---
 fs/ocfs2/extent_map.c                  | 10 +++++++++-
 fs/proc/generic.c                      |  3 ++-
 include/linux/compiler-clang.h         | 29 ++++++++++++++++++++++++-----
 include/linux/kasan.h                  |  6 +++---
 init/main.c                            |  2 +-
 mm/damon/core.c                        |  4 ++++
 mm/damon/lru_sort.c                    |  5 +++++
 mm/damon/reclaim.c                     |  5 +++++
 mm/damon/sysfs.c                       | 14 +++++++++-----
 mm/hugetlb.c                           |  9 ++++++---
 mm/kasan/shadow.c                      | 31 ++++++++++++++++++++++++-------
 mm/khugepaged.c                        |  4 ++--
 mm/memory-failure.c                    | 20 +++++++++-----------
 mm/memory_hotplug.c                    | 10 ++++++++--
 mm/mremap.c                            |  9 ++++++---
 mm/percpu.c                            | 20 ++++++++++++--------
 mm/vmalloc.c                           |  8 ++++----
 25 files changed, 144 insertions(+), 66 deletions(-)


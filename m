Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142903BF692;
	Tue,  9 Jun 2026 03:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780977268; cv=none; b=rXir83nM+WGz3ts3AboyMGbOHvh2jm+QEzGHQIAXJyDnIfCmbtCBVLnV3bm9u/UryBXVLWeKk6MFLO7bTkvjWNtiL8ha+UWulS+utvrEXRVuXbhyGdagCofreGqLJ2NMdBk+GgutS+E67wGSE2TMrRxMPXsY3tYj99yIJVXRNUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780977268; c=relaxed/simple;
	bh=8G7FcVR5dQ9ii7UT2DzctQ/bd2cIHR8b8kF7WE/myR0=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=a6W8dduYTV51R/sB6hiyD4LtgF6AL+6PbHyPUH5dhAk5YWHUIxmvb424iUlQU0f6xdxMJ3/xWNuWapXYe6757a8rmpmjIKufBLe7wSgyp3sHO9LR71KMwKdvQ3t93Xq0rTfasjR8HS9/XhmuVXcc5JOU77dD+7Min/8+X/I49i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V1eRCX0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V1eRCX0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7876B1F00893;
	Tue,  9 Jun 2026 03:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780977266;
	bh=TqrgAu/JqewJItrwuRMduRmwxB/x1xVSsT3lOJ0PyWs=;
	h=Date:From:To:Cc:Subject;
	b=V1eRCX0VUSKmAYCbu72vNTgDCPEHeZ3q2KWPdEgH+NS2RH4N2EkvVGbQlXmgQylsb
	 7SmRcAr3hOfDPHGfQ1bt/JO1NlE8EBuu1W158kgptwux+Ui1Au7CMot+vRx2IXfRdh
	 Rb9UvKHr+Y/mYPhMdvlomi0FRcZSG+S8J++EEqEk=
Date: Mon, 8 Jun 2026 20:54:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes against 7.1-rc7
Message-Id: <20260608205426.3319be94a327307e23b34f3b@linux-foundation.org>
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


The following changes since commit 9d7bea186ba5a002456471edf36cc9b69f809397:

  userfaultfd: remove redundant check in vm_uffd_ops() (2026-05-31 21:50:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-06-08-20-51

for you to fetch changes up to 0c25b8734367574e21aeb8468c2e522713134da7:

  mm/mincore: handle non-swap entries before !CONFIG_SWAP guard (2026-06-03 16:25:52 -0700)

----------------------------------------------------------------
11 hotfixes.  9 are for MM.  8 are cc:stable and the remaining 3
address post-7.1 issues or aren't considered suitable for backporting.

Thre's a 2 patch series "mm/damon/{reclaim,lru_sort}: handle ctx
allocation failures" from SeongJae Park which fixes a couple of DAMON
-ENOMEM bloopers.  The rest are singletons - please see the individual
changelogs for details.

----------------------------------------------------------------
Alistair Popple (1):
      arm64: mm: call pagetable dtor when freeing hot-removed page tables

Baoquan He (1):
      MAINTAINERS: update Baoquan He's email address

Cunlong Li (1):
      zram: fix use-after-free in zram_bvec_write_partial()

Kaitao Cheng (1):
      mm/cma_sysfs: skip inactive CMA areas in sysfs

Lorenzo Stoakes (1):
      mm/huge_memory: use correct flags for device private PMD entry

SeongJae Park (2):
      mm/damon/reclaim: handle ctx allocation failure
      mm/damon/lru_sort: handle ctx allocation failure

Shakeel Butt (1):
      mm/list_lru: drain before clearing xarray entry on reparent

Usama Arif (1):
      mm/mincore: handle non-swap entries before !CONFIG_SWAP guard

Wang Yaxin (1):
      tools headers UAPI: sync linux/taskstats.h for procacct.c

Yilin Zhu (1):
      ipc/shm: serialize orphan cleanup with shm_nattch updates

 .mailmap                        |   1 +
 MAINTAINERS                     |   6 +-
 arch/arm64/mm/mmu.c             |   1 +
 drivers/block/zram/zram_drv.c   |   2 +-
 ipc/shm.c                       |  10 ++--
 mm/cma_sysfs.c                  |   8 ++-
 mm/damon/lru_sort.c             |   4 ++
 mm/damon/reclaim.c              |   4 ++
 mm/huge_memory.c                |  45 ++++++++++----
 mm/list_lru.c                   |  21 ++++---
 mm/mincore.c                    |  10 ++--
 tools/include/uapi/linux/acct.h | 128 ++++++++++++++++++++++++++++++++++++++++
 12 files changed, 204 insertions(+), 36 deletions(-)
 create mode 100644 tools/include/uapi/linux/acct.h



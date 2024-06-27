Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D6317E9;
	Thu, 27 Jun 2024 00:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719448219; cv=none; b=hfzM9iWvZFJviz96OI8pHrl7Xmv6W1qhecO/BKkrM5EL59+bEA3Z7PALgBs3Tu3WT6yBTJz9YuRGcdlcKuobOigAbvy/ZwynN0TKK0ufKvu2uFlCOc0DsPxKkN5H0TB00aLH9wXGZnA+suaA4NnrtQSpSHiutfPducHNse9KnZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719448219; c=relaxed/simple;
	bh=WURpjn1+OWCzi1P9KHg5JWMK7K5TMo+NYUY9ou0Ois0=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Ex3Te8qGHrdjDlGi0E9CBIXrpDhvVJXEZ8LeaePau3mmjC6X7M0tO2gfQR5V7dnkppUjGdMtCIdzA2Nn9liPgHIiQLBoN6lP4BCP16LL2IAudl0mJVb4+sf8wQdTtIg9dcCeJAsN82N3ezhGr0acYsQZxqeYBONdrY6GKj09UnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l8qHyN8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l8qHyN8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790AEC116B1;
	Thu, 27 Jun 2024 00:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719448218;
	bh=WURpjn1+OWCzi1P9KHg5JWMK7K5TMo+NYUY9ou0Ois0=;
	h=Date:From:To:Cc:Subject:From;
	b=l8qHyN8l2ROlPxDQgCfaMBa5CuJJcc+LB33FCmJiGFOs+XeCsuxOR6ZoC0ebvY7Mj
	 s0NJ4+OipqyhEMi9+pHBCApJ8HTwJMRGLzHObSFORfmW9J0rF6n/Fn3HrNOLbUyufi
	 RJMfksqrc0s5HhtUrgQmU9dNtdlyzeupDUs5l50A=
Date: Wed, 26 Jun 2024 17:30:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.10-rc6
Message-Id: <20240626173017.d4d69c597466bdd42da64da3@linux-foundation.org>
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


The following changes since commit f2661062f16b2de5d7b6a5c42a9a5c96326b8454:

  Linux 6.10-rc5 (2024-06-23 17:08:54 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-06-26-17-28

for you to fetch changes up to ab1ffc86cb5bec1c92387b9811d9036512f8f4eb:

  mm/memory: don't require head page for do_set_pmd() (2024-06-24 20:52:11 -0700)

----------------------------------------------------------------
13 hotfixes, 7 are cc:stable.

All are MM related apart from a MAINTAINERS update.  There is no
identifiable theme here - just singleton patches in various places.

----------------------------------------------------------------
Andrew Bresticker (1):
      mm/memory: don't require head page for do_set_pmd()

Andrey Konovalov (1):
      kasan: fix bad call to unpoison_slab_object

Christoph Hellwig (1):
      nfs: drop the incorrect assertion in nfs_swap_rw()

Jan Kara (1):
      ocfs2: fix DIO failure due to insufficient transaction credits

Jarkko Sakkinen (1):
      MAINTAINERS: TPM DEVICE DRIVER: update the W-tag

Jeff Xu (1):
      /proc/pid/smaps: add mseal info for vma

Stephen Brennan (1):
      mm: convert page type macros to enum

Suren Baghdasaryan (2):
      mm/slab: fix 'variable obj_exts set but not used' warning
      mm: handle profiling for fake memory allocations during compaction

Zhaoyang Huang (1):
      mm: fix incorrect vbq reference in purge_fragmented_block

Zi Yan (1):
      mm/migrate: make migrate_pages_batch() stats consistent

aigourensheng (1):
      selftests/mm:fix test_prctl_fork_exec return failure

yangge (1):
      mm/page_alloc: Separate THP PCP into movable and non-movable categories

 Documentation/filesystems/proc.rst                |  1 +
 MAINTAINERS                                       |  2 +-
 fs/nfs/direct.c                                   |  2 --
 fs/ocfs2/aops.c                                   |  5 +++
 fs/ocfs2/journal.c                                | 17 ++++++++++
 fs/ocfs2/journal.h                                |  2 ++
 fs/ocfs2/ocfs2_trace.h                            |  2 ++
 fs/proc/task_mmu.c                                |  3 ++
 include/linux/mm.h                                |  5 +++
 include/linux/mmzone.h                            |  9 +++---
 include/linux/page-flags.h                        | 21 +++++++------
 mm/compaction.c                                   | 11 +++++--
 mm/internal.h                                     |  5 ---
 mm/kasan/common.c                                 |  2 +-
 mm/memory.c                                       |  3 +-
 mm/migrate.c                                      |  5 +++
 mm/page_alloc.c                                   |  9 ++++--
 mm/slub.c                                         |  7 +++--
 mm/vmalloc.c                                      | 21 +++++++++----
 tools/testing/selftests/mm/ksm_functional_tests.c | 38 +++++++++++++----------
 20 files changed, 117 insertions(+), 53 deletions(-)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE4C261B77;
	Tue, 11 Nov 2025 03:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762831970; cv=none; b=iHdGGo953NA/b8UoGqAVoK1LqR6FEW+ksT3X53pNSNSB0AUt0/1pPbIfKOTLVdgvX5BGM/MSjLtEfN+zJs2akmNwb1BNEDHGbwnqOotMYcR0T6ClsUe5p4IeMSuE5Qs0856hoTdC0maizdcuxJeJDg8DPdICEOymDJqRqzwwmSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762831970; c=relaxed/simple;
	bh=LKFIiVEm2jCQZUOC18eb6X046/5tk4c9dtMUB9mF9Ls=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Zsijbz4O+VWNvMtVcPluboZO0LLxRYZX+8Q7zn/YkLK17kb+6gQUGXWbrmxkgNlrELuWCZNJ6k7THCm0nlOl/UigXu/9K1bGyA6D4oEVbnT+IE9g56rumqUEyLmwuhpb27D6z4KNP6D/K8f/aX8eoqn3PwiJP5aGL616Lu5B7cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SeG3sfe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SeG3sfe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814D0C16AAE;
	Tue, 11 Nov 2025 03:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762831968;
	bh=LKFIiVEm2jCQZUOC18eb6X046/5tk4c9dtMUB9mF9Ls=;
	h=Date:From:To:Cc:Subject:From;
	b=SeG3sfe2DH3jhwil5eCv5W1yEK1utNf2CywgT7n+h0R0RZbPrAjDUXMO/vMGGgvoK
	 fA0VHZ+1nkLvR6DcaWVZkLXOcOz/zgZa0d5iHi9wQ00/7+5gPelLIJOPw6FhGjXH5J
	 Uh6Be8m9W6raK3sYxcT45WV2l1y1soOYfX90gi2I=
Date: Mon, 10 Nov 2025 19:32:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.18-rc6
Message-Id: <20251110193247.b023ed17d73a8a82510d7002@linux-foundation.org>
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


The following changes since commit e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c:

  Linux 6.18-rc5 (2025-11-09 15:10:19 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-10-19-30

for you to fetch changes up to b05addf6f0596edb1f82ab4059438c7ef2d2686d:

  kho: warn and exit when unpreserved page wasn't preserved (2025-11-09 21:19:47 -0800)

----------------------------------------------------------------
26 hotfixes.  22(!) are cc:stable, 22 are MM.

- a three patch series from Pasha Tatashin which addresses some Kexec
  Handover issues

- a two patch series from Kiryl Shutsemau which fixes handling of large
  folios which are mapped outside i_size

- a two patch series from Quanmin Yan which fixes some DAMON time issues
  on 32-bit machines

Plus the usual shower of singletome.

----------------------------------------------------------------
Aleksei Nikiforov (1):
      mm/kmsan: fix kmsan kmalloc hook when no stack depots are allocated yet

Carlos Llamas (1):
      scripts/decode_stacktrace.sh: fix build ID and PC source parsing

Catalin Marinas (1):
      mm/huge_memory: initialise the tags of the huge zero folio

Chris Li (1):
      MAINTAINERS: add Chris and Kairui as the swap maintainer

Dev Jain (1):
      mm/mremap: honour writable bit in mremap pte batching

Edward Adam Davis (1):
      nilfs2: avoid having an active sc_timer before freeing sci

Hao Ge (1):
      codetag: debug: handle existing CODETAG_EMPTY in mark_objexts_empty for slabobj_ext

Isaac J. Manjarres (1):
      mm/mm_init: fix hash table order logging in alloc_large_system_hash()

Kairui Song (1):
      mm/shmem: fix THP allocation and fallback loop

Kiryl Shutsemau (2):
      mm/memory: do not populate page table entries beyond i_size
      mm/truncate: unmap large folio on split failure

Lance Yang (1):
      mm/secretmem: fix use-after-free race in fault handler

Martin Kaiser (1):
      maple_tree: fix tracepoint string pointers

Pasha Tatashin (3):
      kho: warn and fail on metadata or preserved memory in scratch area
      kho: increase metadata bitmap size to PAGE_SIZE
      kho: allocate metadata directly from the buddy allocator

Pedro Demarchi Gomes (1):
      ksm: use range-walk function to jump over holes in scan_get_next_rmap_item

Peter Oberparleiter (1):
      gcov: add support for GCC 15

Pratyush Yadav (3):
      kho: fix out-of-bounds access of vmalloc chunk
      kho: fix unpreservation of higher-order vmalloc preservations
      kho: warn and exit when unpreserved page wasn't preserved

Quanmin Yan (2):
      mm/damon/stat: change last_refresh_jiffies to a global variable
      mm/damon/sysfs: change next_update_jiffies to a global variable

Wei Yang (1):
      fs/proc: fix uaf in proc_readdir_de()

Zi Yan (2):
      mm/huge_memory: do not change split_huge_page*() target order silently
      mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order

 MAINTAINERS                      |   4 +-
 arch/arm64/kernel/mte.c          |   3 +-
 arch/arm64/mm/fault.c            |  10 ++++
 fs/nilfs2/segment.c              |   7 ++-
 fs/proc/generic.c                |  12 +++--
 include/linux/gfp.h              |   3 ++
 include/linux/huge_mm.h          |  55 ++++++++-----------
 kernel/Kconfig.kexec             |   9 ++++
 kernel/Makefile                  |   1 +
 kernel/gcov/gcc_4_7.c            |   4 +-
 kernel/kexec_handover.c          |  95 +++++++++++++++++++-------------
 kernel/kexec_handover_debug.c    |  25 +++++++++
 kernel/kexec_handover_internal.h |  20 +++++++
 lib/maple_tree.c                 |  30 ++++++-----
 mm/damon/stat.c                  |   9 ++--
 mm/damon/sysfs.c                 |  10 ++--
 mm/filemap.c                     |  28 +++++++---
 mm/huge_memory.c                 |  35 +++++++-----
 mm/kmsan/core.c                  |   3 --
 mm/kmsan/hooks.c                 |   6 ++-
 mm/kmsan/shadow.c                |   2 +-
 mm/ksm.c                         | 113 +++++++++++++++++++++++++++++++++++----
 mm/memory.c                      |  20 ++++++-
 mm/mm_init.c                     |   2 +-
 mm/mremap.c                      |   2 +-
 mm/secretmem.c                   |   2 +-
 mm/shmem.c                       |   9 ++--
 mm/slub.c                        |   6 ++-
 mm/truncate.c                    |  37 ++++++++++---
 scripts/decode_stacktrace.sh     |  14 ++---
 30 files changed, 424 insertions(+), 152 deletions(-)
 create mode 100644 kernel/kexec_handover_debug.c
 create mode 100644 kernel/kexec_handover_internal.h


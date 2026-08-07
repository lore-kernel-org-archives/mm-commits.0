Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E465936EAB0;
	Fri,  7 Aug 2026 01:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786067220; cv=none; b=B4c17am3qqVDbAEWLHtFsmStR2Y9fBTTKlaA44efi7JQOhZJjNhiJHlV5pmbdNsYRSv2so0DEzxmAKQx5D5vo77q0rO3kq2OA3cx0GJ5pr7yZfptar4KYKM8/+ClxRxnri5qxRwK8ZFaLcRQpEIemymIOtBf55EpJv6dfsJZA1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786067220; c=relaxed/simple;
	bh=artG6w9dg6RCdzaGbL3vw0yxFJ0mweASa6IlqgMoh4Y=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=VnuoLop8CtY98MvC2eEMM+qtmp7aRH6H1A4FGhZNb2vYNDagflzGRfD/ZnpHU82O2VFPsH6PkSMThkrLOcebB0VHCJGYIM5/bAD3utkAkoxlH4axJDnXaWrJlkQLdRK+XR16uNchNmApjli7hImiFoQsD26IROVYQYS9cQ9J/Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZSdJXIlN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZSdJXIlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2021F000E9;
	Fri,  7 Aug 2026 01:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786067216;
	bh=nU96lq1f0kDCoNVyF2FTgpj4D/KM7NZNlYwGJegVXyg=;
	h=Date:From:To:Cc:Subject;
	b=ZSdJXIlNawxFYLQLTsxSUzdaFo4X+voxe4vLGHUs27DDyYJvmVVrAQd8YbA82RR6C
	 fJRFIJ5eMmYeTKxXCl+oAc8gp8dJQ+fPKA61p55573vHURRkZjN7ne6eCzzVOG7YaQ
	 bk5fK2XMk0aLbekL45+sem/DLWWdjvJc3hEt6tCg=
Date: Thu, 6 Aug 2026 18:46:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.2-rc7
Message-Id: <20260806184655.1e970cdcb799e433d91cb8fa@linux-foundation.org>
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


The following changes since commit 9f1d75a4ce04095afdb63d8e540092ff8151dacf:

  selftests/mm: fix potential wild pointer access of getline due to missing init (2026-07-28 17:37:34 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-08-06-18-44

for you to fetch changes up to 1ec0e6b6f7321feb769f50d2f094a0aa6c2eda63:

  mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD} (2026-08-04 20:02:04 -0700)

----------------------------------------------------------------
17 hotfixes.  15 are cc:stable.  16 are for MM.

There's a 3 patch series from Lorenzo "mm: fix UAF caused by race between
ptdump and vmap pgtable freeing" which addresses a quite old bug in the
ptdump code.

And a 2 patch series also from Lorenzo which fixes a four year old bug in
the huge_zero_folio handling.

A 3 patch series from SJ fixes a few possible divide-by-zero issues which
Sashiko sniffed out.  And a 2 patch series which fixes handling of the
commit_inputs parameters.

The remainder are singletons, please see their changelogs for details.

----------------------------------------------------------------
Brendan Jackman (1):
      MAINTAINERS: update address for Brendan Jackman

Danila Tikhonov (1):
      mailmap: map old addresses to Danila Tikhonov

Hugh Dickins (1):
      mm/filemap: __filemap_add_folio() restore index before retrying

Lorenzo Stoakes (ARM) (5):
      mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF
      mm/ptdump: always stabilise against page table freeing using init_mm
      arm64: remove redundant concurrent ptdump UAF mitigation
      mm/huge_memory: fix huge_zero_pfn race
      mm/huge_memory: separate out CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic

Matt Fleming (1):
      mm/huge_memory: initialise workingset state before folio split

Ramin Moussavi (1):
      microblaze: restore the page alignment of swapper_pg_dir

SJ Park (5):
      samples/damon/mtier: error out for zero quota goal target values
      mm/damon/lru_sort: error out for >10000 active_mem_bp
      mm/damon/reclaim: skip damon_call() if ctx has not started
      mm/damon/lru_sort: skip damon_call() if ctx has not started
      mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD}

Zhiling Zou (1):
      mm/page_table_check: skip special zero mappings

liyouhong (1):
      mm/damon/ops-common: putback folios on invalid migrate nid

 .mailmap                        |   3 +
 MAINTAINERS                     |   2 +-
 arch/arm64/include/asm/ptdump.h |   2 -
 arch/arm64/mm/mmu.c             |  43 +--------
 arch/arm64/mm/ptdump.c          |  11 +--
 arch/microblaze/kernel/head.S   |   2 +
 include/linux/mmap_lock.h       |   1 +
 mm/damon/lru_sort.c             |  13 +--
 mm/damon/ops-common.c           |  13 ++-
 mm/damon/paddr.c                |   2 +
 mm/damon/reclaim.c              |  11 +--
 mm/damon/vaddr.c                |   3 +-
 mm/filemap.c                    |   6 ++
 mm/huge_memory.c                | 193 +++++++++++++++++++++++++---------------
 mm/page_table_check.c           |  20 ++++-
 mm/pagewalk.c                   |  36 ++++----
 mm/ptdump.c                     |   7 ++
 mm/vmalloc.c                    |  40 +++++++--
 samples/damon/mtier.c           |   3 +
 19 files changed, 246 insertions(+), 165 deletions(-)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F642EAE7;
	Thu, 17 Apr 2025 03:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744858923; cv=none; b=LZ7UqPgWcnQ2JjsqQL5UHHmDv35XvTsdByn+XhYPL8TUaNE54IB0XMDEdAG7LMwIPt61D+Fg5B3P3erpRmjzdczdI4QburoXjFQwNZtDdIXbHKeFLk9U99/jzmpH5ohOwRxsekL9OpIy6jpUh9j4u4+buG4HDicjL5iK72gnRw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744858923; c=relaxed/simple;
	bh=T/PYf6Vx2LUb8e64Vnd3yEiNgyfh6NqOdaYlcfMOnf0=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=D1P5GL/WR4sCwrBV3y0bRBRQoFNedhxcA8wmYEPz7d0osWtCO+XzlkGfkMtDmTZPc9FK9Wxs2YZ0gs4y/6wdqPxVyW2AuZmBC9/BrVSE1ZVr8A33hpiyRZJTly8mbtNdxv+xgjm2urSWcxPyfguL9ahBl5MUAS62T36G9XYAls4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B04gTF3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B04gTF3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B78DC4CEE2;
	Thu, 17 Apr 2025 03:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744858922;
	bh=T/PYf6Vx2LUb8e64Vnd3yEiNgyfh6NqOdaYlcfMOnf0=;
	h=Date:From:To:Cc:Subject:From;
	b=B04gTF3wvEr92rOKkULJlBM2mP6V75Pgucz5r8wmx1Y4doQolt2gxYq3zVDUTYzIV
	 z41JQuA8LNItlDhttJ5dSByP6fp0NMFnq+s3bmKTE4raPhWirDSehls5We8SgjxSD/
	 ckj/Gs03+PRoQDCY4UVeG+9lkecCDm1sSzXixfzA=
Date: Wed, 16 Apr 2025 20:02:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.15-rc2
Message-Id: <20250416200202.f5fe2bc61292d57a7a2346fd@linux-foundation.org>
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


The following changes since commit 0af2f6be1b4281385b618cb86ad946eded089ac8:

  Linux 6.15-rc1 (2025-04-06 13:11:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-04-16-19-59

for you to fetch changes up to a727a83ef22591d47e2d219cd8e01bd3616f4611:

  MAINTAINERS: update HUGETLB reviewers (2025-04-14 15:23:17 -0700)

----------------------------------------------------------------
31 hotfixes.  9 are cc:stable and the remainder address post-6.15 issues
or aren't considered necessary for -stable kernels.

22 patches are for MM, 9 are otherwise.

----------------------------------------------------------------
Alexei Starovoitov (2):
      locking/local_lock, mm: replace localtry_ helpers with local_trylock_t type
      mm/page_alloc: avoid second trylock of zone->lock

Anshuman Khandual (1):
      selftests/mm: fix compiler -Wmaybe-uninitialized warning

Arnd Bergmann (7):
      ASN.1: add module description
      samples/livepatch: add module descriptions
      fpga: tests: add module descriptions
      zlib: add module description
      ucs2_string: add module description
      mm/kasan: add module decription
      kunit: slub: add module description

Baolin Wang (1):
      selftests: mincore: fix tmpfs mincore test failure

Baoquan He (1):
      MAINTAINERS: add Andrew and Baoquan as kexec maintainers

Daniel Gomez (1):
      radix-tree: add missing cleanup.h

David Hildenbrand (1):
      mm: (un)track_pfn_copy() fix + doc improvements

Frank van der Linden (1):
      mm/cma: report base address of single range correctly

Jean-Michel Hautbois (1):
      mailmap: add entry for Jean-Michel Hautbois

Jinjiang Tu (1):
      mm/hugetlb: fix set_max_huge_pages() when there are surplus pages

Johannes Weiner (1):
      mm: page_alloc: speed up fallbacks in rmqueue_bulk()

Kirill A. Shutemov (1):
      mm: fix apply_to_existing_page_range()

Liu Shixin (1):
      mm/hugetlb: fix nid mismatch in alloc_surplus_hugetlb_folio()

Loic Poulain (1):
      mailmap: map Loic Poulain's old email addresses

Lorenzo Stoakes (1):
      mm/vma: add give_up_on_oom option on modify/merge, use in uffd release

Mark Brown (1):
      selftests/mm: generate a temporary mountpoint for cgroup filesystem

Matthew Wilcox (Oracle) (1):
      test suite: use %zu to print size_t

Oscar Salvador (1):
      MAINTAINERS: update HUGETLB reviewers

Sheng Yong (1):
      lib/iov_iter: fix to increase non slab folio refcount

T.J. Mercier (1):
      alloc_tag: handle incomplete bulk allocations in vm_module_tags_populate

Takuma Watanabe (1):
      mseal: fix typo and style in documentation

Vishal Moola (Oracle) (2):
      mm/compaction: fix bug in hugetlb handling pathway
      mm: fix filemap_get_folios_contig returning batches of identical folios

wangxuewen (1):
      mm/hugetlb: add a line break at the end of the format string

 .mailmap                                           |   3 +
 Documentation/userspace-api/mseal.rst              |   2 +-
 MAINTAINERS                                        |   4 +
 drivers/fpga/tests/fpga-bridge-test.c              |   1 +
 drivers/fpga/tests/fpga-mgr-test.c                 |   1 +
 drivers/fpga/tests/fpga-region-test.c              |   1 +
 include/linux/local_lock.h                         |  58 +-----
 include/linux/local_lock_internal.h                | 207 +++++++++------------
 include/linux/pgtable.h                            |   9 +-
 lib/alloc_tag.c                                    |  15 +-
 lib/asn1_decoder.c                                 |   1 +
 lib/iov_iter.c                                     |   2 +-
 lib/tests/slub_kunit.c                             |   1 +
 lib/ucs2_string.c                                  |   1 +
 lib/zlib_inflate/inflate_syms.c                    |   1 +
 mm/cma.c                                           |  19 +-
 mm/compaction.c                                    |   6 +-
 mm/filemap.c                                       |   1 +
 mm/hugetlb.c                                       |  23 ++-
 mm/kasan/kasan_test_c.c                            |   1 +
 mm/memcontrol.c                                    |  39 ++--
 mm/memory.c                                        |   6 +-
 mm/page_alloc.c                                    | 128 +++++++++----
 mm/userfaultfd.c                                   |  13 +-
 mm/vma.c                                           |  51 ++++-
 mm/vma.h                                           |   9 +-
 samples/livepatch/livepatch-callbacks-busymod.c    |   1 +
 samples/livepatch/livepatch-callbacks-demo.c       |   1 +
 samples/livepatch/livepatch-callbacks-mod.c        |   1 +
 samples/livepatch/livepatch-sample.c               |   1 +
 samples/livepatch/livepatch-shadow-fix1.c          |   1 +
 samples/livepatch/livepatch-shadow-fix2.c          |   1 +
 tools/testing/selftests/mincore/mincore_selftest.c |  16 +-
 .../selftests/mm/charge_reserved_hugetlb.sh        |   4 +-
 tools/testing/selftests/mm/cow.c                   |   2 +-
 .../selftests/mm/hugetlb_reparenting_test.sh       |   2 +-
 tools/testing/shared/linux.c                       |   4 +-
 tools/testing/shared/linux/cleanup.h               |   2 +
 38 files changed, 357 insertions(+), 282 deletions(-)
 create mode 100644 tools/testing/shared/linux/cleanup.h


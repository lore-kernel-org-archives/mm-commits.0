Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA7528E7;
	Tue, 29 Oct 2024 05:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730180259; cv=none; b=jclbOZuX80Uyl7jRWguJXpkEFJzvb90JKBJQ9y+pIMHV/e6hrElLkk7tb9WCOoQYZhYWxv13y/R2riMJDe/LG9FluFCTHZN4R7Z6kAKFpKbPEGRMVRUEoeeWE+Q++RO7lIOB1EyU5SrB9F90jNEvJGIwR4WI9tHgk8jk2U4Ir0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730180259; c=relaxed/simple;
	bh=9olqVLoMvTGZUqCXXqNqiQq4o9I68NSlUNbLAjZFeiI=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=WKZnp1rvqWGVrBqA7c9et/JBPLLks1uG9oneLW8rf+GoszjJPgzoRzlgq0zfvITNiZxguGM+NmQl65ldZxq4XbXyyzh1SP8VU3XCdM6OHjXHgRLBnzZzAoqBCd0jL2hkeaxVskBTvYaJsdoWLOkjugETn7In0fbdgz/mN0sD1HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1cp70fGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1cp70fGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5C1C4CECD;
	Tue, 29 Oct 2024 05:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730180258;
	bh=9olqVLoMvTGZUqCXXqNqiQq4o9I68NSlUNbLAjZFeiI=;
	h=Date:From:To:Cc:Subject:From;
	b=1cp70fGUVDTp42ha/Kg3lV86GDHc+82sK19N0SCeBYmd3/OaxelhpoF9AEb9qjg5Q
	 F0olHnxOMqtoahWLwzQrp540EV2cHcQsfWIvOqsVce2PypCdSl+tRtRt+A3bD1ialP
	 HbWDwBeBLr7SB48Jbr5R5K6h5ka/b+YiJi9IDCKI=
Date: Mon, 28 Oct 2024 22:37:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL V2] hotfixes for 6.12-rc6
Message-Id: <20241028223738.bb14a8723e947d40f3711007@linux-foundation.org>
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


The following changes since commit 81983758430957d9a5cb3333fe324fd70cf63e7e:

  Linux 6.12-rc5 (2024-10-27 12:52:02 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-10-28-21-50

for you to fetch changes up to 01626a18230246efdcea322aa8f067e60ffe5ccd:

  mm: avoid unconditional one-tick sleep when swapcache_prepare fails (2024-10-28 21:40:41 -0700)

----------------------------------------------------------------
21 hotfixes.  13 are cc:stable.  13 are MM and 8 are non-MM.

No particular theme here - mainly singletons, a couple of doubletons.
Please see the changelogs.

----------------------------------------------------------------
Barry Song (1):
      mm: avoid unconditional one-tick sleep when swapcache_prepare fails

David Hildenbrand (1):
      mm/pagewalk: fix usage of pmd_leaf()/pud_leaf() without present check

Edward Adam Davis (1):
      ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow

Edward Liaw (3):
      Revert "selftests/mm: fix deadlock for fork after pthread_create on ARM"
      Revert "selftests/mm: replace atomic_bool with pthread_barrier_t"
      selftests/mm: fix deadlock for fork after pthread_create with atomic_bool

Gregory Price (1):
      resource,kexec: walk_system_ram_res_rev must retain resource flags

Huang Ying (1):
      resource: remove dependency on SPARSEMEM from GET_FREE_REGION

Jann Horn (1):
      mm: mark mas allocation in vms_abort_munmap_vmas as __GFP_NOFAIL

Jeff Xu (1):
      mseal: update mseal.rst

Jeongjun Park (1):
      mm: shmem: fix data-race in shmem_getattr()

Kirill A. Shutemov (1):
      mm: split critical region in remap_file_pages() and invoke LSMs in between

Liam R. Howlett (1):
      mm/mmap: fix race in mmap_region() with ftruncate()

Lorenzo Stoakes (4):
      fork: do not invoke uffd on fork if error occurs
      fork: only invoke khugepaged, ksm hooks if no error
      mm/vma: add expand-only VMA merge mode and optimise do_brk_flags()
      tools: testing: add expand-only mode VMA test

Matt Fleming (1):
      mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves

Nobuhiro Iwamatsu (1):
      mm: numa_clear_kernel_node_hotplug: Add NUMA_NO_NODE check for node id

Ryusuke Konishi (1):
      nilfs2: fix kernel bug due to missing clearing of checked flag

Sabyrzhan Tasbolatov (1):
      x86/traps: move kmsan check after instrumentation_begin

 Documentation/userspace-api/mseal.rst        | 307 +++++++++++++--------------
 arch/x86/kernel/traps.c                      |  12 +-
 fs/nilfs2/page.c                             |   1 +
 fs/ocfs2/file.c                              |   8 +
 fs/userfaultfd.c                             |  28 +++
 include/linux/ksm.h                          |  10 +-
 include/linux/userfaultfd_k.h                |   5 +
 kernel/fork.c                                |  12 +-
 kernel/resource.c                            |   4 +-
 mm/Kconfig                                   |   1 -
 mm/memory.c                                  |  15 +-
 mm/mmap.c                                    |  84 ++++++--
 mm/numa_memblks.c                            |   2 +-
 mm/page_alloc.c                              |  10 +-
 mm/pagewalk.c                                |  16 +-
 mm/shmem.c                                   |   2 +
 mm/vma.c                                     |  23 +-
 mm/vma.h                                     |  26 ++-
 tools/testing/selftests/mm/uffd-common.c     |   5 +-
 tools/testing/selftests/mm/uffd-common.h     |   3 +-
 tools/testing/selftests/mm/uffd-unit-tests.c |  24 +--
 tools/testing/vma/vma.c                      |  40 ++++
 22 files changed, 386 insertions(+), 252 deletions(-)


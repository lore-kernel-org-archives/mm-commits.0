Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FAD44C94;
	Tue, 29 Oct 2024 03:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730173065; cv=none; b=Tchwy1wPpZXrwx8FVYACg56Rhbay2Jhw2AOS8Pbu+CM+wXc5igZfg7ai2YbMwCn1BTBNMsRRPfUxI9gv3AvRAajc2ylBWRfvShAS/QSRNOnDR2nw3ruFgWiHNNkYoyW8ZAk8yTvpTUBh4p2wE5+pFCWyBpfjGjnlzEa2wROuaPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730173065; c=relaxed/simple;
	bh=h7Mxw7eXmfgYdg48xlrXyjMjaIH5ef1xEQhP+Jonl6E=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=HL4vXGknzsuOIb8civL5AjD9ZpkNIJPvsk1cc+7YxIZcDCdsCy/RGW8FD4ItcQ9FkWWG/6fSq1wmy7KdC1LILwLxmp5+hi43xfo6sO8j2+DI6Bopr05RoK0bI3v2kFGb+Of9GGkNUhYlEdBnTp1BIQ4BOb8Zm167iDDPy5cUBc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m3IlS4Py; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m3IlS4Py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59700C4CECD;
	Tue, 29 Oct 2024 03:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730173064;
	bh=h7Mxw7eXmfgYdg48xlrXyjMjaIH5ef1xEQhP+Jonl6E=;
	h=Date:From:To:Cc:Subject:From;
	b=m3IlS4Py60gth7l9f0ToJfx16snNkfBWPqFNBFgaLjUhZCnjsLPDspKff+PNcOw2n
	 /JMNa0Q/Xyql0NDx+43bEgnZy8pnYUdEDX8rBv55OuTSyO+nCRtJRcql5uM6a1ovOO
	 Tv1+cIW/3rhgMZuZxxo0ufyXCjA6A4F6Gqmm/GY0=
Date: Mon, 28 Oct 2024 20:37:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.12-rc6
Message-Id: <20241028203743.3fe4d95463aaafe23a239b51@linux-foundation.org>
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

The following changes since commit 42f7652d3eb527d03665b09edac47f85fb600924:

  Linux 6.12-rc4 (2024-10-20 15:19:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-10-28-20-32

for you to fetch changes up to d7adb730fe497970555350e496478b243b5c7ec5:

  mm: avoid unconditional one-tick sleep when swapcache_prepare fails (2024-10-25 17:14:18 -0700)

----------------------------------------------------------------
23 hotfixes.  13 are cc:stable.  15 are MM and 8 are non-MM.

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

John Hubbard (2):
      mm/gup: stop leaking pinned pages in low memory conditions
      mm/gup: memfd: stop leaking pinned pages in low memory conditions

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
 mm/gup.c                                     |  52 +++--
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
 23 files changed, 419 insertions(+), 271 deletions(-)


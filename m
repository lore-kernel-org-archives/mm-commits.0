Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7F7194AF6;
	Mon, 17 Jun 2024 18:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718650034; cv=none; b=qCsRUjvXCzDojtzKkAn3yXtpYRGKj3Mw+zIV1yHvEbSwjM2XDWJwE96JkV9O2KZgn9DQdtPqtO4KpxxhL9G1B1tqkzjlfWbtGb5IBdVxfq4TXSkRpVS9m2s7jTnpnvQgOovKCOG9DlLvp3PmrH1MTrHP7BBbjh9a93/hhagf4LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718650034; c=relaxed/simple;
	bh=P9nFVL6PwUB1vuX7YltEykomKEoLB1b3dO/elBvkJdE=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=gGOzi0SQLtxvRdOMXZ/6QqJlg919TT43HD0GezTDbok55rdplwy7/sbGucDxynfcLXHUJ00Ei7n6E499VNo9LxEvJp209nL34wjRURGE4PZjzFi6Nyf4eVPIssDMsJebKWKRxoWhbuqsy24nWjQzBPNdFwExoT0k6ZKtjv02qBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u1Bp8cpa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u1Bp8cpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE0EC2BD10;
	Mon, 17 Jun 2024 18:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718650033;
	bh=P9nFVL6PwUB1vuX7YltEykomKEoLB1b3dO/elBvkJdE=;
	h=Date:From:To:Cc:Subject:From;
	b=u1Bp8cpaOA/OEAU9tqGuFRl2CjsWza9+njLV7hNB3cT1gOjoYCKqQGFBjqJquDYUq
	 a6rcnDxJalMpk+7ipsO5UDGiBO5elFGqu3nhefj8DOArb0QCCuqz8v7gT/JcKtMkvA
	 IBxENi7jrlhqLWe75jSr8yHkBBstJnQJCarCWpU8=
Date: Mon, 17 Jun 2024 11:47:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.10-rc5
Message-Id: <20240617114712.45d4743f8bacb832dea4b5a9@linux-foundation.org>
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


The following changes since commit 83a7eefedc9b56fe7bfeff13b6c7356688ffa670:

  Linux 6.10-rc3 (2024-06-09 14:19:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-06-17-11-43

for you to fetch changes up to 01c8f9806bde438ca1c8cbbc439f0a14a6694f6c:

  kcov: don't lose track of remote references during softirqs (2024-06-15 10:43:08 -0700)

----------------------------------------------------------------
19 hotfixes, 8 of which are cc:stable.

Mainly MM singleton fixes.  And a couple of ocfs2 regression fixes.

----------------------------------------------------------------
Aleksandr Nogikh (1):
      kcov: don't lose track of remote references during softirqs

Baolin Wang (1):
      mm: shmem: fix getting incorrect lruvec when replacing a shmem folio

David Hildenbrand (1):
      Revert "mm: init_mlocked_on_free_v3"

Hugh Dickins (1):
      mm/migrate: fix kernel BUG at mm/compaction.c:2761!

Jeff Xu (1):
      mm/memfd: add documentation for MFD_NOEXEC_SEAL MFD_EXEC

Joseph Qi (2):
      ocfs2: fix NULL pointer dereference in ocfs2_journal_dirty()
      ocfs2: fix NULL pointer dereference in ocfs2_abort_trigger()

Kefeng Wang (1):
      mm: fix possible OOB in numa_rebuild_large_mapping()

Lorenzo Stoakes (1):
      MAINTAINERS: remove Lorenzo as vmalloc reviewer

Mark Brown (1):
      selftests: mm: make map_fixed_noreplace test names stable

Oleg Nesterov (1):
      zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING

Peter Oberparleiter (1):
      gcov: add support for GCC 14

Peter Xu (2):
      mm/page_table_check: fix crash on ZONE_DEVICE
      mm/debug_vm_pgtable: drop RANDOM_ORVALUE trick

Rafael Aquini (1):
      mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default

Ran Xiaokai (1):
      mm: huge_memory: fix misused mapping_large_folio_support() for anon folios

Suren Baghdasaryan (2):
      lib/alloc_tag: do not register sysctl interface when CONFIG_SYSCTL=n
      lib/alloc_tag: fix RCU imbalance in pgalloc_tag_get()

Yury Norov (1):
      gcc: disable '-Warray-bounds' for gcc-9

 Documentation/admin-guide/kernel-parameters.txt  |   6 -
 Documentation/userspace-api/index.rst            |   1 +
 Documentation/userspace-api/mfd_noexec.rst       |  86 ++++++++++
 MAINTAINERS                                      |   1 -
 arch/Kconfig                                     |  12 ++
 fs/ocfs2/journal.c                               | 192 +++++++++++++----------
 fs/ocfs2/ocfs2.h                                 |  27 ++++
 fs/ocfs2/super.c                                 |   4 +-
 include/linux/kcov.h                             |   2 +
 include/linux/mm.h                               |   9 +-
 include/linux/pagemap.h                          |   4 +
 include/linux/pgalloc_tag.h                      |  11 +-
 init/Kconfig                                     |   2 +-
 kernel/gcov/gcc_4_7.c                            |   4 +-
 kernel/kcov.c                                    |   1 +
 kernel/pid_namespace.c                           |   1 +
 lib/alloc_tag.c                                  |  16 +-
 mm/debug_vm_pgtable.c                            |  31 +---
 mm/huge_memory.c                                 |  28 ++--
 mm/internal.h                                    |   1 -
 mm/memcontrol.c                                  |   3 +-
 mm/memory.c                                      |  20 +--
 mm/migrate.c                                     |   8 +-
 mm/mm_init.c                                     |  43 +----
 mm/page_alloc.c                                  |   2 +-
 mm/page_table_check.c                            |  11 +-
 mm/shmem.c                                       |   2 +-
 security/Kconfig.hardening                       |  15 --
 tools/testing/selftests/mm/map_fixed_noreplace.c |  24 ++-
 29 files changed, 345 insertions(+), 222 deletions(-)
 create mode 100644 Documentation/userspace-api/mfd_noexec.rst


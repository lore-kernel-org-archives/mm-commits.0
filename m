Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E8F15443C;
	Sun, 10 Nov 2024 09:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731231909; cv=none; b=QYUYZRBc5uq4IEZYEi2I5c5eMubtoMwgY0i7E+rYI2XIoHsCUBReBHJ7UVppTodzIh42GsPDjhYBQE9qcozg6fckMBw10eik6uKwbmXrC4C1RTydSCEAF6py1+Aaj9by29xfOU04hl+9NvTQ3xVkpD9guMS8RN+lmskkPz85YnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731231909; c=relaxed/simple;
	bh=3wkqWUW1Et9tJfzKL8re7wqENmSdU2idaeVd1VHX6sI=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=rTlNlcdGejoDEErQEOsWo7FigpeKDKW9KeB7TLaMXD2old5GXClesgd5HCvjb7P7z1sM9d5wFOuWj4m1LM8etNkkVOL2mV4svMtxZO0+IF73mzXIJcNyr3ETdCndZsPH3R7vwcUOs8ZPF+T5pk9DBBh66/54/LuTcg79ClX9Gz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lq7AHUTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lq7AHUTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42F8C4CECD;
	Sun, 10 Nov 2024 09:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731231909;
	bh=3wkqWUW1Et9tJfzKL8re7wqENmSdU2idaeVd1VHX6sI=;
	h=Date:From:To:Cc:Subject:From;
	b=Lq7AHUTdnpLeFWV+SBSARtLlOlsAi9H51J3zbCaaf25XPbcA/kmhlZToj5REz3lJ4
	 1FVqxt8SYyFmeETNzv+Xda8uTSO7E6h1D/AemfF/5tTxPfMY6HSjBodh5Hx0rkvVKj
	 Bihi3qQOoHVYeMoLrnMgQTVbegr+/ybfv5VYeB9w=
Date: Sun, 10 Nov 2024 01:45:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.12-rc7
Message-Id: <20241110014508.c2626adfff36ba70af88b0a0@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please pull this batch of hotfixes, thanks.


The following changes since commit 59b723cd2adbac2a34fc8e12c74ae26ae45bf230:

  Linux 6.12-rc6 (2024-11-03 14:05:52 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2024-11-09-22-40

for you to fetch changes up to c289f4de8e479251b64988839fd0e87f246e03a2:

  mailmap: add entry for Thorsten Blum (2024-11-07 14:14:59 -0800)

----------------------------------------------------------------
20 hotfixes, 14 of which are cc:stable.

Three affect DAMON.  Lorenzo's five-patch series to address the
mmap_region error handling is here also.

Apart from that, various singletons.

----------------------------------------------------------------
Andrei Vagin (1):
      ucounts: fix counter leak in inc_rlimit_get_ucounts()

Andrew Kanner (1):
      ocfs2: remove entry once instead of null-ptr-dereference in ocfs2_xa_=
remove()

Hugh Dickins (2):
      mm/thp: fix deferred split queue not partially_mapped
      mm/thp: fix deferred split unqueue naming and locking

Lorenzo Stoakes (5):
      mm: avoid unsafe VMA hook invocation when error arises on mmap hook
      mm: unconditionally close VMAs on error
      mm: refactor map_deny_write_exec()
      mm: refactor arch_calc_vm_flag_bits() and arm64 MTE handling
      mm: resolve faulty mmap_region() error path behaviour

Masami Hiramatsu (Google) (1):
      objpool: fix to make percpu slot allocation more robust

Ma=EDra Canal (1):
      mm: fix docs for the kernel parameter ``thp_anon=3D``

Muhammad Usama Anjum (1):
      selftests: hugetlb_dio: check for initial conditions to skip in the s=
tart

Qi Xi (1):
      fs/proc: fix compile warning about variable 'vmcore_mmap_ops'

Roman Gushchin (1):
      signal: restore the override_rlimit logic

SeongJae Park (3):
      mm/damon/core: handle zero {aggregation,ops_update} intervals
      mm/damon/core: handle zero schemes apply interval
      mm/damon/core: avoid overflow in damon_feed_loop_next_input()

Thorsten Blum (1):
      mailmap: add entry for Thorsten Blum

Wei Yang (1):
      mm/mlock: set the correct prev on failure

Yu Zhao (1):
      mm/page_alloc: keep track of free highatomic

 .mailmap                                        |   1 +
 Documentation/admin-guide/kernel-parameters.txt |   2 +-
 Documentation/admin-guide/mm/transhuge.rst      |   2 +-
 arch/arm64/include/asm/mman.h                   |  10 +-
 arch/parisc/include/asm/mman.h                  |   5 +-
 fs/ocfs2/xattr.c                                |   3 +-
 fs/proc/vmcore.c                                |   9 +-
 include/linux/mman.h                            |  28 +++--
 include/linux/mmzone.h                          |   1 +
 include/linux/user_namespace.h                  |   3 +-
 kernel/signal.c                                 |   3 +-
 kernel/ucount.c                                 |   9 +-
 lib/objpool.c                                   |  18 ++--
 mm/damon/core.c                                 |  42 +++++---
 mm/huge_memory.c                                |  56 +++++++---
 mm/internal.h                                   |  55 +++++++++-
 mm/memcontrol-v1.c                              |  25 +++++
 mm/memcontrol.c                                 |   9 +-
 mm/migrate.c                                    |   4 +-
 mm/mlock.c                                      |   9 +-
 mm/mmap.c                                       | 130 +++++++++++++-------=
----
 mm/mprotect.c                                   |   2 +-
 mm/nommu.c                                      |   9 +-
 mm/page_alloc.c                                 |  16 +--
 mm/shmem.c                                      |   3 -
 mm/swap.c                                       |   4 +-
 mm/vma.c                                        |  14 +--
 mm/vma.h                                        |   6 +-
 mm/vmscan.c                                     |   4 +-
 tools/testing/selftests/mm/hugetlb_dio.c        |  19 ++--
 30 files changed, 329 insertions(+), 172 deletions(-)


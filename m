Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDD9C120;
	Mon, 23 Jun 2025 01:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750643712; cv=none; b=VuueaN7HVJe1gj1mj7u4oyQpmGA0Y7Dy/LJ7sftElCLNBuLvqH2WhxI4B0oCB9PMb6BOkpu+T6sbakC92dbquYE857cVw6DtVyprMwbjbPQeVOhekbRdS5sx+VlCfFqIZj83QilXh3C6FlU9CusDFlLdi46E/ImFxz4t/MNdlhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750643712; c=relaxed/simple;
	bh=9cFlEUoSXzuVkaDJmNBJnormf9antQdBn1PhkiCaI7c=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=CxkMWUNix9QEIwdJ7z1kVEKw2zTNnHoRckOOCPkhED0RZkh11AjCMSTMw/qog8d41k3gdNfHDfPrgN1y8Q5NjlJo9Hom2cqNIr5eA9aI8xagHqm4pM1a/0pRasX8gesZT7FWfacazprlW7zHsvYrl6GbA/K7M+brdb0tT8zKq/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vm/KT6rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vm/KT6rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0E7C4CEE3;
	Mon, 23 Jun 2025 01:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750643711;
	bh=9cFlEUoSXzuVkaDJmNBJnormf9antQdBn1PhkiCaI7c=;
	h=Date:From:To:Cc:Subject:From;
	b=Vm/KT6rlFK73BnX66pXhE0VslsCvQhAocn7AsOWBn+t/tAekROFqsktMEQdVunfNs
	 tYABL3tDMMoD5iBrWvjSX6AWrxWAjWptweOxaLrA8JxSoaXgWzzsddbslR2yacG3j9
	 oDNKZnB3U2PwF0plZvP46l5Hf80HoJ7uYY9ZNnsk=
Date: Sun, 22 Jun 2025 18:55:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.16-rc4
Message-Id: <20250622185510.662af99051fedc1815b9de00@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please pull this batch of hotfixes, thanks.


The following changes since commit e04c78d86a9699d136910cfc0bdcf01087e3267e:

  Linux 6.16-rc2 (2025-06-15 13:49:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-06-22-18-52

for you to fetch changes up to c742d127d2d831aa83ae2987a508bca2bf0c7736:

  MAINTAINERS: add additional mmap-related files to mmap section (2025-06-19 20:48:05 -0700)

----------------------------------------------------------------
20 hotfixes.  7 are cc:stable and the remainder address post-6.15 issues
or aren't considered necessary for -stable kernels.  Only 4 are for MM.

- The 3 patch series `Revert "bcache: update min_heap_callbacks to use
  default builtin swap"' from Kuan-Wei Chiu backs out the author's recent
  min_heap changes due to a performance regression.  A fix for this
  regression has been developed but we felt it best to go back to the
  known-good version to give the new code more bake time.

- A lot of MAINTAINERS maintenance.  I like to get these changes
  upstreamed promptly because they can't break things and more
  accurate/complete MAINTAINERS info hopefully improves the speed and
  accuracy of our responses to submitters and reporters.

----------------------------------------------------------------
David Hildenbrand (1):
      mm/gup: revert "mm: gup: fix infinite loop within __get_longterm_locked"

Dev Jain (1):
      selftests/mm: add configs to fix testcase failure

Kairui Song (2):
      mm/shmem, swap: fix softlockup with mTHP swapin
      mm: userfaultfd: fix race of userfaultfd_move and swap cache

Kuan-Wei Chiu (3):
      Revert "bcache: update min_heap_callbacks to use default builtin swap"
      Revert "bcache: remove heap-related macros and switch to generic min_heap"
      bcache: remove unnecessary select MIN_HEAP

Liam R. Howlett (1):
      maple_tree: fix MA_STATE_PREALLOC flag in mas_preallocate()

Lorenzo Stoakes (7):
      MAINTAINERS: add missing mm/workingset.c file to mm reclaim section
      MAINTAINERS: add missing test files to mm gup section
      MAINTAINERS: add further init files to mm init block
      MAINTAINERS: add hugetlb_cgroup.c to hugetlb section
      MAINTAINERS: add stray rmap file to mm rmap section
      MAINTAINERS: add memfd, shmem quota files to shmem section
      MAINTAINERS: add additional mmap-related files to mmap section

Oscar Salvador (1):
      MAINTAINERS: update maintainers for HugeTLB

Pedro Falcato (1):
      selftests/mm: skip uprobe vma merge test if uprobes are not enabled

Pratyush Yadav (2):
      MAINTAINERS: add linux-mm@ list to Kexec Handover
      kho: initialize tail pages for higher order folios properly

Shivank Garg (1):
      selftests/mm: increase timeout from 180 to 900 seconds

 MAINTAINERS                         |  21 ++++++-
 drivers/md/bcache/Kconfig           |   1 -
 drivers/md/bcache/alloc.c           |  57 ++++++------------
 drivers/md/bcache/bcache.h          |   2 +-
 drivers/md/bcache/bset.c            | 116 ++++++++++++++----------------------
 drivers/md/bcache/bset.h            |  40 +++++++------
 drivers/md/bcache/btree.c           |  69 +++++++++------------
 drivers/md/bcache/extents.c         |  45 ++++++--------
 drivers/md/bcache/movinggc.c        |  33 ++++------
 drivers/md/bcache/super.c           |   3 +-
 drivers/md/bcache/sysfs.c           |   4 +-
 drivers/md/bcache/util.h            |  67 ++++++++++++++++++++-
 drivers/md/bcache/writeback.c       |  13 ++--
 kernel/kexec_handover.c             |  29 +++++----
 lib/maple_tree.c                    |   4 +-
 mm/gup.c                            |  14 +++--
 mm/memory.c                         |  20 -------
 mm/shmem.c                          |   6 +-
 mm/swap.h                           |  23 +++++++
 mm/userfaultfd.c                    |  33 +++++++++-
 tools/testing/selftests/mm/config   |   3 +
 tools/testing/selftests/mm/merge.c  |   5 +-
 tools/testing/selftests/mm/settings |   2 +-
 23 files changed, 333 insertions(+), 277 deletions(-)


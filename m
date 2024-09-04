Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F086D4776E;
	Wed,  4 Sep 2024 03:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725420413; cv=none; b=NF6F41AKCPA7brLCWxE0i9+s+JzocVRVeSaRgbH2t0Cq8RWUGvWLlj0obO4eTdHFAJR7XnH6wgqspPc0nNAJZq650snfIR0byUBtrt5LmPXbkxE/YZZbCKjim4kvEaHY+KLcq8wSc/GHen8v5zvoOd6NG+q9pVDrxK/DOZ1tG84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725420413; c=relaxed/simple;
	bh=Gb9HgOw6SwMHu+m6RoFCLfrFFn7egZTm/+TNsO2o4WQ=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=GbjM+WrPCmCZouS0UybHVUMQGH+qj6Eo1yrjSccg4yh+4Yu8tmU5mbeEsQbcqtJ7nX9WVTKHDbYpT5sK/UA7PT3tYG6tYJbiuDhFd1iytzpRoM7vzJy1zQvSR4gwIEDNv+ANGbrLY7I/fzvpGNjk6HMyQYv7zAZBjtn/QIn828M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yHJJwlLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yHJJwlLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDD2C4CEC2;
	Wed,  4 Sep 2024 03:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725420412;
	bh=Gb9HgOw6SwMHu+m6RoFCLfrFFn7egZTm/+TNsO2o4WQ=;
	h=Date:From:To:Cc:Subject:From;
	b=yHJJwlLbT55mciZh8f0oDoniKaNmUXIP03ZznNj31Z64sCxHf2L4t6A69tz/1crDm
	 Xv257ILyUlotOqQSGXcwzdCmXUq1KNg2T/ipFy8Pls3VzhGZOx1bBmxlnMArhwrzHy
	 Nl/ht4ZA9oeYLGozwQ//iiZoIdKcUYC+BhcB5ccU=
Date: Tue, 3 Sep 2024 20:26:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.11-rc7
Message-Id: <20240903202651.f258324d271b4813dfa8de7a@linux-foundation.org>
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


The following changes since commit 431c1646e1f86b949fa3685efc50b660a364c2b6:

  Linux 6.11-rc6 (2024-09-01 19:46:02 +1200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-09-03-20-19

for you to fetch changes up to 052a45c1cb1b32f05dd63a295d65496d8b403283:

  alloc_tag: fix allocation tag reporting when CONFIG_MODULES=n (2024-09-01 17:59:03 -0700)

----------------------------------------------------------------
17 hotfixes, 15 of which are cc:stable.

Mostly MM, no identifiable theme.  And a few nilfs2 fixups.

----------------------------------------------------------------
Adrian Huang (1):
      mm: vmalloc: optimize vmap_lazy_nr arithmetic when purging each vmap_area

Hao Ge (2):
      mm/slub: add check for s->flags in the alloc_tagging_slab_free_hook
      codetag: debug: mark codetags for poisoned page as empty

Jan Kuliga (1):
      mailmap: update entry for Jan Kuliga

Jann Horn (2):
      userfaultfd: fix checks for huge PMDs
      userfaultfd: don't BUG_ON() if khugepaged yanks our page table

Liam R. Howlett (1):
      maple_tree: remove rcu_read_lock() from mt_validate()

Marc Zyngier (1):
      scripts: fix gfp-translate after ___GFP_*_BITS conversion to an enum

Mike Yuan (1):
      mm/memcontrol: respect zswap.writeback setting from parent cg too

Muhammad Usama Anjum (1):
      selftests: mm: fix build errors on armhf

Petr Tesarik (1):
      kexec_file: fix elfcorehdr digest exclusion when CONFIG_CRASH_HOTPLUG=y

Ryusuke Konishi (3):
      nilfs2: protect references to superblock parameters exposed in sysfs
      nilfs2: fix missing cleanup on rollforward recovery error
      nilfs2: fix state management in error path of log writing function

Suren Baghdasaryan (1):
      alloc_tag: fix allocation tag reporting when CONFIG_MODULES=n

Usama Arif (1):
      Revert "mm: skip CMA pages when they are not available"

Will Deacon (1):
      mm: vmalloc: ensure vmap_block is initialised before adding to queue

 .mailmap                                |  1 +
 Documentation/admin-guide/cgroup-v2.rst |  7 ++--
 fs/nilfs2/recovery.c                    | 35 ++++++++++++++++-
 fs/nilfs2/segment.c                     | 10 +++--
 fs/nilfs2/sysfs.c                       | 43 ++++++++++++++++-----
 kernel/kexec_file.c                     |  2 +-
 lib/codetag.c                           | 17 ++++++---
 lib/maple_tree.c                        |  7 +---
 mm/memcontrol.c                         | 12 ++++--
 mm/page_alloc.c                         |  7 ++++
 mm/slub.c                               |  4 ++
 mm/userfaultfd.c                        | 29 ++++++++-------
 mm/vmalloc.c                            |  7 +++-
 mm/vmscan.c                             | 24 +-----------
 scripts/gfp-translate                   | 66 ++++++++++++++++++++++++---------
 tools/testing/selftests/mm/mseal_test.c | 37 +++++++-----------
 tools/testing/selftests/mm/seal_elf.c   | 13 +------
 17 files changed, 197 insertions(+), 124 deletions(-)


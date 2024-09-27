Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B346B139587;
	Fri, 27 Sep 2024 16:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727455662; cv=none; b=tHM557a24jsfqxpToQ5dXJA2H5zWF2XYIToMUM3wf2A0EHIkyYS9HKJPDAwNUiF6aTQ+UfZEH6fdTQ3pkFRw0agQdjBv16YB8vbijltdF1wS/KRtFiWcrXW0VmVsoh9Eyc2xaHpFLj2vpjjgeNW4m/WwaKqU5BaDxKdHVQJvk2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727455662; c=relaxed/simple;
	bh=YiIlX3DiMKQ7D0i0kaflLjAuElpI3TBRCPxZ5j8B+FI=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=PnHo8RnWGWPDLDecou4Wl+tSjipARMq6HbBJRFOST+pMHJ2zkqPn/Rbi5pIpnmfVwKRf/JtovTDKVIq4PKL8EoGer7IEujruclala5pazeALnXoujEjJZtP6lm3Zjv7txNqMHOq9yhRHnmNmlWA5S1mnDq1Ubo5jhWFfA7il6iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Atw1ajzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Atw1ajzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012F2C4CEC4;
	Fri, 27 Sep 2024 16:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727455661;
	bh=YiIlX3DiMKQ7D0i0kaflLjAuElpI3TBRCPxZ5j8B+FI=;
	h=Date:From:To:Cc:Subject:From;
	b=Atw1ajzL+k+4JaRM381/iMJTRT70Zn3wbDpU0r8/Xzl/pQ7Rr+fcV8r5Vo/OX0wYJ
	 n0lVxokIAmuTqA2MioV9y7U43npiEVSKPgBt55QkoW4k4wmy2cICOsSFimaffkHTkB
	 nt5x+Ij8HEUq9524uchIWp56cFcgOkU6eEwuAATo=
Date: Fri, 27 Sep 2024 09:47:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.12-rc1
Message-Id: <20240927094740.1a82b77b071feb9027621bed@linux-foundation.org>
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

The following changes since commit abf2050f51fdca0fd146388f83cddd95a57a008d:

  Merge tag 'media/v6.12-1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2024-09-23 15:27:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-09-27-09-45

for you to fetch changes up to 2af148ef8549a12f8025286b8825c2833ee6bcb8:

  ocfs2: fix uninit-value in ocfs2_get_block() (2024-09-26 14:01:45 -0700)

----------------------------------------------------------------
19 hotfixes.  13 are cc:stable.

There's a focus on fixes for the memfd_pin_folios() work which was added
into 6.11.  Apart from that, the usual shower of singleton fixes.

----------------------------------------------------------------
Andrey Skvortsov (1):
      zram: don't free statically defined names

Diederik de Haas (1):
      mm/damon/Kconfig: update DAMON doc URL

Gautham Ananthakrishna (1):
      ocfs2: reserve space for inline xattr before attaching reflink tree

Guenter Roeck (2):
      mm: make SPLIT_PTE_PTLOCKS depend on SMP
      Revert "list: test: fix tests for list_cut_position()"

Huang Ying (1):
      memory tiers: use default_dram_perf_ref_source in log message

Jeongjun Park (1):
      mm: migrate: annotate data-race in migrate_folio_unmap()

Joseph Qi (1):
      ocfs2: fix uninit-value in ocfs2_get_block()

Lorenzo Stoakes (1):
      tools: fix shared radix-tree build

Mohammed Anees (1):
      ocfs2: fix deadlock in ocfs2_get_system_file_inode

Muhammad Usama Anjum (1):
      kselftests: mm: fix wrong __NR_userfaultfd value

Steve Sistare (6):
      mm/filemap: fix filemap_get_folios_contig THP panic
      mm/hugetlb: fix memfd_pin_folios free_huge_pages leak
      mm/hugetlb: fix memfd_pin_folios resv_huge_pages leak
      mm/gup: fix memfd_pin_folios hugetlb page allocation
      mm/gup: fix memfd_pin_folios alloc race panic
      mm/hugetlb: simplify refs in memfd_alloc_folio

Tiezhu Yang (1):
      compiler.h: specify correct attribute for .rodata..c_jump_table

qiwu.chen (1):
      mm: kfence: fix elapsed time for allocated/freed track

 drivers/block/zram/zram_drv.c              |  6 ++++--
 fs/ocfs2/aops.c                            |  5 ++---
 fs/ocfs2/extent_map.c                      |  8 +++++++-
 fs/ocfs2/refcounttree.c                    | 26 ++++++++++++++++++++++++--
 fs/ocfs2/xattr.c                           | 11 +----------
 include/linux/compiler.h                   |  2 +-
 include/linux/hugetlb.h                    | 10 ++++++++++
 lib/list-test.c                            |  6 ------
 mm/Kconfig                                 |  1 +
 mm/damon/Kconfig                           |  2 +-
 mm/filemap.c                               |  4 ++++
 mm/gup.c                                   |  1 +
 mm/hugetlb.c                               | 17 +++++++++++++++++
 mm/kfence/report.c                         |  2 +-
 mm/memfd.c                                 | 18 ++++++++++--------
 mm/memory-tiers.c                          |  6 +++---
 mm/migrate.c                               |  2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c |  2 +-
 tools/testing/shared/maple-shared.h        |  4 ++++
 tools/testing/shared/shared.h              |  4 ++++
 tools/testing/shared/shared.mk             |  4 +++-
 tools/testing/shared/xarray-shared.h       |  4 ++++
 22 files changed, 104 insertions(+), 41 deletions(-)


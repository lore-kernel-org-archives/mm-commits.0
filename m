Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1033E46B8;
	Sun,  8 Dec 2024 06:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733640099; cv=none; b=YG2SXpJl1EHpqhqdVBPWguM2eJv1/NlR5MkWCzG4PTwFKK2/qbK+jV6Itf8Btm3wugRXeDuElzZ6pjDLCKkJagmeDqeTRhXlpgw0lxBwmRHRTJ1puIfgvYS+ezIj0PfmSV+Ds/YzVWZBMe4bMIs3TR0Zaneu1uNqYdErP8boc2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733640099; c=relaxed/simple;
	bh=qJkNX+11tG/z68nLHKBcMYXpE03KmynQV32MoGxy+iM=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=iCM1UWFhq/xSdcaY7UiyeLoCGxPyKCc9qfCB4BMuMs0eb9sq088i0f5rBQaja46T1xpRuyeuYSn2tDBqKZOrbPbP70kncHzn/OLGtjz2bQfZFkKlp6PEQQ14CF821mSAONbHNZjw18aatW89kUu3EHKcfs3Yv536nIi7W9mpXJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rGs7NqF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rGs7NqF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505DBC4CED2;
	Sun,  8 Dec 2024 06:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733640098;
	bh=qJkNX+11tG/z68nLHKBcMYXpE03KmynQV32MoGxy+iM=;
	h=Date:From:To:Cc:Subject:From;
	b=rGs7NqF22ASXnfGqKMSHX/1xvPD+T1/dPXck+RMhXxsukIGawQVD6Az0RU0okZKc4
	 cLZ0FKn3+0GR1+GeNMIbvRdWGE66EWVobKNXbTuSyRbXEkCvDCltKb21UzQQQThjUL
	 bC918jTBdfMYXZ9NScdqhdc/JK34xwJRqBRT+Ld8=
Date: Sat, 7 Dec 2024 22:41:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
 linux-mm@kvack.org
Subject: [GIT PULL] hotfixes for 6.13-rc2
Message-Id: <20241207224137.b8aa7ed632f97dd07ff201e0@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this patch of hotfixes, thanks.


The following changes since commit 40384c840ea1944d7c5a392e8975ed088ecf0b37:

  Linux 6.13-rc1 (2024-12-01 14:28:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-12-07-22-39

for you to fetch changes up to f1ee5483e40881d8ad5a63aa148b753b5c6a839b:

  iio: magnetometer: yas530: use signed integer type for clamp limits (2024-12-05 19:54:48 -0800)

----------------------------------------------------------------
24 hotfixes.  17 are cc:stable.  15 are MM and 9 are non-MM.

The usual bunch of singletons - please see the relevant changelogs for
details.

----------------------------------------------------------------
Adrian Huang (1):
      sched/numa: fix memory leak due to the overwritten vma->numab_state

Akinobu Mita (1):
      mm/damon: fix order of arguments in damos_before_apply tracepoint

Andrew Morton (1):
      fs/proc/vmcore.c: fix warning when CONFIG_MMU=n

Andrii Nakryiko (1):
      mm: fix vrealloc()'s KASAN poisoning logic

David Hildenbrand (2):
      mm/mempolicy: fix migrate_to_node() assuming there is at least one VMA in a MM
      mm/filemap: don't call folio_test_locked() without a reference in next_uptodate_folio()

David Wang (1):
      mm/codetag: swap tags when migrate pages

Jakob Hauser (1):
      iio: magnetometer: yas530: use signed integer type for clamp limits

Jan Kara (1):
      Revert "readahead: properly shorten readahead when falling back to do_page_cache_ra()"

Jared Kangas (1):
      kasan: make report_lock a raw spinlock

John Hubbard (1):
      mm/gup: handle NULL pages in unpin_user_pages()

John Sperbeck (1):
      mm: memcg: declare do_memsw_account inline

Kalesh Singh (1):
      mm: respect mmap hint address when aligning for THP

Kees Cook (1):
      lib: stackinit: hide never-taken branch from compiler

Lorenzo Stoakes (1):
      mm: correct typo in MMAP_STATE() macro

Marco Elver (1):
      stackdepot: fix stack_depot_save_flags() in NMI context

Mark Brown (1):
      selftest: hugetlb_dio: fix test naming

Matthew Wilcox (Oracle) (2):
      mm: open-code PageTail in folio_flags() and const_folio_flags()
      mm: open-code page_folio() in dump_page()

Maximilian Heyne (1):
      selftests/damon: add _damon_sysfs.py to TEST_FILES

Randy Dunlap (1):
      scatterlist: fix incorrect func name in kernel-doc

Ryusuke Konishi (1):
      nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()

Tetsuo Handa (1):
      ocfs2: free inode when ocfs2_get_init_inode() fails

Wengang Wang (1):
      ocfs2: update seq_file index in ocfs2_dlm_seq_next

 drivers/iio/magnetometer/yamaha-yas530.c | 13 ++++----
 fs/nilfs2/dir.c                          |  2 +-
 fs/ocfs2/dlmglue.c                       |  1 +
 fs/ocfs2/namei.c                         |  4 ++-
 fs/proc/vmcore.c                         | 56 ++++++++++++++++----------------
 include/linux/page-flags.h               |  4 +--
 include/linux/pgalloc_tag.h              |  4 +--
 include/linux/scatterlist.h              |  2 +-
 include/linux/stackdepot.h               |  6 ++--
 include/trace/events/damon.h             |  2 +-
 kernel/sched/fair.c                      | 12 +++++--
 lib/alloc_tag.c                          | 36 ++++++++++++--------
 lib/stackdepot.c                         | 10 +++++-
 lib/stackinit_kunit.c                    |  1 +
 mm/debug.c                               |  7 ++--
 mm/filemap.c                             |  4 +--
 mm/gup.c                                 | 11 ++++++-
 mm/kasan/report.c                        |  6 ++--
 mm/memcontrol-v1.h                       |  2 +-
 mm/mempolicy.c                           |  4 +++
 mm/migrate.c                             |  2 +-
 mm/mmap.c                                |  1 +
 mm/readahead.c                           |  5 ++-
 mm/vma.c                                 |  2 +-
 mm/vmalloc.c                             |  3 +-
 tools/testing/selftests/damon/Makefile   |  2 +-
 tools/testing/selftests/mm/hugetlb_dio.c | 14 +++-----
 27 files changed, 128 insertions(+), 88 deletions(-)


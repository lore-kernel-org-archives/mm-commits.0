Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D9D3655D8;
	Mon, 27 Jul 2026 21:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187217; cv=none; b=bW1dbgy0njq/yeg9T2NctpJAMvnJUfTOj/GaYOUpJTNoCELv5kXrRl1mvzG71MxbBKb2KPP5Y4WyZOLBviGU7IlEwLzyzoC59FLaefzDSv0xtfqUCwrmLvG5xijWHyPtf8V5sSDGpf34mrxTlJx6mF57yP9r9Z6QNPsrhNbbeNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187217; c=relaxed/simple;
	bh=anaZs78MLOU/1dhBIzMqTUF4omCHmH8zZ+0y9Wb0qdc=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=C6jMlCMxb9t94i662AChOVUMfM0DkkyqpZKKTZAVa9oIykMYd3+rZ3ClIwQ6wKD87lqFAOQLCAdbEHbN8dJjOhQR5gpqd9iD1GJ0KW9F8E4qAwR5NhzuoWK0S3gfLvee+hAGRr0t4F2gdEZwQ5QGB7G3jX6lwCCsZ6vpT2b665A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kOXwJZDH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kOXwJZDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D641F000E9;
	Mon, 27 Jul 2026 21:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785187216;
	bh=Zr0LcY8Wrvcz0NRi9l1OH5CTy6dwjY/bTTOCZ5ZkNi8=;
	h=Date:From:To:Cc:Subject;
	b=kOXwJZDHpeKCBXoQqTNDM1r20dL3Ie/xAi1lR3M/niMqTEGyGXszjBcXWek3iAk46
	 HqNBWWl9cMPWYD6f7se7GQqBR/dG9DGqIEdOR9nY6buujtYpv9OWHjLfbtg1jOICkq
	 R4Hvsa1bJHsHLnOs1tNgsQ/0oaxXUO6X0K+vGrjU=
Date: Mon, 27 Jul 2026 14:20:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.2-rc6
Message-Id: <20260727142015.3795e489e504bf62b793bb55@linux-foundation.org>
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


The following changes since commit b95f03f04d475aa6719d15a636ddf32222d55657:

  Merge tag 'mm-hotfixes-stable-2026-07-20-11-37' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2026-07-20 13:04:47 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-27-14-18

for you to fetch changes up to 40de8160ca7f67d14619ee0351ce5d68fc4a237a:

  fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes (2026-07-20 17:41:29 -0700)

----------------------------------------------------------------
13 hotfixes.  All are cc:stable.  11 are for MM.  All are singletons -
please see the changelogs for details.

----------------------------------------------------------------
Aboorva Devarajan (1):
      mm/util: don't read __page_2 for order-1 folios in snapshot_page()

Gregory Price (1):
      mm/vmstat: fold stranded per-cpu node stats when a node comes online

Jori Koolstra (1):
      selftest: fix headers in fclog.c

Joseph Qi (1):
      ocfs2: fix boundary check in ocfs2_check_dir_entry() to use buffer offset

Kefeng Wang (1):
      mm: migrate_device: fix pte_pfn/pte_dirty called on non-present PTE

Kiryl Shutsemau (Meta) (3):
      fs/proc/task_mmu: fix PAGEMAP_SCAN written state for unpopulated ptes
      mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()
      fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes

Qi Zheng (1):
      mm: mglru: fix stale batch updates after memcg reparenting

Stanislav Kinsburskii (1):
      lib: test_hmm: use device devt for coherent device range selection

Usama Arif (1):
      userfaultfd: wait on source PMD during UFFDIO_MOVE

Xiangfeng Cai (1):
      mm/hugetlb: fix list corruption in allocate_file_region_entries()

Zi Yan (1):
      mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()

 fs/ocfs2/dir.c                              |  5 +--
 fs/proc/task_mmu.c                          | 34 +++++++++++++++---
 include/linux/memcontrol.h                  | 25 +++++++++++++
 lib/test_hmm.c                              |  2 +-
 mm/huge_memory.c                            |  2 +-
 mm/hugetlb.c                                | 12 ++++---
 mm/migrate_device.c                         |  5 +--
 mm/mm_init.c                                | 15 +++++---
 mm/percpu-km.c                              |  2 +-
 mm/util.c                                   |  2 +-
 mm/vmscan.c                                 | 11 +++---
 tools/testing/selftests/filesystems/fclog.c |  4 +--
 tools/testing/selftests/mm/pagemap_ioctl.c  | 56 ++++++++++++++++++++++++++++-
 13 files changed, 144 insertions(+), 31 deletions(-)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297848BE5;
	Sun, 18 Aug 2024 02:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723949349; cv=none; b=rZI+6ImeJNaNOWbq5TAN+JAAksl2Q9vxyTrAI9maq36vw37NkiPzhtAxbYKAWaMYDFBOeqazz5MX8Ao6+599is7ErYljcKkxFKYj/lmSiqrg7zQuo8m6NKd38H36+wjsMWy+TkP12Euj2DBn0mZlNH56TRlcaRmWPTLeQDM57bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723949349; c=relaxed/simple;
	bh=5mGZ1Q2IFJHqh4aVFGBDepY8gIQsax6JFm6Htpf9bfA=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=qKkw3eE99klqKQozLmTuHORCH8d/9UUm4QsbXZUoWW56mn+ZHK+1Kkz8h+EGZZ0WXv8bynA/iZ7q4HJTbQcXp5049GDfrrmT729+iUq6knKJ60U1ZYa3lDm9CwWGscxFnyaGKlI06YCJhAr6fyvmPUp55XS/cApwzga9WyJrs2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AKanMxIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AKanMxIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2643C116B1;
	Sun, 18 Aug 2024 02:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723949348;
	bh=5mGZ1Q2IFJHqh4aVFGBDepY8gIQsax6JFm6Htpf9bfA=;
	h=Date:From:To:Cc:Subject:From;
	b=AKanMxIyOXnIqO0peAiSK+Juj6hTj8kbBx/2R4yPlm/pVGDA2burNpFlbdHJYLaCN
	 zKlxZHdB/1eUQ9HWl9JuWYgEZpRMK+XtH6nyTAA3vEoG3JuI0lm5zfLxHFBq7BetiG
	 2YGCJGl0wKGoFQBxDjrmgHpAFsDVeMzYaBy0hpGs=
Date: Sat, 17 Aug 2024 19:49:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.11-rc4
Message-Id: <20240817194908.0d40388a9e597b5b99af644d@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of hotfixes.  Which are a little later
in the week than I'd prefer, sorry and thanks.


The following changes since commit 7c626ce4bae1ac14f60076d00eafe71af30450ba:

  Linux 6.11-rc3 (2024-08-11 14:27:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-08-17-19-34

for you to fetch changes up to 2e6506e1c4eed2676a8412231046f31e10e240da:

  mm/migrate: fix deadlock in migrate_pages_batch() on large folios (2024-08-15 22:26:02 -0700)

----------------------------------------------------------------
16 hotfixes.  All except one are for MM.  10 of these are cc:stable and
the others pertain to post-6.10 issues.

As usual with these merges, singletons and doubletons all over the place,
no identifiable-by-me theme.  Please see the lovingly curated changelogs
to get the skinny.

----------------------------------------------------------------
Dan Carpenter (1):
      selftests/mm: compaction_test: fix off by one in check_compaction()

David Hildenbrand (1):
      mm/hugetlb: fix hugetlb vs. core-mm PT locking

Gao Xiang (1):
      mm/migrate: fix deadlock in migrate_pages_batch() on large folios

Hailong Liu (1):
      mm/vmalloc: fix page mapping if vm_area_alloc_pages() with high order fallback to order 0

Jinjie Ruan (1):
      crash: fix riscv64 crash memory reserve dead loop

Kirill A. Shutemov (1):
      mm: fix endless reclaim on machines with unaccepted memory

Muhammad Usama Anjum (1):
      selftests: memfd_secret: don't build memfd_secret test on unsupported arches

Pasha Tatashin (3):
      mm: don't account memmap on failure
      mm: add system wide stats items category
      mm: don't account memmap per-node

Pedro Falcato (1):
      mseal: fix is_madv_discard()

Suren Baghdasaryan (2):
      alloc_tag: introduce clear_page_tag_ref() helper function
      alloc_tag: mark pages reserved during CMA activation as not tagged

Waiman Long (1):
      mm/memory-failure: use raw_spinlock_t in struct memory_failure_cpu

Zi Yan (2):
      mm/numa: no task_numa_fault() call if PTE is changed
      mm/numa: no task_numa_fault() call if PMD is changed

 include/linux/hugetlb.h                      | 33 ++++++++++++++++--
 include/linux/mm.h                           | 11 ++++++
 include/linux/mmzone.h                       |  2 --
 include/linux/pgalloc_tag.h                  | 13 +++++++
 include/linux/vmstat.h                       | 22 +++++-------
 kernel/crash_reserve.c                       |  3 +-
 mm/huge_memory.c                             | 29 +++++++---------
 mm/hugetlb_vmemmap.c                         | 13 +++----
 mm/memory-failure.c                          | 20 ++++++-----
 mm/memory.c                                  | 33 +++++++++---------
 mm/migrate.c                                 | 16 ++++++---
 mm/mm_init.c                                 | 15 +++-----
 mm/mseal.c                                   | 14 ++++++--
 mm/page_alloc.c                              | 52 +++++++++++-----------------
 mm/page_ext.c                                | 18 +++-------
 mm/sparse-vmemmap.c                          | 11 +++---
 mm/sparse.c                                  |  5 ++-
 mm/vmalloc.c                                 | 11 ++----
 mm/vmstat.c                                  | 52 +++++++++++++---------------
 tools/testing/selftests/mm/Makefile          |  2 ++
 tools/testing/selftests/mm/compaction_test.c |  5 +--
 tools/testing/selftests/mm/run_vmtests.sh    |  3 ++
 22 files changed, 201 insertions(+), 182 deletions(-)


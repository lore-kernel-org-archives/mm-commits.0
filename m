Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C1C3A382C;
	Thu, 30 Apr 2026 22:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777588919; cv=none; b=GuBR/u7U0J9ntP8xxSHNJkZonTUABionAxYnE/Xxxi5wovJ1nwujOYsatE8s9wjfJQhD2v0k0J3JtS47yaJIn6Q0OdTmSGVtU9SpJSSwAEihibMnwM7gncvAS1stu8v9aRrtFBPBeb/KLYUpb5lWglAlLcPEvIgccBbO5Fqnin0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777588919; c=relaxed/simple;
	bh=Zpkg7ICr3kV+8T36Pv6VLyLhBdhfgU6eFlshvNHL7Rk=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=o9vW6YYLmf/laa2pXm1CSfVnS3Y9jKx8VBBsezoYYuIRZrzxoE8LB9GySORsiNRZZiXMx6RQrd7vFAwqMnNfHxyALEIZncK9dI/257mFy8irBqsIzXTfKOM8pZqkY7kcXqxZ4pIpsb37ChBrXPDTehUQjiaR7bjuW5O4JsHIRsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KtQf8hxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KtQf8hxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B469EC2BCB3;
	Thu, 30 Apr 2026 22:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777588918;
	bh=Zpkg7ICr3kV+8T36Pv6VLyLhBdhfgU6eFlshvNHL7Rk=;
	h=Date:From:To:Cc:Subject:From;
	b=KtQf8hxzxa1umru6qOYk1rwl6aZUk6ARl9uDyc6Uf7f+OBGRBprCukpvBRpZmzbDC
	 eBKFgZOxuadaPBjMhUmzQ4bLXRJs5WE39YL0UDuSvbb/ldBbqoxUXjmT6AUXgxCj0e
	 dVmVDJvJxLLbrh7ksjQxdSvYSTmtbThpxZ3caF4I=
Date: Thu, 30 Apr 2026 15:41:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.1-rc2
Message-Id: <20260430154158.4739147fd0129804c9e6766a@linux-foundation.org>
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


The following changes since commit 254f49634ee16a731174d2ae34bc50bd5f45e731:

  Linux 7.1-rc1 (2026-04-26 14:19:00 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-30-15-39

for you to fetch changes up to 99ebc509eef52675ae5bae86aa2a53e15594e4a3:

  mm: memcontrol: fix rcu unbalance in get_non_dying_memcg_end() (2026-04-30 06:13:20 -0700)

----------------------------------------------------------------
20 hotfixes.  All are for MM (and for MMish maintainers).  9 are cc:stable
and the remainder are for post-7.0 issues or aren't deemed suitable for
backporting.

There's a 2 patch DAMON series from SeongJae Park which address races
which could lead to use-after-free errors.  And a 3 patch DAMON series
which avoids the possibility of presenting stale parameter values to
users.

----------------------------------------------------------------
Breno Leitao (1):
      kho: fix error handling in kho_add_subtree()

Dan Carpenter (1):
      mailmap: update entry for Dan Carpenter

David Carlier (1):
      mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()

Joanne Koong (1):
      mm: start background writeback based on per-wb threshold for strictlimit BDIs

Li Wang (1):
      MAINTAINERS: update Li Wang's email address

Liam R. Howlett (1):
      MAINTAINERS: update Liam's email address

Lorenzo Stoakes (1):
      mm/vma: do not try to unmap a VMA if mmap_prepare() invoked from mmap()

Marco Elver (1):
      vmalloc: fix buffer overflow in vrealloc_node_align()

Mark Brown (1):
      selftests/mm: specify requirement for PROC_MEM_ALWAYS_FORCE=y

Pasha Tatashin (1):
      liveupdate: fix return value on session allocation failure

Pedro Falcato (1):
      MAINTAINERS: fix regex pattern in CORE MM category

Qi Zheng (2):
      MAINTAINERS, mailmap: update email address for Qi Zheng
      mm: memcontrol: fix rcu unbalance in get_non_dying_memcg_end()

Sang-Heon Jeon (1):
      mm/hugetlb_cma: round up per_node before logging it

SeongJae Park (5):
      mm/damon/sysfs-schemes: protect memcg_path kfree() with damon_sysfs_lock
      mm/damon/sysfs-schemes: protect path kfree() with damon_sysfs_lock
      mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values
      mm/damon/lru_sort: detect and use fresh enabled and kdamond_pid values
      mm/damon/stat: detect and use fresh enabled value

Sourabh Jain (1):
      MAINTAINERS: remove stale kdump project URL

 .mailmap                           |  5 +++
 MAINTAINERS                        | 30 +++++++-------
 include/linux/maple_tree.h         |  2 +-
 include/linux/mm.h                 |  2 +-
 kernel/liveupdate/kexec_handover.c | 21 ++++++----
 kernel/liveupdate/luo_session.c    | 15 ++++---
 lib/maple_tree.c                   |  2 +-
 lib/test_maple_tree.c              |  4 +-
 mm/damon/lru_sort.c                | 85 ++++++++++++++++++++++++--------------
 mm/damon/reclaim.c                 | 85 ++++++++++++++++++++++++--------------
 mm/damon/stat.c                    | 30 +++++++++-----
 mm/damon/sysfs-schemes.c           | 24 ++++++++++-
 mm/hugetlb_cma.c                   |  1 +
 mm/memcontrol.c                    | 29 ++++++++-----
 mm/page-writeback.c                | 16 +++----
 mm/userfaultfd.c                   | 12 +++++-
 mm/util.c                          | 26 ++++++++----
 mm/vma.c                           |  3 +-
 mm/vmalloc.c                       |  2 +-
 tools/testing/radix-tree/maple.c   |  2 +-
 tools/testing/selftests/mm/config  |  1 +
 tools/testing/vma/include/dup.h    |  2 +-
 tools/testing/vma/include/stubs.h  |  3 +-
 23 files changed, 262 insertions(+), 140 deletions(-)


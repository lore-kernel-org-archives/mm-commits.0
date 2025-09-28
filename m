Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B74217F35;
	Sun, 28 Sep 2025 05:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759038374; cv=none; b=ONTSm+ScOOl5Qc9Lhk3Id62iZnwtInFyniY1l6HQGIAvVzuw04wcvJArwFMmG4CIP8sU16VT8pb8cIbeZIUu/M3E89iiQ7NFor0G2vXnq+FerextOVyEyF+DiV44JMkUWdRQGZqLybvLxxRIDIyAXjjMzQZO5PIwvmKLTuxznJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759038374; c=relaxed/simple;
	bh=Yrgs1IXkVh2mOgB8ie3jgcyYGEi6ekHFtSCD0+MwkqY=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=k3XNlN2QugzPnXX+1EugCiCZT3nL3xz8F5p9m6PLnSBnv8KD/NCauy+QWkFJlU26Ie6O6zfl370uaEO6UG+ChhniS1eRrE5DH9M+OeO0n3OuQCo8kUI2hVtJLOnDiXKPW+vkTShGULp1QrDqkBf9a/JjRGMTUllhPjNQQDUAV/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WDbfj2zt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WDbfj2zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B263AC4CEF0;
	Sun, 28 Sep 2025 05:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759038372;
	bh=Yrgs1IXkVh2mOgB8ie3jgcyYGEi6ekHFtSCD0+MwkqY=;
	h=Date:From:To:Cc:Subject:From;
	b=WDbfj2ztOtV4NlsL9ez32BiVdOiKXt86eXAyZo2D2zRM3aRbIICte+x8e85O2xARf
	 JYP4PB/Vc9Zy4myie62kILbRd+wv6tObTAoVukB31exS8w5krIgiqYnpSo5AMyaKCJ
	 7DMHPUQR4u0fLTcgk9HRsZvY9eoI5xw0bnHNukzg=
Date: Sat, 27 Sep 2025 22:46:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.17
Message-Id: <20250927224612.fffdf688aa7be4206a4a3ff1@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge this batch of hotfixes.

It's rather late in proceedings, sorry.  The world wouldn't end if you
held this off for 6.18-rc1.

Thanks.


The following changes since commit ce4be9e4307c5a60701ff6e0cafa74caffdc54ce:

  zram: fix slot write race condition (2025-09-15 20:01:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2025-09-27-22-35

for you to fetch changes up to 7e89979f6695fb56e8739b7d19614256e637131d:

  include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and friends t=
o static inlines (2025-09-25 16:10:35 -0700)

----------------------------------------------------------------
7 hotfixes.  4 are cc:stable and the remainder address post-6.16 issues or
aren't considered necessary for -stable kernels.  6 of these fixes are for
MM.

All singletons, please see the changelogs for details.

----------------------------------------------------------------
Akinobu Mita (1):
      mm/damon/sysfs: do not ignore callback's return value in damon_sysfs_=
damon_call()

Andrew Morton (1):
      include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and frien=
ds to static inlines

Bence Cs=F3k=E1s (1):
      mailmap: add entry for Bence Cs=F3k=E1s

Eric Biggers (1):
      kmsan: fix out-of-bounds access to shadow memory

Jakub Acs (1):
      fs/proc/task_mmu: check p->vec_buf for NULL

Jane Chu (1):
      mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count

Jinjiang Tu (1):
      mm/hugetlb: fix folio is still mapped when deleted

 .mailmap                 |  1 +
 fs/hugetlbfs/inode.c     | 10 ++++++----
 fs/proc/task_mmu.c       |  3 +++
 include/linux/mm_types.h |  5 +++++
 include/linux/pgtable.h  |  6 +++---
 mm/damon/sysfs.c         |  4 +++-
 mm/hugetlb.c             | 15 +++++----------
 mm/kmsan/core.c          | 10 +++++++---
 mm/kmsan/kmsan_test.c    | 16 ++++++++++++++++
 9 files changed, 49 insertions(+), 21 deletions(-)


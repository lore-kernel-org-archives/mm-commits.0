Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6E426ED41;
	Tue, 22 Sep 2026 00:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790036251; cv=none; b=QKYqeOaeDxQzU+VxDvPLpFEHNj86K5RSkuJbkirU5NnOl7BgmAND/FitDfqkuodrvhzwzAf+jFvfBJiG0j3IT+AmiVgFGT2n77jb98icyty22Q0F1UiT3915hmtECeSMASGC43lJuinnHzelBmOoMW+RX3Exnl8ZFDy/u/K1Pq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790036251; c=relaxed/simple;
	bh=W7fIRlCVbSyxk0dce/5ubN7WVnzKkWUChQDToYTgTTA=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=sHsYijkcHFC217C92HNaCu+Xv0yPr8VY24WVe4hTQtcJzDjcGV2HwyIukAvCpYTsQJEKF0GM5S6CyTYywLIm4zi/CDq09UsVUo1ePyrmCH0I91eF0eYAesrZV+gShJHHyO5QXkrhxOtyMgtNdrVVdMZOsc8disa96jWcul6PWsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KMC4xYnt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KMC4xYnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335BC1F00893;
	Tue, 22 Sep 2026 00:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790036249;
	bh=/UYKcugE8spIFiKcC7kZ6CdbaDdEeSfmV8Pu82NJ678=;
	h=Date:From:To:Cc:Subject;
	b=KMC4xYntSdElwCNoU+C6yj6ZdOuMg5Xw+qn2WUzeF7K82QLDz1TeTgImvHpsmCXDD
	 UTkqhSpd3k+RUVCT8x4CT2QvxCkU0A7GgakYoyI+i7vTDw9929YwYr9ORNH/KMI7J1
	 h5PameJq5T5vIrYhQuh+6d4vhUAfpPYYeCQ84j7w=
Date: Mon, 21 Sep 2026 17:17:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM hotfixes for 7.3-rc5
Message-Id: <20260921171728.57318b258faaa20e78c81b73@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of MM hotfixes, thanks.


(yes, "MM".  nonmm material now has separate hotfixes branches so I'll
ask for nonmm changes to be pulled separately)

(ok, there's an ocfs2 patch here - that's transitional)


The following changes since commit 7891fbb9512f127826e1d5dbf380ee212bd15eb0:

  mm/folio: EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio) (2026-09-08 23:28:06 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-21-17-08

for you to fetch changes up to 692dd08e03f4a5523650e055f033f846bee43a0c:

  MAINTAINERS: update Xu Xin's email (2026-09-18 08:20:15 -0700)

----------------------------------------------------------------
14 hotfixes.  10 are cc:stable.  11 are for MM.

Five are DAMON fixes.  One fixes an arm64 contpte bug where DAMON can
write past the end of a page-table page, resulting in memory corruption
and possible crashes.

Two are hugetlb fixes.  One fixes an mremap() address calculation bug
which can panic x86-64.

There's also a missing anon_vma publication barrier which can result in
hung tasks, and a writeback fix to keep long cgroup writeback drains from
delaying Tasks-RCU grace periods.

The remainder are smaller fixes and maintenance changes.

----------------------------------------------------------------
Baolin Wang (1):
      MAINTAINERS: add Baoquan and Baolin as MGLRU reviewers

Haowen Bai (1):
      mailmap: update Haowen Bai's email address

Jaewook You (1):
      mm/hugetlb: preserve mremap address delta when skipping page tables

Jinjiang Tu (1):
      mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish

Josef Bacik (1):
      writeback: report a Tasks-RCU quiescent state per cgwb drain pass

Joseph Qi (1):
      ocfs2: make ocfs2_calc_xattr_init() return void

Joshua Hahn (1):
      selftests/cgroup: account for zswap shrinker writeback

Liew Rui Yan (2):
      mm/damon/core: allow esz to be set to zero
      mm/damon/core: fix unconditionally skip last region

Longlong Xia (1):
      mm/hugetlb: do not dissolve gigantic pages without runtime support

Nathan Gao (1):
      mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()

SJ Park (2):
      mm/damon/vaddr: avoid hw-driven pte updates during damon_hugetlb_mkold()
      mm/damon/core: reset invalid quota->charge_target_from

Xu Xin (1):
      MAINTAINERS: update Xu Xin's email

 .mailmap                                    |  4 +++
 MAINTAINERS                                 |  4 ++-
 fs/ocfs2/namei.c                            |  9 ++-----
 fs/ocfs2/xattr.c                            | 13 ++++------
 fs/ocfs2/xattr.h                            |  8 +++---
 mm/backing-dev.c                            |  5 ++--
 mm/damon/core.c                             | 39 ++++++++++++++++++-----------
 mm/damon/ops-common.c                       |  7 +++++-
 mm/damon/vaddr.c                            | 21 ++++++++++------
 mm/hugetlb.c                                | 20 ++++++++++++---
 mm/rmap.c                                   |  6 ++++-
 mm/vma.c                                    |  8 ++++++
 tools/testing/selftests/cgroup/test_zswap.c | 28 +++++++++++++++++++--
 13 files changed, 121 insertions(+), 51 deletions(-)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC453194ADB;
	Thu, 19 Sep 2024 07:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726731362; cv=none; b=dxhzGI4+ATLzQWlobDGclvGdHT3pMpDQ760K6pBPtxNbg/3hFKlFeG245Xc6sMWg87VMqN4Pm/hUCw3wRndXbZrEzkidyO/+fmGh21J1CFc5RbCbZqakYIG4tsrALxEt3mO/web1MpTbpKVmm9FvAs4wI5HDNbI/Iq9ZoiNmjuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726731362; c=relaxed/simple;
	bh=LZPYiBISM+Byx5KRxvV3F7+EuAvFwWDJNYhmtFWjCAo=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=lsiP0yULoFmPu22SSeEUZl4syqemQWmyFgXPZoe6eX9WYGaRS6iaakbXgblDplTaUkLSR/PJ4oT9Bd63/gY+TJAY/uoi1qPna9w/hbbb6E4QjvUAyXzAw5aCeadqpmB0+5BLHVsi2HKlKoXVZfSK9r/yduweo/D17FuMsmAnFsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=06Wvpo+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="06Wvpo+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7939C4CEC5;
	Thu, 19 Sep 2024 07:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726731362;
	bh=LZPYiBISM+Byx5KRxvV3F7+EuAvFwWDJNYhmtFWjCAo=;
	h=Date:From:To:Cc:Subject:From;
	b=06Wvpo+q5ZgSrP4xjUHKVI9HpOItLWo5Fvf1EmxhZcIKd03JBTUjE9V1tFnM+us6U
	 2L1GSewOG6VrlrAFie5yyYZARLFc+ZKwFHl6hScgElKy+hi1zia+Olu1k6abvYnQyb
	 X1TyDa/3fq+SEXKQxOqfajG/v1ceRQEvNuf7mVuU=
Date: Thu, 19 Sep 2024 00:35:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.12-rc1
Message-Id: <20240919003557.1777673c0f759f9e4ebaa328@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of hotfixes, thanks.

The following changes since commit 052a45c1cb1b32f05dd63a295d65496d8b403283:

  alloc_tag: fix allocation tag reporting when CONFIG_MODULES=n (2024-09-01 17:59:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-09-19-00-31

for you to fetch changes up to 22af8caff7d1ca22a1ff1a554180e53f7a6555af:

  mm/madvise: process_madvise() drop capability check if same mm (2024-09-17 00:58:05 -0700)

----------------------------------------------------------------
12 hotfixes, 11 of which are cc:stable.

Four fixes for longstanding ocfs2 issues and the remainder address random
MM things.

----------------------------------------------------------------
Chris Li (1):
      mm: vmscan.c: fix OOM on swap stress test

Huang Ying (1):
      resource: fix region_intersects() vs add_memory_driver_managed()

Joseph Qi (1):
      ocfs2: cancel dqi_sync_work before freeing oinfo

Julian Sun (1):
      ocfs2: fix null-ptr-deref when journal load failed.

Liam R. Howlett (1):
      mm/damon/vaddr: protect vma traversal in __damon_va_thre_regions() with rcu read lock

Lizhi Xu (2):
      ocfs2: remove unreasonable unlock in ocfs2_read_blocks
      ocfs2: fix possible null-ptr-deref in ocfs2_set_buffer_uptodate

Lorenzo Stoakes (1):
      mm/madvise: process_madvise() drop capability check if same mm

Miaohe Lin (1):
      mm/huge_memory: ensure huge_zero_folio won't have large_rmappable flag set

Sergey Senozhatsky (1):
      zsmalloc: use unique zsmalloc caches names

Vishal Moola (Oracle) (2):
      mm: change vmf_anon_prepare() to __vmf_anon_prepare()
      mm/hugetlb.c: fix UAF of vma in hugetlb fault pathway

 fs/ocfs2/buffer_head_io.c |  4 ++--
 fs/ocfs2/journal.c        |  7 +++---
 fs/ocfs2/quota_local.c    |  8 +++++--
 kernel/resource.c         | 58 ++++++++++++++++++++++++++++++++++++++++-------
 mm/damon/vaddr.c          |  2 ++
 mm/huge_memory.c          |  2 ++
 mm/hugetlb.c              | 20 ++++++++++++++--
 mm/internal.h             | 11 ++++++++-
 mm/madvise.c              |  2 +-
 mm/memory.c               |  8 +++----
 mm/vmscan.c               |  2 +-
 mm/zsmalloc.c             | 23 ++++++++++++++-----
 12 files changed, 116 insertions(+), 31 deletions(-)


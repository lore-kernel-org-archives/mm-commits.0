Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D88C28371;
	Fri, 25 Jul 2025 01:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753405505; cv=none; b=TAI1oKp3sxJfMlF7CEouEBhrCn1Ma79itjRG80st/Qrpti/CveMvuKKax/2XGCENXRSmjpE7FJ3bDVjQc+2kab8cWx03mnoTUbvFMo8bXWxkA6PZkMpeawePlSfvjvPrRvOdq8gF/jPpayHx7Pr3ynS9yMJLRLq5aW2Kw0oy12s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753405505; c=relaxed/simple;
	bh=tAi5yNbVWJZar85JYgxMKocAfRchNPvqbGllAqQ8wQY=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=pfzLCOPILvwd7X+1bKi2Plq2treI2b+FcqLxIZKCqnOBVA2pyHeOD1p7Kg4np/XIuS/wqevwL+FPXGEwPUHyqJ8Yagn8DCwMwJQ56fSdhyyV2wgeEOAoZAAHMQVmqBYQVWGL9AZ0dMPhsCuVbCPR0KOSf/1wc9i6O+4O9UUbi8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HXP5UqLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HXP5UqLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA5EC4CEED;
	Fri, 25 Jul 2025 01:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753405504;
	bh=tAi5yNbVWJZar85JYgxMKocAfRchNPvqbGllAqQ8wQY=;
	h=Date:From:To:Cc:Subject:From;
	b=HXP5UqLif1X61lXGPABx2KAbUTpnbRg6hpTtBn2nMNaygxT8Ase/sMQtr+pAG10nO
	 b3LAKC0oGKgS28/tNtifcdkHB7Kat3YQBizSFC9avU4m7SBa85DKyk3DqtQV+Sxb2C
	 N0HOhwDaozGo8fO7kqrt6Y122N85kyQm6kJK8UJg=
Date: Thu, 24 Jul 2025 18:05:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.16
Message-Id: <20250724180503.a8a80b0b0c904c1c7f967448@linux-foundation.org>
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


The following changes since commit db6cc3f4ac2e6cdc898fc9cbc8b32ae1bf56bdad:

  Revert "sched/numa: add statistics of numa balance task" (2025-07-09 21:07:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-07-24-18-03

for you to fetch changes up to 0dec7201788b9152f06321d0dab46eed93834cda:

  sprintf.h requires stdarg.h (2025-07-24 17:58:00 -0700)

----------------------------------------------------------------
11 hotfixes.  9 are cc:stable and the remainder address post-6.15 issues
or aren't considered necessary for -stable kernels.

7 are for MM.

----------------------------------------------------------------
Akinobu Mita (1):
      resource: fix false warning in __request_region()

Harry Yoo (1):
      mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n

Jason Gunthorpe (1):
      mm: update MAINTAINERS entry for HMM

Jinjiang Tu (1):
      mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list

Marco Elver (1):
      kasan: use vmalloc_dump_obj() for vmalloc error reports

Nathan Chancellor (1):
      mm/ksm: fix -Wsometimes-uninitialized from clang-21 in advisor_mode_show()

Ryusuke Konishi (1):
      nilfs2: reject invalid file types when reading inodes

SeongJae Park (1):
      mm/damon/core: commit damos_quota_goal->nid

Sergey Senozhatsky (1):
      mailmap: add entry for Senozhatsky

Stephen Rothwell (1):
      sprintf.h requires stdarg.h

Zi Yan (1):
      selftests/mm: fix split_huge_page_test for folio_split() tests

 .mailmap                                          |  4 ++++
 CREDITS                                           |  4 ++++
 MAINTAINERS                                       |  3 ++-
 fs/nilfs2/inode.c                                 |  9 ++++++++-
 include/linux/sprintf.h                           |  1 +
 kernel/resource.c                                 |  5 +++--
 mm/damon/core.c                                   | 15 +++++++++++++++
 mm/kasan/report.c                                 |  4 +++-
 mm/ksm.c                                          |  6 +++---
 mm/memory-failure.c                               |  4 ++++
 mm/vmscan.c                                       |  8 ++++++++
 mm/zsmalloc.c                                     |  3 +++
 tools/testing/selftests/mm/split_huge_page_test.c |  3 ++-
 13 files changed, 60 insertions(+), 9 deletions(-)


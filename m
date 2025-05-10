Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B087B224EA;
	Sat, 10 May 2025 21:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746912338; cv=none; b=AjV+87K/Vuy/xbXL2n55CuVL1M48YUTTFXlr9n13Xdm+4h23XkuFtE/X1wpIx8xC7ZE7u7nXykhxAfpspl7IvgOwiWUSgMj8pdApmXfgNDu42L2/wNO/Hi4UPpquB8g2m9nVzLYxUaSd/vdG0jWAthU78It764w5SMGwhhOWT78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746912338; c=relaxed/simple;
	bh=rtuILwoeJ02PJuhMgQ83eu/H9smsHlvds2fZgT1GB3I=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=eCQl3FsCFjY1b27x24XVvNgq/DFlc9VeGhmkwXsiKQY2XLTAhRyltjsegzix7RiKb4IeVTprpqYqu2BCOOgSGPlEroPaYa87eKvtEOiDgTaAqBMYvTR6DZpE8xVIQ4TGiPt5IPO5VaoiBfGzk2mF3A/mjWI7NnwCoP0TkWfVw6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GkPB6/bS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GkPB6/bS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D13C4CEE2;
	Sat, 10 May 2025 21:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746912337;
	bh=rtuILwoeJ02PJuhMgQ83eu/H9smsHlvds2fZgT1GB3I=;
	h=Date:From:To:Cc:Subject:From;
	b=GkPB6/bSe3Q1n59MVg7bHe5WNUENLRVwjmANfyPQTDR+vdG3rpBQmOCzFGDAi06FV
	 j/cDJvH7BGsnlteiLmGKm/vIyCJ452S4nsEa/dPkuHcfiO/rrGpy4XHUct7qrp+Lw3
	 tRsJ3g05V0gmO0yP8Ld/LEy3pnd6hkmrmuJZiSCk=
Date: Sat, 10 May 2025 14:25:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.15-rc6
Message-Id: <20250510142536.5e56d771875c6357574a3b89@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Linus, please merge this batch of MM and non-MM hotfixes, thanks.

The following changes since commit 92a09c47464d040866cf2b4cd052bc60555185fb:

  Linux 6.15-rc5 (2025-05-04 13:55:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-05-10-14-23

for you to fetch changes up to 7b08b74f3d99f6b801250683c751d391128799ec:

  mm: fix folio_pte_batch() on XEN PV (2025-05-07 23:39:42 -0700)

----------------------------------------------------------------
22 hotfixes.  13 are cc:stable and the remainder address post-6.14 issues
or aren't considered necessary for -stable kernels.

About half are for MM.  Five OCFS2 fixes and a few MAINTAINERS updates.

----------------------------------------------------------------
Feng Tang (1):
      selftests/mm: compaction_test: support platform with huge mount of memory

Frank van der Linden (1):
      mm/hugetlb: copy the CMA flag when demoting

Gavin Guo (1):
      mm/huge_memory: fix dereferencing invalid pmd migration entry

Guenter Roeck (1):
      x86: disable image size check for test builds

Heming Zhao (1):
      ocfs2: fix the issue with discontiguous allocation in the global_bitmap

Jan Kara (3):
      ocfs2: switch osb->disable_recovery to enum
      ocfs2: implement handshaking with ocfs2 recovery thread
      ocfs2: stop quota recovery before disabling quotas

Kairui Song (1):
      mm, swap: fix false warning for large allocation with !THP_SWAP

Kees Cook (1):
      mm: vmalloc: support more granular vrealloc() sizing

Lance Yang (1):
      mailmap: add entries for Lance Yang

Lorenzo Stoakes (4):
      MAINTAINERS: add reverse mapping section
      MAINTAINERS: add core mm section
      MAINTAINERS: add mm THP section
      tools/testing/selftests: fix guard region test tmpfs assumption

Madhavan Srinivasan (1):
      selftests/mm: fix build break when compiling pkey_util.c

Mark Tinguely (1):
      ocfs2: fix panic in failed foilio allocation

Nysal Jan K.A. (1):
      selftests/mm: fix a build failure on powerpc

Peter Xu (1):
      mm/userfaultfd: fix uninitialized output field for -EAGAIN race

Petr Vaněk (1):
      mm: fix folio_pte_batch() on XEN PV

Ryusuke Konishi (1):
      nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()

Uwe Kleine-König (1):
      mailmap: map Uwe's BayLibre addresses to a single one

 .mailmap                                     |  3 ++
 MAINTAINERS                                  | 66 +++++++++++++++++++++--
 arch/x86/kernel/vmlinux.lds.S                | 10 +++-
 fs/nilfs2/the_nilfs.c                        |  3 --
 fs/ocfs2/alloc.c                             |  1 +
 fs/ocfs2/journal.c                           | 80 ++++++++++++++++++++--------
 fs/ocfs2/journal.h                           |  1 +
 fs/ocfs2/ocfs2.h                             | 17 +++++-
 fs/ocfs2/quota_local.c                       |  9 +---
 fs/ocfs2/suballoc.c                          | 38 ++++++++++---
 fs/ocfs2/suballoc.h                          |  1 +
 fs/ocfs2/super.c                             |  3 ++
 fs/userfaultfd.c                             | 28 +++++++---
 include/linux/vmalloc.h                      |  1 +
 mm/huge_memory.c                             | 11 ++--
 mm/hugetlb.c                                 |  6 +++
 mm/internal.h                                | 27 ++++------
 mm/swapfile.c                                | 23 +++++---
 mm/vmalloc.c                                 | 31 ++++++++---
 tools/testing/selftests/mm/compaction_test.c | 19 +++++--
 tools/testing/selftests/mm/guard-regions.c   | 16 +++---
 tools/testing/selftests/mm/pkey-powerpc.h    | 14 ++++-
 tools/testing/selftests/mm/pkey_util.c       |  1 +
 23 files changed, 314 insertions(+), 95 deletions(-)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A41204F93;
	Fri,  6 Jun 2025 23:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749251529; cv=none; b=QJCn7l+CY1U36ruRLLsmaFKafd1uhYgerQdz0ltY7voO/mWPA9/WeGgljE3LCRnOCBFOiVogttiGI3q+/7QirNJApVexypo8SAOlpyDV+E/2zCPKO8gks+YHk2S21Jncbre2lePe1vFHojU+JMeN0EQguvGSUPnue25hbbIEFkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749251529; c=relaxed/simple;
	bh=SIQBpzgDhCq3i24zk4KvGnlpxag/7lRvBGruUPdocL0=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=I4fekBD1E6qY2b6gizlKnttH1gdVIJOQJFk60YmKkhBL75m43w3DX5Bhhl2qrz1Gjt/ykybDiz0AcvYDWB1+gfwMD1m0qXX0FLiEUJL3Nk6PoCddx925d9bLnxYgAl02t0hNzG4yUEpLZXnT7PHcD0D5z1PsAucQSbwKm8UcSM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XrnmW6Fk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XrnmW6Fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC28EC4CEEB;
	Fri,  6 Jun 2025 23:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749251529;
	bh=SIQBpzgDhCq3i24zk4KvGnlpxag/7lRvBGruUPdocL0=;
	h=Date:From:To:Cc:Subject:From;
	b=XrnmW6FkWxwo8Sxbuzq5PmOjTjhQGaxnP89uuDcfKb280YAcLM7/ieLalI5RTfHNM
	 orHDP3hLBj5N+OB1v6EYh+kjElucHjtBcvEcuAVpK0BOkV1wEkUkPohp5ubclGNnYN
	 pyINPHvi8EO9X+tsnD5gEguat8Im0RNoAElUFBas=
Date: Fri, 6 Jun 2025 16:12:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.16-rc1
Message-Id: <20250606161208.2d18790220a7c75ec18b361b@linux-foundation.org>
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


The following changes since commit 546b1c9e93c2bb8cf5ed24e0be1c86bb089b3253:

  Merge tag 'bootconfig-v6.16' of git://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace (2025-06-02 17:39:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-06-06-16-02

for you to fetch changes up to 2da20fd904f87f7bb31b79719bc3dda4093f8cdb:

  kernel/rcu/tree_stall: add /sys/kernel/rcu_stall_count (2025-06-05 22:02:25 -0700)

----------------------------------------------------------------
13 hotfixes.  6 are cc:stable and the remainder address post-6.15 issues
or aren't considered necessary for -stable kernels.  11 are for MM.

----------------------------------------------------------------
Alistair Popple (1):
      MAINTAINERS: add Alistair as reviewer of mm memory policy

Arnd Bergmann (1):
      kmsan: test: add module description

Jann Horn (2):
      mm/hugetlb: unshare page tables during VMA split, not before
      mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race

Joshua Hahn (1):
      mm/mempolicy: fix incorrect freeing of wi_kobj

Kirill A. Shutemov (1):
      mm: fix vmstat after removing NR_BOUNCE

Lorenzo Stoakes (2):
      KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
      MAINTAINERS: add mm swap section

Max Kellermann (1):
      kernel/rcu/tree_stall: add /sys/kernel/rcu_stall_count

Nitesh Shetty (1):
      iov_iter: use iov_offset for length calculation in iov_iter_aligned_bvec

SeongJae Park (1):
      mm/madvise: handle madvise_lock() failure during race unwinding

Suren Baghdasaryan (1):
      alloc_tag: handle module codetag load errors as module load failures

Tal Zussman (1):
      MAINTAINERS: add tlb trace events to MMU GATHER AND TLB INVALIDATION

 MAINTAINERS                      | 21 +++++++++++++
 arch/s390/kvm/gaccess.c          |  8 ++---
 include/linux/codetag.h          |  8 ++---
 include/linux/hugetlb.h          |  3 ++
 kernel/module/main.c             |  5 +--
 kernel/rcu/tree_stall.h          | 26 ++++++++++++++++
 lib/alloc_tag.c                  | 12 ++++---
 lib/codetag.c                    | 34 ++++++++++++++------
 lib/iov_iter.c                   |  2 +-
 mm/hugetlb.c                     | 67 ++++++++++++++++++++++++++++++----------
 mm/kmsan/kmsan_test.c            |  1 +
 mm/madvise.c                     |  5 ++-
 mm/mempolicy.c                   |  4 +--
 mm/vma.c                         |  7 +++++
 mm/vmstat.c                      |  1 -
 tools/testing/vma/vma_internal.h |  2 ++
 16 files changed, 160 insertions(+), 46 deletions(-)


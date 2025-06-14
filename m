Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F201CEE90;
	Sat, 14 Jun 2025 04:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749877196; cv=none; b=LH6KrXNgslWoFvKIIMk5NqsZsBmJpKaRkKCVATt2LWwP+HDNVwltY0+Kd2XiGNK0HOSr4FBDH/I1IxRjR6nQDnb1s88iIFtClr8OQC88Fm+kp3ZiT50dZQu0wwC3646chMPLKSjBhah6jRKJYH8v0bZPqZu3KFGkL9FGPL/jMNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749877196; c=relaxed/simple;
	bh=xS9feyckY1UNrb3X9JjrQrm/by2BHfPnl9c//XqbFiQ=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=e1cWf/1FSiKyAM9fmQbwf5lTd7E83ggxpiSlhSczJlsZKZNu0HSp5ogpoyOfp0wZuB62NZF0Vw9d0bQzJ+i7o4Eew+tmXJh4RkQmshIFN4ZMPLE2JpXnz0Ma8cMfiryJNPo7jJzRIWkbEzZ/lh0UHKg6ES/MtZlWcOxMkjlJBNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KMNRxSUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KMNRxSUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF97C4CEEB;
	Sat, 14 Jun 2025 04:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749877195;
	bh=xS9feyckY1UNrb3X9JjrQrm/by2BHfPnl9c//XqbFiQ=;
	h=Date:From:To:Cc:Subject:From;
	b=KMNRxSUkBkn/XFLn6+y2lAnSiyBjqN8fRDalSK17UN2n4pGeOS+7KjNkQ1Z7EHUTK
	 XYDNabpuwG8bFggNuf33bOR/bPwBcrVSwtqzQGvZ0qaOlPbVZYGd0mIa2o7lKuVrSF
	 k7e2ACiRkWIfKlai1TJPaKZBzZd4NV16Wu6M7q7M=
Date: Fri, 13 Jun 2025 21:59:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.16-rc2
Message-Id: <20250613215955.17731b1cd27ad5230f0962ca@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please pull this small batch of hotfixes for the next -rc, thanks.


The following changes since commit 19272b37aa4f83ca52bdf9c16d5d81bdd1354494:

  Linux 6.16-rc1 (2025-06-08 13:44:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-06-13-21-56

for you to fetch changes up to bb666b7c27073b986b75699e51a7102910f58060:

  mm: add mmap_prepare() compatibility layer for nested file systems (2025-06-12 21:39:02 -0700)

----------------------------------------------------------------
9 hotfixes.  3 are cc:stable and the remainder address post-6.15 issues
or aren't considered necessary for -stable kernels.  Only 4 are for MM.

----------------------------------------------------------------
Andrew Morton (1):
      drivers/rapidio/rio_cm.c: prevent possible heap overwrite

Barry Song (1):
      MAINTAINERS: add Barry as a THP reviewer

Huacai Chen (1):
      init: fix build warnings about export.h

Lorenzo Stoakes (2):
      mm/vma: reset VMA iterator on commit_merge() OOM failure
      mm: add mmap_prepare() compatibility layer for nested file systems

Mark Brown (1):
      selftests/mm: skip failed memfd setups in gup_longterm

Randy Dunlap (1):
      scatterlist: fix extraneous '@'-sign kernel-doc notation

Ryan Roberts (1):
      mm: close theoretical race where stale TLB entries could linger

wangfushuai (1):
      docs: proc: update VmFlags documentation in smaps

 Documentation/filesystems/proc.rst        |  4 ++-
 MAINTAINERS                               |  1 +
 drivers/rapidio/rio_cm.c                  |  3 ++
 include/linux/fs.h                        |  6 ++--
 include/linux/scatterlist.h               |  4 +--
 init/initramfs.c                          |  1 +
 init/main.c                               |  1 +
 lib/scatterlist.c                         |  8 +++---
 mm/madvise.c                              |  2 ++
 mm/util.c                                 | 40 ++++++++++++++++++++++++++
 mm/vma.c                                  | 23 +++------------
 mm/vma.h                                  | 47 +++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/gup_longterm.c |  7 ++++-
 tools/testing/vma/vma_internal.h          | 16 +++++++++++
 14 files changed, 134 insertions(+), 29 deletions(-)


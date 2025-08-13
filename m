Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAAB2BE02B;
	Wed, 13 Aug 2025 03:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755057177; cv=none; b=Dmy/yQGHTFqnP+ZEEpSEtgNbluncdO3IOIQwkZANARKgr3lOgyrpC5bWFzKPx7DEfVkk0i2SXAotlu5mThWjGa9aqnm+eLsdE0oxx72046S12BRzVR/mmX5qc4BPhsAsj7/mGZSZzA2oRDr0epgZX/fK0NICYLGLimANHcWjxLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755057177; c=relaxed/simple;
	bh=ENmDFe3lJzYsbCz4gjRO/Qie8EynIqu821IwkBvbcf8=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=IKXPHPXDHwoJNEqpYFR4vSH60yuKFkCzKvxLHfod6dTxbh3PV0Kgy7TaA4viUxwNOLqG3oIlF/2O3KIEGsP6pNCWjhFKntXiHh7zUM/RWV9PrlWB9mztwzt+UnEYleonp+/9iwDrlX3ApbcG6TmVq03yFHXPItGIyXugers1DMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mdaKKiRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mdaKKiRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6F3C4CEED;
	Wed, 13 Aug 2025 03:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755057177;
	bh=ENmDFe3lJzYsbCz4gjRO/Qie8EynIqu821IwkBvbcf8=;
	h=Date:From:To:Cc:Subject:From;
	b=mdaKKiRbDaXmZTDoJgJCKxkY0oofdNzLmnyBdCsRbqCJnCKRTc2JT0y5JzeUQxuKB
	 WfpqWLZmHjucdfa5hXXzB8KnpHUVfbYOaNwC1KEoWwO5NkcyrxUMG924uDLbAjbA8D
	 pfv42gmxYv0Ej2d6Fjdv8i4lBNky/3OML/mdHbcE=
Date: Tue, 12 Aug 2025 20:52:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.17-rc2
Message-Id: <20250812205256.7782e2e483a8b12774e65dcd@linux-foundation.org>
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


The following changes since commit 6bcdbd62bd56e6d7383f9e06d9d148935b3c9b73:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rmk/linux (2025-08-05 16:55:03 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-08-12-20-50

for you to fetch changes up to c0e1b774f68bdbea1618e356e30672c7f1e32509:

  proc: proc_maps_open allow proc_mem_open to return NULL (2025-08-11 23:01:00 -0700)

----------------------------------------------------------------
12 hotfixes.  5 are cc:stable and the remainder address post-6.16 issues
or aren't considered necessary for -stable kernels.  10 of these fixes are
for MM.

----------------------------------------------------------------
Barry Song (1):
      mm: fix the race between collapse and PT_RECLAIM under per-vma lock

Breno Leitao (1):
      mm/kmemleak: avoid deadlock by moving pr_warn() outside kmemleak_lock

Dev Jain (1):
      mm: pass page directly instead of using folio_page

Jann Horn (1):
      kasan/test: fix protection against compiler elision

Jialin Wang (1):
      proc: proc_maps_open allow proc_mem_open to return NULL

Jinjiang Tu (2):
      mm/smaps: fix race between smaps_hugetlb_range and migration
      fs/proc/task_mmu: hold PTL in pagemap_hugetlb_range and gather_hugetlb_stats

Lorenzo Stoakes (1):
      mm/mremap: avoid expensive folio lookup on mremap folio pte batch

Masami Hiramatsu (Google) (1):
      MAINTAINERS: add Masami as a reviewer of hung task detector

Sukrut Heroorkar (1):
      selftests/proc: fix string literal warning in proc-maps-race.c

Suren Baghdasaryan (1):
      userfaultfd: fix a crash in UFFDIO_MOVE when PMD is a migration entry

Waiman Long (1):
      mm/kmemleak: avoid soft lockup in __kmemleak_do_cleanup()

 MAINTAINERS                                   |  1 +
 fs/proc/task_mmu.c                            | 24 ++++++++++++++++++------
 mm/kasan/kasan_test_c.c                       |  2 +-
 mm/khugepaged.c                               |  2 +-
 mm/kmemleak.c                                 | 10 +++++++++-
 mm/mprotect.c                                 | 23 ++++++++++-------------
 mm/mremap.c                                   |  4 ++++
 mm/userfaultfd.c                              | 17 ++++++++++-------
 tools/testing/selftests/proc/proc-maps-race.c |  6 +++---
 9 files changed, 57 insertions(+), 32 deletions(-)


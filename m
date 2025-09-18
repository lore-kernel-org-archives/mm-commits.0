Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCE81F4181;
	Thu, 18 Sep 2025 04:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758168792; cv=none; b=qArNwlnu99iReaUjFux+ygtFuRDBH9wseODZWSrLS0A8/h9Luu0XTu9X8AQPhFMlnNFOZuEZ/KCPj7zKuaOzzY95R3qaL8teQNps8lxxOLsdnmADBNODTw2RPXoGx/tt97NYsrwpN226maf2q9YGEMWknhFBa631MmbfEK2PBqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758168792; c=relaxed/simple;
	bh=W7Yj5+1o6KKMQC/tA+UpcbbG71xRxkrXyq2jA6xZEe8=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=f9kW3k0d/mdwGMMxV6ex/+n8Lz0Y6GLEHp+n/LEQydaVrJemep9dVpkRIbDb3hWu4/MPxtljur4SzzPotCYkbgHBSAgNfOadfNivTgjtzRKgLADku951xmwHstx+VKOkT7uacvdMK63l/+glLjsFiZgKM4YsCjFSFEKE4hksY1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ErSRjBVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ErSRjBVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEB8C4CEE7;
	Thu, 18 Sep 2025 04:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758168791;
	bh=W7Yj5+1o6KKMQC/tA+UpcbbG71xRxkrXyq2jA6xZEe8=;
	h=Date:From:To:Cc:Subject:From;
	b=ErSRjBVvxfZAW9IXBd47FcARzxb0fJHZzBM57kJEbVjPS9Zgw690tuQI3p5tAiFkk
	 9dgXH8ElJQcIhJBoSCToVRqOjEbLIiv+d49mbKuWF52CyxDDhtRBV0+6lP+SLO6aWn
	 /4v67jTsYSQ33omWwyqA4pDCVQsv6SbNG9tKTXQk=
Date: Wed, 17 Sep 2025 21:13:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: [GIT PULL] hotfixes for 6.17-rc7
Message-Id: <20250917211310.da8771af4cb50be2e657fe6a@linux-foundation.org>
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


The following changes since commit a68172d95c2845d2b5455b072b4ff51ba32650e9:

  MAINTAINERS: add tree entry to numa memblocks and emulation block (2025-09-08 23:45:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-17-21-10

for you to fetch changes up to ce4be9e4307c5a60701ff6e0cafa74caffdc54ce:

  zram: fix slot write race condition (2025-09-15 20:01:45 -0700)

----------------------------------------------------------------
15 hotfixes.  11 are cc:stable and the remainder address post-6.16 issues
or aren't considered necessary for -stable kernels.  13 of these fixes are
for MM.

The usual shower of singletons, plus

- A 5 patch series from Hugh which addresses various misbehaviors in
  get_user_pages()

- A 2 patch series from SeongJae which addresses a quite severe issue in
  DAMON

- A 3 patch series also from SeongJae which completes some fixes for a
  DAMON startup issue

----------------------------------------------------------------
Hugh Dickins (5):
      mm/gup: check ref_count instead of lru before migration
      mm/gup: local lru_add_drain() to avoid lru_add_drain_all()
      mm: revert "mm/gup: clear the LRU flag of a page before adding to LRU batch"
      mm: revert "mm: vmscan.c: fix OOM on swap stress test"
      mm: folio_may_be_lru_cached() unless folio_test_large()

Lance Yang (1):
      MAINTAINERS: add Lance Yang as a THP reviewer

Lorenzo Stoakes (1):
      MAINTAINERS: add Jann Horn as rmap reviewer

Nathan Chancellor (1):
      nilfs2: fix CFI failure when accessing /sys/fs/nilfs2/features/*

SeongJae Park (5):
      mm/damon/core: introduce damon_call_control->dealloc_on_cancel
      mm/damon/sysfs: use dynamically allocated repeat mode damon_call_control
      samples/damon/wsse: avoid starting DAMON before initialization
      samples/damon/prcl: avoid starting DAMON before initialization
      samples/damon/mtier: avoid starting DAMON before initialization

Sergey Senozhatsky (1):
      zram: fix slot write race condition

 MAINTAINERS                   |  2 ++
 drivers/block/zram/zram_drv.c |  8 +++----
 fs/nilfs2/sysfs.c             |  4 ++--
 fs/nilfs2/sysfs.h             |  8 +++----
 include/linux/damon.h         |  2 ++
 include/linux/swap.h          | 10 +++++++++
 mm/damon/core.c               |  8 +++++--
 mm/damon/sysfs.c              | 23 +++++++++++++-------
 mm/gup.c                      | 14 +++++++++---
 mm/mlock.c                    |  6 +++---
 mm/swap.c                     | 50 ++++++++++++++++++++++---------------------
 mm/vmscan.c                   |  2 +-
 samples/damon/mtier.c         |  3 +++
 samples/damon/prcl.c          |  3 +++
 samples/damon/wsse.c          |  3 +++
 15 files changed, 94 insertions(+), 52 deletions(-)


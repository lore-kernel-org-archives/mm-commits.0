Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A3676036;
	Sun,  3 Nov 2024 18:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730660046; cv=none; b=j46L2FA5swujhk5BvF3UAQkjK7ybJEFpFJ2Ac55vfS55glKBWdhja3/ZrbzC4a1Nw8tLDW2uJwbzbKSgn2N8QqFjYA5qPabWPJhQ3A2/Chf6wJEBNbhHrHnalGw0p/ZNUzzUPKgu5bVwiNGz8Wc6PUC4EHAJpcKD8/Oy1WmlROU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730660046; c=relaxed/simple;
	bh=c+u4loJ6pRD4+LwnocXU7ZKua1nFlBmCBPVm25XIrrw=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Qbo/vXDyslolUSYAN3EpijFH7Qi2dgN3oDV2fR8woAombtBWLe0RY2JX+WjvYuetL5McQM1FJXDl0w35H52tDAhyPuUgBXFr42pEl1+QQqvSAbR3EVh2EE9tKF/06S0l3d/JA5w/4OuaU7RWutGA5Yse/zkwqoyqD/UWSfFF8hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kwQJ6F7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kwQJ6F7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B24C4CECD;
	Sun,  3 Nov 2024 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730660045;
	bh=c+u4loJ6pRD4+LwnocXU7ZKua1nFlBmCBPVm25XIrrw=;
	h=Date:From:To:Cc:Subject:From;
	b=kwQJ6F7uhX+7AVNDGEdd4nxuboK+nCAr360f69YsMqnc08KPUShNEmg7NcyEtpJUG
	 WpD23cqRkDyPJqsZUiB0316cLUgQZME4zEOZzeQEEtmyewsezl9XI5CQlizyc4wPtw
	 mUmtdeNPIy4f5fGVh66v3gyIJfKtBW02WkostFjI=
Date: Sun, 3 Nov 2024 10:54:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.12-rc6
Message-Id: <20241103105404.3c1a60806b3db3baa1519537@linux-foundation.org>
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


The following changes since commit 01626a18230246efdcea322aa8f067e60ffe5ccd:

  mm: avoid unconditional one-tick sleep when swapcache_prepare fails (2024-10-28 21:40:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-11-03-10-50

for you to fetch changes up to 1d4832becdc2cdb2cffe2a6050c9d9fd8ff1c58c:

  mm: multi-gen LRU: use {ptep,pmdp}_clear_young_notify() (2024-11-03 10:47:03 -0800)

----------------------------------------------------------------
17 hotfixes.  9 are cc:stable.  13 are MM and 4 are non-MM.

The usual collection of singletons - please see the changelogs.

----------------------------------------------------------------
Andrey Konovalov (1):
      kasan: remove vmalloc_percpu test

Barry Song (1):
      mm: fix PSWPIN counter for large folios swap-in

Chen Ridong (1):
      mm: shrinker: avoid memleak in alloc_shrinker_info

Eugen Hristev (1):
      .mailmap: update e-mail address for Eugen Hristev

Gregory Price (1):
      vmscan,migrate: fix page count imbalance on node stats when demoting pages

Hao Ge (1):
      mm/codetag: fix null pointer check logic for ref and tag

Jarkko Sakkinen (1):
      mailmap: update Jarkko's email addresses

John Hubbard (1):
      mm/gup: stop leaking pinned pages in low memory conditions

Kairui Song (1):
      mm, swap: avoid over reclaim of full clusters

Phillip Lougher (1):
      Squashfs: fix variable overflow in squashfs_readpage_block

Ryusuke Konishi (1):
      nilfs2: fix potential deadlock with newly created symlinks

Vlastimil Babka (1):
      mm, mmap: limit THP alignment of anonymous mappings to PMD-aligned sizes

Wladislav Wiebe (1):
      tools/mm: -Werror fixes in page-types/slabinfo

Yu Zhao (3):
      mm: allow set/clear page_type again
      mm: multi-gen LRU: remove MM_LEAF_OLD and MM_NONLEAF_TOTAL stats
      mm: multi-gen LRU: use {ptep,pmdp}_clear_young_notify()

Zi Yan (1):
      mm: avoid VM_BUG_ON when try to map an anon large folio to zero page.

 .mailmap                   |   5 ++-
 fs/nilfs2/namei.c          |   3 ++
 fs/squashfs/file_direct.c  |   9 ++--
 include/linux/alloc_tag.h  |  16 ++++---
 include/linux/mmzone.h     |   7 ++--
 include/linux/page-flags.h |   8 ++++
 include/linux/swap.h       |   1 +
 mm/gup.c                   |  33 ++++++++-------
 mm/kasan/kasan_test_c.c    |  27 ------------
 mm/migrate.c               |   5 ++-
 mm/mmap.c                  |   3 +-
 mm/page_io.c               |   4 +-
 mm/rmap.c                  |   9 ++--
 mm/shrinker.c              |   8 ++--
 mm/swapfile.c              |  49 +++++++++++++---------
 mm/vmscan.c                | 102 ++++++++++++++++++++++++---------------------
 tools/mm/page-types.c      |   9 ++--
 tools/mm/slabinfo.c        |   4 +-
 18 files changed, 159 insertions(+), 143 deletions(-)


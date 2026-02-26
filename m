Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D613016E2;
	Thu, 26 Feb 2026 22:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772144194; cv=none; b=PeBnII7TZO11z5Qbc3OKAi7Nji1wp9Qr/buJw5yQd1Ko+Ja5HdJuHZL0DJ99W9VVdM6hlX003Y0YMLXRwM+cLGzUi1FHTzoxUXGRsp7Vd9yvQKsPUIHd4THKbWuflAw5gsuj73mCClTmR32lIHi0iMFIavUTqTQreSCtqilC3jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772144194; c=relaxed/simple;
	bh=BE0fpb4BhRoem7NlGuVlvqeNimwZSbowvwDgnccDyFg=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=IFnp252hVi0AWelW3FmS1bxfyu8BHwgpL+/XkElAmmfqx/3hZzl7PAywzVH8eD62U6TnTkL9aNVhgAeFq3cjmaDq+rzHwB7jCkN6QvJcp+KLhtMoh08X6f+HDSn/itrvoH4hWinBHYtN6ZBDJ9GJXakrrq4lVbU5BvRM/oL67k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X1Wf65kj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X1Wf65kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B976C116C6;
	Thu, 26 Feb 2026 22:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772144194;
	bh=BE0fpb4BhRoem7NlGuVlvqeNimwZSbowvwDgnccDyFg=;
	h=Date:From:To:Cc:Subject:From;
	b=X1Wf65kj8xm3BDnBvQQlzXyKgJ2d7LCGkq4Nf8xLr52BY+yXsI61lTG0PF2taALKN
	 nkUmWNT1ktI5VTO9rYzFQNPcM3bkvIuqFJIH9FJue1jsO0GShq13bms6vH9Jxza9+i
	 m2mjxNvKb4a+V+dqgKBXp0mdxngHsrjmVbzYZVEU=
Date: Thu, 26 Feb 2026 14:16:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.0-rc2
Message-Id: <20260226141633.fd525fd4a4fe2c0cc07596f5@linux-foundation.org>
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



The following changes since commit 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-26-14-14

for you to fetch changes up to 410aed670cddac1de4f0c2865f30ec623fd20f78:

  MAINTAINERS: update Yosry Ahmed's email address (2026-02-24 11:13:28 -0800)

----------------------------------------------------------------
12 hotfixes.  7 are cc:stable.  8 are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Alexander Potapenko (2):
      mm/kfence: disable KFENCE upon KASAN HW tags enablement
      mm/kfence: fix KASAN hardware tag faults during late enablement

Arnd Bergmann (1):
      mm: change vma_alloc_folio_noprof() macro to inline function

Daniele Alessandrelli (1):
      mailmap: add entry for Daniele Alessandrelli

Deepanshu Kartikey (1):
      mm: thp: deny THP for files on anonymous inodes

Kalesh Singh (1):
      mm/tracing: rss_stat: ensure curr is false from kthread context

Ming Lei (1):
      mm: fix NULL NODE_DATA dereference for memoryless nodes on boot

Phillip Lougher (1):
      Squashfs: check metadata block offset is within range

Pratyush Yadav (Google) (1):
      liveupdate: luo_file: remember retrieve() status

SeongJae Park (1):
      mm/damon/core: disallow non-power of two min_region_sz

Vlastimil Babka (SUSE) (1):
      MAINTAINERS, mailmap: update e-mail address for Vlastimil Babka

Yosry Ahmed (1):
      MAINTAINERS: update Yosry Ahmed's email address

 .mailmap                     |  5 ++++-
 MAINTAINERS                  | 20 ++++++++++----------
 fs/squashfs/cache.c          |  3 +++
 include/linux/gfp.h          |  7 +++++--
 include/linux/liveupdate.h   |  9 ++++++---
 include/trace/events/kmem.h  |  8 +++++++-
 kernel/liveupdate/luo_file.c | 41 +++++++++++++++++++++++++----------------
 mm/damon/core.c              |  3 +++
 mm/huge_memory.c             |  3 +++
 mm/kfence/core.c             | 29 +++++++++++++++++++++++------
 mm/memfd_luo.c               |  7 ++++++-
 mm/mm_init.c                 |  6 +++++-
 mm/page_alloc.c              |  3 ++-
 13 files changed, 102 insertions(+), 42 deletions(-)


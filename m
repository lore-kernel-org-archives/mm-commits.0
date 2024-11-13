Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6E779FE;
	Wed, 13 Nov 2024 00:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731458490; cv=none; b=IbBBUFusfR3UGCzey8kXSU7P5BzuOwgGGOKS0Il/CrLFKo0A48U0ebqvrxcQkr3xdZaTl2RD1aALrPccokztCKlqCpDu6c6E6rhzqCJVkItAWVvhSA1ir3fukU5f/JRH9nrLGCMOXsqOsXocIDiDVoBTdNUz6fHTK5+lIMmuBhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731458490; c=relaxed/simple;
	bh=Is3ssievspKEHE3q3tDDHCIV5v6o3lZOjLw3GEhHSiM=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=UDs1NGwji1LNtyJDdNgNxwKW6BsFqXNlCM9bNTr0xCi7QTI+d2S826CG0JzRDg0uEKYwoMeediaugaNrCOVuR4aBlbnBSxVd+X7EmqqotM1yPpyLQBFMgfryDVYlxSxY9JGJbSJmmsB01afV3WTBtcrbUlPoPxYwR8qWAX56Y/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=06MG/l7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="06MG/l7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F27EC4CED4;
	Wed, 13 Nov 2024 00:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731458489;
	bh=Is3ssievspKEHE3q3tDDHCIV5v6o3lZOjLw3GEhHSiM=;
	h=Date:From:To:Cc:Subject:From;
	b=06MG/l7WQ2prnXU5sEZyCxX3NGC+U4dfIm7K/X7Lv+Q3oDbRMlnwtPWr7Z7o5+MUg
	 bztOuCl9VnzwnLUmPriV4zPvlyZkRB5zi9Ltf0A9yM6e/c5LZ2DBaJKOF6ZXqJb9Qv
	 Oqhmd7wv3Rn9UFah6iXeXIdcMNizQxmqtRfrmNOg=
Date: Tue, 12 Nov 2024 16:41:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.12
Message-Id: <20241112164128.20f96b224ec3e2be9403fee2@linux-foundation.org>
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

The following changes since commit c289f4de8e479251b64988839fd0e87f246e03a2:

  mailmap: add entry for Thorsten Blum (2024-11-07 14:14:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-11-12-16-39

for you to fetch changes up to dcf32ea7ecede94796fb30231b3969d7c838374c:

  mm: swapfile: fix cluster reclaim work crash on rotational devices (2024-11-12 16:01:36 -0800)

----------------------------------------------------------------
10 hotfixes, 7 of which are cc:stable.  7 are MM, 3 are not.  All
singletons.

----------------------------------------------------------------
Barry Song (1):
      mm: count zeromap read and set for swapout and swapin

Dmitry Antipov (1):
      ocfs2: fix UBSAN warning in ocfs2_verify_volume()

Donet Tom (1):
      selftests: hugetlb_dio: fixup check for initial conditions to skip in the start

Hajime Tazaki (1):
      nommu: pass NULL argument to vma_iter_prealloc()

Hugh Dickins (1):
      mm/thp: fix deferred split queue not partially_mapped: fix

Johannes Weiner (1):
      mm: swapfile: fix cluster reclaim work crash on rotational devices

John Hubbard (1):
      mm/gup: avoid an unnecessary allocation call for FOLL_LONGTERM cases

Roman Gushchin (1):
      mm: page_alloc: move mlocked flag clearance into free_pages_prepare()

Ryusuke Konishi (2):
      nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint
      nilfs2: fix null-ptr-deref in block_dirty_buffer tracepoint

 Documentation/admin-guide/cgroup-v2.rst  |   9 +++
 fs/nilfs2/btnode.c                       |   2 -
 fs/nilfs2/gcinode.c                      |   4 +-
 fs/nilfs2/mdt.c                          |   1 -
 fs/nilfs2/page.c                         |   2 +-
 fs/ocfs2/super.c                         |  13 ++--
 include/linux/memcontrol.h               |  12 ++--
 include/linux/vm_event_item.h            |   2 +
 mm/gup.c                                 | 116 ++++++++++++++++++++-----------
 mm/huge_memory.c                         |   4 +-
 mm/memcontrol.c                          |   4 ++
 mm/nommu.c                               |   2 +-
 mm/page_alloc.c                          |  15 ++++
 mm/page_io.c                             |  16 +++++
 mm/swap.c                                |  14 ----
 mm/swapfile.c                            |   2 +-
 mm/vmstat.c                              |   2 +
 mm/zswap.c                               |   6 +-
 tools/testing/selftests/mm/hugetlb_dio.c |   7 ++
 19 files changed, 158 insertions(+), 75 deletions(-)


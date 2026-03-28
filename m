Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50393491F5;
	Sat, 28 Mar 2026 17:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774720146; cv=none; b=b5nvajblOTg8a1hcnzh65wqlJyF45XAaPWE2X5fBBT/Q+H6p4wYV50+D4BZlUQLd24beNjk6rKN1ImHD3FbGhxJg6APCyeVJ4qemNVafjMjNkCUP27Hl3H3Sb3Ou4ir7FPe+ZMGygraAyihXR+Vwiqq8gqx6rFVYNFseqjn1jUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774720146; c=relaxed/simple;
	bh=dKl5Ev2JkKCfZFM2QBz1yv5YQSqYGiO+Zq8rSPe3O4c=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=dWJAqa2atfoZJWtKFfs/V6bkfDETh9oX+i1KyoZXLUDqKTgSctgVVqw36V3lZwQf0GsbMBVu8gzf/PMrAsOXzCDSXOolnTigUSP2P5F7ZbCWIhWu7AoxyQ/D2lIIvF1oaqFAGYNY/qcbAeXGnfiNc9xMKK+412EeKrtGY86amT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ppWh2Uei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ppWh2Uei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436BDC4CEF7;
	Sat, 28 Mar 2026 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774720146;
	bh=dKl5Ev2JkKCfZFM2QBz1yv5YQSqYGiO+Zq8rSPe3O4c=;
	h=Date:From:To:Cc:Subject:From;
	b=ppWh2UeinNAOpe+n4gw2MNeAHyLbU0436KkQlytVr7GrSXPRj61PmcJOUKx3kj7U0
	 XI21P4TWD+ABXgMw88cs95u9Pl5O/WugdAF3GlWIyneu5sU7K4Kwzzz6/HNFy2AsM5
	 poUGF2PSco6qn94+Uhu+vjJRr5weXVQil01MHywE=
Date: Sat, 28 Mar 2026 10:49:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: [GIT PULL] Additional hotfixes for 7.0-rc6
Message-Id: <20260328104905.4f602f792bacc66ff1495ecd@linux-foundation.org>
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


The following changes since commit 24f9515de8778410e4b84c85b196c9850d2c1e18:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2026-03-24 13:11:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-28-10-45

for you to fetch changes up to 2697dd8ae721db4f6a53d4f4cbd438212a80f8dc:

  mm/mseal: update VMA end correctly on merge (2026-03-27 20:48:38 -0700)

----------------------------------------------------------------
10 hotfixes.  8 are cc:stable.  9 are for MM.

There's a 3-patch series of DAMON fixes from Josh Law and SeongJae Park.
The rest are singletons - please see the changelogs for details.

----------------------------------------------------------------
Alexandre Ghiti (1):
      mm/swap: fix swap cache memcg accounting

Arnd Bergmann (1):
      bug: avoid format attribute warning for clang as well

David Hildenbrand (Arm) (1):
      mm/memory: fix PMD/PUD checks in follow_pfnmap_start()

Harry Yoo (Oracle) (1):
      MAINTAINERS, mailmap: update email address for Harry Yoo

Jinjiang Tu (1):
      mm/huge_memory: fix folio isn't locked in softleaf_to_folio()

Josh Law (3):
      mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
      mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
      mm/damon/sysfs: check contexts->nr in repeat_call_fn

Lorenzo Stoakes (Oracle) (1):
      mm/mseal: update VMA end correctly on merge

Max Boone (1):
      mm/pagewalk: fix race between concurrent split and refault

 .mailmap                |  1 +
 MAINTAINERS             |  4 ++--
 include/linux/leafops.h | 32 +++++++++++++++++++++-----------
 lib/bug.c               |  7 ++-----
 mm/damon/sysfs.c        | 10 +++++++++-
 mm/memory.c             | 18 +++++++++++++++---
 mm/mseal.c              |  3 +--
 mm/pagewalk.c           | 25 ++++++++++++++++++++++---
 mm/swap_state.c         |  9 ++++-----
 9 files changed, 77 insertions(+), 32 deletions(-)


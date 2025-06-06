Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D49A23C513;
	Fri,  6 Jun 2025 23:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749251553; cv=none; b=elEgWKdnApX0OaSZx65TBZIf7NXCAWNuxaIiZWtYtMjF4u4uLsFe9AwSNsUUk5dN8v+6PsXU125JWnT7OXsAs6SBOKN00Mcok2pqcg469Al7zPa8+UgjKeNjoaqexBcyzVSF83B5jkHHSCYLKYJuU/iboxRnGjM36OdGdlbGgK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749251553; c=relaxed/simple;
	bh=Y/AoP0FEgGnlnIYIsy+3MH4A8U98giK25w815lLPc/k=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Fixqf07a1s4M6mBRg/x/w7CxbWdR/aV8g1iWNM8v5wRlANkvCi1QsRWBTqKB76ATG8BYeP7AKtqGixgRY3JB+N5lwgKZbOIX3Hp3aV0xaacEVbm+ohdIQ6ezJi/wIFpyRlRneCk24P/95isAqteet5cGfsTo1AoldkHrihqMdJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e4ZwYuAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e4ZwYuAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847CAC4CEEB;
	Fri,  6 Jun 2025 23:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749251552;
	bh=Y/AoP0FEgGnlnIYIsy+3MH4A8U98giK25w815lLPc/k=;
	h=Date:From:To:Cc:Subject:From;
	b=e4ZwYuAN/l07V+LccYjWrp86lSliWhuyMYRefIEpzakNgFf36Clop6PdJRKFHwxjP
	 M/V8LtaPWCOqPoPw/lXeQKglkOr6WGkg6xrwMwk52k9rwjml/OdqkMeJGYZfTiHcoZ
	 LxGSmaqyS0YAf0CEQbUnEIh/XXqJYZDDcI+R+wKM=
Date: Fri, 6 Jun 2025 16:12:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] Final MM updates for 6.16-rc1
Message-Id: <20250606161231.c9e10415b320f8cbc7006d26@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this single bugfix series for this -rc cycle, thanks.


The following changes since commit 546b1c9e93c2bb8cf5ed24e0be1c86bb089b3253:

  Merge tag 'bootconfig-v6.16' of git://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace (2025-06-02 17:39:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-06-06-16-09

for you to fetch changes up to efe99fabeb11b030c89a7dc5a5e7a7558d0dc7ec:

  selftests/mm: add test about uprobe pte be orphan during vma merge (2025-06-05 21:55:42 -0700)

----------------------------------------------------------------
- The 4 patch series "Fix uprobe pte be overwritten when expanding vma"
  fixes a longstanding and quite obscure bug related to the vma merging of
  the uprobe mmap page.

----------------------------------------------------------------
Enze Li (1):
      mm/damon: s/primitives/code/ on comments

Pu Lehui (4):
      mm: fix uprobe pte be overwritten when expanding vma
      mm: expose abnormal new_pte during move_ptes
      selftests/mm: extract read_sysfs and write_sysfs into vm_util
      selftests/mm: add test about uprobe pte be orphan during vma merge

 mm/damon/modules-common.c              |  2 +-
 mm/damon/modules-common.h              |  2 +-
 mm/damon/ops-common.c                  |  2 +-
 mm/damon/ops-common.h                  |  2 +-
 mm/damon/paddr.c                       |  2 +-
 mm/damon/sysfs-common.c                |  2 +-
 mm/damon/sysfs-common.h                |  2 +-
 mm/damon/vaddr.c                       |  2 +-
 mm/mremap.c                            |  2 ++
 mm/vma.c                               | 20 +++++++++++++---
 mm/vma.h                               |  7 ++++++
 tools/testing/selftests/mm/ksm_tests.c | 32 ++-----------------------
 tools/testing/selftests/mm/merge.c     | 43 ++++++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/thuge-gen.c |  6 ++---
 tools/testing/selftests/mm/vm_util.c   | 38 ++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h   |  2 ++
 16 files changed, 122 insertions(+), 44 deletions(-)


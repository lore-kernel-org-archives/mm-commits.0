Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE13438DD6;
	Wed,  9 Oct 2024 22:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728514235; cv=none; b=MZBW40G5bzO0yGe+kONAZC2Gp2QSVH6uCfshg5J22b9NyoGROWk3llDffQOiwMyJ0ElDYGn+R+0QGeMUuEjLdRzut7Y6EXK5P8UEy3Z71wHXEhGM0BdpodSOKNIijlE/aIVMZtVzJUvXxuQPXLim1gcz2gC9EhZhVz+YivxnKM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728514235; c=relaxed/simple;
	bh=yp9jnf3FBTExrM/NMdoi7V2XqIX6e+POcU+MsL6Eet4=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=CXfmY7fZdxhcEHTwQMLXU0WewY5U4/46lXHbgznt3LItwto0H0krYlP4Gwf274dJFkxh32mGHPo5VQn/2CpbrTvat9kYmcwhrP0VTQWlaa/KQnwp4TW5Fkl1yTuxXDgmr4xbm1WZQGvFmKbKd6Iu7C2mIKiuTYeKlAHyLkLhU5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c38yKG+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c38yKG+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCE7C4CEC3;
	Wed,  9 Oct 2024 22:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728514234;
	bh=yp9jnf3FBTExrM/NMdoi7V2XqIX6e+POcU+MsL6Eet4=;
	h=Date:From:To:Cc:Subject:From;
	b=c38yKG+G7PMon3jviCkCCihTebar6dYZszxvyKxnHnyqxJduPioc5xZhmVI7nOIHs
	 lxP8U94PqfbYoblyDMNjdKCYD0g3sGwJuADW8yz0NevnmZBe8+rvAC5L1a109+Yhcg
	 Zz3krhkyjWMRBhfR58QCG7QYWJ1C629d9/4tZc+Q=
Date: Wed, 9 Oct 2024 15:50:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.12-rc3
Message-Id: <20241009155033.485bc6df1a01b6dfca93a9d9@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b:

  Linux 6.12-rc2 (2024-10-06 15:32:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-10-09-15-46

for you to fetch changes up to aa5f0fa6af38d96bc6f1b7e1534f5b5c025930a6:

  mm: zswap: delete comments for "value" member of 'struct zswap_entry'. (2024-10-09 12:47:19 -0700)

----------------------------------------------------------------
12 hotfixes, 5 of which are c:stable.  All singletons, about half of which
are MM.

----------------------------------------------------------------
Alexander Gordeev (1):
      fs/proc/kcore.c: allow translation of physical memory addresses

David Hildenbrand (1):
      mm/huge_memory: check pmd_special() only after pmd_present()

Donet Tom (1):
      selftests/mm: fix incorrect buffer->mirror size in hmm2 double_map test

Fangrui Song (1):
      .mailmap: update Fangrui's email

Frederic Weisbecker (1):
      kthread: unpark only parked kthread

Huang Ying (1):
      resource, kunit: fix user-after-free in resource_test_region_intersects()

Kanchana P Sridhar (1):
      mm: zswap: delete comments for "value" member of 'struct zswap_entry'.

Krzysztof Kozlowski (1):
      CREDITS: sort alphabetically by name

Kun(llfl) (1):
      device-dax: correct pgoff align in dax_set_mapping()

Michal Hocko (2):
      bcachefs: do not use PF_MEMALLOC_NORECLAIM
      Revert "mm: introduce PF_MEMALLOC_NORECLAIM, PF_MEMALLOC_NOWARN"

Patrick Roy (1):
      secretmem: disable memfd_secret() if arch cannot set direct map

 .mailmap                               |  1 +
 CREDITS                                | 54 +++++++++++++++++-----------------
 arch/s390/include/asm/io.h             |  2 ++
 drivers/dax/device.c                   |  2 +-
 fs/bcachefs/fs.c                       | 14 ++++-----
 fs/inode.c                             | 10 ++++---
 fs/proc/kcore.c                        | 36 +++++++++++++++++++++--
 include/linux/fs.h                     |  7 ++++-
 include/linux/sched.h                  |  4 +--
 include/linux/sched/mm.h               | 17 +++--------
 include/linux/security.h               |  4 +--
 kernel/kthread.c                       |  2 ++
 kernel/resource_kunit.c                | 18 +++++++++---
 mm/huge_memory.c                       |  2 +-
 mm/secretmem.c                         |  4 +--
 mm/zswap.c                             |  1 -
 security/security.c                    | 10 ++++---
 tools/testing/selftests/mm/hmm-tests.c |  2 +-
 18 files changed, 117 insertions(+), 73 deletions(-)


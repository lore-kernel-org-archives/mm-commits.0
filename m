Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C607D345758;
	Mon,  9 Mar 2026 23:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773099527; cv=none; b=Ze/jw9OPsyolHfefb0INyNBgkEV3UrTRnIPAmMglppiRvPBnyg+2ghfPqklv4MpI0On0Ma7r2DLRqRU9MaRogWpt6lM1sGjnXbhjjSP60wZLBD4lU6B+pbS/PcZQ8PAZcXXxYAV4p9xUFqaoj0NvZU4f8fgTkzQX+zrCQj/c+LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773099527; c=relaxed/simple;
	bh=FykBWcFe23lE0fFQ+0Q1RwNiAvy8eDPcpckP4pBtT7Q=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=PRllY5Rr9Y+F3+S6ry00BLdI3x9EzCtsgTPQMRsVUopJ53kIqjR21dYl/Np9C3265rTYfcPUhCVIDvQLW4gc21JX2kI/VbCfmlI2taM8gW8MQ8xhnHwuu0BRoAHU27eirZhEU+melZrmq8Y9HhQBWMRL8k6fpFostiJnL2LesT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ctBzW0Pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ctBzW0Pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BAFC4CEF7;
	Mon,  9 Mar 2026 23:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773099527;
	bh=FykBWcFe23lE0fFQ+0Q1RwNiAvy8eDPcpckP4pBtT7Q=;
	h=Date:From:To:Cc:Subject:From;
	b=ctBzW0PnltS9HVS48yHYDmydDQQY2lN9rew4C6+WJnP8JqzF23lLjJPF/T59cadw8
	 R2wkZ7Z3CxU6Jp8kG7sdFgBvYwUHn/0aFA1SkJsuTgGMXBAPmEQ0eeDr3aBCE/3TEB
	 E9nQJEzqOHrNLKHvogIjOtMNgs6PxyM3lOpghi6s=
Date: Mon, 9 Mar 2026 16:38:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.0-rc4
Message-Id: <20260309163846.f59b3518cba71b9587576e7f@linux-foundation.org>
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



The following changes since commit 410aed670cddac1de4f0c2865f30ec623fd20f78:

  MAINTAINERS: update Yosry Ahmed's email address (2026-02-24 11:13:28 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-09-16-36

for you to fetch changes up to b12bbe35c7c1e431f2fa01fe9291daa52fb7ab43:

  MAINTAINERS, mailmap: update email address for Lorenzo Stoakes (2026-03-04 10:06:40 -0800)

----------------------------------------------------------------
15 hotfixes.  6 are cc:stable.  14 are for MM.

Singletons, with one doubleton - please see the changelogs for details.

----------------------------------------------------------------
Axel Rasmussen (1):
      Revert "ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()"

Hao Li (1):
      memcg: fix slab accounting in refill_obj_stock() trylock path

Jason Xing (1):
      MAINTAINERS: add RELAY entry

Lorenzo Stoakes (Oracle) (1):
      MAINTAINERS, mailmap: update email address for Lorenzo Stoakes

Mike Rapoport (Microsoft) (1):
      tools/testing: fix testing/vma and testing/radix-tree build

Pratyush Yadav (Google) (2):
      mm: memfd_luo: always make all folios uptodate
      mm: memfd_luo: always dirty all folios

Randy Dunlap (2):
      uaccess: correct kernel-doc parameter format
      mm/mmu_notifier: clean up mmu_notifier.h kernel-doc

Raul Pazemecxas De Andrade (1):
      mm/damon/core: clear walk_control on inactive context in damos_walk()

Ritesh Harjani (IBM) (1):
      mm/hugetlb.c: use __pa() instead of virt_to_phys() in early bootmem alloc code

Sergey Senozhatsky (1):
      zram: rename writeback_compressed device attr

Vlastimil Babka (SUSE) (1):
      MAINTAINERS: add co-maintainer and reviewer for SLAB ALLOCATOR

Zi Yan (2):
      mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
      mm/huge_memory: fix a folio_split() race condition with folio_try_get()

 .mailmap                                    |  3 +-
 Documentation/ABI/testing/sysfs-block-zram  |  4 +--
 Documentation/admin-guide/blockdev/zram.rst |  6 ++--
 MAINTAINERS                                 | 33 ++++++++++++-------
 drivers/block/zram/zram_drv.c               | 24 +++++++-------
 drivers/block/zram/zram_drv.h               |  2 +-
 include/linux/mm.h                          | 17 ++++------
 include/linux/mmu_notifier.h                | 31 +++++++++---------
 include/linux/uaccess.h                     |  4 +--
 mm/cma.c                                    |  5 ++-
 mm/damon/core.c                             |  7 ++++-
 mm/huge_memory.c                            | 13 +++++---
 mm/hugetlb.c                                |  4 +--
 mm/memcontrol.c                             |  2 +-
 mm/memfd_luo.c                              | 49 +++++++++++++++++++++++++----
 tools/include/linux/gfp.h                   |  4 +++
 tools/include/linux/overflow.h              | 19 +++++++++++
 tools/include/linux/slab.h                  |  9 ++++++
 18 files changed, 163 insertions(+), 73 deletions(-)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA5B2032D;
	Mon, 25 May 2026 23:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779751497; cv=none; b=q5iAokflORe5DmhpFVnNMtx3LCbIWvfhq4oymlemf97VWQ1zRzONr/0K3+A5TeEgFrqb4N8a+OpSFKOSkS/M1NCXrhIdeLJRZ6J2JjsgiwqAD0I4CkGyfNHOiImIaB35KbT6FudswMgYqTZIFWVxWd+eSiPnnYRD/fbiaMpO89c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779751497; c=relaxed/simple;
	bh=7Myzvxi7wzfjCEaFkO0qEQcJvN4Awohd0j3frGET9T4=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=BAW4+Pp7Pz0CZVDP16A7aWQoVCaG59ZpRP/xoHGNAWfL7c5/G/h+DXyNdhVXJJmtHVeqmjdmjTI46/SR3lDec0A9l9FAiFBWFdHYKiwOX0haFrNd/an8R+QBzv811mEXUSsTt3YqssXRTraH3uEfrzKX+Hv9jHs0v2FzSIZPEsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XS8r4faf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XS8r4faf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4781F00A3A;
	Mon, 25 May 2026 23:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779751495;
	bh=q9/IdT39X3dE7LxPKUv6KDEBgFCD8qHZ8fQBx+/DyiY=;
	h=Date:From:To:Cc:Subject;
	b=XS8r4fafSV79SwewefejSDAPnLagqfP/a7Itn3C1fKwzxQp05KBnkL1WaG44xEWWj
	 vguUTsbAFoBtdAHBNGmulzHL7YDZZEhMqhZhylsQQ2q1vgeWlN/nTzsRCt4X3Evq6J
	 3n2oFGiy2/2pSbnLcQD/D09l+f3wkKyXV2y3Kyb8=
Date: Mon, 25 May 2026 16:24:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.1-rc6
Message-Id: <20260525162455.b407390573351c2d352baa16@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of 13 hotfixes, thanks.


The following changes since commit 27fa82620cbaa89a7fc11ac3057701d598813e87:

  Merge tag 'ata-7.1-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/libata/linux (2026-05-19 14:00:48 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-05-25-16-22

for you to fetch changes up to 54cf41c969da6637cce790b7400da1451609db9b:

  Revert "mm: introduce a new page type for page pool in page type" (2026-05-21 19:06:13 -0700)

----------------------------------------------------------------
13 hotfixes.  9 are for MM.  9 are cc:stable and the remaining 4 address
post-7.1 issues or aren't considered suitable for backporting.

All patches are singletons - please see the individual changelogs for
details.

----------------------------------------------------------------
Alexandre Ghiti (1):
      mm: memcontrol: propagate NMI slab stats to memcg vmstats

Byungchul Park (1):
      Revert "mm: introduce a new page type for page pool in page type"

Deepanshu Kartikey (1):
      kernel/fork: validate exit_signal in kernel_clone()

Dev Jain (1):
      mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one

Eugen Hristev (1):
      MAINTAINERS, mailmap: change email for Eugen Hristev

Ian Ray (1):
      MAINTAINERS: .mailmap: update after GEHC spin-off

Linpu Yu (1):
      ipc: limit next_id allocation to the valid ID range

Lorenzo Stoakes (1):
      Revert "mm/hugetlbfs: update hugetlbfs to use mmap_prepare"

Pratyush Yadav (Google) (1):
      memfd: deny writeable mappings when implying SEAL_WRITE

Richard Chang (1):
      zram: fix use-after-free in zram_writeback_endio

SeongJae Park (1):
      mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()

Sunny Patel (1):
      mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page

Uladzislau Rezki (Sony) (1):
      mm/vmalloc: do not trigger BUG() on BH disabled context

 .mailmap                                         |  6 +-
 MAINTAINERS                                      | 14 ++---
 drivers/block/zram/zram_drv.c                    |  6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |  2 +-
 fs/hugetlbfs/inode.c                             | 46 +++++----------
 include/linux/hugetlb.h                          |  8 +--
 include/linux/hugetlb_inline.h                   | 14 +----
 include/linux/mm.h                               | 27 ++++++++-
 include/linux/page-flags.h                       |  6 --
 include/net/netmem.h                             | 19 +------
 ipc/util.c                                       |  2 +-
 kernel/fork.c                                    | 11 ++--
 mm/damon/sysfs-schemes.c                         |  8 +--
 mm/hugetlb.c                                     | 71 ++++++++++--------------
 mm/memcontrol.c                                  |  6 ++
 mm/memfd.c                                       | 12 ++--
 mm/migrate_device.c                              |  4 +-
 mm/page_alloc.c                                  | 13 ++---
 mm/rmap.c                                        |  2 +
 mm/vmalloc.c                                     |  2 +-
 net/core/netmem_priv.h                           | 23 ++++----
 net/core/page_pool.c                             | 24 +-------
 22 files changed, 135 insertions(+), 191 deletions(-)


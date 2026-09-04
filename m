Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678E16FC3;
	Fri,  4 Sep 2026 00:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788482929; cv=none; b=m/eaWLNQuVHY0wuh8M23xkP+ine7GqWR2K/FtYzh4pAu3N2eO/Moi4QuQFox5rgedFOq0VAAT+J/o4JTCWZM+qHoyjlO/QLMnM3aj7tSLJ0L2VU4xX2F3dSpg6Vp0oTEWitHITM53aSp3ezKzYB5Z2icdy1UmJCkPhd2gdf5QDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788482929; c=relaxed/simple;
	bh=jh5O5cyOclG+OYyDl9N1sQbIplNvsglrZxAJbd097No=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=JUigRbdXfzSsYwjs0+mplvEMzaw8/XtvT9MWYldEPhPuBiYsShrJSo8qyW7zHFxrkglhhtD4rwh5vYK96Y9SlvcA2Hd0X4olNQDoewA8OoCBYUOBhHucYuQBavuppbuxZ2VNawk7iWajimV3KRJh6vYv82aoD2y9hzAfojTzsXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=av8liggb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="av8liggb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81D11F000E9;
	Fri,  4 Sep 2026 00:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788482928;
	bh=fZiJnm472/wWBjeAyig4dXl/rRisSJv+rJypmqNg45g=;
	h=Date:From:To:Cc:Subject;
	b=av8liggbntRqzftSpXrzTrkaUzYy6Vz8VFx+yEzAnncDQhHkX69PGCq6Kcbkx57k6
	 X7ekPLlCqHJWeBUN/c+OG1GBixVgh49MxLwYUEdSQVN93k9msX+Zow607ykTBVr5ej
	 FUnhH8PKf4l05O3+eYaZKva0N6AjnyjomiNb4Izw=
Date: Thu, 3 Sep 2026 17:48:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.3-rc2
Message-Id: <20260903174847.a7f81bd5400d48cc8d0feaf9@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of hotfixes.

There are no fixes (yet) for all the stuff we added in the most recent
merge window.  Hopefully a good sign.

Thanks.


The following changes since commit 786262be6048deab760f68c8acc2c85607165894:

  Merge tag 'edac_updates_for_v7.3_rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras (2026-08-31 20:10:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-03-17-45

for you to fetch changes up to 97d34aa65c29cca85e3e9050f4c936389b38a054:

  mm/secretmem: properly account locked pages (2026-09-03 10:56:10 -0700)

----------------------------------------------------------------
18 hotfixes.  13 are cc:stable.  15 are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Baolin Wang (1):
      mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs

Bryan Lim (1):
      userfaultfd: reset err to be 0 when move_pages_ptes succeeded

Eric Dumazet (2):
      mm/mempolicy: fix sleeping allocation in alloc_pages_bulk_weighted_interleave()
      Revert "once: don't use a work queue to reset sleepable static key"

Geert Uytterhoeven (1):
      MAINTAINERS: cover all of RAID

Hui Su (1):
      mm/migrate_device: avoid out-of-bounds writes for compound folios

Kiryl Shutsemau (Meta) (1):
      MAINTAINERS: add Kiryl as a THP reviewer

Lance Yang (1):
      MAINTAINERS: add Lance Yang as a hung task detector co-maintainer

Longlong Xia (1):
      mm/hugetlb: keep max_huge_pages when dissolving surplus folios

Lorenzo Stoakes (ARM) (3):
      MAINTAINERS: remove Lorenzo as THP co-maintainer
      mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP
      mm/secretmem: properly account locked pages

Narek Jilavyan (1):
      mm/hugetlb_cgroup: call page_counter_set_max() outside VM_BUG_ON()

Shakeel Butt (1):
      memcg: make the v1 soft limit knob inert

Sourav Panda (1):
      mm/hugetlb_cma: fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio

Thorsten Blum (1):
      MAINTAINERS: mailmap: update entries for Thorsten Blum

Usama Arif (1):
      mm/huge_memory: transfer the pmd dirty bit to the folio on zap

Wupeng Ma (1):
      mm/hugetlb: fix missing migratable flag on same-node hugetlb migration

 .mailmap                                       |   3 +-
 Documentation/admin-guide/cgroup-v1/memory.rst |  49 ++---------
 MAINTAINERS                                    |  10 +--
 include/linux/sched/user.h                     |   3 +-
 lib/once.c                                     |   2 +-
 mm/huge_memory.c                               |   2 +
 mm/hugetlb.c                                   |  20 +++--
 mm/hugetlb_cgroup.c                            |   7 +-
 mm/hugetlb_cma.c                               |  21 ++++-
 mm/khugepaged.c                                |   6 --
 mm/madvise.c                                   |   8 ++
 mm/memcontrol-v1.c                             |  43 +++++----
 mm/mempolicy.c                                 |   2 +-
 mm/migrate_device.c                            |  18 ++++
 mm/mremap.c                                    |  22 +++--
 mm/secretmem.c                                 | 116 +++++++++++++++++++++++--
 mm/userfaultfd.c                               |   4 +-
 tools/testing/selftests/mm/memfd_secret.c      |  30 +------
 18 files changed, 233 insertions(+), 133 deletions(-)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029733A6B73;
	Mon, 20 Jul 2026 18:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784572790; cv=none; b=OuexReHMPp9+yQ8rL8qWBVR/TenN8CXbuJs2XRn7f4kCGOFaYpWmHoNZGGIUHK9SnQXsx1b6K/yeLNyHAGr+C7v4CamgneJkG2Gjo7CyUHi/zxxiBrXuxG9ImEDsbITvoE2CVN4qktxSfMQPB7TOm5VHB9EvBXl/6vEz+pI7edE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784572790; c=relaxed/simple;
	bh=mvfy98GnN4DnG6bJSt/uoilx73rxNOFDRKuQXzQs32s=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=kDd640x73mX27hkZvLB1lCFKgPemLMG75/+1MHMq5ItdhWswH7de9/mBvQm8KOYYLTVN9tWq1iWi4DHJeRJQGLY9BJZ2NU4qwnfy01xbte6uQ9zZMWlnw0PzO6jK9M6TFog9VBVplf65L7122brgIF5V6YI7GPElZzdNtSJu4X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SLoo8cFp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SLoo8cFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624A91F000E9;
	Mon, 20 Jul 2026 18:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784572788;
	bh=zF+e/1G0vzgBGsv1J53vfYEU04ziss3ABl+i/SzrfQk=;
	h=Date:From:To:Cc:Subject;
	b=SLoo8cFpJ773Dt7r9HY9ZuvwYzxANVp2rYtJlT5cDRPMAG9lLUsdYRTaL/54Y/W5O
	 kVV4b6eXFbDj3ZYZa5hGXc8Ih8sJW/yZcTsmU3c8Lerzl5rIpZCg5WXC5s9TtRrZVF
	 uRgDJ9jy0ZJBHWiC0SI085XjRxm/bMNZkUY1Sh5k=
Date: Mon, 20 Jul 2026 11:39:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.2-rc5
Message-Id: <20260720113947.6b43f86cede7f20c4126650b@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge this batch of hotfixes, thanks.

The following changes since commit 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53:

  Merge tag 'mm-hotfixes-stable-2026-07-06-17-49' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/akpm/mm (2026-07-06 18:51:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2026-07-20-11-37

for you to fetch changes up to e57d6e9e20b551e4910d7a6331a81775c3ad6693:

  mm/memory-failure: trace: change memory_failure_event to ras subsystem (2=
026-07-09 15:48:56 -0700)

----------------------------------------------------------------
12 hotfixes.  8 are cc:stable and the remainder address post-7.1 issues or
aren't considered appropriate for backporting.  10 are for MM.

All are singletons - please see the relevant changelogs for details.

----------------------------------------------------------------
Arnd Bergmann (1):
      fat: avoid stack overflow warning

Breno Leitao (1):
      mm/kmemleak: fix checksum computation for per-cpu objects

Lance Yang (1):
      MAINTAINERS: add Usama as a THP reviewer

Michael S. Tsirkin (1):
      mm: page_reporting: allow driver to set batch capacity

Mike Rapoport (Microsoft) (1):
      userfaultfd: prevent registration of special VMAs

Rik van Riel (1):
      mm/huge_memory: set PG_has_hwpoisoned only after new folio head is es=
tablished

SJ Park (3):
      MAINTAINERS: s/SeongJae/SJ/
      mm/damon/core: validate ranges in damon_set_regions()
      mm/damon/core: disallow overlapping input ranges for damon_set_region=
s()

Thomas Wei=DFschuh (1):
      m68k: avoid -Wunused-but-set-parameter in clear_user_page()

Wei Yang (1):
      mm/page_vma_mapped: fix device-private PMD handling

Xie Yuanbin (1):
      mm/memory-failure: trace: change memory_failure_event to ras subsystem

 .mailmap                                        |   1 +
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 174 ++++++++++++--------=
----
 MAINTAINERS                                     |   3 +-
 arch/m68k/include/asm/page_mm.h                 |   2 +
 drivers/virtio/virtio_balloon.c                 |   5 +-
 fs/fat/fat.h                                    |   4 +-
 fs/fat/fat_test.c                               |   4 +-
 include/linux/damon.h                           |   2 -
 include/linux/page_reporting.h                  |   4 +-
 include/trace/events/memory-failure.h           |   6 +-
 mm/damon/core.c                                 |  15 +-
 mm/damon/lru_sort.c                             |   2 -
 mm/damon/modules-common.c                       |   2 -
 mm/damon/modules-common.h                       |   2 -
 mm/damon/ops-common.c                           |   2 -
 mm/damon/ops-common.h                           |   2 -
 mm/damon/paddr.c                                |   2 -
 mm/damon/reclaim.c                              |   2 -
 mm/damon/sysfs-common.c                         |   2 -
 mm/damon/sysfs-common.h                         |   2 -
 mm/damon/sysfs-schemes.c                        |   2 -
 mm/damon/sysfs.c                                |   2 -
 mm/damon/tests/core-kunit.h                     |   4 -
 mm/damon/tests/sysfs-kunit.h                    |   2 -
 mm/damon/tests/vaddr-kunit.h                    |   4 -
 mm/damon/vaddr.c                                |   2 -
 mm/huge_memory.c                                |  12 +-
 mm/kmemleak.c                                   |   7 +-
 mm/page_reporting.c                             |  24 ++--
 mm/page_vma_mapped.c                            |  31 +++--
 mm/userfaultfd.c                                |   5 +-
 31 files changed, 163 insertions(+), 170 deletions(-)


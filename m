Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B90670808;
	Thu, 11 Dec 2025 21:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765487488; cv=none; b=EnsaCgh9LI2rCsrHcjGGFZVNNRosyLlglq69j4v9d8Wefv7KCXfRbiOC+fngkdukTZWwycn8Nl+epLpFvnqwjBRddSyUQjsnwNkbF12IPF0tYeKwMPggmIeGALbkHBLSh+HD6wxGwJaFsCRfoSA19Kq9l4CPzFO9hJYwrsmcGS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765487488; c=relaxed/simple;
	bh=dKA7DY+h/BTnP4TtIZ2JRJA+YNGIcriYupklfmwGn10=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=mla0JZD2ilrN2nQu4O5EAfIBV9NOIzsanU7egZFcAmH+ymhNj+NEgj1p2F5LzhemsH8vq00HShuiMDs3A85vC1OJ6TEZTD3ZiC2uKdCOYRHI1MDqk+l0U4jpS2XDc05vweXG30KDr95M9WHFHoT1P0UrXXScdUDvtKdp/QiFhUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WvV9J8K7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WvV9J8K7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0304CC4CEF7;
	Thu, 11 Dec 2025 21:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765487488;
	bh=dKA7DY+h/BTnP4TtIZ2JRJA+YNGIcriYupklfmwGn10=;
	h=Date:From:To:Cc:Subject:From;
	b=WvV9J8K7ngLHz/soT1XhSqGFbutC+LYJYIlV2Tdi0h/hoNT2XajYOmkhsDf1xxwnb
	 vBIs2unjQJ2WxWGtx9X8ZMAAX1IPTzl9QQZ53/c5WEjwm6pSG2PCI/C/pc2WU1dDJT
	 PftPFbwhHMBj1kGHAdzAMikU3avcxxvB/7Eb+kD0=
Date: Thu, 11 Dec 2025 13:11:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional MM updates for 6.19-rc1
Message-Id: <20251211131127.defed99e5b82e49af605108a@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this small batch of followup patches for this -rc
cycle, thanks.

My test merge found no conflicts.



The following changes since commit faf3c923523e5c8fc3baaa413d62e913774ae52f:

  mm: fix vma_start_write_killable() signal handling (2025-11-29 10:41:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-12-11-11-39

for you to fetch changes up to dafdba0964bd10913fbaa5537201cbbe05df5b9c:

  mm/damon/tests/core-kunit: avoid damos_test_commit stack warning (2025-12-09 11:25:34 -0800)

----------------------------------------------------------------
Patch series in this pull request:

- The 2 patch series "powerpc/pseries/cmm: two smaller fixes" from David
  Hildenbrand fixes a couple of minor things in ppc land.

- The 4 patch series "Improve folio split related functions" from Zi Yan
  provides some cleanups and minorish fixes in the folio splitting code.

----------------------------------------------------------------
Arnd Bergmann (1):
      mm/damon/tests/core-kunit: avoid damos_test_commit stack warning

Chen Ridong (1):
      mm: vmscan: correct nr_requested tracing in scan_folios

David Hildenbrand (2):
      powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION
      powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages

Jinhui Guo (1):
      mm/sparse: fix sparse_vmemmap_init_nid_early definition without CONFIG_SPARSEMEM

Lukas Bulwahn (2):
      mm: fix CONFIG_STACK_GROWSUP typo in mm.h
      MAINTAINERS: add idr core-api doc file to XARRAY

Shameer Kolothum (1):
      mm/hugetlb: fix incorrect error return from hugetlb_reserve_pages()

Zi Yan (4):
      mm/huge_memory: change folio_split_supported() to folio_check_splittable()
      mm/huge_memory: replace can_split_folio() with direct refcount calculation
      mm/huge_memory: make min_order_for_split() always return an order
      mm/huge_memory: fix folio split stats counting

 MAINTAINERS                          |   1 +
 arch/powerpc/platforms/pseries/cmm.c |   3 +-
 include/linux/huge_mm.h              |  13 ++-
 include/linux/mm.h                   |   2 +-
 include/linux/mmzone.h               |   2 +-
 mm/damon/tests/core-kunit.h          |   9 +-
 mm/huge_memory.c                     | 165 +++++++++++++++++++----------------
 mm/hugetlb.c                         |  25 ++++--
 mm/vmscan.c                          |   8 +-
 9 files changed, 131 insertions(+), 97 deletions(-)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33C325B0A3;
	Fri, 31 Jul 2026 02:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465230; cv=none; b=n18i5yviuTyIgcllWz6KfEm66ATZJNHeI1kDsHNPhGrK/LQDX4CEcZ/zqt1v9LfJmJ2vGwoP7BMSHFOrk2ofnDq4FSopza5HhKaMQkkyCXZI+xsq+ZUdAZRrSdhaIs31wxqBQdubIK0+Kd4hFE4Sh72yAtPV9k5kvcvqilJr+J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465230; c=relaxed/simple;
	bh=S9DocUI3THX11qb8xnCMsdNe0RHBhTCoRNVDRC6O1/k=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=kI3hY5It/1w//stO39i3pc9QH/8HS51p/Y8SdxvLwrejP0PTRq7D2vQp1B+OvTE5ULTvR1Ci00slhOGbVAHQq7R0wI32hvJkf8CAFbhFhMpI0lFM0WqESlmyQ2V/JJr1jo/cupmmbsrusrpgHlpVOOOlsYqHUVJfp0vs9sNW5zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vXn2Q/hq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vXn2Q/hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445BB1F000E9;
	Fri, 31 Jul 2026 02:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465228;
	bh=MXTkaWVkLpWzsxbU5LuJ4tJlgacPdbaDXNtji94Vx64=;
	h=Date:From:To:Cc:Subject;
	b=vXn2Q/hqbJUiXIklsRKCJC0R5I6i2JOcoD/WyH1vSqUrH7JRjbOgSypPyH9BosFlx
	 O/0KEDGcR/22hthqV3zXMLVS40+NUamWMYRibVJgfoLZYD2IPjTsAqHI08wwEV0qrQ
	 bIDbx0crfdBkDNX+OaYBLcsJZj9jmKvj0lUnBcBc=
Date: Thu, 30 Jul 2026 19:33:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional hotfixes for 7.2-rc6
Message-Id: <20260730193347.67069b3a7254649fb89c0956@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this second batch of hotfixes for the upcoming
-rc release, thanks.


The following changes since commit 62cc90241548d5570ee68e01aaba6506964e9811:

  Merge tag 'mm-hotfixes-stable-2026-07-27-14-18' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2026-07-27 14:36:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-30-19-30

for you to fetch changes up to 9f1d75a4ce04095afdb63d8e540092ff8151dacf:

  selftests/mm: fix potential wild pointer access of getline due to missing init (2026-07-28 17:37:34 -0700)

----------------------------------------------------------------
12 hotfixes.  6 are cc:stable.  9 are for MM.

There's a two-patch series from Nico which fixes a couple of PMD level
mTHP accounting bugs and a two-patch series from Chris Gellermann which
addresses mishandling of getline() in selftests.  All the remainder are
singletons - please see the changelogs for details.

----------------------------------------------------------------
Breno Leitao (1):
      mm: memcg: initialize *locked in memcg1_oom_prepare() stub

Burak Emir (1):
      MAINTAINERS: update address for Burak Emir

Chris Gellermann (2):
      selftests/clone3: fix wild pointer access of getline due to missing init
      selftests/mm: fix potential wild pointer access of getline due to missing init

Jiakai Xu (1):
      riscv/mm: use physical alignment for vmemmap_start_pfn

Kiryl Shutsemau (Meta) (1):
      mm/huge_memory: unlock i_mmap_rwsem before releasing after-split folios

Link Lin (1):
      mm/page_reporting: use system_freezable_wq to fix UAF during suspend

Nico Pache (2):
      mm: decrement MTHP_STAT_NR_ANON in free_zone_device_folio()
      mm/migrate: exclude hugetlb folios from MTHP_STAT_NR_ANON accounting

Nico Pache (Red Hat) (1):
      MAINTAINERS: update Nico Pache's email address

Peter Collingbourne (1):
      arm64, mailmap: update email address for Peter Collingbourne

Richard Chang (1):
      mm: vmscan: abort proactive reclaim early when freezing for suspend

 .mailmap                                        |  3 +++
 MAINTAINERS                                     |  4 ++--
 arch/arm64/kernel/pi/relocate.c                 |  2 +-
 arch/riscv/mm/init.c                            |  3 ++-
 mm/huge_memory.c                                | 12 ++++++++++++
 mm/memcontrol-v1.h                              |  6 +++++-
 mm/memremap.c                                   |  1 +
 mm/migrate.c                                    |  3 ++-
 mm/page_reporting.c                             |  6 ++++--
 mm/vmscan.c                                     | 12 +++++++++++-
 tools/testing/selftests/clone3/clone3_set_tid.c |  2 +-
 tools/testing/selftests/mm/mlock-random-test.c  |  2 +-
 12 files changed, 45 insertions(+), 11 deletions(-)


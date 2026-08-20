Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E68361DA6;
	Thu, 20 Aug 2026 04:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787200550; cv=none; b=J+bCtiNP5fe4u2E1hV6FZoDuPQvRFZ4SE/Rf8fVDKzAU8XK+2WInhrokSYd+fsk0pKy0DogIURQCdjSb8Xr1eU0gdz9CIifUUl4yI0IruAUr1Ns9OtkET9VVpW9EyOgdi8k/8zgIrzZW+KSDV+UqDsGSCAg3c1x1M934j6wz++Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787200550; c=relaxed/simple;
	bh=vv/WMpx9ehxo47rj4T5HRfPRXMP/7okW9KOafJFSfLY=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=BaO7NkiMI2NPR7Fhtz2NFvKdOLo5CnQU8wvnLYBegE9aIwCUASoN59X57ZPArmGF6pxpCEIvLAlhs+W69nRh4ICipI4U1tQVDc175Bz2AehFBsEDvr9yQWV+vy2KS0Eg7+nz+8sBbeSCz8rEymLGnmb+Lsd3EERGYgG0MynS74A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aA/EjqIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aA/EjqIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE58C1F000E9;
	Thu, 20 Aug 2026 04:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787200548;
	bh=0UCl+bymr0EVEpu0WEcn7AlKSOyhvVMhIe4G+bqwAr0=;
	h=Date:From:To:Cc:Subject;
	b=aA/EjqISqhfzGL9cmUa1qc6uJqWVEsQ+/Nhj2bLZqy3l6S7yFmS5jYWV+J4mm2el0
	 jlzmbAvKkpjpFznDfyAjoSmTNhRDDV8ci6rBOFJlPjovm9j2UXZYJWm/xdMVSj9TiA
	 zfPm8zJTVFMQua/VQs+zL/oaWvqcG+W9fjUq+Fbc=
Date: Wed, 19 Aug 2026 21:35:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.3-rc1
Message-Id: <20260819213548.4160b501de0b9ab41029cfcf@linux-foundation.org>
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


The following changes since commit 1ec0e6b6f7321feb769f50d2f094a0aa6c2eda63:

  mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD} (2026-08-04 20:02:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-08-19-21-33

for you to fetch changes up to aedf2efd18977e0cef7eb963166e2b1fcc0aa321:

  mm/pagewalk: fix stale walk->action escaping walk_pmd_range() (2026-08-13 18:06:48 -0700)

----------------------------------------------------------------
8 hotfixes.  5 are cc:stable.  5 are for MM.

All are singletons, please see their changelogs for details.

----------------------------------------------------------------
Breno Leitao (1):
      mm/vmscan: report RCU-tasks quiescent states in shrink_lruvec()

Guodong Xu (1):
      mailmap: add entries for Guodong Xu

Guopeng Zhang (1):
      mm: memcg-v1: fix memsw and TCP failcnt accounting

Hyunwoo Kim (1):
      mm/pagewalk: fix stale walk->action escaping walk_pmd_range()

JP Kobryn (1):
      MAINTAINERS, mailmap: update email address for JP Kobryn

Phillip Lougher (1):
      MAINTAINERS: remove git URL for Squashfs

Shakeel Butt (1):
      memcg: keep folio's objcg same as its node

Youngjun Park (1):
      mm, swap: don't free a hibernation slot that is in the swap cache

 .mailmap        |   3 ++
 MAINTAINERS     |   3 +-
 mm/memcontrol.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++----------
 mm/pagewalk.c   |   6 ++--
 mm/swapfile.c   |   9 ++++-
 mm/vmscan.c     |   2 +-
 6 files changed, 100 insertions(+), 25 deletions(-)


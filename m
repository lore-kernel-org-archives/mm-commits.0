Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0D030E834;
	Wed, 26 Nov 2025 19:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764186837; cv=none; b=WaBA6pN8vkDPrN21KsJC9E7pR/uzf2OfP7lDxw4JKmL643oFc5ElRQ7Zg1MG0Xbv7pZscP9aEU690exY1xAkG6TN0BLKgGbmIPLcTUfEu1LOH+63ubgA/sV4pB6zm+LUqpUCS7P/MwvQDIqvuku86ShJkqPptyNZjk8oWj3ry18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764186837; c=relaxed/simple;
	bh=3LaAVXMxsOTt80DxyOV5M4+5WlNyCCt3WikFqOq5sas=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=dlfFMZeJpxU1+U3deViTZozqm4tzY1/v9QegyFplPP+zjVWbUWHSDpmVD8BaJlYJWEkJlIwOSMu7n53tf9uIedimd4faVta50XogJ0abvLKlH1sciC/3LP1HZF/I/X58db281sKFKPm4eweWvGi3M/qX47IAQYbmtXvFwXkr/gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=olRQMdm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="olRQMdm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DD0C4CEF7;
	Wed, 26 Nov 2025 19:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764186837;
	bh=3LaAVXMxsOTt80DxyOV5M4+5WlNyCCt3WikFqOq5sas=;
	h=Date:From:To:Cc:Subject:From;
	b=olRQMdm2y345wispcDvyoctvilgGJJidnxRVpmvFqCAdqo7/+rEKlv0GNwTVxT6DM
	 NG/lega+nQmIVeG084gmbkXYkP5Vs5lMOgHWdQsPnxDpBJqLtajuMQmbP8uBd6WDD5
	 B2ysfLI17b2mfMg7Xqz+Jk5qWZJ2wsG6RNoRFn1I=
Date: Wed, 26 Nov 2025 11:53:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes against 6.18-rc7
Message-Id: <20251126115356.e5fb496a181886475567ed74@linux-foundation.org>
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


The following changes since commit 1c2a936edd71e133f2806e68324ec81a4eb07588:

  mm, swap: fix potential UAF issue for VMA readahead (2025-11-15 10:52:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-26-11-51

for you to fetch changes up to 7c9580f44f90f7a4c11fc7831efe323ebe446091:

  mm/filemap: fix logic around SIGBUS in filemap_map_pages() (2025-11-24 14:25:18 -0800)

----------------------------------------------------------------
8 hotfixes.  4 are cc:stable, 7 are against mm/.

All are singletons - please see the respective changelogs for details.

----------------------------------------------------------------
Carlos Llamas (1):
      selftests/mm: fix division-by-zero in uffd-unit-tests

Deepanshu Kartikey (1):
      mm/memfd: fix information leak in hugetlb folios

Kiryl Shutsemau (1):
      mm/filemap: fix logic around SIGBUS in filemap_map_pages()

Liam R. Howlett (1):
      mm/mmap_lock: reset maple state on lock_vma_under_rcu() retry

Pratyush Yadav (1):
      MAINTAINERS: add test_kho to KHO's entry

Sam Protsenko (1):
      mailmap: add entry for Sam Protsenko

Wei Yang (1):
      mm/huge_memory: fix NULL pointer deference when splitting folio

Youngjun Park (1):
      mm: swap: remove duplicate nr_swap_pages decrement in get_swap_page_of_type()

 .mailmap                                     |  2 ++
 MAINTAINERS                                  |  1 +
 mm/filemap.c                                 | 27 ++++++++++++++-------------
 mm/huge_memory.c                             | 22 ++++++++++------------
 mm/memfd.c                                   | 27 +++++++++++++++++++++++++++
 mm/mmap_lock.c                               |  1 +
 mm/swapfile.c                                |  4 +---
 tools/testing/selftests/mm/uffd-unit-tests.c | 15 +++++++--------
 8 files changed, 63 insertions(+), 36 deletions(-)


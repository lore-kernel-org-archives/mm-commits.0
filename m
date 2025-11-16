Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9166121FF2E;
	Sun, 16 Nov 2025 18:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763318595; cv=none; b=iako1Mz/g3whL6T3K1ie+eBuUTMuV9BhV3USA625WAg3TMJNx95OPAWfOsBG3g1UkTLmze0BRwsJ7kKIVsB6Q0lGkSVI5FMiYaLxSuGmuKjz0ot/IIv5vLPoZuTMDkiG22gvnD2J+Wxs2EnmxhIROtUPHCboCL40+q4Towp6FFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763318595; c=relaxed/simple;
	bh=mlz8XZ5Zk1VrLETXio4E2rnvuua3hukDKbQJ9q2Ss9Y=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=VBsKOPyJKLcxuiJ3k3Lng9DKB+vtf9cuTy3mNHjrgiV1UDWaO0UYoFl6/ESBuOCDmZCh40t6kdj/7EI2IEk03X/zj7ZXQmQ3mJIgZwDZ9NP4osby9NsvV5+FD3CjyuHxRVdo/1dGodV35dFNrkyk1gUPDal750GbVerzgAaoXC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SaYb1Xl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SaYb1Xl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BD1C116B1;
	Sun, 16 Nov 2025 18:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763318595;
	bh=mlz8XZ5Zk1VrLETXio4E2rnvuua3hukDKbQJ9q2Ss9Y=;
	h=Date:From:To:Cc:Subject:From;
	b=SaYb1Xl9buvWv1y1g+OBuDNjTe5Hd7EZ/z82xsMK6QYsoAmART/6uGP+vx+ypof9d
	 W7/rxllPP0cBmb3b+RjU1Xx07yRVR6YmdyDTIAQL3IMrVoph+WeYzX68FrwTDrKkG3
	 2dRLst8ZLraOkpx8lNrEysEZeGLUdQVOe0JlCNHg=
Date: Sun, 16 Nov 2025 10:43:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] more hotfixes for 6.18-rc6
Message-Id: <20251116104314.af398baa1fafa06daee19ce3@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this small batch of hotfixes for this -rc cyele,
thanks.


The following changes since commit b05addf6f0596edb1f82ab4059438c7ef2d2686d:

  kho: warn and exit when unpreserved page wasn't preserved (2025-11-09 21:19:47 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-16-10-40

for you to fetch changes up to 1c2a936edd71e133f2806e68324ec81a4eb07588:

  mm, swap: fix potential UAF issue for VMA readahead (2025-11-15 10:52:02 -0800)

----------------------------------------------------------------
7 hotfixes.  5 are cc:stable, 4 are against mm/.

All are singletons - please see the respective changelogs for details.

----------------------------------------------------------------
Ankit Khushwaha (1):
      selftests/user_events: fix type cast for write_index packed member in perf_test

David Hildenbrand (Red Hat) (2):
      mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
      MAINTAINERS: update David Hildenbrand's email address

Kairui Song (1):
      mm, swap: fix potential UAF issue for VMA readahead

Pasha Tatashin (1):
      lib/test_kho: check if KHO is enabled

Sourabh Jain (1):
      crash: fix crashkernel resource shrink

Zi Yan (1):
      mm/huge_memory: fix folio split check for anon folios in swapcache

 .mailmap                                        |  1 +
 MAINTAINERS                                     | 28 ++++++++++++-------------
 arch/powerpc/Kconfig                            |  1 +
 arch/powerpc/platforms/Kconfig.cputype          |  1 -
 include/linux/mm.h                              | 13 +++++++++---
 kernel/crash_core.c                             |  2 +-
 lib/test_kho.c                                  |  3 +++
 mm/Kconfig                                      |  7 +++++++
 mm/huge_memory.c                                |  6 ++++--
 mm/swap_state.c                                 | 13 ++++++++++++
 tools/testing/selftests/user_events/perf_test.c |  2 +-
 11 files changed, 55 insertions(+), 22 deletions(-)


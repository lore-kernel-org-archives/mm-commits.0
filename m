Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA6A20102B;
	Sat, 17 May 2025 16:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747500264; cv=none; b=ADFEJRvX7rFpceU4XsKbCVByLzfXvY69J4fse2JtAYpmcoOL8aWvjPe3EwrAhXT6ng9NkNEp3uQbpQYPOT0bFKwqNaDj9EevLaHX6MzZnJGktRa/cW7DHMAcvV3HbL6t+xcckEtPkibWT3glG7ELtu8bfwd9+6iAboBGMDpzoxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747500264; c=relaxed/simple;
	bh=7EF4jHC6B1kxgvo7M67HdzGn2r4DzAv/dsR5x3sRPoQ=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=DkrEsw26iv59dm53GdDvsE5L6pGRvcv0oZ/Y6NBSUWEb+VP2fsy44jD54HI+JWzVQq1xB/8JvGKP8w67Z5ifdhrwMWR8t7r9+3ejk2qJDmBH4jcyoSGg1mlQLX1gzpDzs9+SayjCFY077uk3o3B5ZAuDyJbwMwncAlToWhMU9l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=07sIRf7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="07sIRf7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A36C4CEE3;
	Sat, 17 May 2025 16:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747500263;
	bh=7EF4jHC6B1kxgvo7M67HdzGn2r4DzAv/dsR5x3sRPoQ=;
	h=Date:From:To:Cc:Subject:From;
	b=07sIRf7I4eFCuFXVMpTukvfQ3ohH/5BUC8GDTg/3sbjLhHnbcL6B0wm1pX+SLmTa8
	 QLI9QzfQYMC0+mN6thEuHi4dxnQ6ULjq/otI2j6PrPjRNKgDvKOoeTBvHvY08Gcia2
	 DWdU5024uCYlEovNC/FUN89GS1R4DwbAAAjDQLnI=
Date: Sat, 17 May 2025 09:44:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.15-rc7
Message-Id: <20250517094422.f299a4e333261dfea7beb43c@linux-foundation.org>
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


The following changes since commit 82f2b0b97b36ee3fcddf0f0780a9a0825d52fec3:

  Linux 6.15-rc6 (2025-05-11 14:54:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-05-17-09-41

for you to fetch changes up to 75cb1cca2c880179a11c7dd9380b6f14e41a06a4:

  mm: userfaultfd: correct dirty flags set for both present and swap pte (2025-05-11 17:29:55 -0700)

----------------------------------------------------------------
Nine singleton hotfixes, all MM.  Four are cc:stable.

----------------------------------------------------------------
Barry Song (1):
      mm: userfaultfd: correct dirty flags set for both present and swap pte

David Hildenbrand (1):
      kernel/fork: only call untrack_pfn_clear() on VMAs duplicated for fork()

David Wang (1):
      mm/codetag: move tag retrieval back upfront in __free_pages()

Kairui Song (1):
      mm/memory: fix mapcount / refcount sanity check for mTHP reuse

Kirill A. Shutemov (2):
      mm/page_alloc: ensure try_alloc_pages() plays well with unaccepted memory
      mm/page_alloc: fix race condition in unaccepted memory handling

Lorenzo Stoakes (1):
      MAINTAINERS: add mm GUP section

Sergey Senozhatsky (1):
      zsmalloc: don't underflow size calculation in zs_obj_write()

Wupeng Ma (1):
      mm: hugetlb: fix incorrect fallback for subpool

 MAINTAINERS                 | 12 +++++++
 include/linux/pgalloc_tag.h |  8 +++++
 kernel/fork.c               |  9 ++---
 mm/hugetlb.c                | 28 +++++++++++----
 mm/internal.h               |  1 -
 mm/memory.c                 |  2 +-
 mm/mm_init.c                |  1 -
 mm/page_alloc.c             | 88 +++++++++++----------------------------------
 mm/userfaultfd.c            | 12 +++++--
 mm/zsmalloc.c               |  8 ++---
 10 files changed, 82 insertions(+), 87 deletions(-)


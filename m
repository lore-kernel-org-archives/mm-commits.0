Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5AF264614;
	Fri, 10 Oct 2025 22:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760133806; cv=none; b=SH7iHFS2dvXFNbWI83x/yaGUEMp263T8LBwIsChUWdmJdItUDx9zHRCyfFT6REbxWBl1VCMrG3pid0DAXInVPQzFvU/QJanNU2Kbu7kzQdTm39H3YDNGNBWvbaWl0/SsjRX+l8oVhq5ogpWxIO1Q8lSdmCoDLkKldr82z6f9pS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760133806; c=relaxed/simple;
	bh=evq7KJC3SkQwvHwE0wNIuv0UzWRVw71S/m1wT8vCslA=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=mthRXztvzZMu/SiMhr4iT/TQIaqoT8+4UgdJuGwpMpenPnvqn7T//Jo6WO+mvmoNvQeqsavehH1FnusBVzZL/9hN506mmp3CtxpsEZeeWA8PPcf3tdX0SIAoN8yXMx4tEEq2KOsoB84KeW7GvNNAtYTW8hKEBCD1gApCoTdjOGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VbcUIB/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VbcUIB/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA65C4CEF1;
	Fri, 10 Oct 2025 22:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760133805;
	bh=evq7KJC3SkQwvHwE0wNIuv0UzWRVw71S/m1wT8vCslA=;
	h=Date:From:To:Cc:Subject:From;
	b=VbcUIB/Ac0WEQXNEFE8FPrdF0VjzbYDFX6speK0X2FO8k/4gyPhFiqr0Fgi8k66c8
	 ACmLYVaPonWC3CFNTM+UR6eaYEW64seNRay9ue65Nnt7ewLqTTseBgQwiX+dZ07Wnw
	 Z7tC9JREF/mpeeuuGqfid8UrGt5X3ixovjk1vzkA=
Date: Fri, 10 Oct 2025 15:03:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.18-rc1
Message-Id: <20251010150323.2d73ad0f6fa1c49fbb7d9870@linux-foundation.org>
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



The following changes since commit 7a405dbb0f036f8d1713ab9e7df0cd3137987b07:

  Merge tag 'mm-stable-2025-10-03-16-49' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2025-10-05 12:11:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-10-10-15-00

for you to fetch changes up to f52ce0ea90c83a28904c7cc203a70e6434adfecb:

  mm: hugetlb: avoid soft lockup when mprotect to large memory area (2025-10-07 14:01:12 -0700)

----------------------------------------------------------------
7 hotfixes.  All 7 are cc:stable and all 7 are for MM.

All singletons, please see the changelogs for details.

----------------------------------------------------------------
Jakub Acs (1):
      mm/ksm: fix flag-dropping behavior in ksm_madvise

Lance Yang (2):
      mm/thp: fix MTE tag mismatch when replacing zero-filled subpages
      mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage

Ryan Roberts (1):
      fsnotify: pass correct offset to fsnotify_mmap_perm()

SeongJae Park (1):
      mm/damon/vaddr: do not repeat pte_offset_map_lock() until success

Shakeel Butt (1):
      memcg: skip cgroup_file_notify if spinning is not allowed

Yang Shi (1):
      mm: hugetlb: avoid soft lockup when mprotect to large memory area

 include/linux/memcontrol.h      | 26 +++++++++++++++++++-------
 include/linux/mm.h              |  2 +-
 mm/damon/vaddr.c                |  8 ++------
 mm/huge_memory.c                | 15 +++------------
 mm/hugetlb.c                    |  2 ++
 mm/memcontrol.c                 |  7 ++++---
 mm/migrate.c                    | 23 +++++++++++------------
 mm/util.c                       |  3 ++-
 rust/bindings/bindings_helper.h |  1 +
 9 files changed, 45 insertions(+), 42 deletions(-)


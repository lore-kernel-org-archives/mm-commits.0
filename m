Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C2C26A1CF;
	Mon, 29 Dec 2025 05:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766987565; cv=none; b=c14lhPfXy3zbWh1RmZOgcnmwCaJQ4mR/8DXS5SaqeK2b+HjEqj87Fx4KhPMppwNWR0TQrUVw0ob5KG5dsIIE/d3c/tpqjZx0ex3dlESsRpk9bG1I1P3wGQ6Mjn7h/SVPGe+xW4dgJWXaLM4AMIBhtOnmeWP6GcgU/C4/5YIWzyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766987565; c=relaxed/simple;
	bh=IP8O/3R0xQrKZ7hzXFyKNUrmFs/ElScw+GMdLuR2NLc=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=EcL4QQCexiT/e31VRnnTUbcjvFJb7drQL3/mTad8W3WQtY7iQSTaXljKnlaz46+LtX2f9vyiyDYDaCNULAIFX4cRVbtF/8g936rXGnUZ442MTuW4eIoKQVKBqPR83qHAnPsHw3oo5FkYMU8aWoy33febnkuxYvDNVFBCwIOLc/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sn2tvNPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sn2tvNPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09064C4CEF7;
	Mon, 29 Dec 2025 05:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766987565;
	bh=IP8O/3R0xQrKZ7hzXFyKNUrmFs/ElScw+GMdLuR2NLc=;
	h=Date:From:To:Cc:Subject:From;
	b=sn2tvNPJ8FUY96at4KCMkSusHjrdWHZxmSzppGJOCyPGa7Av9eu1JQcjg5GBQrxDz
	 Sin8enhNTm3oPVCgahN9IzMWOg7P4TcvfW9L3Hpo6pcG+y5vZwIpGyNSeJc3jkpOrC
	 famVX/C8LfKAKSZ4x2PXEJswuXX70f6LzjWfNSqM=
Date: Sun, 28 Dec 2025 21:52:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.19-rc4
Message-Id: <20251228215244.10e9ec389dcadcbcb336c98b@linux-foundation.org>
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


The following changes since commit 9448598b22c50c8a5bb77a9103e2d49f134c9578:

  Linux 6.19-rc2 (2025-12-21 15:52:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-12-28-21-50

for you to fetch changes up to d6b5a8d6f142ad0a8e45181f06e70b4746c4abc3:

  mm/ksm: fix pte_unmap_unlock of wrong address in break_ksm_pmd_entry (2025-12-23 11:23:17 -0800)

----------------------------------------------------------------
27 hotfixes.  12 are cc:stable, 18 are MM.

There's a three patch series from Jiayuan Chen which fixes some issues
with KASAN and vmalloc.  Apart from that it's the usual shower of
singletons - please see the respective changelogs for details.

----------------------------------------------------------------
Akinobu Mita (1):
      mm/damon/vaddr: fix missing pte_unmap_unlock in damos_va_migrate_pmd_entry()

Alexander Gordeev (1):
      mm/page_alloc: change all pageblocks migrate type on coalescing

Alice Ryhl (1):
      rust: maple_tree: rcu_read_lock() in destructor to silence lockdep

Andrew Morton (1):
      genalloc.h: fix htmldocs warning

Ankit Agrawal (1):
      mm: fixup pfnmap memory failure handling to use pgoff

Bartosz Golaszewski (2):
      mailmap: update entry for Bartosz Golaszewski
      MAINTAINERS: update one straggling entry for Bartosz Golaszewski

Bijan Tabatabai (1):
      mm: consider non-anon swap cache folios in folio_expected_ref_count()

Dan Williams (1):
      MAINTAINERS: notify the "Device Memory" community of memory hotplug changes

Jiayuan Chen (1):
      mm/kasan: fix incorrect unpoisoning in vrealloc for KASAN

John Groves (1):
      mm/memremap: fix spurious large folio warning for FS-DAX

Joshua Hahn (1):
      mm/page_alloc: report 1 as zone_batchsize for !CONFIG_MMU

Kaushlendra Kumar (1):
      tools/mm/page_owner_sort: fix timestamp comparison for stable sorting

Maciej Wieczor-Retman (2):
      kasan: refactor pcpu kasan vmalloc unpoison
      kasan: unpoison vms[area] addresses with a common tag

Matthew Wilcox (Oracle) (1):
      idr: fix idr_alloc() returning an ID out of range

Mike Rapoport (Microsoft) (1):
      MAINTAINERS: add Mike Rapoport as maintainer for userfaultfd

Pingfan Liu (2):
      kernel/kexec: change the prototype of kimage_map_segment()
      kernel/kexec: fix IMA when allocation happens in CMA area

Pratyush Yadav (1):
      MAINTAINERS: add ABI headers to KHO and LIVE UPDATE

Ran Xiaokai (1):
      mm/page_owner: fix memory leak in page_owner_stack_fops->release()

Randy Dunlap (2):
      mm: leafops.h: correct kernel-doc function param. names
      sparse: update MAINTAINERS info

Sasha Levin (1):
      mm/ksm: fix pte_unmap_unlock of wrong address in break_ksm_pmd_entry

Shakeel Butt (1):
      mm: memcg: fix unit conversion for K() macro in OOM log

Wake Liu (1):
      selftests/mm: fix thread state check in uffd-unit-tests

WangYuli (1):
      .mailmap: remove one of the entries for WangYuli

 .mailmap                                     |  4 ++--
 MAINTAINERS                                  |  8 +++++--
 include/linux/genalloc.h                     |  1 +
 include/linux/kasan.h                        | 16 ++++++++++++++
 include/linux/kexec.h                        |  4 ++--
 include/linux/leafops.h                      |  4 ++--
 include/linux/memory-failure.h               |  2 ++
 include/linux/mm.h                           |  8 +++----
 kernel/kexec_core.c                          | 16 ++++++++++----
 lib/idr.c                                    |  2 ++
 mm/damon/vaddr.c                             |  2 +-
 mm/kasan/common.c                            | 32 ++++++++++++++++++++++++++++
 mm/kasan/hw_tags.c                           |  2 +-
 mm/kasan/shadow.c                            |  4 +++-
 mm/ksm.c                                     |  2 +-
 mm/memcontrol.c                              |  4 ++--
 mm/memory-failure.c                          | 29 +++++++++++++++----------
 mm/memremap.c                                |  2 --
 mm/page_alloc.c                              | 26 +++++++++++-----------
 mm/page_owner.c                              |  2 +-
 mm/vmalloc.c                                 |  8 +++----
 rust/kernel/maple_tree.rs                    | 11 +++++++++-
 security/integrity/ima/ima_kexec.c           |  4 +---
 tools/mm/page_owner_sort.c                   |  6 +++++-
 tools/testing/radix-tree/idr-test.c          | 21 ++++++++++++++++++
 tools/testing/selftests/mm/uffd-unit-tests.c |  2 +-
 26 files changed, 163 insertions(+), 59 deletions(-)


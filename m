Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BFD13DDDE;
	Fri,  7 Jun 2024 22:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717799385; cv=none; b=maLrYit1MHOuCdhQFLPkFIsiU4/hY/H82efpcgK9rpvfBDW3XkWbpclb2SgZ3VUeNQPmDFLM1lWjq1SeozxCD6vQNpdWbcua6MPM11GDm52P81iaczRTOuODslE07pRAf55dvxaIYbdi7+ByqQ55VgDaK4z9/36mjzp94ulptCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717799385; c=relaxed/simple;
	bh=v2UKkW6fQa0poQx5QJNWEOedTwnRsNr2lgrl9pVMRMI=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=VD52MMUdccJSvx/ukJC9iiaBlJaV/m4hlZ1V2JZ8rcZ4fuAUI6Rq2CZImX94cXORauWRpfyONFGkMsW0/YnuZfUlDDEJvrJQ7gyqeKBcOx1JLxW7QXdmlRM47q9A+TySlASkVurvMITLhXxFwg4skqwm33aCuU95H0bDr2Lzi+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VRmpg5sz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VRmpg5sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6CEC2BBFC;
	Fri,  7 Jun 2024 22:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717799385;
	bh=v2UKkW6fQa0poQx5QJNWEOedTwnRsNr2lgrl9pVMRMI=;
	h=Date:From:To:Cc:Subject:From;
	b=VRmpg5szHAmkA8WhgqWJykHUohf9FW4nUzIg8p2ZY0yaTi2gWJN9CwOW9dvmo6b36
	 S3gZu3YEa74m9+BU1rx7bY2oR9CEBRDwV0CwBfWO3Mcmnzo9bHft9tI+K2NKPqx5bY
	 R1dL3p3nLCNAjJuVJ1TKOPfPqKP5aJlJr+ZYh+ac=
Date: Fri, 7 Jun 2024 15:29:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.10-rc3
Message-Id: <20240607152944.60722ce87f5a4b1a74d1145d@linux-foundation.org>
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


The following changes since commit 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0:

  Linux 6.10-rc1 (2024-05-26 15:20:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-06-07-15-24

for you to fetch changes up to 7373a51e7998b508af7136530f3a997b286ce81c:

  nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors (2024-06-05 19:19:27 -0700)

----------------------------------------------------------------
14 hotfixes, 6 of which are cc:stable.

All except the nilfs2 fix affect MM and all are singletons - see the
chagelogs for details.

----------------------------------------------------------------
Alexander Potapenko (1):
      kmsan: do not wipe out origin when doing partial unpoisoning

Baolin Wang (1):
      mm: drop the 'anon_' prefix for swap-out mTHP counters

Barry Song (2):
      mm: huge_mm: fix undefined reference to `mthp_stats' for CONFIG_SYSFS=n
      mm: arm64: fix the out-of-bounds issue in contpte_clear_young_dirty_ptes

Chengming Zhou (2):
      mm/ksm: fix ksm_pages_scanned accounting
      mm/ksm: fix ksm_zero_pages accounting

Cong Wang (1):
      vmalloc: check CONFIG_EXECMEM in is_vmalloc_or_module_addr()

Johannes Weiner (1):
      mm: page_alloc: fix highatomic typing in multi-block buddies

Oscar Salvador (1):
      mm/hugetlb: do not call vma_add_reservation upon ENOMEM

Ryusuke Konishi (2):
      nilfs2: fix potential kernel bug due to lack of writeback flag waiting
      nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors

Sebastian Andrzej Siewior (1):
      memcg: remove the lockdep assert from __mod_objcg_mlstate()

Suren Baghdasaryan (1):
      mm: fix xyz_noprof functions calling profiled functions

Thadeu Lima de Souza Cascardo (1):
      codetag: avoid race at alloc_slab_obj_exts

 Documentation/admin-guide/mm/transhuge.rst |  4 +--
 arch/arm64/mm/contpte.c                    |  4 +--
 fs/nilfs2/dir.c                            |  2 +-
 fs/nilfs2/segment.c                        |  3 ++
 fs/proc/base.c                             |  2 +-
 include/linux/huge_mm.h                    | 10 ++++--
 include/linux/ksm.h                        | 17 ++++++++--
 include/linux/mm_types.h                   |  2 +-
 mm/filemap.c                               |  2 +-
 mm/huge_memory.c                           |  8 ++---
 mm/hugetlb.c                               | 16 ++++++++--
 mm/kmsan/core.c                            | 15 ++++++---
 mm/ksm.c                                   | 17 +++++-----
 mm/memcontrol.c                            |  2 --
 mm/mempool.c                               |  2 +-
 mm/page_alloc.c                            | 50 ++++++++++++++++++++----------
 mm/page_io.c                               |  2 +-
 mm/slub.c                                  |  5 +--
 mm/util.c                                  | 10 +++---
 mm/vmalloc.c                               |  2 +-
 mm/vmscan.c                                |  2 +-
 21 files changed, 115 insertions(+), 62 deletions(-)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D84617C98;
	Fri, 10 May 2024 20:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715372264; cv=none; b=SSlrFtrXCjJIlGCeKLdkOFpp36rFaTmcj2xBpA4HL1RgJrjQA8se1hgMZ53tpP+UWa4WHXVTgojMGzCSv1zJKFkqfo0ycn5ztd5UzQKu8N1MAu6uQvvjJP8Ko9gg2oS+HuMgMFxn5TBibMCu8w9fopjlFHQPmdbagW6L/vwz7IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715372264; c=relaxed/simple;
	bh=kSFaSH7qNRJ1yVlXYgKexL8JfRsWVC/6Zdpx7ikK+F4=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=bkng7S2Un+c7sMK8mo1Tl+q8io7Kpumw+8/Ma0aI3ufHdOmwoosJ7jC2xBzz/lUGNaHhJOQsICMOnjwfjnk7oKuy4OLrGHIAnSP/5oIk0cJtYMnpdOkpRRwTl9LznhHd1FcyZZorb/kxdVaz+G092IO/YnVw94FZxHBn+azWAZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mfdsXEmm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mfdsXEmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EA3C2BD11;
	Fri, 10 May 2024 20:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715372264;
	bh=kSFaSH7qNRJ1yVlXYgKexL8JfRsWVC/6Zdpx7ikK+F4=;
	h=Date:From:To:Cc:Subject:From;
	b=mfdsXEmm+HC1ti7x9lINFWQ4YqsW+VaQsN4ON9YW3Efjvnve0jv8Wn1iw18xp1HxE
	 T9HxrQLb+bUh/sQnr1/vrg353fWl31UGD/WV2fnExQgGoS9zZAjgBIHj1YnT89BlC8
	 joKfCG83OM/rRuFhGffB/XDVXxlerKc7A0sw8U18=
Date: Fri, 10 May 2024 13:17:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.10
Message-Id: <20240510131743.cf12a22295edd6ae4c175d5b@linux-foundation.org>
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


The following changes since commit 52ccdde16b6540abe43b6f8d8e1e1ec90b0983af:

  mm/hugetlb: fix DEBUG_LOCKS_WARN_ON(1) when dissolve_free_hugetlb_folio() (2024-04-25 10:07:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-05-10-13-14

for you to fetch changes up to 672614a3ed24150f39752365c57a85fca1bd0017:

  mailmap: add entry for Barry Song (2024-05-10 12:55:36 -0700)

----------------------------------------------------------------
18 hotfixes, 7 of which are cc:stable.

More fixups for this cycle's page_owner updates.  And a few userfaultfd
fixes.  Otherwise, random singletons - see the individual changelogs for
details.

----------------------------------------------------------------
Alexander Potapenko (1):
      kmsan: compiler_types: declare __no_sanitize_or_inline

Barry Song (1):
      mailmap: add entry for Barry Song

Christoph Hellwig (1):
      mm,page_owner: don't remove __GFP_NOLOCKDEP in add_stack_record_to_list

Hailong.Liu (1):
      mm/vmalloc: fix return value of vb_alloc if size is 0

Jarkko Sakkinen (1):
      MAINTAINERS: update URL's for KEYS/KEYRINGS_INTEGRITY and TPM DEVICE DRIVER

John Garry (1):
      mailmap: add entry for John Garry

Kefeng Wang (1):
      mm: use memalloc_nofs_save() in page_cache_ra_order()

Liam R. Howlett (1):
      maple_tree: fix mas_empty_area_rev() null pointer dereference

Luis Chamberlain (2):
      tools: fix userspace compilation with new test_xarray changes
      lib/test_xarray.c: fix error assumptions on check_xa_multi_store_adv_add()

Maninder Singh (1):
      mm: page_owner: fix wrong information in dump_page_owner

Matthew Wilcox (Oracle) (1):
      XArray: set the marks correctly when splitting an entry

Michael Ellerman (1):
      selftests/mm: fix powerpc ARCH check

Peter Xu (1):
      mm/userfaultfd: reset ptes when close() for wr-protected ones

Ryan Roberts (2):
      fs/proc/task_mmu: fix loss of young/dirty bits during pagemap scan
      fs/proc/task_mmu: fix uffd-wp confusion in pagemap_scan_pmd_entry()

Tiezhu Yang (2):
      selftests/vDSO: fix building errors on LoongArch
      selftests/vDSO: fix runtime errors on LoongArch

 .mailmap                                           |  6 +++++
 MAINTAINERS                                        |  3 ++-
 fs/proc/task_mmu.c                                 | 24 +++++++++++--------
 fs/userfaultfd.c                                   |  4 ++++
 include/linux/compiler_types.h                     | 11 +++++++++
 lib/maple_tree.c                                   | 16 ++++++-------
 lib/test_xarray.c                                  | 27 ++++++++++++++++++----
 lib/xarray.c                                       | 23 ++++++++++++++----
 mm/page_owner.c                                    |  4 ++--
 mm/readahead.c                                     |  4 ++++
 mm/vmalloc.c                                       |  2 +-
 tools/testing/radix-tree/linux/kernel.h            |  2 ++
 tools/testing/selftests/mm/Makefile                |  6 ++---
 tools/testing/selftests/vDSO/vdso_config.h         |  6 ++++-
 tools/testing/selftests/vDSO/vdso_test_getcpu.c    | 16 +++++--------
 .../selftests/vDSO/vdso_test_gettimeofday.c        | 26 ++++++---------------
 16 files changed, 116 insertions(+), 64 deletions(-)


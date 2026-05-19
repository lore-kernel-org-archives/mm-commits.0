Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC7164AA4;
	Tue, 19 May 2026 04:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779163812; cv=none; b=Xa4zdUXSbTNzqrUhCnRVCjyhDdUQ84PKp2uP9wM0qXAAn4kxOgtlWaqmUKj2CEdWe/tk41ec+fgj40UDG0p5ZCJKbLRZHV5Xn3O/IhdHx3Xi5MfcjBDg8s0mfr99MgciAjCcIY9VxwCO4o9s8LJrfub8VgwmYNOGNp7OLZ7H50I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779163812; c=relaxed/simple;
	bh=jKPUDmc9d1mUFqAQVaoaLRkscbcLeeodQ9MrqHblJxo=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=iyz+FDVwuE5gW7HnjrFFEwDe8s/8WsmLQixSpgS/m16g5RXEA8Z6sUkegMht5jXFa7IpkXjes5dAnLdP+kgm6v5JMs31E59tIA/BY6PM5cfnNfdMrwCycH94/cnNLL8+0E/AdUaLPQaEn59M3iRtECyeUsOaPx9ayes0hgjiqi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bGiwBjeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bGiwBjeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512F6C2BCB3;
	Tue, 19 May 2026 04:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779163811;
	bh=jKPUDmc9d1mUFqAQVaoaLRkscbcLeeodQ9MrqHblJxo=;
	h=Date:From:To:Cc:Subject:From;
	b=bGiwBjeYjAAQZt7zdfBbep2p8SpFYaHti0qkxt4p+QbdjUObgOZMLEfHH0CvoYl2x
	 2TNlv2zwXexxFNZsnXPH4UmtNEd5VeKf/vRRhiYl107bIV5yeqIWzn5D/MRsKGAVe4
	 7GTtTewKiau5wCR9MJKjlD7bgIysFAVrJxGIH17o=
Date: Mon, 18 May 2026 21:10:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.1-rc5
Message-Id: <20260518211010.20af3906b324d3e674ed1e61@linux-foundation.org>
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

The following changes since commit 5d6919055dec134de3c40167a490f33c74c12581:

  Linux 7.1-rc3 (2026-05-10 14:08:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-05-18-21-07

for you to fetch changes up to be3f38d05cc5a7c3f13e51994c5dd043ab604d28:

  mm/memory: fix spurious warning when unmapping device-private/exclusive pages (2026-05-13 17:40:03 -0700)

----------------------------------------------------------------
14 hotfixes.  9 are for MM.  10 are cc:stable and the remainder are for
post-7.1 issues or aren't deemed suitable for backporting.

There's a 2 patch MAINTAINERS series from Mike Rapoport which updates us
for the new KEXEC/KDUMP/crash/LUO/etc arrangements.  And a 2 patch series
from Muchun Song to fix a couple of memory-hotplug issues.  Otherwise
singletons, please see the changelogs for details.

----------------------------------------------------------------
Alistair Popple (1):
      mm/memory: fix spurious warning when unmapping device-private/exclusive pages

Christian A. Ehrhardt (1):
      lib: kunit_iov_iter: fix test fail on powerpc

David Hildenbrand (Arm) (2):
      mm/page_alloc: fix initialization of tags of the huge zero folio with init_on_free
      mm: fix __vm_normal_page() to handle missing support for pmd_special()/pud_special()

Illia Ostapyshyn (2):
      scripts/gdb: mm: cast untyped symbols in x86_page_ops
      scripts/gdb: slab: update field names of struct kmem_cache

Luiz Capitulino (1):
      selftests/mm: run_vmtests.sh: fix destructive tests invocation

Mike Rapoport (Microsoft) (2):
      MAINTAINERS: add tree for KDUMP and KEXEC
      MAINTAINERS: add kexec@ list to LIVE UPDATE ENTRY

Muchun Song (2):
      mm/memory_hotplug: fix memory block reference leak on remove
      drivers/base/memory: fix memory block reference leak in poison accounting

SeongJae Park (2):
      mm/damon/sysfs-schemes: call missing mem_cgroup_iter_break()
      mm/damon: fix damos_stat tracepoint format for sz_applied

Sunny Patel (1):
      mm/migrate_device: fix spinlock leak in migrate_vma_insert_huge_pmd_page

 MAINTAINERS                               |  3 ++
 arch/arm64/include/asm/page.h             |  2 +-
 arch/arm64/mm/fault.c                     | 11 ++++---
 drivers/base/memory.c                     |  8 +++--
 include/linux/gfp_types.h                 | 10 +++----
 include/linux/highmem.h                   |  7 +++--
 include/trace/events/damon.h              |  2 +-
 lib/tests/kunit_iov_iter.c                | 10 +++----
 mm/damon/sysfs-schemes.c                  |  1 +
 mm/memory.c                               | 24 ++++++++++++---
 mm/memory_hotplug.c                       |  2 ++
 mm/migrate_device.c                       |  2 +-
 mm/page_alloc.c                           |  8 ++---
 scripts/gdb/linux/mm.py                   |  6 ++--
 scripts/gdb/linux/slab.py                 |  4 +--
 tools/testing/selftests/mm/hmm-tests.c    | 50 +++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |  2 +-
 17 files changed, 116 insertions(+), 36 deletions(-)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50570349CC3;
	Mon, 14 Sep 2026 04:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789361564; cv=none; b=gK9+YZ4cm/EyXmy4tRNqTbbjtZzqWp4Wx4WN/zkBKPyv/bz991+FHQA7c7IwzQHGVGtz9jCW/tqz0lEcBqLTy/X4kUyGE2idIfU0qaLVMlH5GTy5iVosecQp6z7v/ezDbvLLdiAfSox/zMetkCKRjkunUC5iSWAvUjNETcXi0k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789361564; c=relaxed/simple;
	bh=IOmJ9vKGN9+BB1u/jqy+ZCwwC/C6S6NozX6XkKyyaWU=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=lmKxmFCZvG6JgEOAy+rNCvcPwxHSC6J95/xaw2urSt8T4x5uy1ZF1tIOM1k7ebNiS6G4c1ia56ZGkYswrVmcsAMm9suKGmRL7VwtMeiyVjCd6AygER/aLZi30XHsWR8YrF+EwPDkzl+erczOUhszAaJod2VV1RKYbVjc799JD+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jmEysL+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jmEysL+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DA71F000FF;
	Mon, 14 Sep 2026 04:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789361562;
	bh=3Wt5ocwzEWGnNlYZNryMwTicaVcgg2/IRrlxzOXxn+c=;
	h=Date:From:To:Cc:Subject;
	b=jmEysL+gdBRXJvJ5wGy4PM7XFeiQowuZ8f4CnHxs55WYuJ7Swv6ro4Vjz8CbHJbaz
	 k2DgKnvO/hrEIkvnexjb//nMkqxlb6b7yAWiw1ut/wiDInTaY7isxSWl0oE3BdoNVP
	 UJSDGSFi70HHNsS9QVJMfIUXRaD/fRdc9fH/ud9Q=
Date: Sun, 13 Sep 2026 21:52:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.3-rc4
Message-Id: <20260913215242.66cdff48a7849112984deefc@linux-foundation.org>
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


The following changes since commit 0d9ff90a5422cc7509258aaaba1e7481df4d332a:

  Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2026-09-05 09:25:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-13-21-50

for you to fetch changes up to 7891fbb9512f127826e1d5dbf380ee212bd15eb0:

  mm/folio: EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio) (2026-09-08 23:28:06 -0700)

----------------------------------------------------------------
14 hotfixes.  10 are cc:stable.  11 are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Ackerley Tng (1):
      mm/folio: EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio)

Andrew Morton (1):
      remove old lib/alloc_tag.c

Christopher Obbard (1):
      mailmap: update entry for Christopher Obbard

Coiby Xu (1):
      mailmap: map Coiby Xu's address

Jiayuan Chen (1):
      mm/shrinker: fix bogus set_shrinker_bit() with cgroup.memory=nokmem

Lorenzo Stoakes (ARM) (3):
      mm/huge_memory: bypass THP tuneables for huge pfnmap mappings
      mm/mremap: account mm->locked_vm correctly for MREMAP_DONTUNMAP
      mm/vma: correctly unaccount on mmap_prepare() failure

Nhat Pham (1):
      mm, swap: fix SWAP_USAGE_OFFLIST_BIT collision with real usage count

Qi Zheng (1):
      fs: fix missed removal of super_fs_objects_eligible()

Seunguk Shin (1):
      fs/dax: check zero or empty entry before converting xarray entry

Shakeel Butt (2):
      memcg: avoid charging the root memcg from obj_cgroup_charge_pages()
      mm/mlock: use the IRQ-safe accessor for NR_MLOCK in __munlock_folio()

Wenjie Qi (1):
      mm: filemap: retain mapped dropbehind folios

 .mailmap         |    4 +-
 fs/dax.c         |    9 +-
 fs/super.c       |   18 +-
 lib/alloc_tag.c  | 1029 ------------------------------------------------------
 mm/filemap.c     |    2 +-
 mm/folio.c       |    2 +
 mm/huge_memory.c |   86 +++--
 mm/memcontrol.c  |    2 +-
 mm/mlock.c       |    2 +-
 mm/mremap.c      |    9 +-
 mm/shrinker.c    |    2 +
 mm/swapfile.c    |    2 +-
 mm/vma.c         |    6 +-
 13 files changed, 91 insertions(+), 1082 deletions(-)
 delete mode 100644 lib/alloc_tag.c


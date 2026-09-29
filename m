Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881193A5459;
	Tue, 29 Sep 2026 03:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790651208; cv=none; b=sgri/kUa5UXxOugRGQfDg0KzcJ6nqpxgNaY2aC2Ct4SHgJEVK0gQ8yRnumyTu7m8T+J1TZ56FsWZMEdBsUpIu7jgDRWk7t2mJQFmRk/9NWuowptJ4K9OGoU0CoMdCCMioIJv9LSP9vB4Wsdp78o7p3TC6Ol7ylTpVWLL8/GQ5ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790651208; c=relaxed/simple;
	bh=2PThRlg40h40CAflLtwZ8b1fc/sXZxPLDe6vxY0/tYs=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=X4VVE98+ZKYh7HpQKXF7pPStYYRpk6JVuQZfbmf1CEeoRyOJnZ4Rl7VVcVskcyQ5imL4eBgDs4KVSOu4obreO8PAX9+fxoXQclF4d5nfwemJJtxoB/v8YGtECeEQdI6jrFQjhGIwueZzBadAzc1ycKvOZDbXf2AMN91jsGArJts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L2rAEdkt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L2rAEdkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACDC1F000FF;
	Tue, 29 Sep 2026 03:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790651186;
	bh=vho3LeinpQ8o3z/UPtMq0kZEbhfMraCkRYDhONPdHpQ=;
	h=Date:From:To:Cc:Subject;
	b=L2rAEdktaXL0AWvbQEN0EGjFbbmwS+ulZ+3coToiPlGMatEiKAOYsG3/GuS8cu1t5
	 Sc0QTrbpo3T7AMryC4X1EUnSWosCTkZZnyeTEigTWNkxhxEpSZgVdZQomVgV9FJ1fG
	 J9uR7SO4cP6I/RyY+nTNbATn2hKRysN+g2I6wMX0=
Date: Mon, 28 Sep 2026 20:06:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM hotfixes for 7.3-rc5
Message-Id: <20260928200625.8d739583d545932f905e36b7@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of MM[*] hotfixes.

There are 10 patches, 5 of which are cc:stable.

[*] almost.  Another ocfs2 patch snuck through.

Thanks.


The following changes since commit fe2ec83746e501645709761605c2464a44fd2929:

  Merge tag 'hid-for-linus-2026092202' of git://git.kernel.org/pub/scm/linux/kernel/git/hid/hid (2026-09-22 10:30:17 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-27-19-12

for you to fetch changes up to 976d5e0ddac885b0219252f004f6c561c344df9d:

  mm/vma: predicate setting mmap_prepare VMA fields on new vma alloc (2026-09-26 13:55:11 -0700)

----------------------------------------------------------------
10 hotfixes.  5 are cc:stable.

- Fix module loading incorrectly returning success after alloc_tag codetag
  setup failed.

- Restore MADV_COLLAPSE semantics for shmem so forced collapse ignores the
  shmem THP/mTHP sysfs settings.

- Make alloc_tag UAPI structure padding explicit.

- Fix DAMON schemes unexpectedly stopping after quotas are disabled through
  the online parameter update interface.

- Fix a false SW_TAGS KASAN invalid-access report when freeing vmapped task
  stacks.

- Split the MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION MAINTAINERS
  entry into separate MIGRATION and NUMA PLACEMENT entries.

- Move memory tiering maintenance under NUMA PLACEMENT.

- Add Gregory Price as a NUMA PLACEMENT co-maintainer.

- Add Heming Zhao as an ocfs2 reviewer.

- Fix mmap_prepare() state being copied onto a merged VMA rather than only
  onto a newly allocated VMA.

----------------------------------------------------------------
Andrey Ryabinin (1):
      kasan: unpoison task stack below watermark only in generic mode

Arnd Bergmann (1):
      alloc_tag: avoid implicit padding in uapi

Baolin Wang (1):
      mm: shmem: ignore sysfs configs for shmem forced collapse

David Hildenbrand (Arm) (3):
      MAINTAINERS: split up MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
      MAINTAINERS: move memory tiering under MEMORY MANAGEMENT - NUMA PLACEMENT
      MAINTAINERS: make Gregory a co-maintainer of MEMORY MANAGEMENT - NUMA PLACEMENT

Hao Ge (1):
      module: fix lost error code from codetag_load_module()

Joseph Qi (1):
      MAINTAINERS: add Heming Zhao as ocfs2 reviewer

Lorenzo Stoakes (ARM) (1):
      mm/vma: predicate setting mmap_prepare VMA fields on new vma alloc

SJ Park (1):
      mm/damon/core: don't skip damos_adjust_quota() while esz is not zero

 MAINTAINERS                    | 69 +++++++++++++++++++++++++-----------------
 include/uapi/linux/alloc_tag.h |  1 +
 kernel/module/main.c           |  8 +++--
 mm/damon/core.c                |  2 +-
 mm/kasan/common.c              | 13 +++++++-
 mm/shmem.c                     |  7 +++--
 mm/vma.c                       |  4 +--
 7 files changed, 68 insertions(+), 36 deletions(-)


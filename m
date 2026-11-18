Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794989388;
	b=FCL5c4Qlj+pgmmcEOwzuItuJYb7pvwy2+6QyIc3PrLWgEbf4TfKqTqgWY337zg+YE593
	 Fc50TtHKrF3u3Y9+p8jN+v+H9A5kZltNLBWUZ2RUbBpQNKrD401IWrURK+Ucw09rMPRWW
	 mM+zdRoX70KvJeBxDIpm0T4x5xrl0IbYfc8yxHbQEwkElSDYLgqCJIRFw/Efndx4cneOQ
	 vZsa7ubAxdSQ2vaQ7GujBMV48mjxUQggatL1Fw+UcM+KfKANllOhB0EjYkEhkNyoYoF41
	 V7VJq9aZICiTGakpef2mthI4y82na+2AzdWbALE/8Mo3uVXHEHL0xgASa48uUUy2D8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794989388;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:X-Mailer:
	 Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=QipqgoqPgTxh51C4kAuqqPqEujawJyN1RMmo3KXcqys=;
	b=janouqmLZ7CHvRmcfcBe2oyqZrF81O/K+FfeTzqWtXd7PpZzB6tngHFAJkOWicSK5XvQ
	 mECO8XSo7O5n1PJlOloqv+kh7DYhELmyr15wgmNUUryISO+ShBtfiWu7Ov4ZJJYDJNyyr
	 eetjFYrcZfRI9vA3ATMTMxQMyTwBgJOx3fIo1gfGWm91iPiWmwcoyMKN6Ly0qWRVtMXEY
	 PV1FDuygDK9Hw697QoaOJvRFOCbqNgW866IfRLxmA6b3UfUgHNXZu0Lbtogqo3W2mGYLG
	 1ly5cvXMzPGpLj6v/4aC2Kw6nlgCScEkaUz6sRmTffNWkls3gMJH57prv1OZIe0OmuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hTS8LHsT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFA3606A31C;
	Wed, 18 Nov 2026 08:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hTS8LHsT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5931F000C4;
	Wed, 18 Nov 2026 08:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794989387;
	bh=QipqgoqPgTxh51C4kAuqqPqEujawJyN1RMmo3KXcqys=;
	h=Date:From:To:Cc:Subject;
	b=hTS8LHsT5U8Bg/RQ4lC/sEXSUuwOs5pwESF+JPBmwJW6CiRipQ1JHwVCaLvA+26P9
	 iFknGko/Qb+w0+oBrQJSWNGurXHWZzGSs2f96RfcHQpjvNhJvp+kzY3F/iX2ehZsUw
	 afyyP1e5qCk1OWcFXNGJM1OUoMWrqnciQ05kbqxo=
Date: Wed, 18 Nov 2026 00:09:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] Non-mm hotfixes for 7.4.rc4
Message-Id: <20261118000947.a86e7241c67d295c40eb8b71@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of other-than-MM hotfixes for the
current -rc cycle, thanks,



The following changes since commit fa4ad798f6f681031775266044ba1b0cf3c670bd:

  Merge tag 'for-7.4-rc1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux (2026-11-07 13:52:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-hotfixes-stable-2026-11-18-00-06

for you to fetch changes up to a001666afbf9d2a6096fea95686549b9b1c9d968:

  MAINTAINERS: DRM DRIVERS AND MISC GPU PATCHES (2026-11-17 21:40:05 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-nonmm-hotfixes-stable

Everything:

Total patches:       20
Fixes: tags:         5
cc:stable patches:   5
Reviews/patch:       0.65
Reviewed rate:       45%

Summary of patch series in this merge:

- "get_maintainer: stop sending every patch to LKML" (Konstantin
  Ryabitsev):

  Make THE REST a fallback when no usable subsystem list matches and
  update the submission guide. This avoids routine copies to LKML
  while retaining a mailing list for otherwise unmatched patches.

Summary of the 18 singletons in this merge:

On local OCFS2 mounts, a failed shared mmap write fault now delivers
SIGBUS instead of hitting BUG_ON(). Journal shutdown is serialized
with inode cleanup, and checkpoint waiters no longer use a queue
embedded in the journal being freed.

Queued dlmfs lock work now keeps the superblock active through its final
iput(), avoiding a use-after-free during unmount. The OCFS2
locking_state debugfs iterator follows its live cursor instead of list
links copied from a lock resource which may have been freed during a
read-only remount.

Fault-injection boot parameters no longer call code which allocates
memory and schedules work before slab and workqueues are initialized,
fixing a boot failure.

----------------------------------------------------------------
Alex Elder (1):
      mailmap: add an alias for Alex Elder

Andrea Cervesato (1):
      MAINTAINERS: update Andrea Cervesato's email for LTP

Beat M. Liechti (1):
      mailmap: add entry for Beat M. Liechti

Bradley Morgan (1):
      mailmap: update email address for Bradley Morgan

Cen Zhang (3):
      ocfs2: serialize inode journal access with shutdown
      ocfs2/dlmfs: keep the superblock alive during lock work
      ocfs2: advance locking_state through the live cursor

Guodong Xu (1):
      mailmap: update entry for Guodong Xu

Joe Perches (1):
      MAINTAINERS: DRM DRIVERS AND MISC GPU PATCHES

Konstantin Ryabitsev (2):
      get_maintainer: only use THE REST as a fallback
      docs: submitting-patches: make LKML a list of last resort again

Luiz Capitulino (Red Hat) (1):
      mailmap: add entries for Luiz Capitulino

Miaoqing Pan (1):
      mailmap: add entries for Miaoqing Pan

Mika Westerberg (1):
      mailmap: update Mika Westerberg's email address

Naman Jain (1):
      mailmap: update email address for Naman Jain

Ridong Chen (1):
      mailmap: add entries for Ridong Chen

Sai Teja Aluvala (1):
      mailmap: update email address for Sai Teja Aluvala

Sang-Heon Jeon (1):
      fault-inject: fix boot failure with fault injection boot parameters

Wang Yibo (1):
      mailmap: add Wang Yibo's work email address

Zhiyuan Zhang (1):
      ocfs2: fix kernel BUG in ocfs2_page_mkwrite() when write_end fails

 .mailmap                                     | 24 +++++++++++++---
 Documentation/process/submitting-patches.rst |  9 ++++--
 MAINTAINERS                                  |  4 +--
 fs/ocfs2/dlmfs/userdlm.c                     | 12 ++++++--
 fs/ocfs2/dlmglue.c                           | 19 ++++++++++--
 fs/ocfs2/inode.c                             | 17 +++++------
 fs/ocfs2/journal.c                           | 30 +++++++++++++------
 fs/ocfs2/journal.h                           | 17 +++++------
 fs/ocfs2/mmap.c                              | 12 +++++++-
 fs/ocfs2/ocfs2.h                             |  1 +
 fs/ocfs2/super.c                             |  1 +
 lib/fault-inject.c                           |  8 +++++-
 scripts/get_maintainer.pl                    | 43 ++++++++++++++++++++++++++++
 13 files changed, 157 insertions(+), 40 deletions(-)


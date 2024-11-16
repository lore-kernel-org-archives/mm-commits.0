Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC11138DE1;
	Sat, 16 Nov 2024 23:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731800162; cv=none; b=OeM0p8UU+BuLgbY26VRMScVXiewa0Os6GvcFzL3K4NH4c1Nqh0V0NXwXttwtDPPiMRN1wGUYFpVPO6uU9GLgDEvFAUR2bMoPHWHQhL7WZGDnhWfsm+EkMi+IIUQP/ShW+QYgY9FmacAg6YgLRpLYvL45y4jkTK8lbNhEB2Zkdz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731800162; c=relaxed/simple;
	bh=KgchrBbEjJ6FmtT/OHxHi3NDIfi1tuion/rr6Heara8=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=YVCv40rtnJGzMnLbQQZURCJGEu8Aiu8uEZaWhTNpm0I7EhGmt9t5jn8pdldG3xk3IGXQDd9zE6rjOznNdbuQFpTIwjoKmVqGu4JeAS4IaWVdEtanSVxlUxyH8siYirkNsrgHaksDwTJSFVcZQShh84VbsBoTwpuQCM845oQblkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l2H8JTly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l2H8JTly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C866BC4CEC3;
	Sat, 16 Nov 2024 23:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731800161;
	bh=KgchrBbEjJ6FmtT/OHxHi3NDIfi1tuion/rr6Heara8=;
	h=Date:From:To:Cc:Subject:From;
	b=l2H8JTlyMuxgmdDs/F3QBRaeepMAXlVQYaAPM0nVzQf09ktLewQEppHTKi6bz15Xp
	 P4TgO4XmqufG3yoUeL21C8mTR9mKZgtq0TiUenFsx3yXKgulnJ/oSfpZU6m55CW7EC
	 IH9DizWHQ8yw+oQJW+e5G2LeP7sKinbnepcWaKXw=
Date: Sat, 16 Nov 2024 15:35:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.12
Message-Id: <20241116153556.767f1aeed6ac628a09efe346@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit dcf32ea7ecede94796fb30231b3969d7c838374c:

  mm: swapfile: fix cluster reclaim work crash on rotational devices (2024-=
11-12 16:01:36 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2024-11-16-15-33

for you to fetch changes up to d1aa0c04294e29883d65eac6c2f72fe95cc7c049:

  mm: revert "mm: shmem: fix data-race in shmem_getattr()" (2024-11-16 15:3=
0:32 -0800)

----------------------------------------------------------------
10 hotfixes, 7 of which are cc:stable.  All singletons, please see the
changelogs for details.

----------------------------------------------------------------
Andrew Morton (1):
      mm: revert "mm: shmem: fix data-race in shmem_getattr()"

Dan Carpenter (1):
      fs/proc/task_mmu: prevent integer overflow in pagemap_scan_get_args()

Dave Vasilevsky (1):
      crash, powerpc: default to CRASH_DUMP=3Dn on PPC_BOOK3S_32

Dmitry Antipov (1):
      ocfs2: uncache inode which has failed entering the group

Jann Horn (1):
      mm/mremap: fix address wraparound in move_page_tables()

Jinjiang Tu (1):
      mm: fix NULL pointer dereference in alloc_pages_bulk_noprof

Kairui Song (1):
      mm, swap: fix allocation and scanning race with swapoff

Motiejus Jak=C5`tys (1):
      tools/mm: fix compile error

Qun-Wei Lin (1):
      sched/task_stack: fix object_is_on_stack() for KASAN tagged pointers

Yafang Shao (1):
      mm, doc: update read_ahead_kb for MADV_HUGEPAGE

 Documentation/ABI/stable/sysfs-block |  3 +++
 arch/arm/Kconfig                     |  3 +++
 arch/arm64/Kconfig                   |  3 +++
 arch/loongarch/Kconfig               |  3 +++
 arch/mips/Kconfig                    |  3 +++
 arch/powerpc/Kconfig                 |  4 ++++
 arch/riscv/Kconfig                   |  3 +++
 arch/s390/Kconfig                    |  3 +++
 arch/sh/Kconfig                      |  3 +++
 arch/x86/Kconfig                     |  3 +++
 fs/ocfs2/resize.c                    |  2 ++
 fs/proc/task_mmu.c                   |  4 +++-
 include/linux/sched/task_stack.h     |  2 ++
 kernel/Kconfig.kexec                 |  2 +-
 mm/mremap.c                          |  2 +-
 mm/page_alloc.c                      |  3 ++-
 mm/shmem.c                           |  2 --
 mm/swapfile.c                        | 22 +++++++++++++++++++---
 tools/mm/page-types.c                |  2 +-
 19 files changed, 62 insertions(+), 10 deletions(-)


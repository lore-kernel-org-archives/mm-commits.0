Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EADE39855;
	Fri, 27 Jun 2025 23:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751068788; cv=none; b=eGiecpIhfyN4oZzdULiUP2Cnp9D2yNjcwvSDyfTDcmEgYPTzaWqdu8QeKu2B/92PTi/+8r6ja5Op4UK09W4a+Nfkfu+xKbyzaciSMApO3iSC+QLquK79gB5nOuwKz+QL1LOKmEfqFPz7ox2ouqa05wUrU96cWZIvQqW9/2BGJOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751068788; c=relaxed/simple;
	bh=a1ENHSL551kJXmAR2LSrT74baSsCp54WrKImrl4qs4s=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=S8fxFCcSuoSP94rBIOKfIU0enwBA0lIQMOjp4kZnT/JMwf9VcGsQNiv2huubdKIAPXtKf7F0AV6IoRYuej/fbe+BmA1o5BuzywksyQTfQa7Fk9OR51aWuPBeknPTx4vMD2K6mwYLpdOT0CpnfbZ/pAqOqKl1BkWWS/8VJLwdYlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rnlb7U3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rnlb7U3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9BAC4CEED;
	Fri, 27 Jun 2025 23:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751068788;
	bh=a1ENHSL551kJXmAR2LSrT74baSsCp54WrKImrl4qs4s=;
	h=Date:From:To:Cc:Subject:From;
	b=Rnlb7U3L6HLLXNSKZYAtaKBHgN9BZr8JrsQA3VIGASgf8sh5SXuPOf4nJJt33HdbI
	 LZP0Sg+z0O01KpfTo6VrQnaBJLGpTjxLDKz0csd6SAqYejm6eRz2JhVN4PcNt2YO95
	 hghaF295RRAJpgZEKPrVzPSV3+Ssua4usZrq3kaY=
Date: Fri, 27 Jun 2025 16:59:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.16-rc4
Message-Id: <20250627165947.26fdc00007e5acb0ac39bc8d@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 78f4e737a53e1163ded2687a922fce138aee73f5:

  Merge tag 'for-6.16/dm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm (2025-06-23 15:02:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-06-27-16-56

for you to fetch changes up to c0cb210a87fcdda3c25f43b5a64420e6b07d3f53:

  MAINTAINERS: add Lorenzo as THP co-maintainer (2025-06-25 15:55:04 -0700)

----------------------------------------------------------------
16 hotfixes.  6 are cc:stable and the remainder address post-6.15 issues
or aren't considered necessary for -stable kernels.  5 are for MM.

----------------------------------------------------------------
Arnd Bergmann (1):
      crashdump: add CONFIG_KEYS dependency

David Hildenbrand (1):
      fs/proc/task_mmu: fix PAGE_IS_PFNZERO detection for the huge zero folio

Dev Jain (1):
      selftests/mm: fix validate_addr() helper

Duje Mihanović (1):
      mailmap: update Duje Mihanović's email address

Florian Fainelli (1):
      scripts/gdb: fix dentry_name() lookup

Ge Yang (1):
      mm/hugetlb: remove unnecessary holding of hugetlb_lock

Haiyue Wang (1):
      fuse: fix runtime warning on truncate_folio_batch_exceptionals()

Hao Ge (1):
      mm/alloc_tag: fix the kmemleak false positive issue in the allocation of the percpu variable tag->counters

Lorenzo Stoakes (2):
      MAINTAINERS: add missing files to mm page alloc section
      MAINTAINERS: add Lorenzo as THP co-maintainer

Michal Hocko (1):
      mm: add OOM killer maintainer structure

Mike Rapoport (Microsoft) (1):
      MAINTAINERS: add tree entry to mm init block

SeongJae Park (1):
      mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write

Yu Kuai (1):
      lib/group_cpus: fix NULL pointer dereference from group_cpus_evenly()

Zijun Hu (2):
      mailmap: add entries for Zijun Hu
      mailmap: correct name for a historical account of Zijun Hu

 .mailmap                                           |  4 ++
 MAINTAINERS                                        | 24 +++++++++-
 fs/fuse/inode.c                                    |  4 ++
 fs/proc/task_mmu.c                                 |  2 +-
 include/linux/kmemleak.h                           |  4 ++
 kernel/Kconfig.kexec                               |  1 +
 lib/alloc_tag.c                                    |  8 +++-
 lib/group_cpus.c                                   |  9 +++-
 mm/damon/sysfs-schemes.c                           |  1 +
 mm/hugetlb.c                                       | 54 +++++++---------------
 mm/kmemleak.c                                      | 14 ++++++
 scripts/gdb/linux/vfs.py                           |  2 +-
 tools/testing/selftests/mm/virtual_address_range.c |  7 ++-
 13 files changed, 90 insertions(+), 44 deletions(-)


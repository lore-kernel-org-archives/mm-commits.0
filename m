Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9759C1CAA89;
	Thu, 20 Feb 2025 01:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740016392; cv=none; b=aiA2gdR9RAF2Ve63U/AdjWsq9VK5pOvBHOYH13gsFuFOY90kcgRZpK/I8x/elPYFXC876MmRZdZnBOEp8twODnaFG77flVAS40GCZwSsF+DlPNTqa1BriTh+ffs8jyrGFwD4ryHeJxJaeUZgKgGC68pPiCk79T9q6Tr8CRqf4XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740016392; c=relaxed/simple;
	bh=UTuww2EikEdSjoMQ2T/aSQurNuOKitapWdKE5z0My2M=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=tdYDqDcsFL/UGriBMahr93/EILD5b6nlj+24oKqaiSP49hA+ezKYJIePacSoafiwAlXGOx1BTSccerBNfPpQh0WpfNhdWCja7Kzjeym4AqGrvg2g10HXbB+nkx6ex9fFdpgSKFPbdTvv74LVYY61BqvkaJAWH/bb0Q7BVtD7AAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G1QVR7lv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G1QVR7lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDA9C4AF0C;
	Thu, 20 Feb 2025 01:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740016392;
	bh=UTuww2EikEdSjoMQ2T/aSQurNuOKitapWdKE5z0My2M=;
	h=Date:From:To:Cc:Subject:From;
	b=G1QVR7lvDQD8Wtmi4Elsm1T8qIcTOXfKNIIPm5f8TQde8TcbDiQqmJwuBCE8H5jf6
	 0b3unfiZK3Ds6ZmJo8V9S4ufrvSIt+hHCZBRwwN32O58jOq7Tem+rDFl951keVffkH
	 DskLDHVP/ROGvJFKDHTwbE5wFIxWbFS9kMb0dSJY=
Date: Wed, 19 Feb 2025 17:53:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.14-rc4
Message-Id: <20250219175311.7a5b47084de5ad0258526be2@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 0ad2507d5d93f39619fc42372c347d6006b64319:

  Linux 6.14-rc3 (2025-02-16 14:02:44 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2025-02-19-17-49

for you to fetch changes up to 8344017aaf32a7532cff293eb3df7fd2265ebafd:

  test_xarray: fix failure in check_pause when CONFIG_XARRAY_MULTI is not d=
efined (2025-02-17 22:40:04 -0800)

----------------------------------------------------------------
18 hotfixes.  5 are cc:stable and the remainder address post-6.13 issues
or aren't considered necessary for -stable kernels.

10 are for MM and 8 are for non-MM.  All are singletons, please see the
changelogs for details.

----------------------------------------------------------------
Bart Van Assche (1):
      procfs: fix a locking bug in a vmcore_add_device_dump() error path

Chen Ridong (1):
      memcg: avoid dead loop when setting memory.max

David Hildenbrand (1):
      mm/migrate_device: don't add folio to be freed to LRU in migrate_devi=
ce_finalize()

Feng Tang (1):
      mailmap: add entry for Feng Tang

Florian Fainelli (1):
      tools/mm: fix build warnings with musl-libc

Hyeonggon Yoo (1):
      mm/zswap: fix inconsistency when zswap_store_page() fails

Jeff Johnson (1):
      .mailmap: add entries for Jeff Johnson

Kemeng Shi (1):
      test_xarray: fix failure in check_pause when CONFIG_XARRAY_MULTI is n=
ot defined

Luiz Capitulino (1):
      mm: hugetlb: avoid fallback for specific node allocation of 1G pages

Mark Brown (1):
      selftests/mm: fix check for running THP tests

Nick Desaulniers (2):
      mailmap: update Nick's entry
      MAINTAINERS: update Nick's contact info

Pavel Begunkov (1):
      lib/iov_iter: fix import_iovec_ubuf iovec management

Qi Zheng (1):
      mm: pgtable: fix incorrect reclaim of non-empty PTE pages

Ricardo Ca=F1uelo Navarro (1):
      mm,madvise,hugetlb: check for 0-length range after end address adjust=
ment

Waiman Long (1):
      kasan: don't call find_vm_area() in a PREEMPT_RT kernel

Wang Yaxin (2):
      getdelays: fix error format characters
      taskstats: modify taskstats version

 .mailmap                                           |  4 +++
 .../process/embargoed-hardware-issues.rst          |  2 +-
 .../sp_SP/process/embargoed-hardware-issues.rst    |  2 +-
 MAINTAINERS                                        |  2 +-
 fs/proc/vmcore.c                                   |  5 +++-
 include/uapi/linux/taskstats.h                     |  2 +-
 lib/iov_iter.c                                     |  3 +-
 lib/test_xarray.c                                  | 15 +++++-----
 mm/hugetlb.c                                       |  2 +-
 mm/kasan/report.c                                  | 34 ++++++++++++++++++=
++-
 mm/madvise.c                                       | 11 ++++++-
 mm/memcontrol.c                                    |  1 +
 mm/memory.c                                        | 17 +++++++++--
 mm/migrate_device.c                                | 13 +++-----
 mm/zswap.c                                         | 35 ++++++++++--------=
----
 tools/accounting/getdelays.c                       | 32 ++++++++++--------=
--
 tools/mm/page-types.c                              |  4 +--
 tools/testing/selftests/mm/run_vmtests.sh          |  2 +-
 18 files changed, 120 insertions(+), 66 deletions(-)


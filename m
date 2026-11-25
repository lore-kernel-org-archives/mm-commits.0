Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589051;
	b=JGccD69Y1KDQNWtTFEtLxCfMNcSzjdl0eauanRvpOdlYi4bhAuinLKwRlSGPeIL7enyK
	 v94PnhBRGXNVb+57tMttmvbOOHW24o2BYA/t9w9navEuhGsI2mscOAiT2G5pBjFx77BEU
	 104ZoFUhDVPkRXDX+rgszM70i//Pkc0HCBNNiRdqUYdM/B//FsTk2NOmJZwxhD+UVIBe2
	 3Io2ilPO580dAVlHwbZDNSXFlLA3sHPOWpOYjAmL7hothosKQkLo8x5C3q97ocB/m7rl1
	 bjU+5a3EQpBdAmnA7kDqhXeVW8bO/bk7yWUJ4HHdPLdh04gUZZiCFPPM7rxOwLst5OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589051;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:X-Mailer:
	 Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=LMQAj09bQbCYq864JFAOM1F6lLxWDCCM05N91L35IgQ=;
	b=omgtq+p+ZzLKehGCakikFuigVflyWkztq604HHCqgrt9QMSzdQ9WmtclZPNY5Ei00w8G
	 QrFA1M0KSMGg9HeLyFa2qCt9hzj+4c1HQbtTqsCuDduDQTcmjuyP6HusOYCfy0In1iFwK
	 Wx1nlUUgWx7lIYTVEHoAScIVhSPMXv0hOd8xoGlJBK6SVPSJYiMyFk/Zg5NzmtdvDxpmF
	 zvxI7AgTr2mO/Ary2tCFrCuCL1DUJWy35AVekc+NfpfLTxvdLZe899WZM7fAhZq9DPRBG
	 bFDCuHuhz8V2gPPAMWnk6HxgOC9VFKs+DGwMuYB0vtY+hK0V+dM2hD1do4UVewiuvFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aaRG5jvB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCFE606A321;
	Wed, 25 Nov 2026 06:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aaRG5jvB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B741F000CF;
	Wed, 25 Nov 2026 06:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795589050;
	bh=LMQAj09bQbCYq864JFAOM1F6lLxWDCCM05N91L35IgQ=;
	h=Date:From:To:Cc:Subject;
	b=aaRG5jvBSWj5PNceuyAf4rFfTBdAlBAysT2A6X4VVO6wsWN0puOJZr/etsbm6f/Tn
	 Sx7262mKxmXayfSJXi+2TlBG1qFuOam48b1vC73fcR/l/OCr4C+D4t3d+KKiZiPh6e
	 EhMRW0NwdgrZsfyDw2TNx27Yscjj9YkavfS2KyMk=
Date: Tue, 24 Nov 2026 22:44:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, David Hildenbrand <david@kernel.org>
Subject: [GIT PULL] MM hotfixes for 7.4-rc5
Message-Id: <20261124224409.56e65d8ff1f72a1d485450ad@linux-foundation.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge this batch of MM hotfixes, thanks.


The following changes since commit 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd:

  Merge tag 'mm-nonmm-hotfixes-stable-2026-11-18-00-06' of git://git.kernel=
.org/pub/scm/linux/kernel/git/akpm/mm (2026-11-18 09:51:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2026-11-24-22-39

for you to fetch changes up to 448293c44d86abaff45d6f6919e6056ad97eaa31:

  mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree() (2026-1=
1-22 22:24:15 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-hotfixes-stable

Everything:

Total patches:       26
Fixes: tags:         18
cc:stable patches:   17
Reviews/patch:       3.88
Reviewed rate:       96%

Summary of patch series in this merge:

- "mm: fix swapcache writeout and cluster table races" (Nhat Pham):

  Let reclaim write dirty swapcache folios without anon mappings.
  Publish swap cluster tables under the allocator locks and keep
  stale reclaimers from relocating clusters being populated.

- "mm/hugetlb: various fixes" (David Hildenbrand):

  Prevent fallocate() overflow from consuming and leaking huge pages.
  Serialize mremap() with migration before flushing stale TLB entries,
  and avoid corrupting private hugetlb VMA state during unmapping.

- "MAINTAINERS: remove my reviewerships, add CREDITS entry for THP"
  (Lorenzo Stoakes):

  Remove Lorenzo's MM reviewership entries and record his THP
  maintenance in CREDITS.

- "MAINTAINERS: MM updates (2)" (David Hildenbrand):

  Add Kairui as an MGLRU maintainer, move Barry to the top of its
  reviewer list and remove David from reclaim reviewership.

Summary of the 14 singletons in this merge:

Two list_lru fixes prevent a cgroup's reused ID from making a folio unlink
from the wrong list, which can corrupt the list and later access freed
memory.  They also avoid a NULL dereference if a folio moves to the root
cgroup between the allocation path's two lookups.  MGLRU now moves every
generation when reparenting a cgroup; a skipped list could otherwise
remain in a freed cgroup and cause a use-after-free.  Clearing MGLRU
references before removing a MADV_FREE folio from its generation also
stops reclaim from repeatedly protecting a discardable folio.

The memcg object stock now flushes pending charged bytes when its lock
cannot be taken.  Otherwise memory.current could grow without matching
usage, causing unnecessary reclaim, throttling or OOM kills, and a counter
wrap could leave a permanent charge.  The memcg OOM scan also keeps an
exiting victim visible until it releases its memory, avoiding an
unnecessary second kill that could take down an entire workload.

Swap allocation again prefers free clusters on nonsynchronous devices,
keeping writes mergeable.  In the reported NVMe mysql/sysbench workload,
the prior policy reduced throughput by 19% with iocost; the revised policy
improved throughput by 33% against its base.  The change keeps the old
nonfull-cluster preference for synchronous devices such as zram.  A
separate fix corrects /proc/swaps and swapon() size reporting for
multi-terabyte swap areas.  DAMON's estimated bandwidth calculation no
longer overflows on 32-bit systems.

UFFDIO_MOVE now clears a stale userfaultfd bit when moving a swapped page
into an unregistered VMA.  The old bit could cause MADV_COLLAPSE to fail
or trigger a page-table-check warning on fault-in.  Buffered writes
starting beyond EOF now check an unreadable source buffer before some
filesystems extend the file, avoiding a failed EFAULT write that leaves a
larger file.  On 32-bit systems with 64-bit physical addresses, /dev/mem
now makes the correct uncached mapping decision above 4 GiB.

----------------------------------------------------------------
Alexandre Ghiti (1):
      mm, swap: only prefer nonfull clusters on synchronous devices

Andrew Morton (1):
      MAINTAINERS: add page_ext.h to MEMORY MANAGEMENT - PAGE ALLOCATOR

Chris Down (1):
      mm: memcontrol: don't lose track of exiting OOM victims

David Hildenbrand (Arm) (4):
      MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU) update
      MAINTAINERS: remove myself from MEMORY MANAGEMENT - RECLAIM
      hugetlbfs: fix integer overflow in fallocate()
      mm/hugetlb: fix mremap() racing with page migration

Donggeun Yoo (1):
      userfaultfd: clear the inherited uffd bit in move_swap_pte()

Hui Zhu (1):
      mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()

Hungyu Lin (1):
      filemap: prefault writes starting beyond EOF

Iv=E1n Ezequiel Rodriguez (1):
      mm: use PFN_PHYS() in phys_mem_access_prot()

Josef Bacik (1):
      hugetlbfs: fix unmapping folios from private VMAs

Lorenzo Stoakes (ARM) (5):
      MAINTAINERS: remove myself from MM core reviewership
      MAINTAINERS: remove myself from MM misc, reclaim reviewership
      MAINTAINERS: remove myself from MM rust reviewerships
      CREDITS: add entry for THP maintenance
      MAINTAINERS: consolidate the memory mapping entries into a VMA entry

Nhat Pham (3):
      mm: vmscan: allow writeout of swapcache folios without anon mappings
      mm/swap: publish cluster tables after reacquiring allocator locks
      mm/swap: skip relocation of tableless clusters

Oleksandr Natalenko (1):
      mm/swapfile: really fix integer overflow in swap_show() and swapon()

Shakeel Butt (4):
      mm: mglru: splice all generations when reparenting a memcg
      memcg: flush nr_charged_bytes when the obj stock trylock fails
      mm: list_lru: fix NULL deref when a folio moves to the root memcg
      mm: list_lru: don't use a new memcg's lists for an offline memcg

Wang Guangke (1):
      mm/damon/stat: avoid overflow in estimated_memory_bandwidth calculati=
on

 CREDITS                  |   6 +++
 MAINTAINERS              |  62 ++++++---------------
 fs/hugetlbfs/inode.c     |  18 +++++--
 include/linux/list_lru.h |   2 +
 mm/char-mem.c            |   2 +-
 mm/damon/stat.c          |  15 +++---
 mm/filemap.c             |  10 ++++
 mm/folio.c               |   6 +--
 mm/hugetlb.c             |  21 +++++++-
 mm/list_lru.c            |  41 ++++++++++----
 mm/memcontrol.c          |  10 +++-
 mm/swapfile.c            | 138 +++++++++++++++++++++++++++++++++----------=
----
 mm/userfaultfd.c         |   1 +
 mm/vmscan.c              |  15 ++++--
 14 files changed, 230 insertions(+), 117 deletions(-)


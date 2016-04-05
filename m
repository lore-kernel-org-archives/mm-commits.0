From: akpm@linux-foundation.org
Subject: + huge-tmpfs-no-kswapd-by-default-on-sync-allocations.patch added to -mm tree
Date: Tue, 05 Apr 2016 16:16:41 -0700
Message-ID: <57044759.u8pptD0iyT0zJRns%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbcDEXQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:16:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreslc@google.com, aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: no kswapd by default on sync allocations
has been added to the -mm tree.  Its filename is
     huge-tmpfs-no-kswapd-by-default-on-sync-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-no-kswapd-by-default-on-sync-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-no-kswapd-by-default-on-sync-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andres Lagar-Cavilla <andreslc@google.com>
Subject: huge tmpfs: no kswapd by default on sync allocations

This triggers early compaction abort while in process context, to
ameliorate mmap semaphore stalls.

Signed-off-by: Andres Lagar-Cavilla <andreslc@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Suggested-by: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.txt |    5 +++--
 mm/shmem.c                          |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/tmpfs.txt~huge-tmpfs-no-kswapd-by-default-on-sync-allocations Documentation/filesystems/tmpfs.txt
--- a/Documentation/filesystems/tmpfs.txt~huge-tmpfs-no-kswapd-by-default-on-sync-allocations
+++ a/Documentation/filesystems/tmpfs.txt
@@ -194,8 +194,9 @@ to force huge off for all (intended for
 
 /proc/sys/vm/shmem_huge_gfpmask (intended for experimentation only):
 
-Default 38146762, that is 0x24612ca:
-GFP_HIGHUSER_MOVABLE|__GFP_NOWARN|__GFP_THISNODE|__GFP_NORETRY.
+Default 4592330, that is 0x4612ca:
+GFP_HIGHUSER_MOVABLE|__GFP_NOWARN|__GFP_THISNODE|__GFP_NORETRY
+minus __GFP_KSWAPD_RECLAIM.
 Write a gfpmask built from __GFP flags in include/linux/gfp.h, to experiment
 with better alternatives for the synchronous huge tmpfs allocation used
 when faulting or writing.
diff -puN mm/shmem.c~huge-tmpfs-no-kswapd-by-default-on-sync-allocations mm/shmem.c
--- a/mm/shmem.c~huge-tmpfs-no-kswapd-by-default-on-sync-allocations
+++ a/mm/shmem.c
@@ -324,7 +324,8 @@ int shmem_huge __read_mostly;
 int shmem_huge_recoveries __read_mostly = 8;	/* concurrent recovery limit */
 
 int shmem_huge_gfpmask __read_mostly =
-	(int)(GFP_HIGHUSER_MOVABLE|__GFP_NOWARN|__GFP_THISNODE|__GFP_NORETRY);
+	(int)(GFP_HIGHUSER_MOVABLE|__GFP_NOWARN|__GFP_THISNODE|__GFP_NORETRY) &
+	~__GFP_KSWAPD_RECLAIM;
 int shmem_recovery_gfpmask __read_mostly =
 	(int)(GFP_HIGHUSER_MOVABLE|__GFP_NOWARN|__GFP_THISNODE);
 
_

Patches currently in -mm which might be from andreslc@google.com are

tmpfs-mem_cgroup-charge-fault-to-vm_mm-not-current-mm.patch
kvm-plumb-return-of-hva-when-resolving-page-fault.patch
kvm-teach-kvm-to-map-page-teams-as-huge-pages.patch
huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting.patch
huge-tmpfs-mem_cgroup-shmem_hugepages-accounting.patch
huge-tmpfs-show-page-team-flag-in-pageflags.patch
huge-tmpfs-no-kswapd-by-default-on-sync-allocations.patch


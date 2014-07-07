From: akpm@linux-foundation.org
Subject: [merged] msync-fix-incorrect-fstart-calculation.patch removed
 from -mm tree
Date: Mon, 07 Jul 2014 11:11:24 -0700
Message-ID: <53bae2cc.Ng/7aVViIt/u1dIk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:45371 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaGGSLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:11:25 -0400
Received: by mail-vc0-f201.google.com with SMTP id ij19so656918vcb.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:11:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sangwan@samsung.com, enwlinux@gmail.com, lczerner@redhat.com, matthew.r.wilcox@intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: msync: fix incorrect fstart calculation
has been removed from the -mm tree.  Its filename was
     msync-fix-incorrect-fstart-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: msync: fix incorrect fstart calculation

Fix a regression caused by 7fc34a62ca ("mm/msync.c: sync only the
requested range in msync()").

xfstests generic/075 fail occured on ext4 data=journal mode because the
intended range was not syncing due to wrong fstart calculation.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Reported-by: Eric Whitney <enwlinux@gmail.com>
Tested-by: Eric Whitney <enwlinux@gmail.com>
Acked-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Tested-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/msync.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/msync.c~msync-fix-incorrect-fstart-calculation mm/msync.c
--- a/mm/msync.c~msync-fix-incorrect-fstart-calculation
+++ a/mm/msync.c
@@ -78,7 +78,8 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 			goto out_unlock;
 		}
 		file = vma->vm_file;
-		fstart = start + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
+		fstart = (start - vma->vm_start) +
+			 ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 		fend = fstart + (min(end, vma->vm_end) - start) - 1;
 		start = vma->vm_end;
 		if ((flags & MS_SYNC) && file &&
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-add-i_disksize-to-represent-uninitialized-size-v4.patch
fat-add-fat_fallocate-operation-v4.patch
fat-zero-out-seek-range-on-_fat_get_block-v4.patch
fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4.patch


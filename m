From: akpm@linux-foundation.org
Subject: + msync-fix-incorrect-fstart-calculation.patch added to -mm tree
Date: Fri, 27 Jun 2014 12:24:25 -0700
Message-ID: <53adc4e9.6vJfux0LE3G01lbu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42603 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaF0TY0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jun 2014 15:24:26 -0400
Received: by mail-yh0-f74.google.com with SMTP id b6so501768yha.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2014 12:24:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sangwan@samsung.com, enwlinux@gmail.com, lczerner@redhat.com, matthew.r.wilcox@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: msync: fix incorrect fstart calculation
has been added to the -mm tree.  Its filename is
     msync-fix-incorrect-fstart-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/msync-fix-incorrect-fstart-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/msync-fix-incorrect-fstart-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

msync-fix-incorrect-fstart-calculation.patch
linux-next.patch
fat-add-i_disksize-to-represent-uninitialized-size-v4.patch
fat-add-fat_fallocate-operation-v4.patch
fat-zero-out-seek-range-on-_fat_get_block-v4.patch
fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4.patch


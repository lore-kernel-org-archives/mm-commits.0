From: akpm@linux-foundation.org
Subject: +
 mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-2.patch
 added to -mm tree
Date: Fri, 15 Dec 2017 14:23:13 -0800
Message-ID: <5a344b51.C6UjLiFUZpz05fbo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58322 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756759AbdLOWXO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Dec 2017 17:23:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mhocko@suse.com, yang.s@alibaba-inc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: avoid uninitialized variable use
has been added to the -mm tree.  Its filename is
     mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: thp: avoid uninitialized variable use

When the down_read_trylock() fails, 'vma' has not been initialized yet,
which gcc now warns about:

mm/khugepaged.c: In function 'khugepaged':
mm/khugepaged.c:1659:25: error: 'vma' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Presumably we are not supposed to call find_vma() without the mmap_sem
either, so setting it to NULL for this case seems appropriate.

Link: http://lkml.kernel.org/r/20171215125129.2948634-1-arnd@arndb.de
Fixes: 0951b59acf3a ("mm: thp: use down_read_trylock() in khugepaged to avoid long block")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: "Yang Shi" <yang.s@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/khugepaged.c~mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-2 mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-2
+++ a/mm/khugepaged.c
@@ -1677,11 +1677,10 @@ static unsigned int khugepaged_scan_mm_s
  	 * Don't wait for semaphore (to avoid long wait times).  Just move to
 	 * the next mm on the list.
  	 */
+	vma = NULL;
 	if (unlikely(!down_read_trylock(&mm->mmap_sem)))
 		goto breakouterloop_mmap_sem;
-	if (unlikely(khugepaged_test_exit(mm)))
-		vma = NULL;
-	else
+	if (likely(!khugepaged_test_exit(mm)))
 		vma = find_vma(mm, khugepaged_scan.address);
 
 	progress++;
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-2.patch


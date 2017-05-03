From: akpm@linux-foundation.org
Subject: [folded-merged] proc-show-madv_free-pages-info-in-smaps-fix.patch removed from -mm tree
Date: Wed, 03 May 2017 14:36:05 -0700
Message-ID: <590a4d45.5vjaFr9KXU4xaCtU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45276 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdECVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, shli@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-show-madv_free-pages-info-in-smaps-fix
has been removed from the -mm tree.  Its filename was
     proc-show-madv_free-pages-info-in-smaps-fix.patch

This patch was dropped because it was folded into proc-show-madv_free-pages-info-in-smaps.patch

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: proc-show-madv_free-pages-info-in-smaps-fix

update Documentation/filesystems/proc.txt

Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~proc-show-madv_free-pages-info-in-smaps-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-show-madv_free-pages-info-in-smaps-fix
+++ a/Documentation/filesystems/proc.txt
@@ -444,7 +444,9 @@ a mapping associated with a file may con
 and a page is modified, the file page is replaced by a private anonymous copy.
 "LazyFree" shows the amount of memory which is marked by madvise(MADV_FREE).
 The memory isn't freed immediately with madvise(). It's freed in memory
-pressure if the memory is clean.
+pressure if the memory is clean. Please note that the printed value might
+be lower than the real value due to optimizations used in the current
+implementation. If this is not desirable please file a bug report.
 "AnonHugePages" shows the ammount of memory backed by transparent hugepage.
 "ShmemPmdMapped" shows the ammount of shared (shmem/tmpfs) memory backed by
 huge pages.
_

Patches currently in -mm which might be from mhocko@kernel.org are

proc-show-madv_free-pages-info-in-smaps.patch


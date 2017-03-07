From: akpm@linux-foundation.org
Subject: + proc-show-madv_free-pages-info-in-smaps-fix.patch added to -mm
 tree
Date: Tue, 07 Mar 2017 14:44:31 -0800
Message-ID: <58bf37cf.6u8vuDiwBadTWSD7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756414AbdCHABx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2017 19:01:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, shli@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-show-madv_free-pages-info-in-smaps-fix
has been added to the -mm tree.  Its filename is
     proc-show-madv_free-pages-info-in-smaps-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-show-madv_free-pages-info-in-smaps-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-show-madv_free-pages-info-in-smaps-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

proc-show-madv_free-pages-info-in-smaps-fix.patch


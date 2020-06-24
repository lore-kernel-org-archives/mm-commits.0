From: akpm@linux-foundation.org
Subject: +
 =?us-ascii?Q?mm-filemap-add-missing-fgp=5F-flags-in-kerneldoc-comment-?=
 =?us-ascii?Q?for-pagecache=5Fget=5Fpage.patch?= added to -mm tree
Date: Wed, 24 Jun 2020 14:02:53 -0700
Message-ID: <20200624210253.kHCxT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388763AbgFXVCz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:02:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shakeelb@google.com, riel@surriel.com, hannes@cmpxchg.org, gavin.dg@linux.alibaba.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: filemap: add missing FGP_ flags in kerneldoc comment for pagecache_get_page
has been added to the -mm tree.  Its filename is
     mm-filemap-add-missing-fgp_-flags-in-kerneldoc-comment-for-pagecache_get_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-add-missing-fgp_-flags-in-kerneldoc-comment-for-pagecache_get_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-add-missing-fgp_-flags-in-kerneldoc-comment-for-pagecache_get_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: filemap: add missing FGP_ flags in kerneldoc comment for pagecache_get_page

FGP_{WRITE|NOFS|NOWAIT} were missed in pagecache_get_page's kerneldoc
comment.

Link: http://lkml.kernel.org/r/1593031747-4249-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Gang Deng <gavin.dg@linux.alibaba.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/filemap.c~mm-filemap-add-missing-fgp_-flags-in-kerneldoc-comment-for-pagecache_get_page
+++ a/mm/filemap.c
@@ -1590,6 +1590,9 @@ EXPORT_SYMBOL(find_lock_entry);
  * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if the
  *   page is already in cache.  If the page was allocated, unlock it before
  *   returning so the caller can do the same dance.
+ * * %FGP_WRITE - The page will be written
+ * * %FGP_NOFS - __GFP_FS will get cleared in gfp mask
+ * * %FGP_NOWAIT - Don't get blocked by page lock
  *
  * If %FGP_LOCK or %FGP_CREAT are specified then the function may sleep even
  * if the %GFP flags specified for %FGP_CREAT are atomic.
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

doc-thp-cow-fault-no-longer-allocate-thp.patch
mm-filemap-clear-idle-flag-for-writes.patch
mm-filemap-add-missing-fgp_-flags-in-kerneldoc-comment-for-pagecache_get_page.patch
mm-thp-remove-debug_cow-switch.patch

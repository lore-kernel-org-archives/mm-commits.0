From: akpm@linux-foundation.org
Subject: + vmstat-fix-wrong-comment.patch added to -mm tree
Date: Wed, 09 Aug 2017 12:55:39 -0700
Message-ID: <598b68bb.P+yR8W95Vozxjq9k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752138AbdHITzk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2017 15:55:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sj38.park@gmail.com, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: fix wrong comment
has been added to the -mm tree.  Its filename is
     vmstat-fix-wrong-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-fix-wrong-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-fix-wrong-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj38.park@gmail.com>
Subject: mm/vmstat.c: fix wrong comment

Comment for pagetypeinfo_showblockcount() is mistakenly duplicated from
pagetypeinfo_show_free()'s comment.  This commit fixes it.

Link: http://lkml.kernel.org/r/20170809185816.11244-1-sj38.park@gmail.com
Fixes: 467c996c1e19 ("Print out statistics in relation to fragmentation avoidance to /proc/pagetypeinfo")
Signed-off-by: SeongJae Park <sj38.park@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~vmstat-fix-wrong-comment mm/vmstat.c
--- a/mm/vmstat.c~vmstat-fix-wrong-comment
+++ a/mm/vmstat.c
@@ -1255,7 +1255,7 @@ static void pagetypeinfo_showblockcount_
 	seq_putc(m, '\n');
 }
 
-/* Print out the free pages at each order for each migratetype */
+/* Print out the number of pageblocks for each migratetype */
 static int pagetypeinfo_showblockcount(struct seq_file *m, void *arg)
 {
 	int mtype;
_

Patches currently in -mm which might be from sj38.park@gmail.com are

vmstat-fix-wrong-comment.patch


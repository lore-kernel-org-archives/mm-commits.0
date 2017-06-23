From: akpm@linux-foundation.org
Subject: + mm-remove-ancient-ambiguous-comment.patch added to -mm tree
Date: Fri, 23 Jun 2017 13:34:02 -0700
Message-ID: <594d7b3a.RK5/QcX6M1ZtUqua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754889AbdFWUeD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 16:34:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nborisov@suse.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: remove ancient/ambiguous comment
has been added to the -mm tree.  Its filename is
     mm-remove-ancient-ambiguous-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-ancient-ambiguous-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-ancient-ambiguous-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nikolay Borisov <nborisov@suse.com>
Subject: include/linux/mmzone.h: remove ancient/ambiguous comment

Currently pg_data_t is just a struct which describes a NUMA node memory
layout.  Let's keep the comment simple and remove ambiguity.

Link: http://lkml.kernel.org/r/1498220534-22717-1-git-send-email-nborisov@suse.com
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN include/linux/mmzone.h~mm-remove-ancient-ambiguous-comment include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-ancient-ambiguous-comment
+++ a/include/linux/mmzone.h
@@ -603,12 +603,9 @@ extern struct page *mem_map;
 #endif
 
 /*
- * The pg_data_t structure is used in machines with CONFIG_DISCONTIGMEM
- * (mostly NUMA machines?) to denote a higher-level memory zone than the
- * zone denotes.
- *
  * On NUMA machines, each NUMA node would have a pg_data_t to describe
- * it's memory layout.
+ * it's memory layout. On UMA machines there is a single pglist_data which
+ * describes the whole memory.
  *
  * Memory statistics and page replacement data structures are maintained on a
  * per-zone basis.
_

Patches currently in -mm which might be from nborisov@suse.com are

mm-remove-ancient-ambiguous-comment.patch
writeback-rework-wb__stat-family-of-functions.patch


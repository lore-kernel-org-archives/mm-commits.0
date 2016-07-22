From: akpm@linux-foundation.org
Subject: + mm-add-cond_resched-to-generic_swapfile_activate.patch added to -mm tree
Date: Fri, 22 Jul 2016 14:33:14 -0700
Message-ID: <5792911a.Vx42EUb+v7d2kL8E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbcGVVdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jul 2016 17:33:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpatocka@redhat.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add cond_resched() to generic_swapfile_activate()
has been added to the -mm tree.  Its filename is
     mm-add-cond_resched-to-generic_swapfile_activate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-cond_resched-to-generic_swapfile_activate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-cond_resched-to-generic_swapfile_activate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: mm: add cond_resched() to generic_swapfile_activate()

generic_swapfile_activate() can take quite long time, it iterates over all
blocks of a file, so add cond_resched to it.  I observed about 1 second
stalls when activating a swapfile that was almost unfragmented - this
patch fixes it.

Link: http://lkml.kernel.org/r/alpine.LRH.2.02.1607221710580.4818@file01.intranet.prod.int.rdu2.redhat.com
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_io.c~mm-add-cond_resched-to-generic_swapfile_activate mm/page_io.c
--- a/mm/page_io.c~mm-add-cond_resched-to-generic_swapfile_activate
+++ a/mm/page_io.c
@@ -166,6 +166,8 @@ int generic_swapfile_activate(struct swa
 		unsigned block_in_page;
 		sector_t first_block;
 
+		cond_resched();
+
 		first_block = bmap(inode, probe_block);
 		if (first_block == 0)
 			goto bad_bmap;
_

Patches currently in -mm which might be from mpatocka@redhat.com are

mm-add-cond_resched-to-generic_swapfile_activate.patch
mm-optimize-copy_page_to-from_iter_iovec.patch


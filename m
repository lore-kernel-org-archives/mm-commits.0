From: akpm@linux-foundation.org
Subject: [patch 086/101] mm: add cond_resched() to
 generic_swapfile_activate()
Date: Thu, 28 Jul 2016 15:48:47 -0700
Message-ID: <579a8bcf.gxs8owBdYO8WF8bn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbcG1Wss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mpatocka@redhat.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.com, viro@zeniv.linux.org.uk

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: mm: add cond_resched() to generic_swapfile_activate()

generic_swapfile_activate() can take quite long time, it iterates over all
blocks of a file, so add cond_resched to it.  I observed about 1 second
stalls when activating a swapfile that was almost unfragmented - this
patch fixes it.

Link: http://lkml.kernel.org/r/alpine.LRH.2.02.1607221710580.4818@file01.intranet.prod.int.rdu2.redhat.com
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
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

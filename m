From: akpm@linux-foundation.org
Subject: [merged] vmalloc-back-of-when-the-current-is-killed.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:27:05 -0800
Message-ID: <58b48b99.UyY7OofXeSEXwF2Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60788 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbdB0U16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hch@lst.de, penguin-kernel@I-love.SAKURA.ne.jp, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc: back off when the current task is killed
has been removed from the -mm tree.  Its filename was
     vmalloc-back-of-when-the-current-is-killed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: vmalloc: back off when the current task is killed

__vmalloc_area_node() allocates pages to cover the requested vmalloc size.
This can be a lot of memory.  If the current task is killed by the OOM
killer, and thus has an unlimited access to memory reserves, it can
consume all the memory theoretically.  Fix this by checking for
fatal_signal_pending and back off early.

Link: http://lkml.kernel.org/r/20170201092706.9966-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/vmalloc.c~vmalloc-back-of-when-the-current-is-killed mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-back-of-when-the-current-is-killed
+++ a/mm/vmalloc.c
@@ -1642,6 +1642,11 @@ static void *__vmalloc_area_node(struct
 	for (i = 0; i < area->nr_pages; i++) {
 		struct page *page;
 
+		if (fatal_signal_pending(current)) {
+			area->nr_pages = i;
+			goto fail;
+		}
+
 		if (node == NUMA_NO_NODE)
 			page = alloc_page(alloc_mask);
 		else
_

Patches currently in -mm which might be from mhocko@suse.com are



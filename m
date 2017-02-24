From: akpm@linux-foundation.org
Subject: [patch 066/124] vmalloc: back off when the current task is killed
Date: Fri, 24 Feb 2017 14:58:53 -0800
Message-ID: <58b0baad.4cfVGAr1xQz1ysVt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751593AbdBXW6y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:58:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hch@lst.de, penguin-kernel@I-love.SAKURA.ne.jp, viro@zeniv.linux.org.uk

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

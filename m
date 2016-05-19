From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch removed from -mm tree
Date: Thu, 19 May 2016 16:57:03 -0700
Message-ID: <573e52cf.F7YzosQNn7Pz7fwE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbcESX5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, brouer@redhat.com, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch

This patch was dropped because it was folded into mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix

mm/page_alloc.c: In function 'free_pcp_prepare':
mm/page_alloc.c:997: error: implicit declaration of function 'free_pages_prepare'
mm/page_alloc.c: At top level:
mm/page_alloc.c:1202: error: conflicting types for 'free_pages_prepare'
mm/page_alloc.c:997: note: previous implicit declaration of 'free_pages_prepare' was here

might be a merge snafu

Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix
+++ a/mm/page_alloc.c
@@ -991,6 +991,8 @@ out:
 	return ret;
 }
 
+static bool free_pages_prepare(struct page *page, unsigned int order);
+
 #ifdef CONFIG_DEBUG_VM
 static inline bool free_pcp_prepare(struct page *page)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-nodemaskh-create-next_node_in-helper.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch


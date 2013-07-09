From: akpm@linux-foundation.org
Subject: +
 ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page.patch added to -mm tree
Date: Tue, 09 Jul 2013 15:22:34 -0700
Message-ID: <51dc8d2a.3tI2yQ5Dbto1Dc+x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3GIWWf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 18:22:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, guz.fnst@cn.fujitsu.com

Subject: + ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page.patch added to -mm tree
To: guz.fnst@cn.fujitsu.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 15:22:34 -0700


The patch titled
     Subject: ocfs2/refcounttree: add the missing NULL check of the return value of find_or_create_page()
has been added to the -mm tree.  Its filename is
     ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: ocfs2/refcounttree: add the missing NULL check of the return value of find_or_create_page()

Add the missing NULL check of the return value of find_or_create_page() in
function ocfs2_duplicate_clusters_by_page().

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page
+++ a/fs/ocfs2/refcounttree.c
@@ -2965,7 +2965,11 @@ int ocfs2_duplicate_clusters_by_page(han
 			to = map_end & (PAGE_CACHE_SIZE - 1);
 
 		page = find_or_create_page(mapping, page_index, GFP_NOFS);

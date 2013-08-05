From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page.patch removed from -mm tree
Date: Mon, 05 Aug 2013 12:05:39 -0700
Message-ID: <51fff783.67jgVMPLakfKtDY+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3HETGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:06:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, guz.fnst@cn.fujitsu.com

Subject: [merged] ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page.patch removed from -mm tree
To: guz.fnst@cn.fujitsu.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:05:39 -0700


The patch titled
     Subject: ocfs2/refcounttree: add the missing NULL check of the return value of find_or_create_page()
has been removed from the -mm tree.  Its filename was
     ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: ocfs2/refcounttree: add the missing NULL check of the return value of find_or_create_page()

Add the missing NULL check of the return value of find_or_create_page() in
function ocfs2_duplicate_clusters_by_page().

[akpm@linux-foundation.org: fix layout, per Joel]
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page
+++ a/fs/ocfs2/refcounttree.c
@@ -2965,6 +2965,11 @@ int ocfs2_duplicate_clusters_by_page(han
 			to = map_end & (PAGE_CACHE_SIZE - 1);
 
 		page = find_or_create_page(mapping, page_index, GFP_NOFS);
+		if (!page) {
+			ret = -ENOMEM;
+			mlog_errno(ret);
+			break;
+		}
 
 		/*
 		 * In case PAGE_CACHE_SIZE <= CLUSTER_SIZE, This page
_

Patches currently in -mm which might be from guz.fnst@cn.fujitsu.com are

lib-crc32-update-the-comments-of-crc32_bele_generic.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
linux-next.patch


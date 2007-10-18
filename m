From: akpm@linux-foundation.org
Subject: - fs-use-kmem_cache_zalloc-instead.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:25 -0700
Message-ID: <200710180653.l9I6rPrl030440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59059 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760655AbXJRHhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs: use kmem_cache_zalloc instead
has been removed from the -mm tree.  Its filename was
     fs-use-kmem_cache_zalloc-instead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: use kmem_cache_zalloc instead
From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/file_table.c~fs-use-kmem_cache_zalloc-instead fs/file_table.c
--- a/fs/file_table.c~fs-use-kmem_cache_zalloc-instead
+++ a/fs/file_table.c
@@ -102,12 +102,11 @@ struct file *get_empty_filp(void)
 			goto over;
 	}
 
-	f = kmem_cache_alloc(filp_cachep, GFP_KERNEL);
+	f = kmem_cache_zalloc(filp_cachep, GFP_KERNEL);
 	if (f == NULL)
 		goto fail;
 
 	percpu_counter_inc(&nr_files);
-	memset(f, 0, sizeof(*f));
 	if (security_file_alloc(f))
 		goto fail_sec;
 
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch

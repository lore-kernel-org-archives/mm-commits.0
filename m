From: akpm@linux-foundation.org
Subject: + fs-use-kmem_cache_zalloc-instead.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:30:30 -0700
Message-ID: <200707202130.l6KLUUjs017411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763292AbXGTVaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:30:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com


The patch titled
     fs: use kmem_cache_zalloc instead
has been added to the -mm tree.  Its filename is
     fs-use-kmem_cache_zalloc-instead.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs: use kmem_cache_zalloc instead
From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

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
drivers-net-cxgb3-remove-several-unneeded-zero-initialization.patch
nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable.patch
nbd-change-a-parameters-type-to-remove-a-memcpy-call.patch
fs-use-kmem_cache_zalloc-instead.patch

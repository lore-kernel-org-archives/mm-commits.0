From: akpm@linux-foundation.org
Subject: [merged] kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:16 -0800
Message-ID: <20130228201216.BEE105A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:38292 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab3B1UMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:17 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so245094yen.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com, horms@verge.net.au, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: fix memory leak in function kimage_normal_alloc
has been removed from the -mm tree.  Its filename was
     kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: kexec: fix memory leak in function kimage_normal_alloc

If kimage_normal_alloc() fails to alloc pages for image->swap_page, it
should call kimage_free_page_list() to free allocated pages in
image->control_pages list before it frees image.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN kernel/kexec.c~kexec-fix-memory-leak-in-function-kimage_normal_alloc kernel/kexec.c
--- a/kernel/kexec.c~kexec-fix-memory-leak-in-function-kimage_normal_alloc
+++ a/kernel/kexec.c
@@ -229,6 +229,8 @@ out:
 
 }
 
+static void kimage_free_page_list(struct list_head *list);
+
 static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
 				unsigned long nr_segments,
 				struct kexec_segment __user *segments)
@@ -252,22 +254,22 @@ static int kimage_normal_alloc(struct ki
 					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
 		printk(KERN_ERR "Could not allocate control_code_buffer\n");
-		goto out;
+		goto out_free;
 	}
 
 	image->swap_page = kimage_alloc_control_pages(image, 0);
 	if (!image->swap_page) {
 		printk(KERN_ERR "Could not allocate swap buffer\n");
-		goto out;
+		goto out_free;
 	}
 
-	result = 0;
- out:
-	if (result == 0)
-		*rimage = image;
-	else
-		kfree(image);
+	*rimage = image;
+	return 0;
 
+out_free:
+	kimage_free_page_list(&image->control_pages);
+	kfree(image);
+out:
 	return result;
 }
 
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch


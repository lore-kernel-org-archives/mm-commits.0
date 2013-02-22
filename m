From: akpm@linux-foundation.org
Subject: + kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch added to -mm tree
Date: Fri, 22 Feb 2013 13:59:44 -0800
Message-ID: <20130222215944.9FDEC5A4253@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:56988 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab3BVV7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 16:59:46 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so111814vbi.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 13:59:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com, sasha.levin@oracle.com


The patch titled
     Subject: kexec: fix memory leak in function kimage_normal_alloc
has been added to the -mm tree.  Its filename is
     kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: kexec: fix memory leak in function kimage_normal_alloc

If kimage_normal_alloc() fails to alloc pages for image->swap_page, it
should call kimage_free_page_list() to free allocated pages in
image->control_pages list before it frees image.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
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
mm-fix-return-type-for-functions-nr_free__pages.patch
ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch
fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch
fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch
vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch
net-change-type-of-virtio_chan-p9_max_pages.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch
kexec-prevent-double-free-on-image-allocation-failure.patch
kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch


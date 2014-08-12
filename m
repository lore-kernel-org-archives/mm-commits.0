From: akpm@linux-foundation.org
Subject: [merged]
 kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:49 -0700
Message-ID: <53ea6e75.aLKsy4ehAUqzUmvZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:33481 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaHLTnu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:50 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2671314pab.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: use common function for kimage_normal_alloc() and kimage_crash_alloc()
has been removed from the -mm tree.  Its filename was
     kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec: use common function for kimage_normal_alloc() and kimage_crash_alloc()

kimage_normal_alloc() and kimage_crash_alloc() are doing lot of similar
things and differ only little.  So instead of having two separate
functions create a common function kimage_alloc_init() and pass it the
"flags" argument which tells whether it is normal kexec or kexec_on_panic.
 And this function should be able to deal with both the cases.

This consolidation also helps later where we can use a common function
kimage_file_alloc_init() to handle normal and crash cases for new file
based kexec syscall.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |  105 +++++++++++++++--------------------------------
 1 file changed, 34 insertions(+), 71 deletions(-)

diff -puN kernel/kexec.c~kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc kernel/kexec.c
--- a/kernel/kexec.c~kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc
+++ a/kernel/kexec.c
@@ -261,12 +261,20 @@ static struct kimage *do_kimage_alloc_in
 
 static void kimage_free_page_list(struct list_head *list);
 
-static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
-				unsigned long nr_segments,
-				struct kexec_segment __user *segments)
+static int kimage_alloc_init(struct kimage **rimage, unsigned long entry,
+			     unsigned long nr_segments,
+			     struct kexec_segment __user *segments,
+			     unsigned long flags)
 {
-	int result;
+	int ret;
 	struct kimage *image;
+	bool kexec_on_panic = flags & KEXEC_ON_CRASH;
+
+	if (kexec_on_panic) {
+		/* Verify we have a valid entry point */
+		if ((entry < crashk_res.start) || (entry > crashk_res.end))
+			return -EADDRNOTAVAIL;
+	}
 
 	/* Allocate and initialize a controlling structure */
 	image = do_kimage_alloc_init();
@@ -275,20 +283,26 @@ static int kimage_normal_alloc(struct ki
 
 	image->start = entry;
 
-	result = copy_user_segment_list(image, nr_segments, segments);
-	if (result)
+	ret = copy_user_segment_list(image, nr_segments, segments);
+	if (ret)
 		goto out_free_image;
 
-	result = sanity_check_segment_list(image);
-	if (result)
+	ret = sanity_check_segment_list(image);
+	if (ret)
 		goto out_free_image;
 
+	 /* Enable the special crash kernel control page allocation policy. */
+	if (kexec_on_panic) {
+		image->control_page = crashk_res.start;
+		image->type = KEXEC_TYPE_CRASH;
+	}
+
 	/*
 	 * Find a location for the control code buffer, and add it
 	 * the vector of segments so that it's pages will also be
 	 * counted as destination pages.
 	 */
-	result = -ENOMEM;
+	ret = -ENOMEM;
 	image->control_code_page = kimage_alloc_control_pages(image,
 					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
@@ -296,10 +310,12 @@ static int kimage_normal_alloc(struct ki
 		goto out_free_image;
 	}
 
-	image->swap_page = kimage_alloc_control_pages(image, 0);
-	if (!image->swap_page) {
-		pr_err("Could not allocate swap buffer\n");
-		goto out_free_control_pages;
+	if (!kexec_on_panic) {
+		image->swap_page = kimage_alloc_control_pages(image, 0);
+		if (!image->swap_page) {
+			pr_err("Could not allocate swap buffer\n");
+			goto out_free_control_pages;
+		}
 	}
 
 	*rimage = image;
@@ -308,60 +324,7 @@ out_free_control_pages:
 	kimage_free_page_list(&image->control_pages);
 out_free_image:
 	kfree(image);
-	return result;
-}
-
-static int kimage_crash_alloc(struct kimage **rimage, unsigned long entry,
-				unsigned long nr_segments,
-				struct kexec_segment __user *segments)
-{
-	int result;
-	struct kimage *image;
-
-	/* Verify we have a valid entry point */
-	if ((entry < crashk_res.start) || (entry > crashk_res.end))
-		return -EADDRNOTAVAIL;
-
-	/* Allocate and initialize a controlling structure */
-	image = do_kimage_alloc_init();
-	if (!image)
-		return -ENOMEM;
-
-	image->start = entry;
-
-	/* Enable the special crash kernel control page
-	 * allocation policy.
-	 */
-	image->control_page = crashk_res.start;
-	image->type = KEXEC_TYPE_CRASH;
-
-	result = copy_user_segment_list(image, nr_segments, segments);
-	if (result)
-		goto out_free_image;
-
-	result = sanity_check_segment_list(image);
-	if (result)
-		goto out_free_image;
-
-	/*
-	 * Find a location for the control code buffer, and add
-	 * the vector of segments so that it's pages will also be
-	 * counted as destination pages.
-	 */
-	result = -ENOMEM;
-	image->control_code_page = kimage_alloc_control_pages(image,
-					   get_order(KEXEC_CONTROL_PAGE_SIZE));
-	if (!image->control_code_page) {
-		pr_err("Could not allocate control_code_buffer\n");
-		goto out_free_image;
-	}
-
-	*rimage = image;
-	return 0;
-
-out_free_image:
-	kfree(image);
-	return result;
+	return ret;
 }
 
 static int kimage_is_destination_range(struct kimage *image,
@@ -1004,16 +967,16 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 
 		/* Loading another kernel to reboot into */
 		if ((flags & KEXEC_ON_CRASH) == 0)
-			result = kimage_normal_alloc(&image, entry,
-							nr_segments, segments);
+			result = kimage_alloc_init(&image, entry, nr_segments,
+						   segments, flags);
 		/* Loading another kernel to switch to if this one crashes */
 		else if (flags & KEXEC_ON_CRASH) {
 			/* Free any current crash dump kernel before
 			 * we corrupt it.
 			 */
 			kimage_free(xchg(&kexec_crash_image, NULL));
-			result = kimage_crash_alloc(&image, entry,
-						     nr_segments, segments);
+			result = kimage_alloc_init(&image, entry, nr_segments,
+						   segments, flags);
 			crash_map_reserved_pages();
 		}
 		if (result)
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch


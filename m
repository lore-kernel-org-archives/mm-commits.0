From: akpm@linux-foundation.org
Subject: [merged]
 kexec-move-segment-verification-code-in-a-separate-function.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:43:47 -0700
Message-ID: <53ea6e73.MFNGK/kU9iYjDMCT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:37382 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaHLTns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:48 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so1069795igd.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: move segment verification code in a separate function
has been removed from the -mm tree.  Its filename was
     kexec-move-segment-verification-code-in-a-separate-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec: move segment verification code in a separate function

Previously do_kimage_alloc() will allocate a kimage structure, copy
segment list from user space and then do the segment list sanity
verification.

Break down this function in 3 parts.  do_kimage_alloc_init() to do actual
allocation and basic initialization of kimage structure. 
copy_user_segment_list() to copy segment list from user space and
sanity_check_segment_list() to verify the sanity of segment list as passed
by user space.

In later patches, I need to only allocate kimage and not copy segment list
from user space.  So breaking down in smaller functions enables re-use of
code at other places.

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

 kernel/kexec.c |  182 +++++++++++++++++++++++++----------------------
 1 file changed, 100 insertions(+), 82 deletions(-)

diff -puN kernel/kexec.c~kexec-move-segment-verification-code-in-a-separate-function kernel/kexec.c
--- a/kernel/kexec.c~kexec-move-segment-verification-code-in-a-separate-function
+++ a/kernel/kexec.c
@@ -125,45 +125,27 @@ static struct page *kimage_alloc_page(st
 				       gfp_t gfp_mask,
 				       unsigned long dest);
 
-static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
-			   unsigned long nr_segments,
-			   struct kexec_segment __user *segments)
+static int copy_user_segment_list(struct kimage *image,
+				  unsigned long nr_segments,
+				  struct kexec_segment __user *segments)
 {
+	int ret;
 	size_t segment_bytes;
-	struct kimage *image;
-	unsigned long i;
-	int result;
-
-	/* Allocate a controlling structure */
-	result = -ENOMEM;
-	image = kzalloc(sizeof(*image), GFP_KERNEL);
-	if (!image)
-		goto out;
-
-	image->head = 0;
-	image->entry = &image->head;
-	image->last_entry = &image->head;
-	image->control_page = ~0; /* By default this does not apply */
-	image->start = entry;
-	image->type = KEXEC_TYPE_DEFAULT;
-
-	/* Initialize the list of control pages */
-	INIT_LIST_HEAD(&image->control_pages);
-
-	/* Initialize the list of destination pages */
-	INIT_LIST_HEAD(&image->dest_pages);
-
-	/* Initialize the list of unusable pages */
-	INIT_LIST_HEAD(&image->unusable_pages);
 
 	/* Read in the segments */
 	image->nr_segments = nr_segments;
 	segment_bytes = nr_segments * sizeof(*segments);
-	result = copy_from_user(image->segment, segments, segment_bytes);
-	if (result) {
-		result = -EFAULT;
-		goto out;
-	}
+	ret = copy_from_user(image->segment, segments, segment_bytes);
+	if (ret)
+		ret = -EFAULT;
+
+	return ret;
+}
+
+static int sanity_check_segment_list(struct kimage *image)
+{
+	int result, i;
+	unsigned long nr_segments = image->nr_segments;
 
 	/*
 	 * Verify we have good destination addresses.  The caller is
@@ -185,9 +167,9 @@ static int do_kimage_alloc(struct kimage
 		mstart = image->segment[i].mem;
 		mend   = mstart + image->segment[i].memsz;
 		if ((mstart & ~PAGE_MASK) || (mend & ~PAGE_MASK))
-			goto out;
+			return result;
 		if (mend >= KEXEC_DESTINATION_MEMORY_LIMIT)
-			goto out;
+			return result;
 	}
 
 	/* Verify our destination addresses do not overlap.
@@ -208,7 +190,7 @@ static int do_kimage_alloc(struct kimage
 			pend   = pstart + image->segment[j].memsz;
 			/* Do the segments overlap ? */
 			if ((mend > pstart) && (mstart < pend))
-				goto out;
+				return result;
 		}
 	}
 
@@ -220,18 +202,61 @@ static int do_kimage_alloc(struct kimage
 	result = -EINVAL;
 	for (i = 0; i < nr_segments; i++) {
 		if (image->segment[i].bufsz > image->segment[i].memsz)
-			goto out;
+			return result;
+	}
+
+	/*
+	 * Verify we have good destination addresses.  Normally
+	 * the caller is responsible for making certain we don't
+	 * attempt to load the new image into invalid or reserved
+	 * areas of RAM.  But crash kernels are preloaded into a
+	 * reserved area of ram.  We must ensure the addresses
+	 * are in the reserved area otherwise preloading the
+	 * kernel could corrupt things.
+	 */
+
+	if (image->type == KEXEC_TYPE_CRASH) {
+		result = -EADDRNOTAVAIL;
+		for (i = 0; i < nr_segments; i++) {
+			unsigned long mstart, mend;
+
+			mstart = image->segment[i].mem;
+			mend = mstart + image->segment[i].memsz - 1;
+			/* Ensure we are within the crash kernel limits */
+			if ((mstart < crashk_res.start) ||
+			    (mend > crashk_res.end))
+				return result;
+		}
 	}
 
-	result = 0;
-out:
-	if (result == 0)
-		*rimage = image;
-	else
-		kfree(image);
+	return 0;
+}
 
-	return result;
+static struct kimage *do_kimage_alloc_init(void)
+{
+	struct kimage *image;
 
+	/* Allocate a controlling structure */
+	image = kzalloc(sizeof(*image), GFP_KERNEL);
+	if (!image)
+		return NULL;
+
+	image->head = 0;
+	image->entry = &image->head;
+	image->last_entry = &image->head;
+	image->control_page = ~0; /* By default this does not apply */
+	image->type = KEXEC_TYPE_DEFAULT;
+
+	/* Initialize the list of control pages */
+	INIT_LIST_HEAD(&image->control_pages);
+
+	/* Initialize the list of destination pages */
+	INIT_LIST_HEAD(&image->dest_pages);
+
+	/* Initialize the list of unusable pages */
+	INIT_LIST_HEAD(&image->unusable_pages);
+
+	return image;
 }
 
 static void kimage_free_page_list(struct list_head *list);
@@ -244,10 +269,19 @@ static int kimage_normal_alloc(struct ki
 	struct kimage *image;
 
 	/* Allocate and initialize a controlling structure */
-	image = NULL;
-	result = do_kimage_alloc(&image, entry, nr_segments, segments);
+	image = do_kimage_alloc_init();
+	if (!image)
+		return -ENOMEM;
+
+	image->start = entry;
+
+	result = copy_user_segment_list(image, nr_segments, segments);
+	if (result)
+		goto out_free_image;
+
+	result = sanity_check_segment_list(image);
 	if (result)
-		goto out;
+		goto out_free_image;
 
 	/*
 	 * Find a location for the control code buffer, and add it
@@ -259,22 +293,21 @@ static int kimage_normal_alloc(struct ki
 					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
 		pr_err("Could not allocate control_code_buffer\n");
-		goto out_free;
+		goto out_free_image;
 	}
 
 	image->swap_page = kimage_alloc_control_pages(image, 0);
 	if (!image->swap_page) {
 		pr_err("Could not allocate swap buffer\n");
-		goto out_free;
+		goto out_free_control_pages;
 	}
 
 	*rimage = image;
 	return 0;
-
-out_free:
+out_free_control_pages:
 	kimage_free_page_list(&image->control_pages);
+out_free_image:
 	kfree(image);
-out:
 	return result;
 }
 
@@ -284,19 +317,17 @@ static int kimage_crash_alloc(struct kim
 {
 	int result;
 	struct kimage *image;
-	unsigned long i;
 
-	image = NULL;
 	/* Verify we have a valid entry point */
-	if ((entry < crashk_res.start) || (entry > crashk_res.end)) {
-		result = -EADDRNOTAVAIL;
-		goto out;
-	}
+	if ((entry < crashk_res.start) || (entry > crashk_res.end))
+		return -EADDRNOTAVAIL;
 
 	/* Allocate and initialize a controlling structure */
-	result = do_kimage_alloc(&image, entry, nr_segments, segments);
-	if (result)
-		goto out;
+	image = do_kimage_alloc_init();
+	if (!image)
+		return -ENOMEM;
+
+	image->start = entry;
 
 	/* Enable the special crash kernel control page
 	 * allocation policy.
@@ -304,25 +335,13 @@ static int kimage_crash_alloc(struct kim
 	image->control_page = crashk_res.start;
 	image->type = KEXEC_TYPE_CRASH;
 
-	/*
-	 * Verify we have good destination addresses.  Normally
-	 * the caller is responsible for making certain we don't
-	 * attempt to load the new image into invalid or reserved
-	 * areas of RAM.  But crash kernels are preloaded into a
-	 * reserved area of ram.  We must ensure the addresses
-	 * are in the reserved area otherwise preloading the
-	 * kernel could corrupt things.
-	 */
-	result = -EADDRNOTAVAIL;
-	for (i = 0; i < nr_segments; i++) {
-		unsigned long mstart, mend;
+	result = copy_user_segment_list(image, nr_segments, segments);
+	if (result)
+		goto out_free_image;
 
-		mstart = image->segment[i].mem;
-		mend = mstart + image->segment[i].memsz - 1;
-		/* Ensure we are within the crash kernel limits */
-		if ((mstart < crashk_res.start) || (mend > crashk_res.end))
-			goto out_free;
-	}
+	result = sanity_check_segment_list(image);
+	if (result)
+		goto out_free_image;
 
 	/*
 	 * Find a location for the control code buffer, and add
@@ -334,15 +353,14 @@ static int kimage_crash_alloc(struct kim
 					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
 		pr_err("Could not allocate control_code_buffer\n");
-		goto out_free;
+		goto out_free_image;
 	}
 
 	*rimage = image;
 	return 0;
 
-out_free:
+out_free_image:
 	kfree(image);
-out:
 	return result;
 }
 
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch


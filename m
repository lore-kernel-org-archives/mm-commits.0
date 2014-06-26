From: akpm@linux-foundation.org
Subject: +
 kexec-move-segment-verification-code-in-a-separate-function.patch added to
 -mm tree
Date: Thu, 26 Jun 2014 14:08:46 -0700
Message-ID: <53ac8bde.enrWgpef7xT5FsoK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaFZVIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 17:08:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: move segment verification code in a separate function
has been added to the -mm tree.  Its filename is
     kexec-move-segment-verification-code-in-a-separate-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-move-segment-verification-code-in-a-separate-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-move-segment-verification-code-in-a-separate-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -124,45 +124,27 @@ static struct page *kimage_alloc_page(st
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
@@ -184,9 +166,9 @@ static int do_kimage_alloc(struct kimage
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
@@ -207,7 +189,7 @@ static int do_kimage_alloc(struct kimage
 			pend   = pstart + image->segment[j].memsz;
 			/* Do the segments overlap ? */
 			if ((mend > pstart) && (mstart < pend))
-				goto out;
+				return result;
 		}
 	}
 
@@ -219,18 +201,61 @@ static int do_kimage_alloc(struct kimage
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
@@ -243,10 +268,19 @@ static int kimage_normal_alloc(struct ki
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
@@ -258,22 +292,21 @@ static int kimage_normal_alloc(struct ki
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
 
@@ -283,19 +316,17 @@ static int kimage_crash_alloc(struct kim
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
@@ -303,25 +334,13 @@ static int kimage_crash_alloc(struct kim
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
@@ -333,15 +352,14 @@ static int kimage_crash_alloc(struct kim
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
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-kexec-kdump-on-efi-systems.patch
linux-next.patch


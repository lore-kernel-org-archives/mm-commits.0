From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix.patch
 removed from -mm tree
Date: Fri, 08 Aug 2014 14:03:23 -0700
Message-ID: <53e53b1b.dIssUHiXRAYEBL2M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:53953 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494AbaHHVDY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 17:03:24 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so812576qap.0
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 14:03:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: fix freeing up for image loader data loading
has been removed from the -mm tree.  Its filename was
     kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix.patch

This patch was dropped because it was folded into kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec: fix freeing up for image loader data loading

During testing I noticed a crash. Which in turn showed that there are
problems with how I am freeing up image->image_loader_data.

In one case I am freeing up kimage->image_loader_data first and then
calling up arch to free up which might have been contained in that
structure. That's wrong.

I have done little cleanup and this should fix the issues around
freeing up of loader data.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kexec-bzimage64.c  |    4 ++--
 arch/x86/kernel/machine_kexec_64.c |    2 +-
 include/linux/kexec.h              |    2 +-
 kernel/kexec.c                     |   11 ++++++++---
 4 files changed, 12 insertions(+), 7 deletions(-)

diff -puN arch/x86/kernel/kexec-bzimage64.c~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix arch/x86/kernel/kexec-bzimage64.c
--- a/arch/x86/kernel/kexec-bzimage64.c~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -355,9 +355,9 @@ out_free_params:
 }
 
 /* This cleanup function is called after various segments have been loaded */
-int bzImage64_cleanup(struct kimage *image)
+int bzImage64_cleanup(void *loader_data)
 {
-	struct bzimage64_data *ldata = image->image_loader_data;
+	struct bzimage64_data *ldata = loader_data;
 
 	if (!ldata)
 		return 0;
diff -puN arch/x86/kernel/machine_kexec_64.c~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -329,7 +329,7 @@ int arch_kimage_file_post_load_cleanup(s
 	if (!image->fops || !image->fops->cleanup)
 		return 0;
 
-	return image->fops->cleanup(image);
+	return image->fops->cleanup(image->image_loader_data);
 }
 
 /*
diff -puN include/linux/kexec.h~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix
+++ a/include/linux/kexec.h
@@ -190,7 +190,7 @@ typedef void *(kexec_load_t)(struct kima
 			     unsigned long kernel_len, char *initrd,
 			     unsigned long initrd_len, char *cmdline,
 			     unsigned long cmdline_len);
-typedef int (kexec_cleanup_t)(struct kimage *image);
+typedef int (kexec_cleanup_t)(void *loader_data);
 
 struct kexec_file_ops {
 	kexec_probe_t *probe;
diff -puN kernel/kexec.c~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix kernel/kexec.c
--- a/kernel/kexec.c~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix
+++ a/kernel/kexec.c
@@ -460,6 +460,14 @@ static void kimage_file_post_load_cleanu
 
 	/* See if architecture has anything to cleanup post load */
 	arch_kimage_file_post_load_cleanup(image);
+
+	/*
+	 * Above call should have called into bootloader to free up
+	 * any data stored in kimage->image_loader_data. It should
+	 * be ok now to free it up.
+	 */
+	kfree(image->image_loader_data);
+	image->image_loader_data = NULL;
 }
 
 /*
@@ -576,7 +584,6 @@ out_free_control_pages:
 	kimage_free_page_list(&image->control_pages);
 out_free_post_load_bufs:
 	kimage_file_post_load_cleanup(image);
-	kfree(image->image_loader_data);
 out_free_image:
 	kfree(image);
 	return ret;
@@ -900,8 +907,6 @@ static void kimage_free(struct kimage *i
 	/* Free the kexec control pages... */
 	kimage_free_page_list(&image->control_pages);
 
-	kfree(image->image_loader_data);
-
 	/*
 	 * Free up any temporary buffers allocated. This might hit if
 	 * error occurred much later after buffer allocation.
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
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
kexec-support-for-kexec-on-panic-using-new-system-call-fix.patch
kexec-support-kexec-kdump-on-efi-systems.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
kexec-verify-the-signature-of-signed-pe-bzimage.patch


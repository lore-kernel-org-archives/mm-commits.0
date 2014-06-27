From: akpm@linux-foundation.org
Subject: +
 kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix.patch
 added to -mm tree
Date: Fri, 27 Jun 2014 11:28:21 -0700
Message-ID: <53adb7c5.pOkHCZczPeoRP1M8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pb0-f74.google.com ([209.85.160.74]:47978 "EHLO
	mail-pb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaF0S2W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jun 2014 14:28:22 -0400
Received: by mail-pb0-f74.google.com with SMTP id rq2so747295pbb.5
        for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2014 11:28:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: fix freeing up for image loader data loading
has been added to the -mm tree.  Its filename is
     kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix.patch

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
@@ -453,6 +453,14 @@ static void kimage_file_post_load_cleanu
 
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
@@ -569,7 +577,6 @@ out_free_control_pages:
 	kimage_free_page_list(&image->control_pages);
 out_free_post_load_bufs:
 	kimage_file_post_load_cleanup(image);
-	kfree(image->image_loader_data);
 out_free_image:
 	kfree(image);
 	return ret;
@@ -893,8 +900,6 @@ static void kimage_free(struct kimage *i
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
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-kexec-kdump-on-efi-systems.patch


From: akpm@linux-foundation.org
Subject: + kexec-rename-unusebale_pages-to-unusable_pages.patch added to
 -mm tree
Date: Thu, 26 Jun 2014 14:08:44 -0700
Message-ID: <53ac8bdc.9p42S5efSQ7Gj5XF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaFZVIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 17:08:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: rename unusebale_pages to unusable_pages
has been added to the -mm tree.  Its filename is
     kexec-rename-unusebale_pages-to-unusable_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-rename-unusebale_pages-to-unusable_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-rename-unusebale_pages-to-unusable_pages.patch

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
Subject: kexec: rename unusebale_pages to unusable_pages

Let's use the more common "unusable".

This patch was originally written and posted by Boris. I am including it
in this patch series.

Signed-off-by: Borislav Petkov <bp@suse.de>
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

 include/linux/kexec.h |    2 +-
 kernel/kexec.c        |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/kexec.h~kexec-rename-unusebale_pages-to-unusable_pages include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-rename-unusebale_pages-to-unusable_pages
+++ a/include/linux/kexec.h
@@ -100,7 +100,7 @@ struct kimage {
 
 	struct list_head control_pages;
 	struct list_head dest_pages;
-	struct list_head unuseable_pages;
+	struct list_head unusable_pages;
 
 	/* Address of next control page to allocate for crash kernels. */
 	unsigned long control_page;
diff -puN kernel/kexec.c~kexec-rename-unusebale_pages-to-unusable_pages kernel/kexec.c
--- a/kernel/kexec.c~kexec-rename-unusebale_pages-to-unusable_pages
+++ a/kernel/kexec.c
@@ -153,7 +153,7 @@ static int do_kimage_alloc(struct kimage
 	INIT_LIST_HEAD(&image->dest_pages);
 
 	/* Initialize the list of unusable pages */
-	INIT_LIST_HEAD(&image->unuseable_pages);
+	INIT_LIST_HEAD(&image->unusable_pages);
 
 	/* Read in the segments */
 	image->nr_segments = nr_segments;
@@ -608,7 +608,7 @@ static void kimage_free_extra_pages(stru
 	kimage_free_page_list(&image->dest_pages);
 
 	/* Walk through and free any unusable pages I have cached */
-	kimage_free_page_list(&image->unuseable_pages);
+	kimage_free_page_list(&image->unusable_pages);
 
 }
 static void kimage_terminate(struct kimage *image)
@@ -731,7 +731,7 @@ static struct page *kimage_alloc_page(st
 		/* If the page cannot be used file it away */
 		if (page_to_pfn(page) >
 				(KEXEC_SOURCE_MEMORY_LIMIT >> PAGE_SHIFT)) {
-			list_add(&page->lru, &image->unuseable_pages);
+			list_add(&page->lru, &image->unusable_pages);
 			continue;
 		}
 		addr = page_to_pfn(page) << PAGE_SHIFT;
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


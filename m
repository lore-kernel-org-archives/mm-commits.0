From: akpm@linux-foundation.org
Subject: [merged] kexec-rename-unusebale_pages-to-unusable_pages.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:45 -0700
Message-ID: <53ea6e71.gqePMeQqbzltDCMN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:54391 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbaHLTnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:46 -0400
Received: by mail-qg0-f74.google.com with SMTP id z60so1311451qgd.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: rename unusebale_pages to unusable_pages
has been removed from the -mm tree.  Its filename was
     kexec-rename-unusebale_pages-to-unusable_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -154,7 +154,7 @@ static int do_kimage_alloc(struct kimage
 	INIT_LIST_HEAD(&image->dest_pages);
 
 	/* Initialize the list of unusable pages */
-	INIT_LIST_HEAD(&image->unuseable_pages);
+	INIT_LIST_HEAD(&image->unusable_pages);
 
 	/* Read in the segments */
 	image->nr_segments = nr_segments;
@@ -609,7 +609,7 @@ static void kimage_free_extra_pages(stru
 	kimage_free_page_list(&image->dest_pages);
 
 	/* Walk through and free any unusable pages I have cached */
-	kimage_free_page_list(&image->unuseable_pages);
+	kimage_free_page_list(&image->unusable_pages);
 
 }
 static void kimage_terminate(struct kimage *image)
@@ -732,7 +732,7 @@ static struct page *kimage_alloc_page(st
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


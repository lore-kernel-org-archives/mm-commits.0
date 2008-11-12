From: akpm@linux-foundation.org
Subject: + hibernate-do-not-oops-on-resume-if-image-data-are-incorrect.patch added to -mm tree
Date: Wed, 12 Nov 2008 14:45:09 -0800
Message-ID: <200811122245.mACMjAn5001111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbYKLWpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 17:45:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, lenb@kernel.org, pavel@suse.cz


The patch titled
     hibernate: do not oops on resume if image data are incorrect
has been added to the -mm tree.  Its filename is
     hibernate-do-not-oops-on-resume-if-image-data-are-incorrect.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hibernate: do not oops on resume if image data are incorrect
From: Rafael J. Wysocki <rjw@sisk.pl>

During resume from hibernation using the userland interface image data are
being passed from the used space process to the kernel.  These data need
not be valid, but currently the kernel sometimes oopses if it gets invalid
image data, which is wrong.  Make the kernel return error codes to the
user space in such cases.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |   43 ++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff -puN kernel/power/snapshot.c~hibernate-do-not-oops-on-resume-if-image-data-are-incorrect kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~hibernate-do-not-oops-on-resume-if-image-data-are-incorrect
+++ a/kernel/power/snapshot.c
@@ -529,6 +529,14 @@ static int memory_bm_test_bit(struct mem
 	return test_bit(bit, addr);
 }
 
+static bool memory_bm_pfn_present(struct memory_bitmap *bm, unsigned long pfn)
+{
+	void *addr;
+	unsigned int bit;
+
+	return !memory_bm_find_bit(bm, pfn, &addr, &bit);
+}
+
 /**
  *	memory_bm_next_pfn - find the pfn that corresponds to the next set bit
  *	in the bitmap @bm.  If the pfn cannot be found, BM_END_OF_MAP is
@@ -1466,9 +1474,7 @@ load_header(struct swsusp_info *info)
  *	unpack_orig_pfns - for each element of @buf[] (1 page at a time) set
  *	the corresponding bit in the memory bitmap @bm
  */
-
-static inline void
-unpack_orig_pfns(unsigned long *buf, struct memory_bitmap *bm)
+static int unpack_orig_pfns(unsigned long *buf, struct memory_bitmap *bm)
 {
 	int j;
 
@@ -1476,8 +1482,13 @@ unpack_orig_pfns(unsigned long *buf, str
 		if (unlikely(buf[j] == BM_END_OF_MAP))
 			break;
 
-		memory_bm_set_bit(bm, buf[j]);
+		if (memory_bm_pfn_present(bm, buf[j]))
+			memory_bm_set_bit(bm, buf[j]);
+		else
+			return -EFAULT;
 	}
+
+	return 0;
 }
 
 /* List of "safe" pages that may be used to store data loaded from the suspend
@@ -1615,7 +1626,7 @@ get_highmem_page_buffer(struct page *pag
 	pbe = chain_alloc(ca, sizeof(struct highmem_pbe));
 	if (!pbe) {
 		swsusp_free();
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	pbe->orig_page = page;
 	if (safe_highmem_pages > 0) {
@@ -1684,7 +1695,7 @@ prepare_highmem_image(struct memory_bitm
 static inline void *
 get_highmem_page_buffer(struct page *page, struct chain_allocator *ca)
 {
-	return NULL;
+	return ERR_PTR(-EINVAL);
 }
 
 static inline void copy_last_highmem_page(void) {}
@@ -1795,8 +1806,13 @@ prepare_image(struct memory_bitmap *new_
 static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
 {
 	struct pbe *pbe;
-	struct page *page = pfn_to_page(memory_bm_next_pfn(bm));
+	struct page *page;
+	unsigned long pfn = memory_bm_next_pfn(bm);
 
+	if (pfn == BM_END_OF_MAP)
+		return ERR_PTR(-EFAULT);
+
+	page = pfn_to_page(pfn);
 	if (PageHighMem(page))
 		return get_highmem_page_buffer(page, ca);
 
@@ -1812,7 +1828,7 @@ static void *get_buffer(struct memory_bi
 	pbe = chain_alloc(ca, sizeof(struct pbe));
 	if (!pbe) {
 		swsusp_free();
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	pbe->orig_address = page_address(page);
 	pbe->address = safe_pages_list;
@@ -1875,7 +1891,10 @@ int snapshot_write_next(struct snapshot_
 				return error;
 
 		} else if (handle->prev <= nr_meta_pages) {
-			unpack_orig_pfns(buffer, &copy_bm);
+			error = unpack_orig_pfns(buffer, &copy_bm);
+			if (error)
+				return error;
+
 			if (handle->prev == nr_meta_pages) {
 				error = prepare_image(&orig_bm, &copy_bm);
 				if (error)
@@ -1886,12 +1905,14 @@ int snapshot_write_next(struct snapshot_
 				restore_pblist = NULL;
 				handle->buffer = get_buffer(&orig_bm, &ca);
 				handle->sync_read = 0;
-				if (!handle->buffer)
-					return -ENOMEM;
+				if (IS_ERR(handle->buffer))
+					return PTR_ERR(handle->buffer);
 			}
 		} else {
 			copy_last_highmem_page();
 			handle->buffer = get_buffer(&orig_bm, &ca);
+			if (IS_ERR(handle->buffer))
+				return PTR_ERR(handle->buffer);
 			if (handle->buffer != buffer)
 				handle->sync_read = 0;
 		}
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
hibernate-take-overlapping-zones-into-account.patch
hibernate-do-not-oops-on-resume-if-image-data-are-incorrect.patch
e1000e-use-device_set_wakeup_enable.patch
e1000-use-device_set_wakeup_enable.patch
igb-use-device_set_wakeup_enable.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
shrink_slab-handle-bad-shrinkers.patch


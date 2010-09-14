From: akpm@linux-foundation.org
Subject: + use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages.patch added to -mm tree
Date: Tue, 14 Sep 2010 16:07:06 -0700
Message-ID: <201009142307.o8EN760N023844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755786Ab0INXHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 19:07:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, ebiederm@xmission.com, jbeulich@novell.com, miklos@szeredi.hu, rjw@sisk.pl


The patch titled
     use clear_page()/copy_page() in favor of memset()/memcpy() on whole pages
has been added to the -mm tree.  Its filename is
     use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages.patch

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
Subject: use clear_page()/copy_page() in favor of memset()/memcpy() on whole pages
From: "Jan Beulich" <JBeulich@novell.com>

After all that's what they are intended for.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c           |    2 +-
 kernel/kexec.c          |    2 +-
 kernel/power/snapshot.c |   14 +++++++-------
 kernel/power/swap.c     |    6 +++---
 mm/memory.c             |    2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff -puN fs/fuse/dev.c~use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages fs/fuse/dev.c
--- a/fs/fuse/dev.c~use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages
+++ a/fs/fuse/dev.c
@@ -811,7 +811,7 @@ static int fuse_copy_page(struct fuse_co
 
 	if (page && zeroing && count < PAGE_SIZE) {
 		void *mapaddr = kmap_atomic(page, KM_USER1);
-		memset(mapaddr, 0, PAGE_SIZE);
+		clear_page(mapaddr);
 		kunmap_atomic(mapaddr, KM_USER1);
 	}
 	while (count) {
diff -puN kernel/kexec.c~use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages kernel/kexec.c
--- a/kernel/kexec.c~use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages
+++ a/kernel/kexec.c
@@ -816,7 +816,7 @@ static int kimage_load_normal_segment(st
 
 		ptr = kmap(page);
 		/* Start with a clear page */
-		memset(ptr, 0, PAGE_SIZE);
+		clear_page(ptr);
 		ptr += maddr & ~PAGE_MASK;
 		mchunk = PAGE_SIZE - (maddr & ~PAGE_MASK);
 		if (mchunk > mbytes)
diff -puN kernel/power/snapshot.c~use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages
+++ a/kernel/power/snapshot.c
@@ -988,7 +988,7 @@ static void copy_data_page(unsigned long
 			 */
 			safe_copy_page(buffer, s_page);
 			dst = kmap_atomic(d_page, KM_USER0);
-			memcpy(dst, buffer, PAGE_SIZE);
+			copy_page(dst, buffer);
 			kunmap_atomic(dst, KM_USER0);
 		} else {
 			safe_copy_page(page_address(d_page), s_page);
@@ -1680,7 +1680,7 @@ int snapshot_read_next(struct snapshot_h
 		memory_bm_position_reset(&orig_bm);
 		memory_bm_position_reset(&copy_bm);
 	} else if (handle->cur <= nr_meta_pages) {
-		memset(buffer, 0, PAGE_SIZE);
+		clear_page(buffer);
 		pack_pfns(buffer, &orig_bm);
 	} else {
 		struct page *page;
@@ -1694,7 +1694,7 @@ int snapshot_read_next(struct snapshot_h
 			void *kaddr;
 
 			kaddr = kmap_atomic(page, KM_USER0);
-			memcpy(buffer, kaddr, PAGE_SIZE);
+			copy_page(buffer, kaddr);
 			kunmap_atomic(kaddr, KM_USER0);
 			handle->buffer = buffer;
 		} else {
@@ -1977,7 +1977,7 @@ static void copy_last_highmem_page(void)
 		void *dst;
 
 		dst = kmap_atomic(last_highmem_page, KM_USER0);
-		memcpy(dst, buffer, PAGE_SIZE);
+		copy_page(dst, buffer);
 		kunmap_atomic(dst, KM_USER0);
 		last_highmem_page = NULL;
 	}
@@ -2263,9 +2263,9 @@ swap_two_pages_data(struct page *p1, str
 
 	kaddr1 = kmap_atomic(p1, KM_USER0);
 	kaddr2 = kmap_atomic(p2, KM_USER1);
-	memcpy(buf, kaddr1, PAGE_SIZE);
-	memcpy(kaddr1, kaddr2, PAGE_SIZE);
-	memcpy(kaddr2, buf, PAGE_SIZE);
+	copy_page(buf, kaddr1);
+	copy_page(kaddr1, kaddr2);
+	copy_page(kaddr2, buf);
 	kunmap_atomic(kaddr1, KM_USER0);
 	kunmap_atomic(kaddr2, KM_USER1);
 }
diff -puN kernel/power/swap.c~use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages kernel/power/swap.c
--- a/kernel/power/swap.c~use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages
+++ a/kernel/power/swap.c
@@ -251,7 +251,7 @@ static int write_page(void *buf, sector_
 	if (bio_chain) {
 		src = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
 		if (src) {
-			memcpy(src, buf, PAGE_SIZE);
+			copy_page(src, buf);
 		} else {
 			WARN_ON_ONCE(1);
 			bio_chain = NULL;	/* Go synchronous */
@@ -325,7 +325,7 @@ static int swap_write_page(struct swap_m
 		error = write_page(handle->cur, handle->cur_swap, NULL);
 		if (error)
 			goto out;
-		memset(handle->cur, 0, PAGE_SIZE);
+		clear_page(handle->cur);
 		handle->cur_swap = offset;
 		handle->k = 0;
 	}
@@ -910,7 +910,7 @@ int swsusp_check(void)
 	hib_resume_bdev = open_by_devnum(swsusp_resume_device, FMODE_READ);
 	if (!IS_ERR(hib_resume_bdev)) {
 		set_blocksize(hib_resume_bdev, PAGE_SIZE);
-		memset(swsusp_header, 0, PAGE_SIZE);
+		clear_page(swsusp_header);
 		error = hib_bio_read_page(swsusp_resume_block,
 					swsusp_header, NULL);
 		if (error)
diff -puN mm/memory.c~use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages mm/memory.c
--- a/mm/memory.c~use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages
+++ a/mm/memory.c
@@ -2079,7 +2079,7 @@ static inline void cow_user_page(struct 
 		 * zeroes.
 		 */
 		if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE))
-			memset(kaddr, 0, PAGE_SIZE);
+			clear_page(kaddr);
 		kunmap_atomic(kaddr, KM_USER0);
 		flush_dcache_page(dst);
 	} else
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
x86-use-clear_page-copy_page-and-__gfp_zero-in-favor-of-memset-memcpy-on-whole-pages.patch
modules-no-need-to-align-modinfo-strings.patch
use-clear_page-copy_page-in-favor-of-memset-memcpy-on-whole-pages.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453A3E94104
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbjJFTUQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbjJFTUP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:20:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78359BE
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:20:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91828C433C8;
        Fri,  6 Oct 2023 19:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696620003;
        bh=FQehIu37dQU5g9tTE7qDvub9CfpgcXEFI+uDO1YtMs4=;
        h=Date:To:From:Subject:From;
        b=io42sfTTJ0dDhGEABAmY4tY068Rj2W/X7o9z0D+oQ4hHRe7PApYvusS4wwR2VWPHG
         qF85WQy2U5fCcx8IDtEUdzEV3FE5xDtXklquDNB5YhR1/2nVvRO8LMNUFiwwki5+U9
         3hYz6tjOYi2GZV9YUcEppBPHyRSz8dS9IbAjnaWQ=
Date:   Fri, 06 Oct 2023 12:20:00 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        mike.kravetz@oracle.com, kraxel@redhat.com,
        junxiao.chang@intel.com, jgg@nvidia.com, hughd@google.com,
        dongwon.kim@intel.com, david@redhat.com, daniel.vetter@ffwll.ch,
        vivek.kasireddy@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-introduce-pin_user_pages_fd-for-pinning-shmem-hugetlbfs-file-pages.patch added to mm-unstable branch
Message-Id: <20231006192002.91828C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: introduce pin_user_pages_fd() for pinning shmem/hugetlbfs file pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-introduce-pin_user_pages_fd-for-pinning-shmem-hugetlbfs-file-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-introduce-pin_user_pages_fd-for-pinning-shmem-hugetlbfs-file-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: mm/gup: introduce pin_user_pages_fd() for pinning shmem/hugetlbfs file pages
Date: Tue, 3 Oct 2023 00:44:45 -0700

Patch series "mm/gup: Introduce pin_user_pages_fd() for pinning
shmem/hugetlbfs file pages".

The first patch introduces pin_user_pages_fd() API and the second patch
shows how the udmabuf driver can use it to longterm-pin the the pages. 
The last patch adds two new udmabuf selftests to verify data coherency
after page migration.


This patch (of 3):

For drivers that would like to longterm-pin the pages associated with a
file, the pin_user_pages_fd() API provides an option to not only FOLL_PIN
the pages but also to check and migrate them if they reside in movable
zone or CMA block.  For now, this API can only work with files belonging
to shmem or hugetlbfs given that the udmabuf driver is the only user.

It must be noted that the pages associated with hugetlbfs files are
expected to be found in the page cache.  An error is returned if they are
not found.  However, shmem pages can be swapped in or allocated if they
are not present in the page cache.

Link: https://lkml.kernel.org/r/20231003074447.3245729-1-vivek.kasireddy@intel.com
Link: https://lkml.kernel.org/r/20231003074447.3245729-2-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 
 mm/gup.c           |   87 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

--- a/include/linux/mm.h~mm-gup-introduce-pin_user_pages_fd-for-pinning-shmem-hugetlbfs-file-pages
+++ a/include/linux/mm.h
@@ -2463,6 +2463,8 @@ long get_user_pages_unlocked(unsigned lo
 		    struct page **pages, unsigned int gup_flags);
 long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
+long pin_user_pages_fd(int fd, pgoff_t start, unsigned long nr_pages,
+		       unsigned int gup_flags, struct page **pages);
 
 int get_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages);
--- a/mm/gup.c~mm-gup-introduce-pin_user_pages_fd-for-pinning-shmem-hugetlbfs-file-pages
+++ a/mm/gup.c
@@ -3410,3 +3410,90 @@ long pin_user_pages_unlocked(unsigned lo
 				     &locked, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages_unlocked);
+
+/**
+ * pin_user_pages_fd() - pin user pages associated with a file
+ * @fd:         the fd whose pages are to be pinned
+ * @start:      starting file offset
+ * @nr_pages:   number of pages from start to pin
+ * @gup_flags:  flags modifying pin behaviour
+ * @pages:      array that receives pointers to the pages pinned.
+ *              Should be at least nr_pages long.
+ *
+ * Attempt to pin (and migrate) pages associated with a file belonging to
+ * either shmem or hugetlbfs. An error is returned if pages associated with
+ * hugetlbfs files are not present in the page cache. However, shmem pages
+ * are swapped in or allocated if they are not present in the page cache.
+ *
+ * Returns number of pages pinned. This would be equal to the number of
+ * pages requested.
+ * If nr_pages is 0 or negative, returns 0. If no pages were pinned, returns
+ * -errno.
+ */
+long pin_user_pages_fd(int fd, pgoff_t start, unsigned long nr_pages,
+		       unsigned int gup_flags, struct page **pages)
+{
+	struct page *page;
+	struct file *filep;
+	unsigned int flags, i;
+	long ret;
+
+	if (nr_pages <= 0)
+		return 0;
+	if (!is_valid_gup_args(pages, NULL, &gup_flags, FOLL_PIN))
+		return 0;
+
+	if (start < 0)
+		return -EINVAL;
+
+	filep = fget(fd);
+	if (!filep)
+	    return -EINVAL;
+
+	if (!shmem_file(filep) && !is_file_hugepages(filep))
+	    return -EINVAL;
+
+	flags = memalloc_pin_save();
+	do {
+		for (i = 0; i < nr_pages; i++) {
+			if (shmem_mapping(filep->f_mapping)) {
+				page = shmem_read_mapping_page(filep->f_mapping,
+							       start + i);
+				if (IS_ERR(page)) {
+					ret = PTR_ERR(page);
+					goto err;
+				}
+			} else {
+				page = find_get_page_flags(filep->f_mapping,
+							   start + i,
+							   FGP_ACCESSED);
+				if (!page) {
+					ret = -EINVAL;
+					goto err;
+				}
+			}
+			ret = try_grab_page(page, FOLL_PIN);
+			if (unlikely(ret))
+				goto err;
+
+			pages[i] = page;
+			put_page(pages[i]);
+		}
+
+		ret = check_and_migrate_movable_pages(nr_pages, pages);
+	} while (ret == -EAGAIN);
+
+err:
+	memalloc_pin_restore(flags);
+	fput(filep);
+	if (!ret)
+		return nr_pages;
+
+	while (i > 0 && pages[--i]) {
+		unpin_user_page(pages[i]);
+		pages[i] = NULL;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pin_user_pages_fd);
+
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are

mm-gup-introduce-pin_user_pages_fd-for-pinning-shmem-hugetlbfs-file-pages.patch
udmabuf-pin-the-pages-using-pin_user_pages_fd-api.patch
selftests-dma-buf-udmabuf-add-tests-to-verify-data-after-page-migration.patch


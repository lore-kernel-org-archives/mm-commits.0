Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 834CDCE7A9D
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 16:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjIYQL0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 12:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbjIYQLZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 12:11:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87681B8
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 09:11:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A3FC433C8;
        Mon, 25 Sep 2023 16:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695658278;
        bh=Gd2KrME3fKBX9MfJbe+tjCHKYfmFNrQgdd68t+yhSJs=;
        h=Date:To:From:Subject:From;
        b=fsce9BKwyk+XtrgrDrNN1cugzQnQ5RcWowHLUhzpPqN+B3chuKxK2OuE2ekUWNHay
         IUynNLBR95a3OT8Zf+7vG09xSHpvEKtfWizcX3cjSMktrtKKkuUSxcbZj0eT9ZUfm0
         YqlmM4doCUhuq2F9vENrIi9vouuuBVBAZQjgmBxk=
Date:   Mon, 25 Sep 2023 09:11:17 -0700
To:     mm-commits@vger.kernel.org, yun.zhou@windriver.com,
        willy@infradead.org, viro@zeniv.linux.org.uk, vbabka@suse.cz,
        surenb@google.com, shy828301@gmail.com, shuah@kernel.org,
        rppt@kernel.org, pgofman@codeweavers.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, namit@vmware.com,
        mirq-linux@rere.qmqm.pl, Liam.Howlett@oracle.com,
        gustavoars@kernel.org, gregkh@linuxfoundation.org,
        gorcunov@gmail.com, emmir@google.com, david@redhat.com,
        dan.j.williams@intel.com, brauner@kernel.org,
        axelrasmussen@google.com, avagin@gmail.com, alex.sierra@amd.com,
        usama.anjum@collabora.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-headers-uapi-update-linux-fsh-with-the-kernel-sources.patch added to mm-unstable branch
Message-Id: <20230925161118.18A3FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools headers UAPI: update linux/fs.h with the kernel sources
has been added to the -mm mm-unstable branch.  Its filename is
     tools-headers-uapi-update-linux-fsh-with-the-kernel-sources.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-headers-uapi-update-linux-fsh-with-the-kernel-sources.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: tools headers UAPI: update linux/fs.h with the kernel sources
Date: Mon, 21 Aug 2023 19:15:16 +0500

New IOCTL and macros has been added in the kernel sources. Update the
tools header file as well.

Link: https://lkml.kernel.org/r/20230821141518.870589-5-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Miroslaw <emmir@google.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul Gofman <pgofman@codeweavers.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yun Zhou <yun.zhou@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/uapi/linux/fs.h |   59 ++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

--- a/tools/include/uapi/linux/fs.h~tools-headers-uapi-update-linux-fsh-with-the-kernel-sources
+++ a/tools/include/uapi/linux/fs.h
@@ -305,4 +305,63 @@ typedef int __bitwise __kernel_rwf_t;
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
 			 RWF_APPEND)
 
+/* Pagemap ioctl */
+#define PAGEMAP_SCAN	_IOWR('f', 16, struct pm_scan_arg)
+
+/* Bitmasks provided in pm_scan_args masks and reported in page_region.categories. */
+#define PAGE_IS_WPALLOWED	(1 << 0)
+#define PAGE_IS_WRITTEN		(1 << 1)
+#define PAGE_IS_FILE		(1 << 2)
+#define PAGE_IS_PRESENT		(1 << 3)
+#define PAGE_IS_SWAPPED		(1 << 4)
+#define PAGE_IS_PFNZERO		(1 << 5)
+#define PAGE_IS_HUGE		(1 << 6)
+
+/*
+ * struct page_region - Page region with flags
+ * @start:	Start of the region
+ * @end:	End of the region (exclusive)
+ * @categories:	PAGE_IS_* category bitmask for the region
+ */
+struct page_region {
+	__u64 start;
+	__u64 end;
+	__u64 categories;
+};
+
+/* Flags for PAGEMAP_SCAN ioctl */
+#define PM_SCAN_WP_MATCHING	(1 << 0)	/* Write protect the pages matched. */
+#define PM_SCAN_CHECK_WPASYNC	(1 << 1)	/* Abort the scan when a non-WP-enabled page is found. */
+
+/*
+ * struct pm_scan_arg - Pagemap ioctl argument
+ * @size:		Size of the structure
+ * @flags:		Flags for the IOCTL
+ * @start:		Starting address of the region
+ * @end:		Ending address of the region
+ * @walk_end		Address where the scan stopped (written by kernel).
+ *			walk_end == end (address tags cleared) informs that the scan completed on entire range.
+ * @vec:		Address of page_region struct array for output
+ * @vec_len:		Length of the page_region struct array
+ * @max_pages:		Optional limit for number of returned pages (0 = disabled)
+ * @category_inverted:	PAGE_IS_* categories which values match if 0 instead of 1
+ * @category_mask:	Skip pages for which any category doesn't match
+ * @category_anyof_mask: Skip pages for which no category matches
+ * @return_mask:	PAGE_IS_* categories that are to be reported in `page_region`s returned
+ */
+struct pm_scan_arg {
+	__u64 size;
+	__u64 flags;
+	__u64 start;
+	__u64 end;
+	__u64 walk_end;
+	__u64 vec;
+	__u64 vec_len;
+	__u64 max_pages;
+	__u64 category_inverted;
+	__u64 category_mask;
+	__u64 category_anyof_mask;
+	__u64 return_mask;
+};
+
 #endif /* _UAPI_LINUX_FS_H */
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes.patch
tools-headers-uapi-update-linux-fsh-with-the-kernel-sources.patch
mm-pagemap-add-documentation-of-pagemap_scan-ioctl.patch
selftests-mm-add-pagemap-ioctl-tests.patch


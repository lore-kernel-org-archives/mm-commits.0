Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A75CDB484
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjJRVfc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbjJRVfa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1CF1B8
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F88AC433C7;
        Wed, 18 Oct 2023 21:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664896;
        bh=GmwqmppM4tF/ch2Ji4sRYlt7fC7eB6gvKJPGfUnMwaE=;
        h=Date:To:From:Subject:From;
        b=yRdg8dZIKVug0c6/oZDBjW0x6AVXGAIiy6tdYUkbNx+Mmym/PsiVUohBNOns9XKCZ
         n8CBKsKgkOc4Jw3M8bK1SB2grhxTkIIp1t5igRDtIIEDVMsdor7nubHudJA6f1Cp+5
         s/wpVb+p133fWM8CsobEuB7hGYpmS9+BehaMgoXU=
Date:   Wed, 18 Oct 2023 14:34:55 -0700
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
Subject: [merged mm-stable] tools-headers-uapi-update-linux-fsh-with-the-kernel-sources.patch removed from -mm tree
Message-Id: <20231018213456.2F88AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools headers UAPI: update linux/fs.h with the kernel sources
has been removed from the -mm tree.  Its filename was
     tools-headers-uapi-update-linux-fsh-with-the-kernel-sources.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



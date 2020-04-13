From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-replace-zero-length-array-with-flexible-array-member.patch added to -mm
 tree
Date: Mon, 13 Apr 2020 15:33:02 -0700
Message-ID: <20200413223302.JSM1HaXea%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389641AbgDMWdD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 18:33:03 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw, chenqiwu@xiaomi.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: replace zero-length array with flexible-array member
has been added to the -mm tree.  Its filename is
     mm-replace-zero-length-array-with-flexible-array-member.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-replace-zero-length-array-with-flexible-array-member.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-zero-length-array-with-flexible-array-member.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: chenqiwu <chenqiwu@xiaomi.com>
Subject: mm: replace zero-length array with flexible-array member

The current codebase makes use of the zero-length array language extension
to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning in
case the flexible array does not occur last in the structure, which will
help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by this
change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied.  As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Link: http://lkml.kernel.org/r/1586599916-15456-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h     |    2 +-
 include/linux/mmzone.h |    2 +-
 include/linux/swap.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-replace-zero-length-array-with-flexible-array-member
+++ a/include/linux/mm.h
@@ -1718,7 +1718,7 @@ struct frame_vector {
 	unsigned int nr_frames;	/* Number of frames stored in ptrs array */
 	bool got_ref;		/* Did we pin pages by getting page ref? */
 	bool is_pfns;		/* Does array contain pages or pfns? */
-	void *ptrs[0];		/* Array of pinned pfns / pages. Use
+	void *ptrs[];		/* Array of pinned pfns / pages. Use
 				 * pfns_vector_pages() or pfns_vector_pfns()
 				 * for access */
 };
--- a/include/linux/mmzone.h~mm-replace-zero-length-array-with-flexible-array-member
+++ a/include/linux/mmzone.h
@@ -1147,7 +1147,7 @@ struct mem_section_usage {
 	DECLARE_BITMAP(subsection_map, SUBSECTIONS_PER_SECTION);
 #endif
 	/* See declaration of similar field in struct zone */
-	unsigned long pageblock_flags[0];
+	unsigned long pageblock_flags[];
 };
 
 void subsection_map_init(unsigned long pfn, unsigned long nr_pages);
--- a/include/linux/swap.h~mm-replace-zero-length-array-with-flexible-array-member
+++ a/include/linux/swap.h
@@ -275,7 +275,7 @@ struct swap_info_struct {
 					 */
 	struct work_struct discard_work; /* discard worker */
 	struct swap_cluster_list discard_clusters; /* discard clusters list */
-	struct plist_node avail_lists[0]; /*
+	struct plist_node avail_lists[]; /*
 					   * entries in swap_avail_heads, one
 					   * entry per node.
 					   * Must be last as the number of the
_

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-swapfile-use-list_prevnext_entry-instead-of-open-coding.patch
mm-replace-zero-length-array-with-flexible-array-member.patch

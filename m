From: akpm@linux-foundation.org
Subject: + mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
 added to -mm tree
Date: Tue, 10 Jun 2014 15:43:00 -0700
Message-ID: <539789f4.TEpv2sXLfA4jENsN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFJWnB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 18:43:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, fabf@skynet.be

Subject: + mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch added to -mm tree
To: fabf@skynet.be,mgorman@suse.de
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 15:43:00 -0700


The patch titled
     Subject: mm/page_alloc.c: add __meminit to alloc_pages_exact_nid()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/page_alloc.c: add __meminit to alloc_pages_exact_nid()

alloc_pages_exact_nid() is only called by __meminit alloc_page_cgroup()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 mm/page_alloc.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid include/linux/gfp.h
--- a/include/linux/gfp.h~mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid
+++ a/include/linux/gfp.h
@@ -360,7 +360,7 @@ extern unsigned long get_zeroed_page(gfp
 void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
 void free_pages_exact(void *virt, size_t size);
 /* This is different from alloc_pages_exact_node !!! */
-void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
+void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
 
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask), 0)
diff -puN mm/page_alloc.c~mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid
+++ a/mm/page_alloc.c
@@ -2949,7 +2949,7 @@ EXPORT_SYMBOL(alloc_pages_exact);
  * Note this is not alloc_pages_exact_node() which allocates on a specific node,
  * but is not exact.
  */
-void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask)
+void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask)
 {
 	unsigned order = get_order(size);
 	struct page *p = alloc_pages_node(nid, gfp_mask, order);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch


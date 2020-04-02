From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 045/155] mm/gup: /proc/vmstat: pin_user_pages
 (FOLL_PIN) reporting
Date: Wed, 01 Apr 2020 21:05:37 -0700
Message-ID: <20200402040537.IfQKrmLGP%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEFj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:05:39 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, ira.weiny@intel.com, jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, shuah@kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, willy@infradead.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: /proc/vmstat: pin_user_pages (FOLL_PIN) reporting

Now that pages are "DMA-pinned" via pin_user_page*(), and unpinned via
unpin_user_pages*(), we need some visibility into whether all of this is
working correctly.

Add two new fields to /proc/vmstat:

    nr_foll_pin_acquired
    nr_foll_pin_released

These are documented in Documentation/core-api/pin_user_pages.rst.  They
represent the number of pages (since boot time) that have been pinned
("nr_foll_pin_acquired") and unpinned ("nr_foll_pin_released"), via
pin_user_pages*() and unpin_user_pages*().

In the absence of long-running DMA or RDMA operations that hold pages
pinned, the above two fields will normally be equal to each other.

Also: update Documentation/core-api/pin_user_pages.rst, to remove an
earlier (now confirmed untrue) claim about a performance problem with
/proc/vmstat.

Also: update Documentation/core-api/pin_user_pages.rst to rename the new
/proc/vmstat entries, to the names listed here.

Link: http://lkml.kernel.org/r/20200211001536.1027652-9-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst |   33 ++++++++++++++++----
 include/linux/mmzone.h                    |    2 +
 mm/gup.c                                  |   13 +++++++
 mm/vmstat.c                               |    2 +
 4 files changed, 45 insertions(+), 5 deletions(-)

--- a/Documentation/core-api/pin_user_pages.rst~mm-gup-proc-vmstat-pin_user=
_pages-foll_pin-reporting
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -208,12 +208,35 @@ has the following new calls to exercise
 You can monitor how many total dma-pinned pages have been acquired and rel=
eased
 since the system was booted, via two new /proc/vmstat entries: ::
=20
-    /proc/vmstat/nr_foll_pin_requested
-    /proc/vmstat/nr_foll_pin_requested
+    /proc/vmstat/nr_foll_pin_acquired
+    /proc/vmstat/nr_foll_pin_released
=20
-Those are both going to show zero, unless CONFIG_DEBUG_VM is set. This is
-because there is a noticeable performance drop in unpin_user_page(), when =
they
-are activated.
+Under normal conditions, these two values will be equal unless there are a=
ny
+long-term [R]DMA pins in place, or during pin/unpin transitions.
+
+* nr_foll_pin_acquired: This is the number of logical pins that have been
+  acquired since the system was powered on. For huge pages, the head page =
is
+  pinned once for each page (head page and each tail page) within the huge=
 page.
+  This follows the same sort of behavior that get_user_pages() uses for hu=
ge
+  pages: the head page is refcounted once for each tail or head page in th=
e huge
+  page, when get_user_pages() is applied to a huge page.
+
+* nr_foll_pin_released: The number of logical pins that have been released=
 since
+  the system was powered on. Note that pages are released (unpinned) on a
+  PAGE_SIZE granularity, even if the original pin was applied to a huge pa=
ge.
+  Becaused of the pin count behavior described above in "nr_foll_pin_acqui=
red",
+  the accounting balances out, so that after doing this::
+
+    pin_user_pages(huge_page);
+    for (each page in huge_page)
+        unpin_user_page(page);
+
+...the following is expected::
+
+    nr_foll_pin_released =3D=3D nr_foll_pin_acquired
+
+(...unless it was already out of balance due to a long-term RDMA pin being=
 in
+place.)
=20
 References
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/include/linux/mmzone.h~mm-gup-proc-vmstat-pin_user_pages-foll_pin-rep=
orting
+++ a/include/linux/mmzone.h
@@ -243,6 +243,8 @@ enum node_stat_item {
 	NR_DIRTIED,		/* page dirtyings since bootup */
 	NR_WRITTEN,		/* page writings since bootup */
 	NR_KERNEL_MISC_RECLAIMABLE,	/* reclaimable non-slab kernel pages */
+	NR_FOLL_PIN_ACQUIRED,	/* via: pin_user_page(), gup flag: FOLL_PIN */
+	NR_FOLL_PIN_RELEASED,	/* pages returned via unpin_user_page() */
 	NR_VM_NODE_STAT_ITEMS
 };
=20
--- a/mm/gup.c~mm-gup-proc-vmstat-pin_user_pages-foll_pin-reporting
+++ a/mm/gup.c
@@ -86,6 +86,8 @@ static __maybe_unused struct page *try_g
 	if (flags & FOLL_GET)
 		return try_get_compound_head(page, refs);
 	else if (flags & FOLL_PIN) {
+		int orig_refs =3D refs;
+
 		/*
 		 * When pinning a compound page of order > 1 (which is what
 		 * hpage_pincount_available() checks for), use an exact count to
@@ -104,6 +106,9 @@ static __maybe_unused struct page *try_g
 		if (hpage_pincount_available(page))
 			hpage_pincount_add(page, refs);
=20
+		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_ACQUIRED,
+				    orig_refs);
+
 		return page;
 	}
=20
@@ -158,6 +163,8 @@ bool __must_check try_grab_page(struct p
 		 * once, so that the page really is pinned.
 		 */
 		page_ref_add(page, refs);
+
+		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_ACQUIRED, 1);
 	}
=20
 	return true;
@@ -178,6 +185,7 @@ static bool __unpin_devmap_managed_user_
=20
 	count =3D page_ref_sub_return(page, refs);
=20
+	mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_RELEASED, 1);
 	/*
 	 * devmap page refcounts are 1-based, rather than 0-based: if
 	 * refcount is 1, then the page is free and the refcount is
@@ -228,6 +236,8 @@ void unpin_user_page(struct page *page)
=20
 	if (page_ref_sub_and_test(page, refs))
 		__put_page(page);
+
+	mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_RELEASED, 1);
 }
 EXPORT_SYMBOL(unpin_user_page);
=20
@@ -2014,6 +2024,9 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
 static void put_compound_head(struct page *page, int refs, unsigned int fl=
ags)
 {
 	if (flags & FOLL_PIN) {
+		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_RELEASED,
+				    refs);
+
 		if (hpage_pincount_available(page))
 			hpage_pincount_sub(page, refs);
 		else
--- a/mm/vmstat.c~mm-gup-proc-vmstat-pin_user_pages-foll_pin-reporting
+++ a/mm/vmstat.c
@@ -1168,6 +1168,8 @@ const char * const vmstat_text[] =3D {
 	"nr_dirtied",
 	"nr_written",
 	"nr_kernel_misc_reclaimable",
+	"nr_foll_pin_acquired",
+	"nr_foll_pin_released",
=20
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
_

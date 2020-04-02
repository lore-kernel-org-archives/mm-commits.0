From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 038/155] mm/gup: split get_user_pages_remote()
 into two routines
Date: Wed, 01 Apr 2020 21:05:10 -0700
Message-ID: <20200402040510.BXlTrn0dg%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEFN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:05:13 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, ira.weiny@intel.com, jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, shuah@kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, willy@infradead.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: split get_user_pages_remote() into two routines

Patch series "mm/gup: track FOLL_PIN pages", v6.

This activates tracking of FOLL_PIN pages.  This is in support of fixing
the get_user_pages()+DMA problem described in [1]-[4].

FOLL_PIN support is now in the main linux tree.  However, the patch to use
FOLL_PIN to track pages was *not* submitted, because Leon saw an RDMA test
suite failure that involved (I think) page refcount overflows when huge
pages were used.

This patch definitively solves that kind of overflow problem, by adding an
exact pincount, for compound pages (of order > 1), in the 3rd struct page
of a compound page.  If available, that form of pincounting is used,
instead of the GUP_PIN_COUNTING_BIAS approach.  Thanks again to Jan Kara
for that idea.

Other interesting changes:

* dump_page(): added one, or two new things to report for compound
  pages: head refcount (for all compound pages), and map_pincount (for
  compound pages of order > 1).

* Documentation/core-api/pin_user_pages.rst: removed the "TODO" for the
  huge page refcount upper limit problems, and added notes about how it
  works now.  Also added a note about the dump_page() enhancements.

* Added some comments in gup.c and mm.h, to explain that there are two
  ways to count pinned pages: exact (for compound pages of order > 1) and
  fuzzy (GUP_PIN_COUNTING_BIAS: for all other pages).

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
General notes about the tracking patch:

This is a prerequisite to solving the problem of proper interactions
between file-backed pages, and [R]DMA activities, as discussed in [1],
[2], [3], [4] and in a remarkable number of email threads since about
2017.  :)

In contrast to earlier approaches, the page tracking can be incrementally
applied to the kernel call sites that, until now, have been simply calling
get_user_pages() ("gup").  In other words, opt-in by changing from this:

    get_user_pages() (sets FOLL_GET)
    put_page()

to this:
    pin_user_pages() (sets FOLL_PIN)
    unpin_user_page()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Future steps:

* Convert more subsystems from get_user_pages() to pin_user_pages().
  The first probably needs to be bio/biovecs, because any filesystem
  testing is too difficult without those in place.

* Change VFS and filesystems to respond appropriately when encountering
  dma-pinned pages.

* Work with Ira and others to connect this all up with file system
  leases.

[1] Some slow progress on get_user_pages() (Apr 2, 2019):
    https://lwn.net/Articles/784574/

[2] DMA and get_user_pages() (LPC: Dec 12, 2018):
    https://lwn.net/Articles/774411/

[3] The trouble with get_user_pages() (Apr 30, 2018):
    https://lwn.net/Articles/753027/

[4] LWN kernel index: get_user_pages()
    https://lwn.net/Kernel/Index/#Memory_management-get_user_pages


This patch (of 12):

An upcoming patch requires reusing the implementation of
get_user_pages_remote().  Split up get_user_pages_remote() into an outer
routine that checks flags, and an implementation routine that will be
reused.  This makes subsequent changes much easier to understand.

There should be no change in behavior due to this patch.

Link: http://lkml.kernel.org/r/20200211001536.1027652-2-jhubbard@nvidia.com
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

 mm/gup.c |   56 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

--- a/mm/gup.c~mm-gup-split-get_user_pages_remote-into-two-routines
+++ a/mm/gup.c
@@ -1557,6 +1557,37 @@ static __always_inline long __gup_longte
 }
 #endif /* CONFIG_FS_DAX || CONFIG_CMA */
=20
+#ifdef CONFIG_MMU
+static long __get_user_pages_remote(struct task_struct *tsk,
+				    struct mm_struct *mm,
+				    unsigned long start, unsigned long nr_pages,
+				    unsigned int gup_flags, struct page **pages,
+				    struct vm_area_struct **vmas, int *locked)
+{
+	/*
+	 * Parts of FOLL_LONGTERM behavior are incompatible with
+	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
+	 * vmas. However, this only comes up if locked is set, and there are
+	 * callers that do request FOLL_LONGTERM, but do not set locked. So,
+	 * allow what we can.
+	 */
+	if (gup_flags & FOLL_LONGTERM) {
+		if (WARN_ON_ONCE(locked))
+			return -EINVAL;
+		/*
+		 * This will check the vmas (even if our vmas arg is NULL)
+		 * and return -ENOTSUPP if DAX isn't allowed in this case:
+		 */
+		return __gup_longterm_locked(tsk, mm, start, nr_pages, pages,
+					     vmas, gup_flags | FOLL_TOUCH |
+					     FOLL_REMOTE);
+	}
+
+	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
+				       locked,
+				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
+}
+
 /*
  * get_user_pages_remote() - pin user pages in memory
  * @tsk:	the task_struct to use for page fault accounting, or
@@ -1619,7 +1650,6 @@ static __always_inline long __gup_longte
  * should use get_user_pages because it cannot pass
  * FAULT_FLAG_ALLOW_RETRY to handle_mm_fault.
  */
-#ifdef CONFIG_MMU
 long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long start, unsigned long nr_pages,
 		unsigned int gup_flags, struct page **pages,
@@ -1632,28 +1662,8 @@ long get_user_pages_remote(struct task_s
 	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
 		return -EINVAL;
=20
-	/*
-	 * Parts of FOLL_LONGTERM behavior are incompatible with
-	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
-	 * vmas. However, this only comes up if locked is set, and there are
-	 * callers that do request FOLL_LONGTERM, but do not set locked. So,
-	 * allow what we can.
-	 */
-	if (gup_flags & FOLL_LONGTERM) {
-		if (WARN_ON_ONCE(locked))
-			return -EINVAL;
-		/*
-		 * This will check the vmas (even if our vmas arg is NULL)
-		 * and return -ENOTSUPP if DAX isn't allowed in this case:
-		 */
-		return __gup_longterm_locked(tsk, mm, start, nr_pages, pages,
-					     vmas, gup_flags | FOLL_TOUCH |
-					     FOLL_REMOTE);
-	}

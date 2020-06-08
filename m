From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 18/54] mm/gup: introduce pin_user_pages_locked()
Date: Sun, 07 Jun 2020 21:41:02 -0700
Message-ID: <20200608044102.WqWr6YExw%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHElE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:41:04 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel@ffwll.ch, david@fromorbit.com, david@redhat.com, jack@suse.cz, jglisse@redhat.com, jhubbard@nvidia.com, jrdr.linux@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, torvalds@linux-foundation.org, vbabka@suse.cz

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: introduce pin_user_pages_locked()

Patch series "mm/gup: introduce pin_user_pages_locked(), use it in frame_ve=
ctor.c", v2.

This adds yet one more pin_user_pages*() variant, and uses that to convert
mm/frame_vector.c.

With this, along with maybe 20 or 30 other recent patches in various
trees, we are close to having the relevant gup call sites converted--with
the notable exception of the bio/block layer.


This patch (of 2):

Introduce pin_user_pages_locked(), which is nearly identical to
get_user_pages_locked() except that it sets FOLL_PIN and rejects FOLL_GET.

As with other pairs of get_user_pages*() and pin_user_pages() API calls,
it's prudent to assert that FOLL_PIN is *not* set in the get_user_pages*()
call, so add that as part of this.

[jhubbard@nvidia.com: v2]
  Link: http://lkml.kernel.org/r/20200531234131.770697-2-jhubbard@nvidia.com
Link: http://lkml.kernel.org/r/20200531234131.770697-1-jhubbard@nvidia.com
Link: http://lkml.kernel.org/r/20200527223243.884385-1-jhubbard@nvidia.com
Link: http://lkml.kernel.org/r/20200527223243.884385-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/gup.c           |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

--- a/include/linux/mm.h~mm-gup-introduce-pin_user_pages_locked
+++ a/include/linux/mm.h
@@ -1706,6 +1706,8 @@ long pin_user_pages(unsigned long start,
 		    struct vm_area_struct **vmas);
 long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages, int *locked);
+long pin_user_pages_locked(unsigned long start, unsigned long nr_pages,
+		    unsigned int gup_flags, struct page **pages, int *locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
 long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
--- a/mm/gup.c~mm-gup-introduce-pin_user_pages_locked
+++ a/mm/gup.c
@@ -2035,6 +2035,12 @@ long get_user_pages_locked(unsigned long
 	 */
 	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
 		return -EINVAL;
+	/*
+	 * FOLL_PIN must only be set internally by the pin_user_pages*() APIs,
+	 * never directly by the caller, so enforce that:
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+		return -EINVAL;
=20
 	return __get_user_pages_locked(current, current->mm, start, nr_pages,
 				       pages, NULL, locked,
@@ -3058,3 +3064,33 @@ long pin_user_pages_unlocked(unsigned lo
 	return get_user_pages_unlocked(start, nr_pages, pages, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages_unlocked);
+
+/*
+ * pin_user_pages_locked() is the FOLL_PIN variant of get_user_pages_locke=
d().
+ * Behavior is the same, except that this one sets FOLL_PIN and rejects
+ * FOLL_GET.
+ */
+long pin_user_pages_locked(unsigned long start, unsigned long nr_pages,
+			   unsigned int gup_flags, struct page **pages,
+			   int *locked)
+{
+	/*
+	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
+	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
+	 * vmas.  As there are no users of this flag in this call we simply
+	 * disallow this option for now.
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
+		return -EINVAL;
+
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	gup_flags |=3D FOLL_PIN;
+	return __get_user_pages_locked(current, current->mm, start, nr_pages,
+				       pages, NULL, locked,
+				       gup_flags | FOLL_TOUCH);
+}
+EXPORT_SYMBOL(pin_user_pages_locked);
+
_

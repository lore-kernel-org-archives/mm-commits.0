From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-require-foll_get-for-get_user_pages_fast.patch
 added to -mm tree
Date: Mon, 10 Feb 2020 21:50:38 -0800
Message-ID: <20200211055038.Z94Osi2Qc%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbgBKFul (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 00:50:41 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, ira.weiny@intel.com, jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, shuah@kernel.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, willy@infradead.org


The patch titled
     Subject: mm/gup: require FOLL_GET for get_user_pages_fast()
has been added to the -mm tree.  Its filename is
     mm-gup-require-foll_get-for-get_user_pages_fast.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-require-foll_get-for-ge=
t_user_pages_fast.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-require-foll_get-for-ge=
t_user_pages_fast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: require FOLL_GET for get_user_pages_fast()

Internal to mm/gup.c, require that get_user_pages_fast() and
__get_user_pages_fast() identify themselves, by setting FOLL_GET.  This is
required in order to be able to make decisions based on "FOLL_PIN, or
FOLL_GET, or both or neither are set", in upcoming patches.

Link: http://lkml.kernel.org/r/20200211001536.1027652-6-jhubbard@nvidia.com
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

 mm/gup.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-require-foll_get-for-get_user_pages_fast
+++ a/mm/gup.c
@@ -2390,6 +2390,14 @@ int __get_user_pages_fast(unsigned long
 	unsigned long len, end;
 	unsigned long flags;
 	int nr =3D 0;
+	/*
+	 * Internally (within mm/gup.c), gup fast variants must set FOLL_GET,
+	 * because gup fast is always a "pin with a +1 page refcount" request.
+	 */
+	unsigned int gup_flags =3D FOLL_GET;
+
+	if (write)
+		gup_flags |=3D FOLL_WRITE;
=20
 	start =3D untagged_addr(start) & PAGE_MASK;
 	len =3D (unsigned long) nr_pages << PAGE_SHIFT;
@@ -2415,7 +2423,7 @@ int __get_user_pages_fast(unsigned long
 	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP) &&
 	    gup_fast_permitted(start, end)) {
 		local_irq_save(flags);
-		gup_pgd_range(start, end, write ? FOLL_WRITE : 0, pages, &nr);
+		gup_pgd_range(start, end, gup_flags, pages, &nr);
 		local_irq_restore(flags);
 	}
=20
@@ -2454,7 +2462,7 @@ static int internal_get_user_pages_fast(
 	int nr =3D 0, ret =3D 0;
=20
 	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
-				       FOLL_FORCE | FOLL_PIN)))
+				       FOLL_FORCE | FOLL_PIN | FOLL_GET)))
 		return -EINVAL;
=20
 	start =3D untagged_addr(start) & PAGE_MASK;
@@ -2521,6 +2529,13 @@ int get_user_pages_fast(unsigned long st
 	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
 		return -EINVAL;
=20
+	/*
+	 * The caller may or may not have explicitly set FOLL_GET; either way is
+	 * OK. However, internally (within mm/gup.c), gup fast variants must set
+	 * FOLL_GET, because gup fast is always a "pin with a +1 page refcount"
+	 * request.
+	 */
+	gup_flags |=3D FOLL_GET;
 	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-split-get_user_pages_remote-into-two-routines.patch
mm-gup-pass-a-flags-arg-to-__gup_device_-functions.patch
mm-introduce-page_ref_sub_return.patch
mm-gup-pass-gup-flags-to-two-more-routines.patch
mm-gup-require-foll_get-for-get_user_pages_fast.patch
mm-gup-track-foll_pin-pages.patch
mm-gup-page-hpage_pinned_refcount-exact-pin-counts-for-huge-pages.patch
mm-gup-proc-vmstat-pin_user_pages-foll_pin-reporting.patch
mm-gup_benchmark-support-pin_user_pages-and-related-calls.patch
selftests-vm-run_vmtests-invoke-gup_benchmark-with-basic-foll_pin-coverage.=
patch
mm-dump_page-additional-diagnostics-for-huge-pinned-pages.patch

From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-allow-foll_force-for-get_user_pages_fast.patch removed from -mm tree
Date: Fri, 31 Jan 2020 15:17:43 -0800
Message-ID: <20200131231743.owaMjZl5o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXRp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:17:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com, mchehab@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: mm/gup: allow FOLL_FORCE for get_user_pages_fast()
has been removed from the -mm tree.  Its filename was
     mm-gup-allow-foll_force-for-get_user_pages_fast.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: allow FOLL_FORCE for get_user_pages_fast()

Commit 817be129e6f2 ("mm: validate get_user_pages_fast flags") allowed
only FOLL_WRITE and FOLL_LONGTERM to be passed to get_user_pages_fast().=20
This, combined with the fact that get_user_pages_fast() falls back to
"slow gup", which *does* accept FOLL_FORCE, leads to an odd situation: if
you need FOLL_FORCE, you cannot call get_user_pages_fast().

There does not appear to be any reason for filtering out FOLL_FORCE.=20
There is nothing in the _fast() implementation that requires that we avoid
writing to the pages.  So it appears to have been an oversight.

Fix by allowing FOLL_FORCE to be set for get_user_pages_fast().

Link: http://lkml.kernel.org/r/20200107224558.2362728-9-jhubbard@nvidia.com
Fixes: 817be129e6f2 ("mm: validate get_user_pages_fast flags")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-allow-foll_force-for-get_user_pages_fast
+++ a/mm/gup.c
@@ -2411,7 +2411,8 @@ int get_user_pages_fast(unsigned long st
 	unsigned long addr, len, end;
 	int nr =3D 0, ret =3D 0;
=20
-	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM)))
+	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
+				       FOLL_FORCE)))
 		return -EINVAL;
=20
 	start =3D untagged_addr(start) & PAGE_MASK;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

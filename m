From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 044/118] mm/gup_benchmark: use proper FOLL_WRITE
 flags instead of hard-coding "1"
Date: Thu, 30 Jan 2020 22:13:32 -0800
Message-ID: <20200131061332.OQK3vA8vG%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGNd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:13:33 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.williamson@redhat.com, aneesh.kumar@linux.ibm.com, axboe@kernel.dk, bjorn.topel@intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, hch@lst.de, hverkuil-cisco@xs4all.nl, ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill@shutemov.name, leonro@mellanox.com, linux-mm@kvack.org, mchehab@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com, torvalds@linux-foundation.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup_benchmark: use proper FOLL_WRITE flags instead of hard-codi=
ng "1"

Fix the gup benchmark flags to use the symbolic FOLL_WRITE, instead of a
hard-coded "1" value.

Also, clean up the filtering of gup flags a little, by just doing it once
before issuing any of the get_user_pages*() calls.  This makes it harder
to overlook, instead of having little "gup_flags & 1" phrases in the
function calls.

Link: http://lkml.kernel.org/r/20200107224558.2362728-22-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_benchmark.c                         |    9 ++++++---
 tools/testing/selftests/vm/gup_benchmark.c |    6 +++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/mm/gup_benchmark.c~mm-gup_benchmark-use-proper-foll_write-flags-inste=
ad-of-hard-coding-1
+++ a/mm/gup_benchmark.c
@@ -49,18 +49,21 @@ static int __gup_benchmark_ioctl(unsigne
 			nr =3D (next - addr) / PAGE_SIZE;
 		}
=20
+		/* Filter out most gup flags: only allow a tiny subset here: */
+		gup->flags &=3D FOLL_WRITE;
+
 		switch (cmd) {
 		case GUP_FAST_BENCHMARK:
-			nr =3D get_user_pages_fast(addr, nr, gup->flags & 1,
+			nr =3D get_user_pages_fast(addr, nr, gup->flags,
 						 pages + i);
 			break;
 		case GUP_LONGTERM_BENCHMARK:
 			nr =3D get_user_pages(addr, nr,
-					    (gup->flags & 1) | FOLL_LONGTERM,
+					    gup->flags | FOLL_LONGTERM,
 					    pages + i, NULL);
 			break;
 		case GUP_BENCHMARK:
-			nr =3D get_user_pages(addr, nr, gup->flags & 1, pages + i,
+			nr =3D get_user_pages(addr, nr, gup->flags, pages + i,
 					    NULL);
 			break;
 		default:
--- a/tools/testing/selftests/vm/gup_benchmark.c~mm-gup_benchmark-use-prope=
r-foll_write-flags-instead-of-hard-coding-1
+++ a/tools/testing/selftests/vm/gup_benchmark.c
@@ -18,6 +18,9 @@
 #define GUP_LONGTERM_BENCHMARK	_IOWR('g', 2, struct gup_benchmark)
 #define GUP_BENCHMARK		_IOWR('g', 3, struct gup_benchmark)
=20
+/* Just the flags we need, copied from mm.h: */
+#define FOLL_WRITE	0x01	/* check pte is writable */
+
 struct gup_benchmark {
 	__u64 get_delta_usec;
 	__u64 put_delta_usec;
@@ -85,7 +88,8 @@ int main(int argc, char **argv)
 	}
=20
 	gup.nr_pages_per_call =3D nr_pages;
-	gup.flags =3D write;
+	if (write)
+		gup.flags |=3D FOLL_WRITE;
=20
 	fd =3D open("/sys/kernel/debug/gup_benchmark", O_RDWR);
 	if (fd =3D=3D -1)
_

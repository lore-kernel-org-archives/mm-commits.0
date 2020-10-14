Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEDEC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666CF22253
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709166;
	bh=sCsGNJQrgr7RzWHYdu45L3g0PQEbzOCmoQHnZdgpeQc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1k04DWZ6l0p/9mF84sb6HSBS+RiGsA2FerrfqftsawVH1EIiGUsgT+1USYscnUJHc
	 4QnqFKO8maII/6BPNsCeuHYOvJ7m2bfyD7NPyZDTx9KNblbLBb7Yn6vJnTjn7WWcoX
	 ysLhYStR96Puu9LsSlWR6O5oX3KCB3iftrMDC8ho=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389516AbgJNU70 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389499AbgJNU7Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC7822224E;
        Wed, 14 Oct 2020 20:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709164;
        bh=sCsGNJQrgr7RzWHYdu45L3g0PQEbzOCmoQHnZdgpeQc=;
        h=Date:From:To:Subject:From;
        b=foZwQPFJZv1M1CAJkBe6f8dUGbeDX779ojtBPFwPeepEJb5JPmt5qRAe2GKxgYeHB
         IBUblvYfpxV/CmKzftTH+QCnOX+Ee7Uh+6oGuKBRUYXeOsCIQ60Y/71MCGtL4wIZKQ
         9dfaai2RueRegKQbeh60RDOb+xjr2fJuWoeIth4c=
Date:   Wed, 14 Oct 2020 13:59:23 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com,
        hch@infradead.org, jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com,
        jhubbard@nvidia.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shuah@kernel.org,
        song.bao.hua@hisilicon.com, vbabka@suse.cz,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [merged]
 mm-gup_benchmark-use-pin_user_pages-for-foll_longterm-flag.patch removed
 from -mm tree
Message-ID: <20201014205923.Xegwc4sIk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_benchmark: use pin_user_pages for FOLL_LONGTERM flag
has been removed from the -mm tree.  Its filename was
     mm-gup_benchmark-use-pin_user_pages-for-foll_longterm-flag.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/gup_benchmark: use pin_user_pages for FOLL_LONGTERM flag

According to Documentation/core-api/pin_user_pages.rst, FOLL_PIN is a
prerequisite to FOLL_LONGTERM.  Another way of saying that is,
FOLL_LONGTERM is a specific case, more restrictive case of FOLL_PIN.

Almost all kernel modules are using pin_user_pages() with FOLL_LONGTERM,
mm/gup_benchmark.c seems to the only exception in which FOLL_PIN is not a
prerequisite to FOLL_LONGTERM.

Link: http://lkml.kernel.org/r/20200815122056.29508-1-song.bao.hua@hisilico=
n.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
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

 mm/gup_benchmark.c                         |   23 +++++++++----------
 tools/testing/selftests/vm/gup_benchmark.c |   14 +++++------
 2 files changed, 19 insertions(+), 18 deletions(-)

--- a/mm/gup_benchmark.c~mm-gup_benchmark-use-pin_user_pages-for-foll_longt=
erm-flag
+++ a/mm/gup_benchmark.c
@@ -6,10 +6,10 @@
 #include <linux/debugfs.h>
=20
 #define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_benchmark)
-#define GUP_LONGTERM_BENCHMARK	_IOWR('g', 2, struct gup_benchmark)
-#define GUP_BENCHMARK		_IOWR('g', 3, struct gup_benchmark)
-#define PIN_FAST_BENCHMARK	_IOWR('g', 4, struct gup_benchmark)
-#define PIN_BENCHMARK		_IOWR('g', 5, struct gup_benchmark)
+#define GUP_BENCHMARK		_IOWR('g', 2, struct gup_benchmark)
+#define PIN_FAST_BENCHMARK	_IOWR('g', 3, struct gup_benchmark)
+#define PIN_BENCHMARK		_IOWR('g', 4, struct gup_benchmark)
+#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_benchmark)
=20
 struct gup_benchmark {
 	__u64 get_delta_usec;
@@ -28,7 +28,6 @@ static void put_back_pages(unsigned int
=20
 	switch (cmd) {
 	case GUP_FAST_BENCHMARK:
-	case GUP_LONGTERM_BENCHMARK:
 	case GUP_BENCHMARK:
 		for (i =3D 0; i < nr_pages; i++)
 			put_page(pages[i]);
@@ -36,6 +35,7 @@ static void put_back_pages(unsigned int
=20
 	case PIN_FAST_BENCHMARK:
 	case PIN_BENCHMARK:
+	case PIN_LONGTERM_BENCHMARK:
 		unpin_user_pages(pages, nr_pages);
 		break;
 	}
@@ -50,6 +50,7 @@ static void verify_dma_pinned(unsigned i
 	switch (cmd) {
 	case PIN_FAST_BENCHMARK:
 	case PIN_BENCHMARK:
+	case PIN_LONGTERM_BENCHMARK:
 		for (i =3D 0; i < nr_pages; i++) {
 			page =3D pages[i];
 			if (WARN(!page_maybe_dma_pinned(page),
@@ -101,11 +102,6 @@ static int __gup_benchmark_ioctl(unsigne
 			nr =3D get_user_pages_fast(addr, nr, gup->flags,
 						 pages + i);
 			break;
-		case GUP_LONGTERM_BENCHMARK:
-			nr =3D get_user_pages(addr, nr,
-					    gup->flags | FOLL_LONGTERM,
-					    pages + i, NULL);
-			break;
 		case GUP_BENCHMARK:
 			nr =3D get_user_pages(addr, nr, gup->flags, pages + i,
 					    NULL);
@@ -118,6 +114,11 @@ static int __gup_benchmark_ioctl(unsigne
 			nr =3D pin_user_pages(addr, nr, gup->flags, pages + i,
 					    NULL);
 			break;
+		case PIN_LONGTERM_BENCHMARK:
+			nr =3D pin_user_pages(addr, nr,
+					    gup->flags | FOLL_LONGTERM,
+					    pages + i, NULL);
+			break;
 		default:
 			kvfree(pages);
 			ret =3D -EINVAL;
@@ -162,10 +163,10 @@ static long gup_benchmark_ioctl(struct f
=20
 	switch (cmd) {
 	case GUP_FAST_BENCHMARK:
-	case GUP_LONGTERM_BENCHMARK:
 	case GUP_BENCHMARK:
 	case PIN_FAST_BENCHMARK:
 	case PIN_BENCHMARK:
+	case PIN_LONGTERM_BENCHMARK:
 		break;
 	default:
 		return -EINVAL;
--- a/tools/testing/selftests/vm/gup_benchmark.c~mm-gup_benchmark-use-pin_u=
ser_pages-for-foll_longterm-flag
+++ a/tools/testing/selftests/vm/gup_benchmark.c
@@ -15,12 +15,12 @@
 #define PAGE_SIZE sysconf(_SC_PAGESIZE)
=20
 #define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_benchmark)
-#define GUP_LONGTERM_BENCHMARK	_IOWR('g', 2, struct gup_benchmark)
-#define GUP_BENCHMARK		_IOWR('g', 3, struct gup_benchmark)
+#define GUP_BENCHMARK		_IOWR('g', 2, struct gup_benchmark)
=20
 /* Similar to above, but use FOLL_PIN instead of FOLL_GET. */
-#define PIN_FAST_BENCHMARK	_IOWR('g', 4, struct gup_benchmark)
-#define PIN_BENCHMARK		_IOWR('g', 5, struct gup_benchmark)
+#define PIN_FAST_BENCHMARK	_IOWR('g', 3, struct gup_benchmark)
+#define PIN_BENCHMARK		_IOWR('g', 4, struct gup_benchmark)
+#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_benchmark)
=20
 /* Just the flags we need, copied from mm.h: */
 #define FOLL_WRITE	0x01	/* check pte is writable */
@@ -52,6 +52,9 @@ int main(int argc, char **argv)
 		case 'b':
 			cmd =3D PIN_BENCHMARK;
 			break;
+		case 'L':
+			cmd =3D PIN_LONGTERM_BENCHMARK;
+			break;
 		case 'm':
 			size =3D atoi(optarg) * MB;
 			break;
@@ -67,9 +70,6 @@ int main(int argc, char **argv)
 		case 'T':
 			thp =3D 0;
 			break;
-		case 'L':
-			cmd =3D GUP_LONGTERM_BENCHMARK;
-			break;
 		case 'U':
 			cmd =3D GUP_BENCHMARK;
 			break;
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are



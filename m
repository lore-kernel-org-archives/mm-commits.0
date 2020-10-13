Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E877AC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1BFA22203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633143;
	bh=btlHOICNsWV2voLDl184kUJn9cnoH1ZQeNKjD5SLUiQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hKGJbzVsifjht1QsLEaW7KX7BlHkhO9CgFAFHP6gamU2j3dpMZXtLtNyrDl4AUkL9
	 BY/cS/H23fU7GGCFn+moZyqZvu5SZsTk2XvowSC9oDP51PPZhE+R4nwQi8lR6SESIh
	 hCcPsr9iHOn20PX0phMY4KHe3uUVh8kvpVL+iWog=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgJMXwX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728737AbgJMXv4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E854A221FF;
        Tue, 13 Oct 2020 23:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633115;
        bh=btlHOICNsWV2voLDl184kUJn9cnoH1ZQeNKjD5SLUiQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CMXKmL+0Qsp7YlscRx2O1qu0JwRr/WqCdARsn1Wtxt/MyCWrVI/0nkJeq22m9BSgR
         R6gRxGueB9mcXDsduECzSQJ4PzQV6miLeUqoipzMFC4Pm9Nub2q7VQDFMuJv9g5T89
         7wHo1RS4RifnxUB3rfgvEK1rzHkUAG19nk2NQgxU=
Date:   Tue, 13 Oct 2020 16:51:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
        jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com,
        jhubbard@nvidia.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, song.bao.hua@hisilicon.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [patch 065/181] mm/gup_benchmark: use pin_user_pages for
 FOLL_LONGTERM flag
Message-ID: <20201013235154.eZcoryXQk%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

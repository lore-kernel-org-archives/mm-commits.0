Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF8EC43457
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AB6B208E4
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976478;
	bh=lmEEKv2mIKNfdNCObR/g2iM92wjOFNdktBDk6OdfgUE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=P/KjSyCtDr2E1HnjqZxvb3iXnoRbIvq+Q8noiDMkec0/KpQrYn8AZDvf/u8akbfzY
	 sWKFFKqgdGRtJ8wmO3fUOKcANLzRt2kWclST7VQRUG34vIG/u/cJy0a4Eis0jTpORt
	 ukeybzotAfs8n/ZUfvAYNk2NXn/78POZ3WOZgHqw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439898AbgJQXOi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXOh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:14:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04DA820878;
        Sat, 17 Oct 2020 23:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976475;
        bh=lmEEKv2mIKNfdNCObR/g2iM92wjOFNdktBDk6OdfgUE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iPaG6Kt+lndUFR0+gpDVRP1+vt6RMJ6cU+eoz/cyTuLZDd7aeaskBGYNMy+uZBOXw
         VCDLQLEoOsPZpEieLD+YbIMUVOidCaTameI4+F5hDLI6hdRsyjGOrpiHaun3ud7BeT
         rTQ80YumBE+x8FRrfBnVCywUWx9Ub2HozgCcA+KM=
Date:   Sat, 17 Oct 2020 16:14:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, jglisse@redhat.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 19/40] selftests/vm: only some gup_test items are
 really benchmarks
Message-ID: <20201017231434.DkYlvReNz%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: only some gup_test items are really benchmarks

Therefore, some minor cleanup and improvements are in order:

1. Rename the other items appropriately.

2. Stop reporting timing information on the non-benchmark items. It's
   still being recorded and is available, but there's no point in
   cluttering up the report with data that no one reasonably needs to
   check.

3. Don't do iterations, for non-benchmark items.

4. Print out a shorter, more appropriate report for the non-benchmark
   tests.

5. Add the command that was run, to the report. This really helps, as
   there are quite a lot of options now.

Link: https://lkml.kernel.org/r/20200929212747.251804-6-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst |    2=20
 mm/gup_test.c                             |   14 ++---
 mm/gup_test.h                             |    8 +--
 tools/testing/selftests/vm/gup_test.c     |   47 ++++++++++++++++----
 4 files changed, 51 insertions(+), 20 deletions(-)

--- a/Documentation/core-api/pin_user_pages.rst~selftests-vm-only-some-gup_=
test-items-are-really-benchmarks
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -226,7 +226,7 @@ This file::
 has the following new calls to exercise the new pin*() wrapper functions:
=20
 * PIN_FAST_BENCHMARK (./gup_test -a)
-* PIN_BENCHMARK (./gup_test -b)
+* PIN_BASIC_TEST (./gup_test -b)
=20
 You can monitor how many total dma-pinned pages have been acquired and rel=
eased
 since the system was booted, via two new /proc/vmstat entries: ::
--- a/mm/gup_test.c~selftests-vm-only-some-gup_test-items-are-really-benchm=
arks
+++ a/mm/gup_test.c
@@ -13,13 +13,13 @@ static void put_back_pages(unsigned int
=20
 	switch (cmd) {
 	case GUP_FAST_BENCHMARK:
-	case GUP_BENCHMARK:
+	case GUP_BASIC_TEST:
 		for (i =3D 0; i < nr_pages; i++)
 			put_page(pages[i]);
 		break;
=20
 	case PIN_FAST_BENCHMARK:
-	case PIN_BENCHMARK:
+	case PIN_BASIC_TEST:
 	case PIN_LONGTERM_BENCHMARK:
 		unpin_user_pages(pages, nr_pages);
 		break;
@@ -34,7 +34,7 @@ static void verify_dma_pinned(unsigned i
=20
 	switch (cmd) {
 	case PIN_FAST_BENCHMARK:
-	case PIN_BENCHMARK:
+	case PIN_BASIC_TEST:
 	case PIN_LONGTERM_BENCHMARK:
 		for (i =3D 0; i < nr_pages; i++) {
 			page =3D pages[i];
@@ -94,7 +94,7 @@ static int __gup_test_ioctl(unsigned int
 			nr =3D get_user_pages_fast(addr, nr, gup->flags,
 						 pages + i);
 			break;
-		case GUP_BENCHMARK:
+		case GUP_BASIC_TEST:
 			nr =3D get_user_pages(addr, nr, gup->flags, pages + i,
 					    NULL);
 			break;
@@ -102,7 +102,7 @@ static int __gup_test_ioctl(unsigned int
 			nr =3D pin_user_pages_fast(addr, nr, gup->flags,
 						 pages + i);
 			break;
-		case PIN_BENCHMARK:
+		case PIN_BASIC_TEST:
 			nr =3D pin_user_pages(addr, nr, gup->flags, pages + i,
 					    NULL);
 			break;
@@ -157,10 +157,10 @@ static long gup_test_ioctl(struct file *
=20
 	switch (cmd) {
 	case GUP_FAST_BENCHMARK:
-	case GUP_BENCHMARK:
 	case PIN_FAST_BENCHMARK:
-	case PIN_BENCHMARK:
 	case PIN_LONGTERM_BENCHMARK:
+	case GUP_BASIC_TEST:
+	case PIN_BASIC_TEST:
 		break;
 	default:
 		return -EINVAL;
--- a/mm/gup_test.h~selftests-vm-only-some-gup_test-items-are-really-benchm=
arks
+++ a/mm/gup_test.h
@@ -5,10 +5,10 @@
 #include <linux/types.h>
=20
 #define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_test)
-#define GUP_BENCHMARK		_IOWR('g', 2, struct gup_test)
-#define PIN_FAST_BENCHMARK	_IOWR('g', 3, struct gup_test)
-#define PIN_BENCHMARK		_IOWR('g', 4, struct gup_test)
-#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_test)
+#define PIN_FAST_BENCHMARK	_IOWR('g', 2, struct gup_test)
+#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 3, struct gup_test)
+#define GUP_BASIC_TEST		_IOWR('g', 4, struct gup_test)
+#define PIN_BASIC_TEST		_IOWR('g', 5, struct gup_test)
=20
 struct gup_test {
 	__u64 get_delta_usec;
--- a/tools/testing/selftests/vm/gup_test.c~selftests-vm-only-some-gup_test=
-items-are-really-benchmarks
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -14,12 +14,30 @@
 /* Just the flags we need, copied from mm.h: */
 #define FOLL_WRITE	0x01	/* check pte is writable */
=20
+static char *cmd_to_str(unsigned long cmd)
+{
+	switch (cmd) {
+	case GUP_FAST_BENCHMARK:
+		return "GUP_FAST_BENCHMARK";
+	case PIN_FAST_BENCHMARK:
+		return "PIN_FAST_BENCHMARK";
+	case PIN_LONGTERM_BENCHMARK:
+		return "PIN_LONGTERM_BENCHMARK";
+	case GUP_BASIC_TEST:
+		return "GUP_BASIC_TEST";
+	case PIN_BASIC_TEST:
+		return "PIN_BASIC_TEST";
+	}
+	return "Unknown command";
+}
+
 int main(int argc, char **argv)
 {
 	struct gup_benchmark gup;
 	unsigned long size =3D 128 * MB;
 	int i, fd, filed, opt, nr_pages =3D 1, thp =3D -1, repeats =3D 1, write =
=3D 0;
-	int cmd =3D GUP_FAST_BENCHMARK, flags =3D MAP_PRIVATE;
+	int cmd =3D GUP_FAST_BENCHMARK;
+	int flags =3D MAP_PRIVATE;
 	char *file =3D "/dev/zero";
 	char *p;
=20
@@ -29,7 +47,7 @@ int main(int argc, char **argv)
 			cmd =3D PIN_FAST_BENCHMARK;
 			break;
 		case 'b':
-			cmd =3D PIN_BENCHMARK;
+			cmd =3D PIN_BASIC_TEST;
 			break;
 		case 'L':
 			cmd =3D PIN_LONGTERM_BENCHMARK;
@@ -50,7 +68,7 @@ int main(int argc, char **argv)
 			thp =3D 0;
 			break;
 		case 'U':
-			cmd =3D GUP_BENCHMARK;
+			cmd =3D GUP_BASIC_TEST;
 			break;
 		case 'u':
 			cmd =3D GUP_FAST_BENCHMARK;
@@ -104,18 +122,31 @@ int main(int argc, char **argv)
 	for (; (unsigned long)p < gup.addr + size; p +=3D PAGE_SIZE)
 		p[0] =3D 0;
=20
-	for (i =3D 0; i < repeats; i++) {
+	/* Only report timing information on the *_BENCHMARK commands: */
+	if ((cmd =3D=3D PIN_FAST_BENCHMARK) || (cmd =3D=3D GUP_FAST_BENCHMARK) ||
+	     (cmd =3D=3D PIN_LONGTERM_BENCHMARK)) {
+		for (i =3D 0; i < repeats; i++) {
+			gup.size =3D size;
+			if (ioctl(fd, cmd, &gup))
+				perror("ioctl"), exit(1);
+
+			printf("%s: Time: get:%lld put:%lld us",
+			       cmd_to_str(cmd), gup.get_delta_usec,
+			       gup.put_delta_usec);
+			if (gup.size !=3D size)
+				printf(", truncated (size: %lld)", gup.size);
+			printf("\n");
+		}
+	} else {
 		gup.size =3D size;
 		if (ioctl(fd, cmd, &gup)) {
 			perror("ioctl");
 			exit(1);
 		}
=20
-		printf("Time: get:%lld put:%lld us", gup.get_delta_usec,
-			gup.put_delta_usec);
+		printf("%s: done\n", cmd_to_str(cmd));
 		if (gup.size !=3D size)
-			printf(", truncated (size: %lld)", gup.size);
-		printf("\n");
+			printf("Truncated (size: %lld)\n", gup.size);
 	}
=20
 	return 0;
_

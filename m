Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB88C3526C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0827F22D08
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgLPAAJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727774AbgLOX0n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:43 -0500
Date:   Tue, 15 Dec 2020 15:17:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074238;
        bh=XIehnTW3+8vuKKhb9slwCQqSj5++Hi7Xb+GtNWxviTQ=;
        h=From:To:Subject:From;
        b=am6QnP4G5xbvYDScsaQiK/zCUPevQ2Vyq5Iexi6iGNlTIeQk28P0pPFss4A12UKvD
         B7TksdWCnW9HMp+yEiH2q0Ysoh5pINgJ2TQV3Gouq2Nj1jKDjOf+Sk/isOSF46s+6q
         jB9xrDhneLBRDJ/W0UcnneHyZ4gtLCBdr8SarvGw=
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [merged]
 selftests-vm-gup_test-introduce-the-dump_pages-sub-test.patch removed from
 -mm tree
Message-ID: <20201215231718.SojzTCol3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: gup_test: introduce the dump_pages() sub-test
has been removed from the -mm tree.  Its filename was
     selftests-vm-gup_test-introduce-the-dump_pages-sub-test.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: gup_test: introduce the dump_pages() sub-test

For quite a while, I was doing a quick hack to gup_test.c (previously,
gup_benchmark.c) whenever I wanted to try out my changes to dump_page().
This makes that hack unnecessary, and instead allows anyone to easily get
the same coverage from a user space program.  That saves a lot of time
because you don't have to change the kernel, in order to test different
pages and options.

The new sub-test takes advantage of the existing gup_test infrastructure,
which already provides a simple user space program, some allocated user
space pages, an ioctl call, pinning of those pages (via either
get_user_pages or pin_user_pages) and a corresponding kernel-side test
invocation.  There's not much more required, mainly just a couple of
inputs from the user.

In fact, the new test re-uses the existing command line options in order
to get various helpful combinations (THP or normal, _fast or slow gup, gup
vs.  pup, and more).

New command line options are: which pages to dump, and what type of
"get/pin" to use.

In order to figure out which pages to dump, the logic is:

* If the user doesn't specify anything, the page 0 (the first page in
  the address range that the program sets up for testing) is dumped.

* Or, the user can type up to 8 page indices anywhere on the command
  line.  If you type more than 8, then it uses the first 8 and ignores the
  remaining items.

For example:

    ./gup_test -ct -F 1 0 19 0x1000

Meaning:
    -c:          dump pages sub-test
    -t:          use THP pages
    -F 1:        use pin_user_pages() instead of get_user_pages()
    0 19 0x1000: dump pages 0, 19, and 4096

Link: https://lkml.kernel.org/r/20201026064021.3545418-7-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig                            |    6 ++
 mm/gup_test.c                         |   56 +++++++++++++++++++++++-
 mm/gup_test.h                         |   10 ++++
 tools/testing/selftests/vm/gup_test.c |   45 ++++++++++++++++++-
 4 files changed, 113 insertions(+), 4 deletions(-)

--- a/mm/gup_test.c~selftests-vm-gup_test-introduce-the-dump_pages-sub-test
+++ a/mm/gup_test.c
@@ -7,7 +7,7 @@
 #include "gup_test.h"
=20
 static void put_back_pages(unsigned int cmd, struct page **pages,
-			   unsigned long nr_pages)
+			   unsigned long nr_pages, unsigned int gup_test_flags)
 {
 	unsigned long i;
=20
@@ -23,6 +23,15 @@ static void put_back_pages(unsigned int
 	case PIN_LONGTERM_BENCHMARK:
 		unpin_user_pages(pages, nr_pages);
 		break;
+	case DUMP_USER_PAGES_TEST:
+		if (gup_test_flags & GUP_TEST_FLAG_DUMP_PAGES_USE_PIN) {
+			unpin_user_pages(pages, nr_pages);
+		} else {
+			for (i =3D 0; i < nr_pages; i++)
+				put_page(pages[i]);
+
+		}
+		break;
 	}
 }
=20
@@ -49,6 +58,37 @@ static void verify_dma_pinned(unsigned i
 	}
 }
=20
+static void dump_pages_test(struct gup_test *gup, struct page **pages,
+			    unsigned long nr_pages)
+{
+	unsigned int index_to_dump;
+	unsigned int i;
+
+	/*
+	 * Zero out any user-supplied page index that is out of range. Remember:
+	 * .which_pages[] contains a 1-based set of page indices.
+	 */
+	for (i =3D 0; i < GUP_TEST_MAX_PAGES_TO_DUMP; i++) {
+		if (gup->which_pages[i] > nr_pages) {
+			pr_warn("ZEROING due to out of range: .which_pages[%u]: %u\n",
+				i, gup->which_pages[i]);
+			gup->which_pages[i] =3D 0;
+		}
+	}
+
+	for (i =3D 0; i < GUP_TEST_MAX_PAGES_TO_DUMP; i++) {
+		index_to_dump =3D gup->which_pages[i];
+
+		if (index_to_dump) {
+			index_to_dump--; // Decode from 1-based, to 0-based
+			pr_info("---- page #%u, starting from user virt addr: 0x%llx\n",
+				index_to_dump, gup->addr);
+			dump_page(pages[index_to_dump],
+				  "gup_test: dump_pages() test");
+		}
+	}
+}
+
 static int __gup_test_ioctl(unsigned int cmd,
 		struct gup_test *gup)
 {
@@ -111,6 +151,14 @@ static int __gup_test_ioctl(unsigned int
 					    gup->flags | FOLL_LONGTERM,
 					    pages + i, NULL);
 			break;
+		case DUMP_USER_PAGES_TEST:
+			if (gup->flags & GUP_TEST_FLAG_DUMP_PAGES_USE_PIN)
+				nr =3D pin_user_pages(addr, nr, gup->flags,
+						    pages + i, NULL);
+			else
+				nr =3D get_user_pages(addr, nr, gup->flags,
+						    pages + i, NULL);
+			break;
 		default:
 			ret =3D -EINVAL;
 			goto unlock;
@@ -134,9 +182,12 @@ static int __gup_test_ioctl(unsigned int
 	 */
 	verify_dma_pinned(cmd, pages, nr_pages);
=20
+	if (cmd =3D=3D DUMP_USER_PAGES_TEST)
+		dump_pages_test(gup, pages, nr_pages);
+
 	start_time =3D ktime_get();
=20
-	put_back_pages(cmd, pages, nr_pages);
+	put_back_pages(cmd, pages, nr_pages, gup->flags);
=20
 	end_time =3D ktime_get();
 	gup->put_delta_usec =3D ktime_us_delta(end_time, start_time);
@@ -161,6 +212,7 @@ static long gup_test_ioctl(struct file *
 	case PIN_LONGTERM_BENCHMARK:
 	case GUP_BASIC_TEST:
 	case PIN_BASIC_TEST:
+	case DUMP_USER_PAGES_TEST:
 		break;
 	default:
 		return -EINVAL;
--- a/mm/gup_test.h~selftests-vm-gup_test-introduce-the-dump_pages-sub-test
+++ a/mm/gup_test.h
@@ -9,6 +9,11 @@
 #define PIN_LONGTERM_BENCHMARK	_IOWR('g', 3, struct gup_test)
 #define GUP_BASIC_TEST		_IOWR('g', 4, struct gup_test)
 #define PIN_BASIC_TEST		_IOWR('g', 5, struct gup_test)
+#define DUMP_USER_PAGES_TEST	_IOWR('g', 6, struct gup_test)
+
+#define GUP_TEST_MAX_PAGES_TO_DUMP		8
+
+#define GUP_TEST_FLAG_DUMP_PAGES_USE_PIN	0x1
=20
 struct gup_test {
 	__u64 get_delta_usec;
@@ -17,6 +22,11 @@ struct gup_test {
 	__u64 size;
 	__u32 nr_pages_per_call;
 	__u32 flags;
+	/*
+	 * Each non-zero entry is the number of the page (1-based: first page is
+	 * page 1, so that zero entries mean "do nothing") from the .addr base.
+	 */
+	__u32 which_pages[GUP_TEST_MAX_PAGES_TO_DUMP];
 };
=20
 #endif	/* __GUP_TEST_H */
--- a/mm/Kconfig~selftests-vm-gup_test-introduce-the-dump_pages-sub-test
+++ a/mm/Kconfig
@@ -832,6 +832,12 @@ config GUP_TEST
 	  get_user_pages*() and pin_user_pages*(), as well as smoke tests of
 	  the non-_fast variants.
=20
+	  There is also a sub-test that allows running dump_page() on any
+	  of up to eight pages (selected by command line args) within the
+	  range of user-space addresses. These pages are either pinned via
+	  pin_user_pages*(), or pinned via get_user_pages*(), as specified
+	  by other command line arguments.
+
 	  See tools/testing/selftests/vm/gup_test.c
=20
 config GUP_GET_PTE_LOW_HIGH
--- a/tools/testing/selftests/vm/gup_test.c~selftests-vm-gup_test-introduce=
-the-dump_pages-sub-test
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -27,13 +27,15 @@ static char *cmd_to_str(unsigned long cm
 		return "GUP_BASIC_TEST";
 	case PIN_BASIC_TEST:
 		return "PIN_BASIC_TEST";
+	case DUMP_USER_PAGES_TEST:
+		return "DUMP_USER_PAGES_TEST";
 	}
 	return "Unknown command";
 }
=20
 int main(int argc, char **argv)
 {
-	struct gup_test gup;
+	struct gup_test gup =3D { 0 };
 	unsigned long size =3D 128 * MB;
 	int i, fd, filed, opt, nr_pages =3D 1, thp =3D -1, repeats =3D 1, write =
=3D 0;
 	unsigned long cmd =3D GUP_FAST_BENCHMARK;
@@ -41,7 +43,7 @@ int main(int argc, char **argv)
 	char *file =3D "/dev/zero";
 	char *p;
=20
-	while ((opt =3D getopt(argc, argv, "m:r:n:f:abtTLUuwSH")) !=3D -1) {
+	while ((opt =3D getopt(argc, argv, "m:r:n:F:f:abctTLUuwSH")) !=3D -1) {
 		switch (opt) {
 		case 'a':
 			cmd =3D PIN_FAST_BENCHMARK;
@@ -52,6 +54,21 @@ int main(int argc, char **argv)
 		case 'L':
 			cmd =3D PIN_LONGTERM_BENCHMARK;
 			break;
+		case 'c':
+			cmd =3D DUMP_USER_PAGES_TEST;
+			/*
+			 * Dump page 0 (index 1). May be overridden later, by
+			 * user's non-option arguments.
+			 *
+			 * .which_pages is zero-based, so that zero can mean "do
+			 * nothing".
+			 */
+			gup.which_pages[0] =3D 1;
+			break;
+		case 'F':
+			/* strtol, so you can pass flags in hex form */
+			gup.flags =3D strtol(optarg, 0, 0);
+			break;
 		case 'm':
 			size =3D atoi(optarg) * MB;
 			break;
@@ -91,6 +108,30 @@ int main(int argc, char **argv)
 		}
 	}
=20
+	if (optind < argc) {
+		int extra_arg_count =3D 0;
+		/*
+		 * For example:
+		 *
+		 *   ./gup_test -c 0 1 0x1001
+		 *
+		 * ...to dump pages 0, 1, and 4097
+		 */
+
+		while ((optind < argc) &&
+		       (extra_arg_count < GUP_TEST_MAX_PAGES_TO_DUMP)) {
+			/*
+			 * Do the 1-based indexing here, so that the user can
+			 * use normal 0-based indexing on the command line.
+			 */
+			long page_index =3D strtol(argv[optind], 0, 0) + 1;
+
+			gup.which_pages[extra_arg_count] =3D page_index;
+			extra_arg_count++;
+			optind++;
+		}
+	}
+
 	filed =3D open(file, O_RDWR|O_CREAT);
 	if (filed < 0) {
 		perror("open");
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch


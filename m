Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C47C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39441224BD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgLODPF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728089AbgLODOk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:14:40 -0500
Date:   Mon, 14 Dec 2020 19:13:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002039;
        bh=xhWSAVnCi8GLn7c4hbVoC3Mlgi+wTPI7i3oODOAl2qs=;
        h=From:To:Subject:In-Reply-To:From;
        b=kHe/EW/qcGx+sGZcz5syyC99MSmaqRrftRfaAUKfNrkD8r38E4fD8BlLE+XlyBCeC
         K3Fp2rbVvjHJDkqsdb7GnEUxJ1t2shzyLSIwoAUvran1oUi2PeyNY9L0JDySDd8/MB
         GDtlqLXrTTo8hT14JZzpWpraTnlgrCI/twdZZKKE=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        axelrasmussen@google.com, dgilbert@redhat.com, gthelen@google.com,
        joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, shuah@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 181/200] userfaultfd: selftests: make __{s,u}64
 format specifiers portable
Message-ID: <20201215031358.1TNhsPII9%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: selftests: make __{s,u}64 format specifiers portable

On certain platforms (powerpcle is the one on which I ran into this),
"%Ld" and "%Lu" are unsuitable for printing __s64 and __u64, respectively,
resulting in build warnings.  Cast to {u,}int64_t, and use the PRI{d,u}64
macros defined in inttypes.h to print them.  This ought to be portable to
all platforms.

Splitting this off into a separate macro lets us remove some lines, and
get rid of some (I would argue) stylistically odd cases where we joined
printf() and exit() into a single statement with a ,.

Finally, this also fixes a "missing braces around initializer" warning
when we initialize prms in wp_range().

[axelrasmussen@google.com: v2]
  Link: https://lkml.kernel.org/r/20201203180244.1811601-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20201202211542.1121189-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Alan Gilbert <dgilbert@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   81 +++++++++------------
 1 file changed, 35 insertions(+), 46 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-make-__su64-format-specifiers-portable
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -55,6 +55,8 @@
 #include <setjmp.h>
 #include <stdbool.h>
 #include <assert.h>
+#include <inttypes.h>
+#include <stdint.h>
 
 #include "../kselftest.h"
 
@@ -135,6 +137,13 @@ static void usage(void)
 	exit(1);
 }
 
+#define uffd_error(code, fmt, ...)                                             \
+	do {                                                                   \
+		fprintf(stderr, fmt, ##__VA_ARGS__);                           \
+		fprintf(stderr, ": %" PRId64 "\n", (int64_t)(code));           \
+		exit(1);                                                       \
+	} while (0)
+
 static void uffd_stats_reset(struct uffd_stats *uffd_stats,
 			     unsigned long n_cpus)
 {
@@ -338,7 +347,7 @@ static int my_bcmp(char *str1, char *str
 
 static void wp_range(int ufd, __u64 start, __u64 len, bool wp)
 {
-	struct uffdio_writeprotect prms = { 0 };
+	struct uffdio_writeprotect prms;
 
 	/* Write protection page faults */
 	prms.range.start = start;
@@ -347,7 +356,8 @@ static void wp_range(int ufd, __u64 star
 	prms.mode = wp ? UFFDIO_WRITEPROTECT_MODE_WP : 0;
 
 	if (ioctl(ufd, UFFDIO_WRITEPROTECT, &prms)) {
-		fprintf(stderr, "clear WP failed for address 0x%Lx\n", start);
+		fprintf(stderr, "clear WP failed for address 0x%" PRIx64 "\n",
+			(uint64_t)start);
 		exit(1);
 	}
 }
@@ -481,14 +491,11 @@ static void retry_copy_page(int ufd, str
 	if (ioctl(ufd, UFFDIO_COPY, uffdio_copy)) {
 		/* real retval in ufdio_copy.copy */
 		if (uffdio_copy->copy != -EEXIST) {
-			fprintf(stderr, "UFFDIO_COPY retry error %Ld\n",
-				uffdio_copy->copy);
-			exit(1);
+			uffd_error(uffdio_copy->copy,
+				   "UFFDIO_COPY retry error");
 		}
-	} else {
-		fprintf(stderr,	"UFFDIO_COPY retry unexpected %Ld\n",
-			uffdio_copy->copy); exit(1);
-	}
+	} else
+		uffd_error(uffdio_copy->copy, "UFFDIO_COPY retry unexpected");
 }
 
 static int __copy_page(int ufd, unsigned long offset, bool retry)
@@ -509,14 +516,10 @@ static int __copy_page(int ufd, unsigned
 	uffdio_copy.copy = 0;
 	if (ioctl(ufd, UFFDIO_COPY, &uffdio_copy)) {
 		/* real retval in ufdio_copy.copy */
-		if (uffdio_copy.copy != -EEXIST) {
-			fprintf(stderr, "UFFDIO_COPY error %Ld\n",
-				uffdio_copy.copy);
-			exit(1);
-		}
+		if (uffdio_copy.copy != -EEXIST)
+			uffd_error(uffdio_copy.copy, "UFFDIO_COPY error");
 	} else if (uffdio_copy.copy != page_size) {
-		fprintf(stderr, "UFFDIO_COPY unexpected copy %Ld\n",
-			uffdio_copy.copy); exit(1);
+		uffd_error(uffdio_copy.copy, "UFFDIO_COPY unexpected copy");
 	} else {
 		if (test_uffdio_copy_eexist && retry) {
 			test_uffdio_copy_eexist = false;
@@ -795,7 +798,8 @@ static int userfaultfd_open(int features
 		return 1;
 	}
 	if (uffdio_api.api != UFFD_API) {
-		fprintf(stderr, "UFFDIO_API error %Lu\n", uffdio_api.api);
+		fprintf(stderr, "UFFDIO_API error: %" PRIu64 "\n",
+			(uint64_t)uffdio_api.api);
 		return 1;
 	}
 
@@ -957,13 +961,12 @@ static void retry_uffdio_zeropage(int uf
 				     offset);
 	if (ioctl(ufd, UFFDIO_ZEROPAGE, uffdio_zeropage)) {
 		if (uffdio_zeropage->zeropage != -EEXIST) {
-			fprintf(stderr, "UFFDIO_ZEROPAGE retry error %Ld\n",
-				uffdio_zeropage->zeropage);
-			exit(1);
+			uffd_error(uffdio_zeropage->zeropage,
+				   "UFFDIO_ZEROPAGE retry error");
 		}
 	} else {
-		fprintf(stderr, "UFFDIO_ZEROPAGE retry unexpected %Ld\n",
-			uffdio_zeropage->zeropage); exit(1);
+		uffd_error(uffdio_zeropage->zeropage,
+			   "UFFDIO_ZEROPAGE retry unexpected");
 	}
 }
 
@@ -972,6 +975,7 @@ static int __uffdio_zeropage(int ufd, un
 	struct uffdio_zeropage uffdio_zeropage;
 	int ret;
 	unsigned long has_zeropage;
+	__s64 res;
 
 	has_zeropage = uffd_test_ops->expected_ioctls & (1 << _UFFDIO_ZEROPAGE);
 
@@ -983,29 +987,17 @@ static int __uffdio_zeropage(int ufd, un
 	uffdio_zeropage.range.len = page_size;
 	uffdio_zeropage.mode = 0;
 	ret = ioctl(ufd, UFFDIO_ZEROPAGE, &uffdio_zeropage);
+	res = uffdio_zeropage.zeropage;
 	if (ret) {
 		/* real retval in ufdio_zeropage.zeropage */
 		if (has_zeropage) {
-			if (uffdio_zeropage.zeropage == -EEXIST) {
-				fprintf(stderr, "UFFDIO_ZEROPAGE -EEXIST\n");
-				exit(1);
-			} else {
-				fprintf(stderr, "UFFDIO_ZEROPAGE error %Ld\n",
-					uffdio_zeropage.zeropage);
-				exit(1);
-			}
-		} else {
-			if (uffdio_zeropage.zeropage != -EINVAL) {
-				fprintf(stderr,
-					"UFFDIO_ZEROPAGE not -EINVAL %Ld\n",
-					uffdio_zeropage.zeropage);
-				exit(1);
-			}
-		}
+			uffd_error(res, "UFFDIO_ZEROPAGE %s",
+				   res == -EEXIST ? "-EEXIST" : "error");
+		} else if (res != -EINVAL)
+			uffd_error(res, "UFFDIO_ZEROPAGE not -EINVAL");
 	} else if (has_zeropage) {
-		if (uffdio_zeropage.zeropage != page_size) {
-			fprintf(stderr, "UFFDIO_ZEROPAGE unexpected %Ld\n",
-				uffdio_zeropage.zeropage); exit(1);
+		if (res != page_size) {
+			uffd_error(res, "UFFDIO_ZEROPAGE unexpected");
 		} else {
 			if (test_uffdio_zeropage_eexist && retry) {
 				test_uffdio_zeropage_eexist = false;
@@ -1014,11 +1006,8 @@ static int __uffdio_zeropage(int ufd, un
 			}
 			return 1;
 		}
-	} else {
-		fprintf(stderr,
-			"UFFDIO_ZEROPAGE succeeded %Ld\n",
-			uffdio_zeropage.zeropage); exit(1);
-	}
+	} else
+		uffd_error(res, "UFFDIO_ZEROPAGE succeeded");
 
 	return 0;
 }
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F6BC6369E
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 22:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCCEB221FD
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 22:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgLBWz5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 17:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgLBWz4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 17:55:56 -0500
Date:   Wed, 02 Dec 2020 14:55:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606949715;
        bh=1v9t1anpYsiDxhZVPEzCZRMUqxgDjPJc0fYhhEdcTnE=;
        h=From:To:Subject:From;
        b=lXd7L9K6JlRBqGSj6BaI7aQU7omH140j6RvRJhRXIyHoyfdiaTxtpIJcmk/KRJs17
         KYg13LdP4Fffq0zSm4amQ5dUbOc3Nu/24ypT8h5UbmPsNlf35QHmiYk9o4LgY0KrZ2
         a6BtybjAFzwOwslZcp+JCgHtS/P565zZibDKTyN8=
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com, dgilbert@redhat.com,
        gthelen@google.com, joe@perches.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, shuah@kernel.org
Subject:  +
 userfaultfd-selftests-make-__su64-format-specifiers-portable.patch added to
 -mm tree
Message-ID: <20201202225514.D_OZlC7As%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftests: make __{s,u}64 format specifiers portable
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-make-__su64-format-specifiers-portable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-make-__su64-format-specifiers-portable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-make-__su64-format-specifiers-portable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: selftests: make __{s,u}64 format specifiers portable

On certain platforms (powerpcle is the one on which I ran into this),
"%Ld" and "%Lu" are unsuitable for printing __s64 and __u64, respectively,
resulting in a build warning.  Cast to {u,}int64_t, and use the PRI{d,u}64
macros defined in inttypes.h to print them.  This ought to be portable to
all platforms.

Splitting this off into a separate function lets us remove some lines, and
get rid of some (I would argue) stylistically odd cases where we joined
printf() and exit() into a single statement with a ,.

Finally, this also fixes a "missing braces around initializer" warning
when we initialize prms in wp_range().

Link: https://lkml.kernel.org/r/20201202211542.1121189-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Alan Gilbert <dgilbert@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   77 +++++++++------------
 1 file changed, 36 insertions(+), 41 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-make-__su64-format-specifiers-portable
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -55,6 +55,8 @@
 #include <setjmp.h>
 #include <stdbool.h>
 #include <assert.h>
+#include <inttypes.h>
+#include <stdint.h>
 
 #include "../kselftest.h"
 
@@ -135,6 +137,12 @@ static void usage(void)
 	exit(1);
 }
 
+static void uffd_error(const char *message, __s64 code)
+{
+	fprintf(stderr, "%s: %" PRId64 "\n", message, (int64_t)code);
+	exit(1);
+}
+
 static void uffd_stats_reset(struct uffd_stats *uffd_stats,
 			     unsigned long n_cpus)
 {
@@ -331,7 +339,7 @@ static int my_bcmp(char *str1, char *str
 
 static void wp_range(int ufd, __u64 start, __u64 len, bool wp)
 {
-	struct uffdio_writeprotect prms = { 0 };
+	struct uffdio_writeprotect prms;
 
 	/* Write protection page faults */
 	prms.range.start = start;
@@ -340,7 +348,8 @@ static void wp_range(int ufd, __u64 star
 	prms.mode = wp ? UFFDIO_WRITEPROTECT_MODE_WP : 0;
 
 	if (ioctl(ufd, UFFDIO_WRITEPROTECT, &prms)) {
-		fprintf(stderr, "clear WP failed for address 0x%Lx\n", start);
+		fprintf(stderr, "clear WP failed for address 0x%" PRIx64 "\n",
+			(uint64_t)start);
 		exit(1);
 	}
 }
@@ -474,14 +483,11 @@ static void retry_copy_page(int ufd, str
 	if (ioctl(ufd, UFFDIO_COPY, uffdio_copy)) {
 		/* real retval in ufdio_copy.copy */
 		if (uffdio_copy->copy != -EEXIST) {
-			fprintf(stderr, "UFFDIO_COPY retry error %Ld\n",
-				uffdio_copy->copy);
-			exit(1);
+			uffd_error("UFFDIO_COPY retry error",
+				   uffdio_copy->copy);
 		}
-	} else {
-		fprintf(stderr,	"UFFDIO_COPY retry unexpected %Ld\n",
-			uffdio_copy->copy); exit(1);
-	}
+	} else
+		uffd_error("UFFDIO_COPY retry unexpected", uffdio_copy->copy);
 }
 
 static int __copy_page(int ufd, unsigned long offset, bool retry)
@@ -502,15 +508,11 @@ static int __copy_page(int ufd, unsigned
 	uffdio_copy.copy = 0;
 	if (ioctl(ufd, UFFDIO_COPY, &uffdio_copy)) {
 		/* real retval in ufdio_copy.copy */
-		if (uffdio_copy.copy != -EEXIST) {
-			fprintf(stderr, "UFFDIO_COPY error %Ld\n",
-				uffdio_copy.copy);
-			exit(1);
-		}
-	} else if (uffdio_copy.copy != page_size) {
-		fprintf(stderr, "UFFDIO_COPY unexpected copy %Ld\n",
-			uffdio_copy.copy); exit(1);
-	} else {
+		if (uffdio_copy.copy != -EEXIST)
+			uffd_error("UFFDIO_COPY error", uffdio_copy.copy);
+	} else if (uffdio_copy.copy != page_size)
+		uffd_error("UFFDIO_COPY unexpected copy", uffdio_copy.copy);
+	else {
 		if (test_uffdio_copy_eexist && retry) {
 			test_uffdio_copy_eexist = false;
 			retry_copy_page(ufd, &uffdio_copy, offset);
@@ -788,7 +790,8 @@ static int userfaultfd_open(int features
 		return 1;
 	}
 	if (uffdio_api.api != UFFD_API) {
-		fprintf(stderr, "UFFDIO_API error %Lu\n", uffdio_api.api);
+		fprintf(stderr, "UFFDIO_API error: %" PRIu64 "\n",
+			(uint64_t)uffdio_api.api);
 		return 1;
 	}
 
@@ -950,13 +953,12 @@ static void retry_uffdio_zeropage(int uf
 				     offset);
 	if (ioctl(ufd, UFFDIO_ZEROPAGE, uffdio_zeropage)) {
 		if (uffdio_zeropage->zeropage != -EEXIST) {
-			fprintf(stderr, "UFFDIO_ZEROPAGE retry error %Ld\n",
-				uffdio_zeropage->zeropage);
-			exit(1);
+			uffd_error("UFFDIO_ZEROPAGE retry error",
+				   uffdio_zeropage->zeropage);
 		}
 	} else {
-		fprintf(stderr, "UFFDIO_ZEROPAGE retry unexpected %Ld\n",
-			uffdio_zeropage->zeropage); exit(1);
+		uffd_error("UFFDIO_ZEROPAGE retry unexpected",
+			   uffdio_zeropage->zeropage);
 	}
 }
 
@@ -979,26 +981,20 @@ static int __uffdio_zeropage(int ufd, un
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
+			uffd_error(uffdio_zeropage.zeropage == -EEXIST ?
+						 "UFFDIO_ZEROPAGE -EEXIST" :
+						 "UFFDIO_ZEROPAGE error",
+				   uffdio_zeropage.zeropage);
 		} else {
 			if (uffdio_zeropage.zeropage != -EINVAL) {
-				fprintf(stderr,
-					"UFFDIO_ZEROPAGE not -EINVAL %Ld\n",
-					uffdio_zeropage.zeropage);
-				exit(1);
+				uffd_error("UFFDIO_ZEROPAGE not -EINVAL",
+					   uffdio_zeropage.zeropage);
 			}
 		}
 	} else if (has_zeropage) {
 		if (uffdio_zeropage.zeropage != page_size) {
-			fprintf(stderr, "UFFDIO_ZEROPAGE unexpected %Ld\n",
-				uffdio_zeropage.zeropage); exit(1);
+			uffd_error("UFFDIO_ZEROPAGE unexpected",
+				   uffdio_zeropage.zeropage);
 		} else {
 			if (test_uffdio_zeropage_eexist && retry) {
 				test_uffdio_zeropage_eexist = false;
@@ -1008,9 +1004,8 @@ static int __uffdio_zeropage(int ufd, un
 			return 1;
 		}
 	} else {
-		fprintf(stderr,
-			"UFFDIO_ZEROPAGE succeeded %Ld\n",
-			uffdio_zeropage.zeropage); exit(1);
+		uffd_error("UFFDIO_ZEROPAGE succeeded",
+			   uffdio_zeropage.zeropage);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mmap_lock-add-tracepoints-around-lock-acquisition.patch
mmap_lock-add-tracepoints-around-lock-acquisition-fix.patch
userfaultfd-selftests-make-__su64-format-specifiers-portable.patch


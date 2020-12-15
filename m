Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618E9C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3437120791
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgLOCV0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:21:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbgLOCV0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:21:26 -0500
Date:   Mon, 14 Dec 2020 18:20:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998845;
        bh=d4EBpjwkQjorVFv0fIVEokL27ISqDmtqhLPuIj00qX8=;
        h=From:To:Subject:From;
        b=OhYC2MyvouMw/rhUirsZGb+LtG0zIaciGDF5upv4CYDSBxgMVSZunEWopWuDobgxz
         w33cFSsdGzpCQf2G41jvvIcVsB78lzQV38wUxskq1R0DZyHhdXBUxGX41lsDGfcvPu
         HHQstFBMSxnKGekAAz4oTfBTllZxPGt/1FlguM/Y=
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com, dgilbert@redhat.com,
        gthelen@google.com, joe@perches.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, shuah@kernel.org
Subject:  [folded-merged]
 userfaultfd-selftests-make-__su64-format-specifiers-portable-v2.patch
 removed from -mm tree
Message-ID: <20201215022044.daBQdWXBu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-selftests-make-__su64-format-specifiers-portable-v2
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-make-__su64-format-specifiers-portable-v2.patch

This patch was dropped because it was folded into userfaultfd-selftests-make-__su64-format-specifiers-portable.patch

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd-selftests-make-__su64-format-specifiers-portable-v2

Link: https://lkml.kernel.org/r/20201203180244.1811601-1-axelrasmussen@google.com
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

 tools/testing/selftests/vm/userfaultfd.c |   60 +++++++++------------
 1 file changed, 27 insertions(+), 33 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-make-__su64-format-specifiers-portable-v2
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -137,11 +137,12 @@ static void usage(void)
 	exit(1);
 }
 
-static void uffd_error(const char *message, __s64 code)
-{
-	fprintf(stderr, "%s: %" PRId64 "\n", message, (int64_t)code);
-	exit(1);
-}
+#define uffd_error(code, fmt, ...)                                             \
+	do {                                                                   \
+		fprintf(stderr, fmt, ##__VA_ARGS__);                           \
+		fprintf(stderr, ": %" PRId64 "\n", (int64_t)(code));           \
+		exit(1);                                                       \
+	} while (0)
 
 static void uffd_stats_reset(struct uffd_stats *uffd_stats,
 			     unsigned long n_cpus)
@@ -490,11 +491,11 @@ static void retry_copy_page(int ufd, str
 	if (ioctl(ufd, UFFDIO_COPY, uffdio_copy)) {
 		/* real retval in ufdio_copy.copy */
 		if (uffdio_copy->copy != -EEXIST) {
-			uffd_error("UFFDIO_COPY retry error",
-				   uffdio_copy->copy);
+			uffd_error(uffdio_copy->copy,
+				   "UFFDIO_COPY retry error");
 		}
 	} else
-		uffd_error("UFFDIO_COPY retry unexpected", uffdio_copy->copy);
+		uffd_error(uffdio_copy->copy, "UFFDIO_COPY retry unexpected");
 }
 
 static int __copy_page(int ufd, unsigned long offset, bool retry)
@@ -516,10 +517,10 @@ static int __copy_page(int ufd, unsigned
 	if (ioctl(ufd, UFFDIO_COPY, &uffdio_copy)) {
 		/* real retval in ufdio_copy.copy */
 		if (uffdio_copy.copy != -EEXIST)
-			uffd_error("UFFDIO_COPY error", uffdio_copy.copy);
-	} else if (uffdio_copy.copy != page_size)
-		uffd_error("UFFDIO_COPY unexpected copy", uffdio_copy.copy);
-	else {
+			uffd_error(uffdio_copy.copy, "UFFDIO_COPY error");
+	} else if (uffdio_copy.copy != page_size) {
+		uffd_error(uffdio_copy.copy, "UFFDIO_COPY unexpected copy");
+	} else {
 		if (test_uffdio_copy_eexist && retry) {
 			test_uffdio_copy_eexist = false;
 			retry_copy_page(ufd, &uffdio_copy, offset);
@@ -960,12 +961,12 @@ static void retry_uffdio_zeropage(int uf
 				     offset);
 	if (ioctl(ufd, UFFDIO_ZEROPAGE, uffdio_zeropage)) {
 		if (uffdio_zeropage->zeropage != -EEXIST) {
-			uffd_error("UFFDIO_ZEROPAGE retry error",
-				   uffdio_zeropage->zeropage);
+			uffd_error(uffdio_zeropage->zeropage,
+				   "UFFDIO_ZEROPAGE retry error");
 		}
 	} else {
-		uffd_error("UFFDIO_ZEROPAGE retry unexpected",
-			   uffdio_zeropage->zeropage);
+		uffd_error(uffdio_zeropage->zeropage,
+			   "UFFDIO_ZEROPAGE retry unexpected");
 	}
 }
 
@@ -974,6 +975,7 @@ static int __uffdio_zeropage(int ufd, un
 	struct uffdio_zeropage uffdio_zeropage;
 	int ret;
 	unsigned long has_zeropage;
+	__s64 res;
 
 	has_zeropage = uffd_test_ops->expected_ioctls & (1 << _UFFDIO_ZEROPAGE);
 
@@ -985,23 +987,17 @@ static int __uffdio_zeropage(int ufd, un
 	uffdio_zeropage.range.len = page_size;
 	uffdio_zeropage.mode = 0;
 	ret = ioctl(ufd, UFFDIO_ZEROPAGE, &uffdio_zeropage);
+	res = uffdio_zeropage.zeropage;
 	if (ret) {
 		/* real retval in ufdio_zeropage.zeropage */
 		if (has_zeropage) {
-			uffd_error(uffdio_zeropage.zeropage == -EEXIST ?
-						 "UFFDIO_ZEROPAGE -EEXIST" :
-						 "UFFDIO_ZEROPAGE error",
-				   uffdio_zeropage.zeropage);
-		} else {
-			if (uffdio_zeropage.zeropage != -EINVAL) {
-				uffd_error("UFFDIO_ZEROPAGE not -EINVAL",
-					   uffdio_zeropage.zeropage);
-			}
-		}
+			uffd_error(res, "UFFDIO_ZEROPAGE %s",
+				   res == -EEXIST ? "-EEXIST" : "error");
+		} else if (res != -EINVAL)
+			uffd_error(res, "UFFDIO_ZEROPAGE not -EINVAL");
 	} else if (has_zeropage) {
-		if (uffdio_zeropage.zeropage != page_size) {
-			uffd_error("UFFDIO_ZEROPAGE unexpected",
-				   uffdio_zeropage.zeropage);
+		if (res != page_size) {
+			uffd_error(res, "UFFDIO_ZEROPAGE unexpected");
 		} else {
 			if (test_uffdio_zeropage_eexist && retry) {
 				test_uffdio_zeropage_eexist = false;
@@ -1010,10 +1006,8 @@ static int __uffdio_zeropage(int ufd, un
 			}
 			return 1;
 		}
-	} else {
-		uffd_error("UFFDIO_ZEROPAGE succeeded",
-			   uffdio_zeropage.zeropage);
-	}
+	} else
+		uffd_error(res, "UFFDIO_ZEROPAGE succeeded");
 
 	return 0;
 }
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mmap_lock-add-tracepoints-around-lock-acquisition.patch
userfaultfd-selftests-make-__su64-format-specifiers-portable.patch


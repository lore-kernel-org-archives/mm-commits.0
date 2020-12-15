Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26FBC47434
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A26822CAE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgLPAAQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:32864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730091AbgLOX1Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:16 -0500
Date:   Tue, 15 Dec 2020 15:17:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074232;
        bh=RKr8UW+zsAXSeQlgZowi6JCJHHuqpdmop0QBU6308Yw=;
        h=From:To:Subject:From;
        b=N7JqMpSKToReXnOhUA1x8rQpCK98mtCdM5BMVnbTGdfKhOkO8qO/K5xWICYnneuvZ
         gY/GGFi5wSCF7cOe2fK1uED1daF0vsPpSpJa9KAQpSMrsvK2LJqqkMTN3fYpPKW2j4
         4vn7eUk2EV3LpSZANZWjW8mKfXoOFU4zdoKNf8uk=
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [merged] selftests-vm-use-a-common-gup_testh.patch
 removed from -mm tree
Message-ID: <20201215231712.I1GXIIKfK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: use a common gup_test.h
has been removed from the -mm tree.  Its filename was
     selftests-vm-use-a-common-gup_testh.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: use a common gup_test.h

Avoid the need to copy-paste the gup_test ioctl commands and the struct
gup_test definition, between the kernel and the user space application, by
providing a new header file for these.  This allows easier and safer
adding of new ioctl calls, as well as reducing the overall line count.

Details: The header file has to be able to compile independently, because
of the arguably unfortunate way that the Makefile is written: the Makefile
tries to build all of its prerequisites, when really it should be only
building the .c files, and leaving the other prerequisites (LOCAL_HDRS) as
pure dependencies.

That Makefile limitation is probably not worth fixing, but it explains why
one of the includes had to be moved into the new header file.

Also: simplify the ioctl struct (struct gup_test), by deleting the unused
__expansion[10] field.  This sort of thing is what you might see in a
stable ABI, but this low-level, kernel-developer-oriented selftests/vm
system is very much not subject to ABI stability.  So "expansion" and
"reserved" fields are unnecessary here.

Link: https://lkml.kernel.org/r/20201026064021.3545418-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c                         |   17 +----------------
 mm/gup_test.h                         |   22 ++++++++++++++++++++++
 tools/testing/selftests/vm/Makefile   |    2 ++
 tools/testing/selftests/vm/gup_test.c |   22 +---------------------
 4 files changed, 26 insertions(+), 37 deletions(-)

--- a/mm/gup_test.c~selftests-vm-use-a-common-gup_testh
+++ a/mm/gup_test.c
@@ -4,22 +4,7 @@
 #include <linux/uaccess.h>
 #include <linux/ktime.h>
 #include <linux/debugfs.h>
-
-#define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_test)
-#define GUP_BENCHMARK		_IOWR('g', 2, struct gup_test)
-#define PIN_FAST_BENCHMARK	_IOWR('g', 3, struct gup_test)
-#define PIN_BENCHMARK		_IOWR('g', 4, struct gup_test)
-#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_test)
-
-struct gup_test {
-	__u64 get_delta_usec;
-	__u64 put_delta_usec;
-	__u64 addr;
-	__u64 size;
-	__u32 nr_pages_per_call;
-	__u32 flags;
-	__u64 expansion[10];	/* For future use */
-};
+#include "gup_test.h"
=20
 static void put_back_pages(unsigned int cmd, struct page **pages,
 			   unsigned long nr_pages)
--- /dev/null
+++ a/mm/gup_test.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef __GUP_TEST_H
+#define __GUP_TEST_H
+
+#include <linux/types.h>
+
+#define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_test)
+#define GUP_BENCHMARK		_IOWR('g', 2, struct gup_test)
+#define PIN_FAST_BENCHMARK	_IOWR('g', 3, struct gup_test)
+#define PIN_BENCHMARK		_IOWR('g', 4, struct gup_test)
+#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_test)
+
+struct gup_test {
+	__u64 get_delta_usec;
+	__u64 put_delta_usec;
+	__u64 addr;
+	__u64 size;
+	__u32 nr_pages_per_call;
+	__u32 flags;
+};
+
+#endif	/* __GUP_TEST_H */
--- a/tools/testing/selftests/vm/gup_test.c~selftests-vm-use-a-common-gup_t=
esth
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -2,39 +2,19 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
-
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/prctl.h>
 #include <sys/stat.h>
 #include <sys/types.h>
-
-#include <linux/types.h>
+#include "../../../../mm/gup_test.h"
=20
 #define MB (1UL << 20)
 #define PAGE_SIZE sysconf(_SC_PAGESIZE)
=20
-#define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_test)
-#define GUP_BENCHMARK		_IOWR('g', 2, struct gup_test)
-
-/* Similar to above, but use FOLL_PIN instead of FOLL_GET. */
-#define PIN_FAST_BENCHMARK	_IOWR('g', 3, struct gup_test)
-#define PIN_BENCHMARK		_IOWR('g', 4, struct gup_test)
-#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_test)
-
 /* Just the flags we need, copied from mm.h: */
 #define FOLL_WRITE	0x01	/* check pte is writable */
=20
-struct gup_test {
-	__u64 get_delta_usec;
-	__u64 put_delta_usec;
-	__u64 addr;
-	__u64 size;
-	__u32 nr_pages_per_call;
-	__u32 flags;
-	__u64 expansion[10];	/* For future use */
-};
-
 int main(int argc, char **argv)
 {
 	struct gup_test gup;
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-use-a-common-gup_tes=
th
+++ a/tools/testing/selftests/vm/Makefile
@@ -134,3 +134,5 @@ endif
 $(OUTPUT)/userfaultfd: LDLIBS +=3D -lpthread
=20
 $(OUTPUT)/mlock-random-test: LDLIBS +=3D -lcap
+
+$(OUTPUT)/gup_test: ../../../../mm/gup_test.h
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch


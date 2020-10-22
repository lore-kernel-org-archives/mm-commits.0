Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83002C5517A
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 22:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CF3524641
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 22:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603407017;
	bh=l5/oVEGstOrM1v2A9WmBzQPqY6lNUorv5TzToL1DFIo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vM4bE9gGOmnCj1XSWCT0rKfhsT7rLZ2NjldSyBMR8ELMMSNnlIOmjh7TsWyeQWkLK
	 N5L4+zbPfGJ26tTmznsmo7f5VfGcjvk5iclc3IpfBu6JNsmv2otOwy8xlT3Ax2rg/o
	 hxFrnM3dqo0OMFo0irRkIpHCKkW5yLSlEaydOcd8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373089AbgJVWuR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 18:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S372983AbgJVWuQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 18:50:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0889223C7;
        Thu, 22 Oct 2020 22:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603407015;
        bh=l5/oVEGstOrM1v2A9WmBzQPqY6lNUorv5TzToL1DFIo=;
        h=Date:From:To:Subject:From;
        b=lOl1NeagXHeiLG2IHtUS5pDpMR2hNl6RrTLoCvU2mAmkULkIP1h8EySIAtx++oCvp
         5TNpvN9+W3o896ZqPZQsSwUwlpB+dZAmAZrr6/S0tKxg+9Np38XWA2XJK96HhKv674
         1imf5PzWImwjgMf0ox7pSqKn+obkszxBJQ7v/VAk=
Date:   Thu, 22 Oct 2020 15:50:15 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [to-be-updated] selftests-vm-use-a-common-gup_testh.patch
 removed from -mm tree
Message-ID: <20201022225015.ySJKRsDWs%akpm@linux-foundation.org>
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

This patch was dropped because an updated version will be merged

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

Link: https://lkml.kernel.org/r/20200929212747.251804-3-jhubbard@nvidia.com
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
+#include "../../../../mm/gup_test.h"
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
-#define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_benchmark)
-#define GUP_BENCHMARK		_IOWR('g', 2, struct gup_benchmark)
-
-/* Similar to above, but use FOLL_PIN instead of FOLL_GET. */
-#define PIN_FAST_BENCHMARK	_IOWR('g', 3, struct gup_benchmark)
-#define PIN_BENCHMARK		_IOWR('g', 4, struct gup_benchmark)
-#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_benchmark)
-
 /* Just the flags we need, copied from mm.h: */
 #define FOLL_WRITE	0x01	/* check pte is writable */
=20
-struct gup_benchmark {
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
 	struct gup_benchmark gup;
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-use-a-common-gup_tes=
th
+++ a/tools/testing/selftests/vm/Makefile
@@ -130,3 +130,5 @@ endif
 $(OUTPUT)/userfaultfd: LDLIBS +=3D -lpthread
=20
 $(OUTPUT)/mlock-random-test: LDLIBS +=3D -lcap
+
+$(OUTPUT)/gup_test: ../../../../mm/gup_test.h
_

Patches currently in -mm which might be from jhubbard@nvidia.com are



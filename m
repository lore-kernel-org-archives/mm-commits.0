Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B00C4363D
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 440B42075F
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601506339;
	bh=GzeI44IVEtTrO+JYOijZ9D1JUzzAY/gxmKUYVPlpmFc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=s8bUpGNu5a86DcSn6Bqe+3dbsUsNNGY/rYfQv8ADqRKFStmd7G4miMOBAquYkYa0t
	 oocnL6iHfVRGWRWnPLnAfe577FBtw3ryvCX8GYyDAETpLYAz87YTY2Qe5HuCwGFNyN
	 U2xivdqfux8KjsWhWT5DyO32XpPpU++zmqsqZgMs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731921AbgI3WwT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731913AbgI3WwS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 18:52:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0287F20719;
        Wed, 30 Sep 2020 22:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601506338;
        bh=GzeI44IVEtTrO+JYOijZ9D1JUzzAY/gxmKUYVPlpmFc=;
        h=Date:From:To:Subject:From;
        b=oZjcbvzw8Zw30IwVY9sc9IahGdhekwB6J9kEF9QddqgHQKjIbCoVuV6T4bjv+kesR
         EAK+4cwpfUKSdOCdUAVWSd5ufgGlEM0qH+1PPj1Ib34vAzq+ed/Y/LSU2a+1Di47AP
         O0SViIY6skOrfbqXiTP0GaZjX7WvZfUr3JiKK7iA=
Date:   Wed, 30 Sep 2020 15:52:17 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  +
 selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch added to
 -mm tree
Message-ID: <20200930225217.ig31S279F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: hmm-tests: remove the libhugetlbfs dependency
has been added to the -mm tree.  Its filename is
     selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-hmm-tests-remove=
-the-libhugetlbfs-dependency.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-hmm-tests-remove=
-the-libhugetlbfs-dependency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: hmm-tests: remove the libhugetlbfs dependency

HMM selftests are incredibly useful, but they are only effective if people
actually build and run them.  All the other tests in selftests/vm can be
built with very standard, always-available libraries: libpthread, librt.=20
The hmm-tests.c program, on the other hand, requires something that is
(much) less readily available: libhugetlbfs.  And so the build will
typically fail for many developers.

A simple attempt to install libhugetlbfs will also run into complications
on some common distros these days: Fedora and Arch Linux (yes, Arch AUR
has it, but that's fragile, as always with AUR).  The library is not
maintained actively enough at the moment, for distros to deal with it.  I
had to build it from source, for Fedora, and that didn't go too smoothly
either.

It turns out that, out of 21 tests in hmm-tests.c, only 2 actually require
functionality from libhugetlbfs.  Therefore, if libhugetlbfs is missing,
simply ifdef those two tests out and allow the developer to at least have
the other 19 tests, if they don't want to pause to work through the above
issues.  Also issue a warning, so that it's clear that there is an
imperfection in the build.

In order to do that, a tiny shell script (check_config.sh) runs a quick
compile (not link, that's too prone to false failures with library paths),
and basically, if the compiler doesn't find hugetlbfs.h in its standard
locations, then the script concludes that libhugetlbfs is not available.=20
The output is in two files, one for inclusion in hmm-test.c
(local_config.h), and one for inclusion in the Makefile (local_config.mk).

Link: https://lkml.kernel.org/r/20200929212747.251804-9-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore      |    1=20
 tools/testing/selftests/vm/Makefile        |   24 +++++++++++++-
 tools/testing/selftests/vm/check_config.sh |   31 +++++++++++++++++++
 tools/testing/selftests/vm/hmm-tests.c     |   10 +++++-
 4 files changed, 63 insertions(+), 3 deletions(-)

--- /dev/null
+++ a/tools/testing/selftests/vm/check_config.sh
@@ -0,0 +1,31 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Probe for libraries and create header files to record the results. Both C
+# header files and Makefile include fragments are created.
+
+OUTPUT_H_FILE=3Dlocal_config.h
+OUTPUT_MKFILE=3Dlocal_config.mk
+
+# libhugetlbfs
+tmpname=3D$(mktemp)
+tmpfile_c=3D${tmpname}.c
+tmpfile_o=3D${tmpname}.o
+
+echo "#include <sys/types.h>"        > $tmpfile_c
+echo "#include <hugetlbfs.h>"       >> $tmpfile_c
+echo "int func(void) { return 0; }" >> $tmpfile_c
+
+CC=3D${1:?"Usage: $0 <compiler> # example compiler: gcc"}
+$CC -c $tmpfile_c -o $tmpfile_o >/dev/null 2>&1
+
+if [ -f $tmpfile_o ]; then
+    echo "#define LOCAL_CONFIG_HAVE_LIBHUGETLBFS 1" > $OUTPUT_H_FILE
+    echo "HMM_EXTRA_LIBS =3D -lhugetlbfs"             > $OUTPUT_MKFILE
+else
+    echo "// No libhugetlbfs support found"      > $OUTPUT_H_FILE
+    echo "# No libhugetlbfs support found, so:"  > $OUTPUT_MKFILE
+    echo "HMM_EXTRA_LIBS =3D "                    >> $OUTPUT_MKFILE
+fi
+
+rm ${tmpname}.*
--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-hmm-tests-remove-t=
he-libhugetlbfs-dependency
+++ a/tools/testing/selftests/vm/.gitignore
@@ -20,3 +20,4 @@ va_128TBswitch
 map_fixed_noreplace
 write_to_hugetlbfs
 hmm-tests
+local_config.*
--- a/tools/testing/selftests/vm/hmm-tests.c~selftests-vm-hmm-tests-remove-=
the-libhugetlbfs-dependency
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -21,12 +21,16 @@
 #include <strings.h>
 #include <time.h>
 #include <pthread.h>
-#include <hugetlbfs.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <sys/ioctl.h>
=20
+#include "./local_config.h"
+#ifdef LOCAL_CONFIG_HAVE_LIBHUGETLBFS
+#include <hugetlbfs.h>
+#endif
+
 /*
  * This is a private UAPI to the kernel test module so it isn't exported
  * in the usual include/uapi/... directory.
@@ -662,6 +666,7 @@ TEST_F(hmm, anon_write_huge)
 	hmm_buffer_free(buffer);
 }
=20
+#ifdef LOCAL_CONFIG_HAVE_LIBHUGETLBFS
 /*
  * Write huge TLBFS page.
  */
@@ -720,6 +725,7 @@ TEST_F(hmm, anon_write_hugetlbfs)
 	buffer->ptr =3D NULL;
 	hmm_buffer_free(buffer);
 }
+#endif /* LOCAL_CONFIG_HAVE_LIBHUGETLBFS */
=20
 /*
  * Read mmap'ed file memory.
@@ -1336,6 +1342,7 @@ TEST_F(hmm2, snapshot)
 	hmm_buffer_free(buffer);
 }
=20
+#ifdef LOCAL_CONFIG_HAVE_LIBHUGETLBFS
 /*
  * Test the hmm_range_fault() HMM_PFN_PMD flag for large pages that
  * should be mapped by a large page table entry.
@@ -1411,6 +1418,7 @@ TEST_F(hmm, compound)
 	buffer->ptr =3D NULL;
 	hmm_buffer_free(buffer);
 }
+#endif /* LOCAL_CONFIG_HAVE_LIBHUGETLBFS */
=20
 /*
  * Test two devices reading the same memory (double mapped).
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-hmm-tests-remove-the=
-libhugetlbfs-dependency
+++ a/tools/testing/selftests/vm/Makefile
@@ -1,5 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm selftests
+
+include local_config.mk
+
 uname_M :=3D $(shell uname -m 2>/dev/null || echo not)
 MACHINE ?=3D $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/')
=20
@@ -76,8 +79,6 @@ TEST_FILES :=3D test_vmalloc.sh
 KSFT_KHDR_INSTALL :=3D 1
 include ../lib.mk
=20
-$(OUTPUT)/hmm-tests: LDLIBS +=3D -lhugetlbfs
-
 ifeq ($(ARCH),x86_64)
 BINARIES_32 :=3D $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
 BINARIES_64 :=3D $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
@@ -130,3 +131,22 @@ endif
 $(OUTPUT)/mlock-random-test: LDLIBS +=3D -lcap
=20
 $(OUTPUT)/gup_test: ../../../../mm/gup_test.h
+
+$(OUTPUT)/hmm-tests: local_config.h
+
+# HMM_EXTRA_LIBS may get set in local_config.mk, or it may be left empty.
+$(OUTPUT)/hmm-tests: LDLIBS +=3D $(HMM_EXTRA_LIBS)
+
+local_config.mk local_config.h: check_config.sh
+	./check_config.sh $(CC)
+
+EXTRA_CLEAN +=3D local_config.mk local_config.h
+
+ifeq ($(HMM_EXTRA_LIBS),)
+all: warn_missing_hugelibs
+
+warn_missing_hugelibs:
+	@echo ; \
+	echo "Warning: missing libhugetlbfs support. Some HMM tests will be skipp=
ed." ; \
+	echo
+endif
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch
mm-gup-protect-unpin_user_pages-against-npages=3D=3D-errno.patch
selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch
selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch
mm-gup_benchmark-rename-to-mm-gup_test.patch
selftests-vm-use-a-common-gup_testh.patch
selftests-vm-rename-run_vmtests-run_vmtestssh.patch
selftests-vm-minor-cleanup-makefile-and-gup_testc.patch
selftests-vm-only-some-gup_test-items-are-really-benchmarks.patch
selftests-vm-gup_test-introduce-the-dump_pages-sub-test.patch
selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch


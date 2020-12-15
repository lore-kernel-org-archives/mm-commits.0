Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78744C47436
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 634E122DD6
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgLOX7z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:32846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729874AbgLOX0I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:08 -0500
Date:   Tue, 15 Dec 2020 15:17:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074241;
        bh=/ley1g4JuGCdy9rN/Pc38ppQwsSGUTjdhTJcZ0YoymE=;
        h=From:To:Subject:From;
        b=T6xf2aS/P5OL+2RsoubcmZaH3bYb7A4mUlzjnDd+LXLnwr35hCtN2lDUoGakEhktE
         1/puhLAfWf/3o1r3d6XwSIPVvs9fVJZBTSJcl5/npzUziekpiACZJ6XJ9ZOBOd6Hxz
         ioNOW3dAnnOgkpxO/dl9qr1Jt/9rzOWV+00tf+eU=
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [merged]
 selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch removed
 from -mm tree
Message-ID: <20201215231721.-hPVVM8Q5%akpm@linux-foundation.org>
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
has been removed from the -mm tree.  Its filename was
     selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: hmm-tests: remove the libhugetlbfs dependency

HMM selftests are incredibly useful, but they are only effective if people
actually build and run them.  All the other tests in selftests/vm can be
built with very standard, always-available libraries: libpthread, librt.
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
locations, then the script concludes that libhugetlbfs is not available.
The output is in two files, one for inclusion in hmm-test.c
(local_config.h), and one for inclusion in the Makefile (local_config.mk).

Link: https://lkml.kernel.org/r/20201026064021.3545418-9-jhubbard@nvidia.com
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
@@ -80,8 +83,6 @@ TEST_FILES :=3D test_vmalloc.sh
 KSFT_KHDR_INSTALL :=3D 1
 include ../lib.mk
=20
-$(OUTPUT)/hmm-tests: LDLIBS +=3D -lhugetlbfs
-
 ifeq ($(ARCH),x86_64)
 BINARIES_32 :=3D $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
 BINARIES_64 :=3D $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
@@ -134,3 +135,22 @@ endif
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
+	/bin/sh ./check_config.sh $(CC)
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

secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DEC3C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F34224B2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgLODFk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbgLODFb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:05:31 -0500
Date:   Mon, 14 Dec 2020 19:05:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001515;
        bh=GPMt/Awx8emJaIi7Y/rQOqtixo9pv+LZLtADkcHCE8I=;
        h=From:To:Subject:In-Reply-To:From;
        b=Ov37dmyn+7kz4K5BCuPTF2fhafPVJaRfp9UiWMMP7UA6eYowXb4njCBumilLfksNU
         1c1IPi1seZFJCiescVQInK+9HoDstBskGYskbH+zw++P1uSMFpJoZv0jZNRon6QjTk
         K05P2ShoU5wRBlmF9NzBvIjFKdHVFwvWOxFQmziU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, jglisse@redhat.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 035/200] selftests/vm: minor cleanup: Makefile and
 gup_test.c
Message-ID: <20201215030514.GqVP2YBiz%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: minor cleanup: Makefile and gup_test.c

A few cleanups that don't deserve separate patches, but that also should
not clutter up other functional changes:

1. Remove an unnecessary #include <prctl.h>

2. Restore the sorted order of TEST_GEN_FILES.

3. Add -lpthread to the common LDLIBS, as it is harmless and several
   tests use it. This gets rid of one special rule already.

Link: https://lkml.kernel.org/r/20201026064021.3545418-5-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile   |   10 ++++------
 tools/testing/selftests/vm/gup_test.c |    1 -
 2 files changed, 4 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/vm/gup_test.c~selftests-vm-minor-cleanup-make=
file-and-gup_testc
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -4,7 +4,6 @@
 #include <unistd.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
-#include <sys/prctl.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include "../../../../mm/gup_test.h"
--- a/tools/testing/selftests/vm/Makefile~selftests-vm-minor-cleanup-makefi=
le-and-gup_testc
+++ a/tools/testing/selftests/vm/Makefile
@@ -21,14 +21,15 @@ MACHINE ?=3D $(shell echo $(uname_M) | sed
 MAKEFLAGS +=3D --no-builtin-rules
=20
 CFLAGS =3D -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
-LDLIBS =3D -lrt
+LDLIBS =3D -lrt -lpthread
 TEST_GEN_FILES =3D compaction_test
 TEST_GEN_FILES +=3D gup_test
 TEST_GEN_FILES +=3D hmm-tests
 TEST_GEN_FILES +=3D hugepage-mmap
 TEST_GEN_FILES +=3D hugepage-shm
-TEST_GEN_FILES +=3D map_hugetlb
+TEST_GEN_FILES +=3D khugepaged
 TEST_GEN_FILES +=3D map_fixed_noreplace
+TEST_GEN_FILES +=3D map_hugetlb
 TEST_GEN_FILES +=3D map_populate
 TEST_GEN_FILES +=3D mlock-random-test
 TEST_GEN_FILES +=3D mlock2-tests
@@ -37,7 +38,6 @@ TEST_GEN_FILES +=3D on-fault-limit
 TEST_GEN_FILES +=3D thuge-gen
 TEST_GEN_FILES +=3D transhuge-stress
 TEST_GEN_FILES +=3D userfaultfd
-TEST_GEN_FILES +=3D khugepaged
=20
 ifeq ($(ARCH),x86_64)
 CAN_BUILD_I386 :=3D $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_32bi=
t_program.c -m32)
@@ -80,7 +80,7 @@ TEST_FILES :=3D test_vmalloc.sh
 KSFT_KHDR_INSTALL :=3D 1
 include ../lib.mk
=20
-$(OUTPUT)/hmm-tests: LDLIBS +=3D -lhugetlbfs -lpthread
+$(OUTPUT)/hmm-tests: LDLIBS +=3D -lhugetlbfs
=20
 ifeq ($(ARCH),x86_64)
 BINARIES_32 :=3D $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
@@ -131,8 +131,6 @@ warn_32bit_failure:
 endif
 endif
=20
-$(OUTPUT)/userfaultfd: LDLIBS +=3D -lpthread
-
 $(OUTPUT)/mlock-random-test: LDLIBS +=3D -lcap
=20
 $(OUTPUT)/gup_test: ../../../../mm/gup_test.h
_

Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43868C5517A
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 22:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5A5D24641
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 22:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603407023;
	bh=zGZx2GXZkM2jQsack1ycG9PNxwzimmM9mGhI6sEnit0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=L/B5c2CdkqS2wnPX2Z628uInwqWqv0+BAa2OXm+oknzZ8si4Li7PFuglVewPbzQ0q
	 ewWPXKCBnA/RK/kmcPsx+HdKOTSNklhpL+2PyFLAjNzQ6Y1yrddJoHJltYl2iZL5to
	 EharPE0ULMh0E1BjMiTkfbsRR99du92wwZvwpANE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373093AbgJVWuW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 18:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S372983AbgJVWuW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 18:50:22 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A57CA221EB;
        Thu, 22 Oct 2020 22:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603407022;
        bh=zGZx2GXZkM2jQsack1ycG9PNxwzimmM9mGhI6sEnit0=;
        h=Date:From:To:Subject:From;
        b=jogqdfPvycC5Mud4yk8rI1TBmwz8jDtIzQ6X5/ojzJr3JvPN5MHG0ZwbSlAw2IoKF
         r14XMJosk5gYzZKsjXuVg3OirtfJFKGUDO1VV2QKquM73CNS7+ilSukgP6Rpg6N9yZ
         HaQHhhyMawqAGnjFbdqkRNgQa2fQMopaalq5Lkn4=
Date:   Thu, 22 Oct 2020 15:50:21 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [to-be-updated]
 selftests-vm-minor-cleanup-makefile-and-gup_testc.patch removed from -mm
 tree
Message-ID: <20201022225021.6POZKISZK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: minor cleanup: Makefile and gup_test.c
has been removed from the -mm tree.  Its filename was
     selftests-vm-minor-cleanup-makefile-and-gup_testc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: minor cleanup: Makefile and gup_test.c

A few cleanups that don't deserve separate patches, but that also should
not clutter up other functional changes:

1. Remove an unnecessary #include <prctl.h>

2. Restore the sorted order of TEST_GEN_FILES.

3. Add -lpthread to the common LDLIBS, as it is harmless and several
   tests use it. This gets rid of one special rule already.

Link: https://lkml.kernel.org/r/20200929212747.251804-5-jhubbard@nvidia.com
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
@@ -76,7 +76,7 @@ TEST_FILES :=3D test_vmalloc.sh
 KSFT_KHDR_INSTALL :=3D 1
 include ../lib.mk
=20
-$(OUTPUT)/hmm-tests: LDLIBS +=3D -lhugetlbfs -lpthread
+$(OUTPUT)/hmm-tests: LDLIBS +=3D -lhugetlbfs
=20
 ifeq ($(ARCH),x86_64)
 BINARIES_32 :=3D $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
@@ -127,8 +127,6 @@ warn_32bit_failure:
 endif
 endif
=20
-$(OUTPUT)/userfaultfd: LDLIBS +=3D -lpthread
-
 $(OUTPUT)/mlock-random-test: LDLIBS +=3D -lcap
=20
 $(OUTPUT)/gup_test: ../../../../mm/gup_test.h
_

Patches currently in -mm which might be from jhubbard@nvidia.com are



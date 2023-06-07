Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACF8C77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240772AbjFGCh4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240774AbjFGChl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:37:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7531A19B7
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08E11639D9
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC75C433EF;
        Wed,  7 Jun 2023 02:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686105459;
        bh=9lDalBawEXHopiKfDYU5aCt49e+sUL/rF/QzPMexmKw=;
        h=Date:To:From:Subject:From;
        b=NMdT+cLxD2hFsjcPlP9g/bbfwMRZlGudJwlSIaOuj0YgARcud31lRjdp81NrPuF8c
         UdTlbWLb3age66pCjW32mz/pbhwJ2fnGQBY9pd/sRvpCT83vVYH7aW3tY10J5AzJjg
         n7B4+wLtwzJTutO1zSGMqD2hEUazbKC6JzR11GC8=
Date:   Tue, 06 Jun 2023 19:37:38 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-error-out-if-kernel-header-files-are-not-yet-built-fix.patch added to mm-unstable branch
Message-Id: <20230607023739.5BC75C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-error-out-if-kernel-header-files-are-not-yet-built-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-error-out-if-kernel-header-files-are-not-yet-built-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-error-out-if-kernel-header-files-are-not-yet-built-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests-error-out-if-kernel-header-files-are-not-yet-built-fix
Date: Tue, 6 Jun 2023 13:10:23 -0700

abort the make process the first time headers aren't detected

Link: https://lkml.kernel.org/r/14573e7e-f2ad-ff34-dfbd-3efdebee51ed@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/Makefile~selftests-error-out-if-kernel-header-files-are-not-yet-built-fix
+++ a/tools/testing/selftests/Makefile
@@ -145,10 +145,12 @@ ifneq ($(KBUILD_OUTPUT),)
   abs_objtree := $(realpath $(abs_objtree))
   BUILD := $(abs_objtree)/kselftest
   KHDR_INCLUDES := -isystem ${abs_objtree}/usr/include
+  KHDR_DIR := ${abs_objtree}/usr/include
 else
   BUILD := $(CURDIR)
   abs_srctree := $(shell cd $(top_srcdir) && pwd)
   KHDR_INCLUDES := -isystem ${abs_srctree}/usr/include
+  KHDR_DIR := ${abs_srctree}/usr/include
   DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
@@ -162,7 +164,7 @@ export KHDR_INCLUDES
 # all isn't the first target in the file.
 .DEFAULT_GOAL := all
 
-all:
+all: kernel_header_files
 	@ret=1;							\
 	for TARGET in $(TARGETS); do				\
 		BUILD_TARGET=$$BUILD/$$TARGET;			\
@@ -173,6 +175,23 @@ all:
 		ret=$$((ret * $$?));				\
 	done; exit $$ret;
 
+kernel_header_files:
+	@ls $(KHDR_DIR)/linux/*.h >/dev/null 2>/dev/null;                          \
+	if [ $$? -ne 0 ]; then                                                     \
+            RED='\033[1;31m';                                                  \
+            NOCOLOR='\033[0m';                                                 \
+            echo;                                                              \
+            echo -e "$${RED}error$${NOCOLOR}: missing kernel header files.";   \
+            echo "Please run this and try again:";                             \
+            echo;                                                              \
+            echo "    cd $(top_srcdir)";                                       \
+            echo "    make headers";                                           \
+            echo;                                                              \
+	    exit 1;                                                                \
+	fi
+
+.PHONY: kernel_header_files
+
 run_tests: all
 	@for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-fix-uffd-stress-unused-function-warning.patch
selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc.patch
selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc.patch
selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch
selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch
selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds.patch
selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch
selftests-mm-fix-build-failures-due-to-missing-madv_collapse.patch
selftests-mm-move-certain-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
documentation-kselftest-make-headers-is-a-prerequisite.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built-fix.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB72C7EE2A
	for <mm-commits@archiver.kernel.org>; Mon,  5 Jun 2023 21:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjFEVaA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Jun 2023 17:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjFEV37 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2023 17:29:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC4E10E
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 14:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E00F262AF7
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 21:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412E3C433EF;
        Mon,  5 Jun 2023 21:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686000596;
        bh=Wv1dRsxUl3fLop8C6nNmLsW6dTI4lq+mpdhJozfbtbk=;
        h=Date:To:From:Subject:From;
        b=LUoFeCpCf1sBPKLqUZL/zbsvRn6PsleFu0v9uAnlfZSFolXjlbWYQTayvg3/8T99g
         ni1wFiQrrR+bOBlp3GeWC+9COPuDLGbF5NSRn4Fan4sgeyHPbASxnJScqX+5wzhO0c
         2t/q3Tdd7mvlzLlPiKQGQTdMUJZAufGNy/4KVr7U=
Date:   Mon, 05 Jun 2023 14:29:55 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-error-out-if-kernel-header-files-are-not-yet-built.patch added to mm-nonmm-unstable branch
Message-Id: <20230605212956.412E3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: error out if kernel header files are not yet built
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-error-out-if-kernel-header-files-are-not-yet-built.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-error-out-if-kernel-header-files-are-not-yet-built.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: selftests: error out if kernel header files are not yet built
Date: Sat, 3 Jun 2023 18:36:37 -0700

As per a discussion with Muhammad Usama Anjum [1], the following is how
one is supposed to build selftests:

    make headers && make -C tools/testing/selftests/mm

Change the selftest build system's lib.mk to fail out with a helpful
message if that prerequisite "make headers" has not been done yet.

[1] https://lore.kernel.org/all/bf910fa5-0c96-3707-cce4-5bcc656b6274@collabora.com/

Link: https://lkml.kernel.org/r/20230604013637.203330-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/lib.mk |   36 ++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/lib.mk~selftests-error-out-if-kernel-header-files-are-not-yet-built
+++ a/tools/testing/selftests/lib.mk
@@ -44,10 +44,22 @@ endif
 selfdir = $(realpath $(dir $(filter %/lib.mk,$(MAKEFILE_LIST))))
 top_srcdir = $(selfdir)/../../..
 
-ifeq ($(KHDR_INCLUDES),)
-KHDR_INCLUDES := -isystem $(top_srcdir)/usr/include
+ifneq ($(KBUILD_OUTPUT),)
+  # Make's built-in functions such as $(abspath ...), $(realpath ...) cannot
+  # expand a shell special character '~'. We use a somewhat tedious way here.
+  abs_objtree := $(shell cd $(top_srcdir) && mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) && pwd)
+  $(if $(abs_objtree),, \
+    $(error failed to create output directory "$(KBUILD_OUTPUT)"))
+  # $(realpath ...) resolves symlinks
+  abs_objtree := $(realpath $(abs_objtree))
+  KHDR_DIR := ${abs_objtree}/usr/include
+else
+  abs_srctree := $(shell cd $(top_srcdir) && pwd)
+  KHDR_DIR := ${abs_srctree}/usr/include
 endif
 
+KHDR_INCLUDES := -isystem $(KHDR_DIR)
+
 # The following are built by lib.mk common compile rules.
 # TEST_CUSTOM_PROGS should be used by tests that require
 # custom build rule and prevent common build rule use.
@@ -58,7 +70,25 @@ TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)
 TEST_GEN_PROGS_EXTENDED := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS_EXTENDED))
 TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
 
-all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
+all: kernel_header_files $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) \
+     $(TEST_GEN_FILES)
+
+kernel_header_files:
+	@ls $(KHDR_DIR)/linux/*.h >/dev/null 2>/dev/null;                      \
+	if [ $$? -ne 0 ]; then                                                 \
+            RED='\033[1;31m';                                                  \
+            NOCOLOR='\033[0m';                                                 \
+            echo;                                                              \
+            echo -e "$${RED}error$${NOCOLOR}: missing kernel header files.";   \
+            echo "Please run this and try again:";                             \
+            echo;                                                              \
+            echo "    cd $(top_srcdir)";                                       \
+            echo "    make headers";                                           \
+            echo;                                                              \
+	    exit 1; \
+	fi
+
+.PHONY: kernel_header_files
 
 define RUN_TESTS
 	BASE_DIR="$(selfdir)";			\
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-fix-uffd-stress-unused-function-warning.patch
selftests-mm-fix-unused-variable-warning-in-hugetlb-madvisec.patch
selftests-mm-fix-unused-variable-warning-in-migrationc.patch
selftests-mm-fix-a-char-assignment-in-mlock2-testsc.patch
selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch
selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch
selftests-mm-set-wno-format-security-to-avoid-uffd-build-warnings.patch
selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch
selftests-mm-move-psize-pshift-into-vm_utilsc.patch
selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
selftests-mm-fix-missing-uffdio_continue_mode_wp-and-similar-build-failures.patch
selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built.patch


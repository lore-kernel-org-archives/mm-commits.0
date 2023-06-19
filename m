Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB21EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjFSXI6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFSXI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:08:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99538F9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:08:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4AE560EF6
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38013C433C8;
        Mon, 19 Jun 2023 23:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216135;
        bh=Twq8qFVmkEmn57LfKnyC62CA55Q82ERTgI7GyNpDLT0=;
        h=Date:To:From:Subject:From;
        b=iKGiy7Uol4rGT4bbmdWQzGtwfZPShj4hcMKvHvk2KOH/P7b0vM+YSMopoBikyMJCx
         +B91PKi7QzS4E3Q2IyyVF1nz414Hw9feg5kXtMf28op5nq59IHfqr07zYzWeGNqYqk
         Mo1L2sbOxUSbkRmAnhp9H/3pbudRiJJUFyEIQIks=
Date:   Mon, 19 Jun 2023 16:08:54 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-error-out-if-kernel-header-files-are-not-yet-built-fix.patch removed from -mm tree
Message-Id: <20230619230855.38013C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests-error-out-if-kernel-header-files-are-not-yet-built-fix
has been removed from the -mm tree.  Its filename was
     selftests-error-out-if-kernel-header-files-are-not-yet-built-fix.patch

This patch was dropped because it was folded into selftests-error-out-if-kernel-header-files-are-not-yet-built.patch

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


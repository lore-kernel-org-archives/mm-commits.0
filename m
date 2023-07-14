Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EFFC001DC
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jul 2023 18:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbjGNSM7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jul 2023 14:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbjGNSM5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2023 14:12:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41ECD3C33
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 11:12:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2916561D34
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 18:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81970C433C7;
        Fri, 14 Jul 2023 18:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689358333;
        bh=+p2tRQHk5I5iW0g/4bkLP0e2e6hUoqh9OyMmtjllQkc=;
        h=Date:To:From:Subject:From;
        b=Nsm9yScUrROumBtwe4JMsWRNYegqXdADltnDGpHUc1M/qCJJE5o50zTUKw5AEDPHM
         AiljAzvfWhjQ4QOoYzo6hyTZbGMAgZLffMO+0kHB7UwvG9wSxH6o3usxdlB3aBxr7X
         LL1yySg2iQp1QnPMEWRdK9Wj9b7hpr6jb4PZrP5I=
Date:   Fri, 14 Jul 2023 11:12:12 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, jhubbard@nvidia.com, anders.roxell@linaro.org,
        broonie@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-fix-arm64-test-installation.patch removed from -mm tree
Message-Id: <20230714181213.81970C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: fix arm64 test installation
has been removed from the -mm tree.  Its filename was
     selftests-fix-arm64-test-installation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests: fix arm64 test installation
Date: Mon, 10 Jul 2023 15:04:21 +0100

The recent change 9fc96c7c19df ("selftests: error out if kernel header
files are not yet built") to generate an error message when building
kselftests without having installed the headers is generating spurious
failures during the install step which breaks the arm64 selftests (and
only the arm64 selftests):

Emit Tests for arm64
make[5]: *** [../../lib.mk:81: kernel_header_files] Error 1
make[5]: *** [../../lib.mk:81: kernel_header_files] Error 1
make[5]: *** [../../lib.mk:81: kernel_header_files] Error 1
make[5]: *** [../../lib.mk:81: kernel_header_files] Error 1
make[5]: *** [../../lib.mk:81: kernel_header_files] Error 1
make[5]: *** [../../lib.mk:81: kernel_header_files] Error 1
make[5]: *** [../../lib.mk:81: kernel_header_files] Error 1
make[4]: *** [Makefile:26: all] Error 2

Presumably the arm64 tests are doing something unusual in their build
setup which could be adjusted but I didn't immediately see it and since
this is having a serious impact on test coverage in automation let's just
revert for now.

This is causing failures in KernelCI with the command:

   make KBUILD_BUILD_USER=KernelCI FORMAT=.xz ARCH=arm64 HOSTCC=gcc CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_COMPAT=arm-linux-gnueabihf- CC="ccache aarch64-linux-gnu-gcc" O=/tmp/kci/linux/build -C/tmp/kci/linux -j10 kselftest-gen_tar

and also when building using tuxmake.

Full log: https://storage.kernelci.org/mainline/master/v6.5-rc1/arm64/defconfig/gcc-10/logs/kselftest.log

Link: https://lkml.kernel.org/r/20230710-kselftest-fix-arm64-v1-1-48e872844f25@kernel.org
Fixes: 9fc96c7c19df ("selftests: error out if kernel header files are not yet built")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |   21 ---------------
 tools/testing/selftests/lib.mk   |   40 ++---------------------------
 2 files changed, 4 insertions(+), 57 deletions(-)

--- a/tools/testing/selftests/lib.mk~selftests-fix-arm64-test-installation
+++ a/tools/testing/selftests/lib.mk
@@ -44,26 +44,10 @@ endif
 selfdir = $(realpath $(dir $(filter %/lib.mk,$(MAKEFILE_LIST))))
 top_srcdir = $(selfdir)/../../..
 
-ifeq ("$(origin O)", "command line")
-  KBUILD_OUTPUT := $(O)
+ifeq ($(KHDR_INCLUDES),)
+KHDR_INCLUDES := -isystem $(top_srcdir)/usr/include
 endif
 
-ifneq ($(KBUILD_OUTPUT),)
-  # Make's built-in functions such as $(abspath ...), $(realpath ...) cannot
-  # expand a shell special character '~'. We use a somewhat tedious way here.
-  abs_objtree := $(shell cd $(top_srcdir) && mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) && pwd)
-  $(if $(abs_objtree),, \
-    $(error failed to create output directory "$(KBUILD_OUTPUT)"))
-  # $(realpath ...) resolves symlinks
-  abs_objtree := $(realpath $(abs_objtree))
-  KHDR_DIR := ${abs_objtree}/usr/include
-else
-  abs_srctree := $(shell cd $(top_srcdir) && pwd)
-  KHDR_DIR := ${abs_srctree}/usr/include
-endif
-
-KHDR_INCLUDES := -isystem $(KHDR_DIR)
-
 # The following are built by lib.mk common compile rules.
 # TEST_CUSTOM_PROGS should be used by tests that require
 # custom build rule and prevent common build rule use.
@@ -74,25 +58,7 @@ TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)
 TEST_GEN_PROGS_EXTENDED := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS_EXTENDED))
 TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
 
-all: kernel_header_files $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) \
-     $(TEST_GEN_FILES)
-
-kernel_header_files:
-	@ls $(KHDR_DIR)/linux/*.h >/dev/null 2>/dev/null;                      \
-	if [ $$? -ne 0 ]; then                                                 \
-            RED='\033[1;31m';                                                  \
-            NOCOLOR='\033[0m';                                                 \
-            echo;                                                              \
-            echo -e "$${RED}error$${NOCOLOR}: missing kernel header files.";   \
-            echo "Please run this and try again:";                             \
-            echo;                                                              \
-            echo "    cd $(top_srcdir)";                                       \
-            echo "    make headers";                                           \
-            echo;                                                              \
-	    exit 1; \
-	fi
-
-.PHONY: kernel_header_files
+all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
 
 define RUN_TESTS
 	BASE_DIR="$(selfdir)";			\
--- a/tools/testing/selftests/Makefile~selftests-fix-arm64-test-installation
+++ a/tools/testing/selftests/Makefile
@@ -146,12 +146,10 @@ ifneq ($(KBUILD_OUTPUT),)
   abs_objtree := $(realpath $(abs_objtree))
   BUILD := $(abs_objtree)/kselftest
   KHDR_INCLUDES := -isystem ${abs_objtree}/usr/include
-  KHDR_DIR := ${abs_objtree}/usr/include
 else
   BUILD := $(CURDIR)
   abs_srctree := $(shell cd $(top_srcdir) && pwd)
   KHDR_INCLUDES := -isystem ${abs_srctree}/usr/include
-  KHDR_DIR := ${abs_srctree}/usr/include
   DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
@@ -165,7 +163,7 @@ export KHDR_INCLUDES
 # all isn't the first target in the file.
 .DEFAULT_GOAL := all
 
-all: kernel_header_files
+all:
 	@ret=1;							\
 	for TARGET in $(TARGETS); do				\
 		BUILD_TARGET=$$BUILD/$$TARGET;			\
@@ -176,23 +174,6 @@ all: kernel_header_files
 		ret=$$((ret * $$?));				\
 	done; exit $$ret;
 
-kernel_header_files:
-	@ls $(KHDR_DIR)/linux/*.h >/dev/null 2>/dev/null;                          \
-	if [ $$? -ne 0 ]; then                                                     \
-            RED='\033[1;31m';                                                  \
-            NOCOLOR='\033[0m';                                                 \
-            echo;                                                              \
-            echo -e "$${RED}error$${NOCOLOR}: missing kernel header files.";   \
-            echo "Please run this and try again:";                             \
-            echo;                                                              \
-            echo "    cd $(top_srcdir)";                                       \
-            echo "    make headers";                                           \
-            echo;                                                              \
-	    exit 1;                                                                \
-	fi
-
-.PHONY: kernel_header_files
-
 run_tests: all
 	@for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
_

Patches currently in -mm which might be from broonie@kernel.org are



Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2FDC001B3
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjFSXUt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFSXUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BA1E6E
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B27C760F1B
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13712C433C8;
        Mon, 19 Jun 2023 23:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216835;
        bh=3Cyem4yMRZ/uvdNiwKBDu0yb5EghOPz8s+/m8LNcaQk=;
        h=Date:To:From:Subject:From;
        b=C/tc9F2uSKIJD/3pdwvU9W322PUMPC2fFgOAMhpwGsv/wWSjhDQyFXR1jbn2rbRxr
         0+lT/dIUf7OEVwpoiTCaojsNglhM/LiWqCeuvXw6pUZaMW392t1Kr2eDeMmdE/JVuu
         0+596kchHQAi0YOreQMzxd66VefuXKcvOSODtsN4=
Date:   Mon, 19 Jun 2023 16:20:34 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, anders.roxell@linaro.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-error-out-if-kernel-header-files-are-not-yet-built.patch removed from -mm tree
Message-Id: <20230619232035.13712C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: error out if kernel header files are not yet built
has been removed from the -mm tree.  Its filename was
     selftests-error-out-if-kernel-header-files-are-not-yet-built.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests: error out if kernel header files are not yet built
Date: Tue, 6 Jun 2023 00:16:37 -0700

As per a discussion with Muhammad Usama Anjum [1], the following is how
one is supposed to build selftests:

    make headers && make -C tools/testing/selftests/mm

Change the selftest build system's lib.mk to fail out with a helpful
message if that prerequisite "make headers" has not been done yet.

[1] https://lore.kernel.org/all/bf910fa5-0c96-3707-cce4-5bcc656b6274@collabora.com/

[jhubbard@nvidia.com: abort the make process the first time headers aren't detected]
  Link: https://lkml.kernel.org/r/14573e7e-f2ad-ff34-dfbd-3efdebee51ed@nvidia.com
[anders.roxell@linaro.org: fix out-of-tree builds]
  Link: https://lkml.kernel.org/r/20230613074931.666966-1-anders.roxell@linaro.org
Link: https://lkml.kernel.org/r/20230606071637.267103-12-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |   21 ++++++++++++++-
 tools/testing/selftests/lib.mk   |   40 ++++++++++++++++++++++++++---
 2 files changed, 57 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/lib.mk~selftests-error-out-if-kernel-header-files-are-not-yet-built
+++ a/tools/testing/selftests/lib.mk
@@ -44,10 +44,26 @@ endif
 selfdir = $(realpath $(dir $(filter %/lib.mk,$(MAKEFILE_LIST))))
 top_srcdir = $(selfdir)/../../..
 
-ifeq ($(KHDR_INCLUDES),)
-KHDR_INCLUDES := -isystem $(top_srcdir)/usr/include
+ifeq ("$(origin O)", "command line")
+  KBUILD_OUTPUT := $(O)
 endif
 
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
+endif
+
+KHDR_INCLUDES := -isystem $(KHDR_DIR)
+
 # The following are built by lib.mk common compile rules.
 # TEST_CUSTOM_PROGS should be used by tests that require
 # custom build rule and prevent common build rule use.
@@ -58,7 +74,25 @@ TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)
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
--- a/tools/testing/selftests/Makefile~selftests-error-out-if-kernel-header-files-are-not-yet-built
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



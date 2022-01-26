Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8DFC3525A
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jan 2022 01:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbiAZBsr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 20:48:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54626 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235983AbiAZBsr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 20:48:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27909B81BA0
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 01:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587AEC340E0;
        Wed, 26 Jan 2022 01:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643161725;
        bh=8gPgcB+Ku824ZPvdAcKwk+Q1gcnOBAYpFtxtdNPFwZI=;
        h=Date:From:To:Subject:From;
        b=Zc9Zun/2cdH4iW3uSp9QntLLxF8wscQU9T4Io4o3p16lAlyWihRb+S4QUS094wt7q
         HE+nLaibgevl/6h+d6swMvh6PpvxavoCm47UFp1zjk6mfL5pZiWf8Aj3PtXS1fgeOC
         QmAGVfWo2NqUOreVyPCWzxsS3dhIuCIIWqU+kGXk=
Date:   Tue, 25 Jan 2022 17:48:43 -0800
From:   akpm@linux-foundation.org
To:     andrealmeid@collabora.com, apopple@nvidia.com,
        chi.minghao@zte.com.cn, dave@stgolabs.net, davem@davemloft.net,
        dvhart@infradead.org, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mic@digikod.net, mingo@redhat.com, mm-commits@vger.kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, shuah@kernel.org,
        tglx@linutronix.de, usama.anjum@collabora.com
Subject:  + selftests-set-the-build-variable-to-absolute-path.patch
 added to -mm tree
Message-ID: <20220126014843.T_L4uk4wB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: set the BUILD variable to absolute path
has been added to the -mm tree.  Its filename is
     selftests-set-the-build-variable-to-absolute-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-set-the-build-variable-to-absolute-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-set-the-build-variable-to-absolute-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: set the BUILD variable to absolute path

Patch series "selftests: Fix separate output directory builds", v2.

Build of several selftests fail if separate output directory is
specified by the following methods:
1) make -C tools/testing/selftests O=<build_dir>
2) export KBUILD_OUTPUT="build_dir"; make -C tools/testing/selftests

Build fails because of several reasons:
1) The kernel headers aren't found.
2) The path of output objects is wrong and hence unaccessible.

These problems can be solved by:
1) Including the correct path of uapi header files
2) By setting the BUILD variable correctly inside Makefile

Following different build scenarios have been tested after making these
changes to verify that nothing gets broken with these changes:
make -C tools/testing/selftests
make -C tools/testing/selftests/futex
make -C tools/testing/selftests/kvm
make -C tools/testing/selftests/landlock
make -C tools/testing/selftests/net
make -C tools/testing/selftests/net/mptcp
make -C tools/testing/selftests/vm
make -C tools/testing/selftests O=build
make -C tools/testing/selftests o=/opt/build
export KBUILD_OUTPUT="/opt/build"; make -C tools/testing/selftests
export KBUILD_OUTPUT="build"; make -C tools/testing/selftests
cd <any_dir>; make -C <src_path>/tools/testing/selftests
cd <any_dir>; make -C <src_path>/tools/testing/selftests O=build


This patch (of 10):

The build of kselftests fails if relative path is specified through
KBUILD_OUTPUT or O=<path> method.  BUILD variable is used to determine the
path of the output objects.  When make is run from other directories with
relative paths, the exact path of the build objects is ambiguous and build
fails.

	make[1]: Entering directory '/home/usama/repos/kernel/linux_mainline2/tools/testing/selftests/alsa'
	gcc     mixer-test.c -L/usr/lib/x86_64-linux-gnu -lasound  -o build/kselftest/alsa/mixer-test
	/usr/bin/ld: cannot open output file build/kselftest/alsa/mixer-test

Set the BUILD variable to the absolute path of the output directory.  Make
the logic readable and easy to follow.  Use spaces instead of tabs for
indentation as if with tab indentation is considered recipe in make.

Link: https://lkml.kernel.org/r/20220119101531.2850400-1-usama.anjum@collabora.com
Link: https://lkml.kernel.org/r/20220119101531.2850400-2-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Andr Almeida <andrealmeid@collabora.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Mickal Salan <mic@digikod.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: Minghao Chi <chi.minghao@zte.com.cn>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/Makefile~selftests-set-the-build-variable-to-absolute-path
+++ a/tools/testing/selftests/Makefile
@@ -114,19 +114,27 @@ ifdef building_out_of_srctree
 override LDFLAGS =
 endif
 
-ifneq ($(O),)
-	BUILD := $(O)/kselftest
+top_srcdir ?= ../../..
+
+ifeq ("$(origin O)", "command line")
+  KBUILD_OUTPUT := $(O)
+endif
+
+ifneq ($(KBUILD_OUTPUT),)
+  # Make's built-in functions such as $(abspath ...), $(realpath ...) cannot
+  # expand a shell special character '~'. We use a somewhat tedious way here.
+  abs_objtree := $(shell cd $(top_srcdir) && mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) && pwd)
+  $(if $(abs_objtree),, \
+    $(error failed to create output directory "$(KBUILD_OUTPUT)"))
+  # $(realpath ...) resolves symlinks
+  abs_objtree := $(realpath $(abs_objtree))
+  BUILD := $(abs_objtree)/kselftest
 else
-	ifneq ($(KBUILD_OUTPUT),)
-		BUILD := $(KBUILD_OUTPUT)/kselftest
-	else
-		BUILD := $(shell pwd)
-		DEFAULT_INSTALL_HDR_PATH := 1
-	endif
+  BUILD := $(CURDIR)
+  DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
 # Prepare for headers install
-top_srcdir ?= ../../..
 include $(top_srcdir)/scripts/subarch.include
 ARCH           ?= $(SUBARCH)
 export KSFT_KHDR_INSTALL_DONE := 1
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-set-the-build-variable-to-absolute-path.patch
selftests-add-and-export-a-kernel-uapi-headers-path.patch
selftests-correct-the-headers-install-path.patch
selftests-futex-add-the-uapi-headers-include-variable.patch
selftests-kvm-add-the-uapi-headers-include-variable.patch
selftests-landlock-add-the-uapi-headers-include-variable.patch
selftests-net-add-the-uapi-headers-include-variable.patch
selftests-mptcp-add-the-uapi-headers-include-variable.patch
selftests-vm-add-the-uapi-headers-include-variable.patch
selftests-vm-remove-dependecy-from-internal-kernel-macros.patch


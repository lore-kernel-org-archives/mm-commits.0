Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8781EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjFSXI7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFSXI6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:08:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE67124
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:08:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C2B260F29
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64277C433C0;
        Mon, 19 Jun 2023 23:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216136;
        bh=3Q94+V2rbpJv6YO8oTB4tB/6P+5PB7s+5vhh4o1DlVs=;
        h=Date:To:From:Subject:From;
        b=mOu8jBpAasePe9FcK1sz/a10ZYR3JaS96cOVMIsdTn0GnWONKNAt5PTy8DLcouyKG
         7hrTYPJHfP1XwTdANNK4ugDcbcUvtq/bnM7iU4lEc3iBWxMw9M0zx38LNpHs+Ct/I2
         oQfkFmFDjMU9Fs2n8vNGQBZlxrK0N8NNuvluBL1w=
Date:   Mon, 19 Jun 2023 16:08:55 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        jhubbard@nvidia.com, david@redhat.com, anders.roxell@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-error-out-if-kernel-header-files-are-not-yet-built-fix-2.patch removed from -mm tree
Message-Id: <20230619230856.64277C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: lib.mk: fix out-of-tree builds
has been removed from the -mm tree.  Its filename was
     selftests-error-out-if-kernel-header-files-are-not-yet-built-fix-2.patch

This patch was dropped because it was folded into selftests-error-out-if-kernel-header-files-are-not-yet-built.patch

------------------------------------------------------
From: Anders Roxell <anders.roxell@linaro.org>
Subject: selftests: lib.mk: fix out-of-tree builds
Date: Tue, 13 Jun 2023 09:49:31 +0200

Since commit ("selftests: error out if kernel header files are not yet
built") got merged, the kselftest build correctly because the
KBUILD_OUTPUT isn't set when building out-of-tree and specifying 'O=' This
is the error message that pops up.

make --silent --keep-going --jobs=32 O=/home/anders/.cache/tuxmake/builds/1482/build INSTALL_PATH=/home/anders/.cache/tuxmake/builds/1482/build/kselftest_install ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- V=1 CROSS_COMPILE_COMPAT=arm-linux-gnueabihf- kselftest-install
make[3]: Entering directory '/home/anders/src/kernel/next/tools/testing/selftests/alsa'

-e error: missing kernel header files.
Please run this and try again:

    cd /home/anders/src/kernel/next/tools/testing/selftests/../../..
    make headers

make[3]: Leaving directory '/home/anders/src/kernel/next/tools/testing/selftests/alsa'
make[3]: *** [../lib.mk:77: kernel_header_files] Error 1

Fixing the issue by assigning KBUILD_OUTPUT the same way how its done in
kselftest's Makefile.  By adding 'KBUILD_OUTPUT := $(O)' 'if $(origin O)'
is set to 'command line'.  This will set the the BUILD dir to
KBUILD_OUTPUT/kselftest when doing out-of-tree builds which makes them in
its own separete output directory.

Link: https://lkml.kernel.org/r/20230613074931.666966-1-anders.roxell@linaro.org
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/lib.mk |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/lib.mk~selftests-error-out-if-kernel-header-files-are-not-yet-built-fix-2
+++ a/tools/testing/selftests/lib.mk
@@ -44,6 +44,10 @@ endif
 selfdir = $(realpath $(dir $(filter %/lib.mk,$(MAKEFILE_LIST))))
 top_srcdir = $(selfdir)/../../..
 
+ifeq ("$(origin O)", "command line")
+  KBUILD_OUTPUT := $(O)
+endif
+
 ifneq ($(KBUILD_OUTPUT),)
   # Make's built-in functions such as $(abspath ...), $(realpath ...) cannot
   # expand a shell special character '~'. We use a somewhat tedious way here.
_

Patches currently in -mm which might be from anders.roxell@linaro.org are

selftests-error-out-if-kernel-header-files-are-not-yet-built.patch
selftests-damon-add-config-file.patch


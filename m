Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A454CEB64DA
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jun 2023 19:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbjFMTxI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jun 2023 15:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjFMTxG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jun 2023 15:53:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D010FB3
        for <mm-commits@vger.kernel.org>; Tue, 13 Jun 2023 12:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66E4461554
        for <mm-commits@vger.kernel.org>; Tue, 13 Jun 2023 19:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD21C433F0;
        Tue, 13 Jun 2023 19:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686685981;
        bh=jZiou9h7NJ7wppQ2sOsxljcTEk0tBGHZwnFMDxkahaU=;
        h=Date:To:From:Subject:From;
        b=iE0H7NfdW3ruXVhUmRA7/YNFeqhdjLV+cTSYSIfwrJYfnvNQoB9vdrj3luDYBTFCk
         D8IFZMItbZVk/1E3Pu3leZXcB5LUEwXnkC/xagn5KF8mBiLliHymVYtaergkfNWVdl
         vcu5nov9/0iF2j+BF3W9E9amRnlDmJXjhv0KWQgk=
Date:   Tue, 13 Jun 2023 12:53:01 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        jhubbard@nvidia.com, david@redhat.com, anders.roxell@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-error-out-if-kernel-header-files-are-not-yet-built-fix-2.patch added to mm-unstable branch
Message-Id: <20230613195301.BDD21C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: lib.mk: fix out-of-tree builds
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-error-out-if-kernel-header-files-are-not-yet-built-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-error-out-if-kernel-header-files-are-not-yet-built-fix-2.patch

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
From: Anders Roxell <anders.roxell@linaro.org>
Subject: selftests: lib.mk: fix out-of-tree builds
Date: Tue, 13 Jun 2023 09:49:31 +0200

Since commit ("selftests: error out if kernel header files are not yet
built") got merged, the kselftest build correctly because the
KBUILD_OUTPUT isn't set when building out-of-tree and specifying 'O=' This
is the error message that pops up.

make --silent --keep-going --jobs=32 O=/home/anders/.cache/tuxmake/builds/1482/build INSTALL_PATH=/home/anders/.cache/tuxmake/builds/1482/build/kselftest_install ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- V=1 CROSS_COMPILE_COMPAT=arm-linux-gnueabihf- kselftest-install
make[3]: Entering directory '/home/anders/src/kernel/next/tools/testing/selftests/alsa'

-e [1;31merror[0m: missing kernel header files.
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

selftests-error-out-if-kernel-header-files-are-not-yet-built-fix-2.patch
selftests-damon-add-config-file.patch


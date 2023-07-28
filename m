Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D688C001E0
	for <mm-commits@archiver.kernel.org>; Fri, 28 Jul 2023 18:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbjG1SZE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jul 2023 14:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236727AbjG1SZA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2023 14:25:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769224686
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 11:24:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01D92621B4
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 18:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53513C433C7;
        Fri, 28 Jul 2023 18:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690568663;
        bh=tQuuoGxDZJUIWfjIL3cpbS349gzZOfAS33LbW08Wivw=;
        h=Date:To:From:Subject:From;
        b=0FYqo+ldhIdi/P+BGt/Tv8OZJIEDhlPngwunyS5YoiLuJT1JUykgO1v5FFLlYjuEL
         O/amZJjZTbR6oSuWrduvYp92PF4EO78Bg8E3Xk3pnLsUV+FcTsIrz6+FBFgeJPZjJR
         nEiQ72p6Q1FME1vksXurmDyPFCMgu3Hx2+23E/Mk=
Date:   Fri, 28 Jul 2023 11:24:22 -0700
To:     mm-commits@vger.kernel.org, oberpar@linux.ibm.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gcov-shut-up-missing-prototype-warnings-for-internal-stubs.patch added to mm-nonmm-unstable branch
Message-Id: <20230728182423.53513C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: shut up missing prototype warnings for internal stubs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     gcov-shut-up-missing-prototype-warnings-for-internal-stubs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gcov-shut-up-missing-prototype-warnings-for-internal-stubs.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: gcov: shut up missing prototype warnings for internal stubs
Date: Tue, 25 Jul 2023 14:23:38 +0200

gcov uses global functions that are called from generated code, but these
have no prototype in a header, which causes a W=1 build warning:

kernel/gcov/gcc_base.c:12:6: error: no previous prototype for '__gcov_init' [-Werror=missing-prototypes]
kernel/gcov/gcc_base.c:40:6: error: no previous prototype for '__gcov_flush' [-Werror=missing-prototypes]
kernel/gcov/gcc_base.c:46:6: error: no previous prototype for '__gcov_merge_add' [-Werror=missing-prototypes]
kernel/gcov/gcc_base.c:52:6: error: no previous prototype for '__gcov_merge_single' [-Werror=missing-prototypes]

Just turn off these warnings unconditionally for the two files that
contain them.

Link: https://lore.kernel.org/all/0820010f-e9dc-779d-7924-49c7df446bce@linux.ibm.com/
Link: https://lkml.kernel.org/r/20230725123042.2269077-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/gcov/Makefile~gcov-shut-up-missing-prototype-warnings-for-internal-stubs
+++ a/kernel/gcov/Makefile
@@ -3,4 +3,6 @@ ccflags-y := -DSRCTREE='"$(srctree)"' -D
 
 obj-y := base.o fs.o
 obj-$(CONFIG_CC_IS_GCC) += gcc_base.o gcc_4_7.o
+CFLAGS_gcc_base.o += -Wno-missing-prototypes -Wno-missing-declarations
 obj-$(CONFIG_CC_IS_CLANG) += clang.o
+CFLAGS_clang.o += -Wno-missing-prototypes -Wno-missing-declarations
_

Patches currently in -mm which might be from arnd@arndb.de are

iomem-remove-__weak-ioremap_cache-helper.patch
gcov-shut-up-missing-prototype-warnings-for-internal-stubs.patch


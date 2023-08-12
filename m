Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8644DC0015E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjHLWGM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjHLWFw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFB5171C
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33B20620D4
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D83C433C7;
        Sat, 12 Aug 2023 22:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877954;
        bh=M2sL0N9feStS+QWIpnNiyMSsxaeJNAT61QbNCXD0E4c=;
        h=Date:To:From:Subject:From;
        b=eCvdKJt/EXCCbkrdUYB+LTyHhIQFOp8GqcjBsFM/FvUM/wgUUTeFcHd35Mb9DYKyO
         j5eijLi2oSFlKk+I/Dopq0EnTQsS0m1W0eubVGatcGtUN3kY6zNAlJQfnuSmuTAPOO
         1zyuXdSF/lI6jl3i6lq8alS9AET1VUc5gthkbGr8=
Date:   Sat, 12 Aug 2023 15:05:54 -0700
To:     mm-commits@vger.kernel.org, oberpar@linux.ibm.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] gcov-shut-up-missing-prototype-warnings-for-internal-stubs.patch removed from -mm tree
Message-Id: <20230812220554.88D83C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: gcov: shut up missing prototype warnings for internal stubs
has been removed from the -mm tree.  Its filename was
     gcov-shut-up-missing-prototype-warnings-for-internal-stubs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

radix-tree-remove-unused-variable.patch
iomem-remove-__weak-ioremap_cache-helper.patch


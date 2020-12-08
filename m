Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE1FC4361B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 00:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0430223A1C
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 00:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgLHAqs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 19:46:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728735AbgLHAqs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Dec 2020 19:46:48 -0500
Date:   Mon, 07 Dec 2020 16:46:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607388367;
        bh=i1auv3vONj8SJZcKspky7KQk0EmUZ4AE7V5pXAqiqm8=;
        h=From:To:Subject:From;
        b=1NYntMHtzrt7TwlIba85M3rSeN3BCXu1WLn56H0BZoyZHZspscEThaOk7o3Dinu9F
         jztDFvc4S63dOG1Uwo253SV4Lbe+jiSXgFn5Q0ZaRSvDD5UdNEYNXjjC3AQ7zOdjvi
         HWpkMMRmlokPGhToVs+Ab3J3kBpjEZ2rH5EZK/4c=
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        iii@linux.ibm.com, lkp@intel.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, zaslonko@linux.ibm.com
Subject:  [merged] zlib-export-s390-symbols-for-zlib-modules.patch
 removed from -mm tree
Message-ID: <20201208004606.4NK8aWQ-V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zlib: export S390 symbols for zlib modules
has been removed from the -mm tree.  Its filename was
     zlib-export-s390-symbols-for-zlib-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: zlib: export S390 symbols for zlib modules

Fix build errors when ZLIB_INFLATE=m and ZLIB_DEFLATE=m and ZLIB_DFLTCC=y
by exporting the 2 needed symbols in dfltcc_inflate.c.

Fixes these build errors:

ERROR: modpost: "dfltcc_inflate" [lib/zlib_inflate/zlib_inflate.ko] undefined!
ERROR: modpost: "dfltcc_can_inflate" [lib/zlib_inflate/zlib_inflate.ko] undefined!

Link: https://lkml.kernel.org/r/20201123191712.4882-1-rdunlap@infradead.org
Fixes: 126196100063 ("lib/zlib: add s390 hardware support for kernel zlib_inflate")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_dfltcc/dfltcc_inflate.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/zlib_dfltcc/dfltcc_inflate.c~zlib-export-s390-symbols-for-zlib-modules
+++ a/lib/zlib_dfltcc/dfltcc_inflate.c
@@ -4,6 +4,7 @@
 #include "dfltcc_util.h"
 #include "dfltcc.h"
 #include <asm/setup.h>
+#include <linux/export.h>
 #include <linux/zutil.h>
 
 /*
@@ -29,6 +30,7 @@ int dfltcc_can_inflate(
     return is_bit_set(dfltcc_state->af.fns, DFLTCC_XPND) &&
                is_bit_set(dfltcc_state->af.fmts, DFLTCC_FMT0);
 }
+EXPORT_SYMBOL(dfltcc_can_inflate);
 
 static int dfltcc_was_inflate_used(
     z_streamp strm
@@ -147,3 +149,4 @@ dfltcc_inflate_action dfltcc_inflate(
     return (cc == DFLTCC_CC_OP1_TOO_SHORT || cc == DFLTCC_CC_OP2_TOO_SHORT) ?
         DFLTCC_INFLATE_BREAK : DFLTCC_INFLATE_CONTINUE;
 }
+EXPORT_SYMBOL(dfltcc_inflate);
_

Patches currently in -mm which might be from rdunlap@infradead.org are

tmpfs-fix-documentation-nits.patch
procfs-delete-duplicated-words-other-fixes.patch
bfs-dont-use-warning-string-when-its-just-info.patch


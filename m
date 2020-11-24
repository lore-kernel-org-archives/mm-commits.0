Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBB9C56202
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E8A220729
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:58:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n1jsO93C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgKXA6b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 19:58:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728703AbgKXA6a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 19:58:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0080F20715;
        Tue, 24 Nov 2020 00:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606179510;
        bh=U9xJXdczPS28NoT7l7noHX21nr9fIP+/zzZnvQZGnlg=;
        h=Date:From:To:Subject:From;
        b=n1jsO93C2mAEBSaKS58ITTXMDTukXE+4j7Rmfl/rwafdgjohiaHnL1JXRIBfPPF4e
         HmXBUQGtNpVyLfECm+hHtN6KlqehFtNz6LIXhe8h9R/xCSysusAnZj2A0XQpGQXi6t
         cdrNirA5fsaru2oUrMxK0czIUDzL//KcWKflljt4=
Date:   Mon, 23 Nov 2020 16:58:29 -0800
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        iii@linux.ibm.com, lkp@intel.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, zaslonko@linux.ibm.com
Subject:  + zlib-export-s390-symbols-for-zlib-modules.patch added
 to -mm tree
Message-ID: <20201124005829.lVxJJnnSg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zlib: export S390 symbols for zlib modules
has been added to the -mm tree.  Its filename is
     zlib-export-s390-symbols-for-zlib-modules.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zlib-export-s390-symbols-for-zlib-modules.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zlib-export-s390-symbols-for-zlib-modules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zlib-export-s390-symbols-for-zlib-modules.patch
procfs-delete-duplicated-words-other-fixes.patch


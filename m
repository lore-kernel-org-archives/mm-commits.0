Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9A8C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35A4761041
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhISXoe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhISXod (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:44:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B98961004;
        Sun, 19 Sep 2021 23:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632094987;
        bh=01qQkI7wR/OCNy+qAHgLzoGQpjwCvH1wIOaEnVfGecw=;
        h=Date:From:To:Subject:From;
        b=VYG1ymSM+vy4qFL9GUiG7/kDNFQ3F6cXn0zgyrFt+CWwde57CLhKpWLknarZ5Oxtr
         ObPyvE6U9d24uBMwLiAfx0rmodiPVDz3Nr6Mr3jdwqYxFcr+bEpyQVHsTbgwMuPnQy
         yoX45HKbWQtKFmxXHkn1EXDgGtDQOVG/HppJ7v8M=
Date:   Sun, 19 Sep 2021 16:43:06 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stefan.wahren@i2se.com,
        paul.walmsley@sifive.com, palmer@dabbelt.com, mkubecek@suse.cz,
        jszhang@kernel.org, aou@eecs.berkeley.edu, miles.chen@mediatek.com
Subject:  +
 scripts-sorttable-riscv-fix-undelcred-identifier-em_riscv-error.patch added
 to -mm tree
Message-ID: <20210919234306.Q3iwS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/sorttable: riscv: fix undelcred identifier 'EM_RISCV' error
has been added to the -mm tree.  Its filename is
     scripts-sorttable-riscv-fix-undelcred-identifier-em_riscv-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-sorttable-riscv-fix-undelcred-identifier-em_riscv-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-sorttable-riscv-fix-undelcred-identifier-em_riscv-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: scripts/sorttable: riscv: fix undelcred identifier 'EM_RISCV' error

Fix the following build break by adding a conditional definition of
EM_RISCV in order to allow cross-compilation on machines which do not have
EM_RISCV definition in their host.

build break log from [1]:
scripts/sorttable.c:352:7: error: use of undeclared identifier 'EM_RISCV'

[1] https://lore.kernel.org/lkml/e8965b25-f15b-c7b4-748c-d207dda9c8e8@i2se.com/

EM_RISCV was added to <elf.h> in glibc 2.24 so builds on systems with
glibc headers < 2.24 should show this error.

[mkubecek@suse.cz: changelog addition]
Link: https://lkml.kernel.org/r/20210913030625.4525-1-miles.chen@mediatek.com
Fixes: 54fed35fd393 ("riscv: Enable BUILDTIME_TABLE_SORT")
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Cc: Michal Kubecek <mkubecek@suse.cz>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/sorttable.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/sorttable.c~scripts-sorttable-riscv-fix-undelcred-identifier-em_riscv-error
+++ a/scripts/sorttable.c
@@ -54,6 +54,10 @@
 #define EM_ARCV2	195
 #endif
 
+#ifndef EM_RISCV
+#define EM_RISCV	243
+#endif
+
 static uint32_t (*r)(const uint32_t *);
 static uint16_t (*r2)(const uint16_t *);
 static uint64_t (*r8)(const uint64_t *);
_

Patches currently in -mm which might be from miles.chen@mediatek.com are

scripts-sorttable-riscv-fix-undelcred-identifier-em_riscv-error.patch


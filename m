Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E84BC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C0826125F
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345221AbhIXWpP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238242AbhIXWpM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D71B56125F;
        Fri, 24 Sep 2021 22:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523419;
        bh=HzKdeZV8Mh/bu9P5zZcHBxV6NxADl9v994DHcueykNY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MWX/RQJjTsXaJg2nQuwitvKxWsdFPbywDyspDiKp6MrTzNpN60+4epTyMHP2N3JAj
         vqrU3dwo45XEtcowlexKCklvoUo2N0n3vaZICZUk0ckKLM4EoeMMnxuTOa7Dcn4aZN
         YGjhrXr5rKWOELuF2UhN+3O9OT6kxHCht6EB4kIs=
Date:   Fri, 24 Sep 2021 15:43:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aou@eecs.berkeley.edu,
        jszhang@kernel.org, linux-mm@kvack.org, miles.chen@mediatek.com,
        mkubecek@suse.cz, mm-commits@vger.kernel.org, mmayer@broadcom.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        stefan.wahren@i2se.com, torvalds@linux-foundation.org
Subject:  [patch 07/16] scripts/sorttable: riscv: fix undeclared
 identifier 'EM_RISCV' error
Message-ID: <20210924224338.8vuOlQPWr%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miles Chen <miles.chen@mediatek.com>
Subject: scripts/sorttable: riscv: fix undeclared identifier 'EM_RISCV' error

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
Cc: Markus Mayer <mmayer@broadcom.com>
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
